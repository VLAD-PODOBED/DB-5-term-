alter session set nls_date_format = 'DD-MM-YYYY';

------------------------------------ ������� �1

alter table TEACHER
    add BIRTHDAY date;
alter table TEACHER
    add SALARY number;

update TEACHER
set BIRTHDAY = '12-02-1959'
where TEACHER = '����';
update TEACHER
set BIRTHDAY = '30-01-1987'
where TEACHER = '�����';
update TEACHER
set BIRTHDAY = '19-04-1991'
where TEACHER = '�����';
update TEACHER
set BIRTHDAY = '16-04-1964'
where TEACHER = '����';
update TEACHER
set BIRTHDAY = '19-11-1988'
where TEACHER = '����';
update TEACHER
set BIRTHDAY = '05-10-1966'
where TEACHER = '�����';
update TEACHER
set BIRTHDAY = '10-08-1976'
where TEACHER = '���';
update TEACHER
set BIRTHDAY = '11-09-1989'
where TEACHER = '���';
update TEACHER
set BIRTHDAY = '24-12-1983'
where TEACHER = '���';
update TEACHER
set BIRTHDAY = '03-06-1990'
where TEACHER = '����';
update TEACHER
set BIRTHDAY = '10-05-1970'
where TEACHER = '������';
update TEACHER
set BIRTHDAY = '26-10-1999'
where TEACHER = '?';
update TEACHER
set BIRTHDAY = '30-07-1984'
where TEACHER = '���';
update TEACHER
set BIRTHDAY = '11-03-1975'
where TEACHER = '���';
update TEACHER
set BIRTHDAY = '12-07-1969'
where TEACHER = '������';
update TEACHER
set BIRTHDAY = '26-02-1983'
where TEACHER = '�����';
update TEACHER
set BIRTHDAY = '13-12-1991'
where TEACHER = '������';
update TEACHER
set BIRTHDAY = '20-01-1968'
where TEACHER = '����';
update TEACHER
set BIRTHDAY = '21-12-1969'
where TEACHER = '����';
update TEACHER
set BIRTHDAY = '28-01-1975'
where TEACHER = '����';
update TEACHER
set BIRTHDAY = '10-07-1983'
where TEACHER = '������';
update TEACHER
set BIRTHDAY = '08-10-1988'
where TEACHER = '���';
update TEACHER
set BIRTHDAY = '30-07-1984'
where TEACHER = '�����';
update TEACHER
set BIRTHDAY = '16-04-1964'
where TEACHER = '������';
update TEACHER
set BIRTHDAY = '12-05-1985'
where TEACHER = '������';
update TEACHER
set BIRTHDAY = '20-10-1980'
where TEACHER = '�����';
update TEACHER
set BIRTHDAY = '21-08-1990'
where TEACHER = '���';
update TEACHER
set BIRTHDAY = '13-08-1966'
where TEACHER = '����';
update TEACHER
set BIRTHDAY = '11-11-1978'
where TEACHER = '����';

update TEACHER
set SALARY = 1030
where TEACHER = '����';
update TEACHER
set SALARY = 1030
where TEACHER = '�����';
update TEACHER
set SALARY = 980
where TEACHER = '�����';
update TEACHER
set SALARY = 1050
where TEACHER = '����';
update TEACHER
set SALARY = 590
where TEACHER = '����';
update TEACHER
set SALARY = 870
where TEACHER = '�����';
update TEACHER
set SALARY = 815
where TEACHER = '���';
update TEACHER
set SALARY = 995
where TEACHER = '���';
update TEACHER
set SALARY = 1460
where TEACHER = '���';
update TEACHER
set SALARY = 1120
where TEACHER = '����';
update TEACHER
set SALARY = 1250
where TEACHER = '������';
update TEACHER
set SALARY = 333
where TEACHER = '?';
update TEACHER
set SALARY = 1520
where TEACHER = '���';
update TEACHER
set SALARY = 1430
where TEACHER = '���';
update TEACHER
set SALARY = 900
where TEACHER = '������';
update TEACHER
set SALARY = 875
where TEACHER = '�����';
update TEACHER
set SALARY = 970
where TEACHER = '������';
update TEACHER
set SALARY = 780
where TEACHER = '����';
update TEACHER
set SALARY = 1150
where TEACHER = '����';
update TEACHER
set SALARY = 805
where TEACHER = '����';
update TEACHER
set SALARY = 905
where TEACHER = '������';
update TEACHER
set SALARY = 1200
where TEACHER = '���';
update TEACHER
set SALARY = 1500
where TEACHER = '�����';
update TEACHER
set SALARY = 905
where TEACHER = '������';
update TEACHER
set SALARY = 715
where TEACHER = '������';
update TEACHER
set SALARY = 880
where TEACHER = '�����';
update TEACHER
set SALARY = 735
where TEACHER = '���';
update TEACHER
set SALARY = 595
where TEACHER = '����';
update TEACHER
set SALARY = 850
where TEACHER = '����';


