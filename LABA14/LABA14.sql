alter session set nls_date_format='dd-mm-yyyy hh24:mi:ss';

alter system set JOB_QUEUE_PROCESSES = 5;
select count(*) from dba_objects_ae where Object_Type = 'PACKAGE';

------------------------------------ Задание №1
--drop table PODOBED_14;
--drop table PODOBED_TO;
--drop table job_status;

create table PODOBED_14
(
    a number,
    b number
);
create table PODOBED_TO
(
    a number,
    b number
);

create table job_status
(
    status        nvarchar2(50),
    error_message nvarchar2(500),
    datetime      date default sysdate
);

insert into PODOBED_14 values (1, 11);
insert into PODOBED_14 values (2, 12);
insert into PODOBED_14 values (3, 13);
insert into PODOBED_14 values (4, 14);
insert into PODOBED_14 values (5, 15);
insert into PODOBED_14 values (6, 16);
insert into PODOBED_14 values (7, 17);
insert into PODOBED_14 values (8, 18);
insert into PODOBED_14 values (9, 19);
insert into PODOBED_14 values (10, 20);
commit;
select * from PODOBED_14;

------------------------------------ Задание №2, 3
--drop procedure job_procedure;
create or replace procedure job_procedure
is
    cursor job_cursor is
    select * from PODOBED_14;

    err_message varchar2(500);
begin
    for m in job_cursor
    loop
        insert into PODOBED_TO values (m.a, m.b);
    end loop;

    delete from PODOBED_14;
    insert into job_status (status, datetime) values ('SUCCESS', sysdate);
    commit;
    exception
      when others then
          err_message := sqlerrm;
          insert into job_status (status, error_message) values ('FAILURE', err_message);
          commit;
end job_procedure;


declare job_number user_jobs.job%type;
begin
  dbms_job.submit(job_number, 'BEGIN job_procedure(); END;', sysdate, 'sysdate + 7');
  commit;
  dbms_output.put_line(job_number);
end;

select * from JOB_STATUS;

------------------------------------ Задание №4
select job, what, last_date, last_sec, next_date, next_sec, broken from user_jobs;

------------------------------------ Задание №5
begin
  dbms_job.run(5);
end;

begin
  dbms_job.remove(22);
end;


select * from JOB_STATUS;

------------------------------------ Задание №6
begin
dbms_scheduler.create_schedule(
  schedule_name => 'SCH_1',
  start_date => sysdate,
  repeat_interval => 'FREQ=WEEKLY',
  comments => 'SCH_1 WEEKLY starts now'
);
end;

select * from user_scheduler_schedules;

begin
dbms_scheduler.create_program(
  program_name => 'PROGRAM_1',
  program_type => 'STORED_PROCEDURE',
  program_action => 'job_procedure',
  number_of_arguments => 0,
  enabled => true,
  comments => 'PROGRAM_1'
);
end;

select * from user_scheduler_programs;


begin
    dbms_scheduler.create_job(
            job_name => 'JOB_1',
            program_name => 'PROGRAM_1',
            schedule_name => 'SCH_1',
            enabled => true
        );
end;

select * from user_scheduler_jobs;

begin
  DBMS_SCHEDULER.DISABLE('JOB_1');
end;

begin
    DBMS_SCHEDULER.RUN_JOB('JOB_1');
end;


begin
  DBMS_SCHEDULER.DROP_JOB( JOB_NAME => 'JOB_1');
end;