------------------------------------ ������� �2
select regexp_substr(teacher_name, '(\S+)', 1, 1) || ' ' ||
       substr(regexp_substr(teacher_name, '(\S+)', 1, 2), 1, 1) || '. ' ||
       substr(regexp_substr(teacher_name, '(\S+)', 1, 3), 1, 1) || '. ' as ���
from teacher;

------------------------------------ ������� �3
select * from teacher where TO_CHAR(birthday, 'd') = 2;

------------------------------------ ������� �4
--drop view next_month

create or replace view next_month as
select * from TEACHER
where TO_CHAR(birthday, 'mm') =
      (select substr(to_char(trunc(last_day(sysdate)) + 1), 4, 2)
       from dual);

select * from next_month;

------------------------------------ ������� �5
--drop view number_months
create or replace view number_months as
select to_char(birthday, 'Month') �����,
       count(*)                   ����������
from teacher
group by to_char(birthday, 'Month')
having count(*) >= 1
order by ���������� desc;

select * from number_months;

------------------------------------ ������� �6

DECLARE
  -- ��������� ������ ��� ������� �������������� � �������
  CURSOR teacher_birthday_cur IS
    SELECT * 
    FROM teacher 
    WHERE MOD((EXTRACT(YEAR FROM sysdate) - EXTRACT(YEAR FROM birthday) + 1), 10) = 0;

  v_teacher  teacher%rowtype;
BEGIN
  -- ��������� ������
  OPEN teacher_birthday_cur;

  -- �������� ������ �� �������
  LOOP
    FETCH teacher_birthday_cur INTO v_teacher;
    EXIT WHEN teacher_birthday_cur%NOTFOUND;
    -- ������� ������ � �������������
    dbms_output.put_line(v_teacher.teacher || ' ' || v_teacher.teacher_name || ' ' || v_teacher.pulpit || ' ' || v_teacher.birthday || ' ' || v_teacher.salary);
  END LOOP;

  -- ��������� ������
  CLOSE teacher_birthday_cur;
END;

------------------------------------ ������� �7
-- �������� ������� � ���������� ������� ���������� ����� �� ��������
declare
    cursor teachers_avg_salary is
        select pulpit, floor(avg(salary)) as AVG_SALARY
        from TEACHER
        group by pulpit;
    cursor faculty_avg_salary is
        select FACULTY, AVG(SALARY)
        from TEACHER
                 join PULPIT P on TEACHER.PULPIT = P.PULPIT
        group by FACULTY;
    cursor faculties_avg_salary is
        select AVG(SALARY)
        from TEACHER;
    m_pulpit  TEACHER.PULPIT%type;
    m_salary  TEACHER.SALARY%type;
    m_faculty PULPIT.FACULTY%type;
begin

    dbms_output.put_line('--------------- �� �������� -----------------');
    open teachers_avg_salary;
    fetch teachers_avg_salary into m_pulpit, m_salary;

    while (teachers_avg_salary%found)
        loop
            dbms_output.put_line(m_pulpit || ' ' || m_salary);
            fetch teachers_avg_salary into m_pulpit, m_salary;
        end loop;
    close teachers_avg_salary;

    dbms_output.put_line('--------------- �� ����������� -----------------');
    open faculty_avg_salary;
    fetch faculty_avg_salary into m_faculty, m_salary;

    while (faculty_avg_salary%found)
        loop
            dbms_output.put_line(m_faculty || ' ' || m_salary);
            fetch faculty_avg_salary into m_faculty, m_salary;
        end loop;
    close faculty_avg_salary;

    dbms_output.put_line('--------------- �� ���� ����������� -----------------');
    open faculties_avg_salary;
    fetch faculties_avg_salary into m_salary;
    dbms_output.put_line(round(m_salary, 2));
    close faculties_avg_salary;
end;

------------------------------------ ������� �8
declare
type contacts is record( 
email VARCHAR2(50),
phone number(13));
type person is record(
name teacher.teacher_name%type,
pulpit teacher.pulpit%type,
contact contacts);
per1 PERSON;
begin
per1.name:= 'dszfsd';
per1.pulpit:='FIT';
per1.contact.email := 'podobedvladislavgeorg@gmail.com';
per1.contact.phone := 123456789;
dbms_output.put_line( per1.name||' '|| per1.pulpit||' '|| per1.contact.email||'  '|| per1.contact.phone);
end;



