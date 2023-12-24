alter database open;
-- 1 
create table Persons
(
    id number primary key, 
    name varchar2(20)
);

-- 2
declare
    id number(10) := 1;
    name varchar(20);
begin
    while(id <= 10)
    loop
        name := concat('person_', to_char(id));
        insert into Persons(id, name) values (id, name);
        id := id + 1;
    end loop;
    commit;
end;

select * from Persons;

-- 3
-- 4
create or replace trigger tg1
before insert on Persons
begin
    dbms_output.put_line('before insert tg1');
end;

create or replace trigger tg2
before delete on Persons
begin
    dbms_output.put_line('before delete tg2 ');
end;

create or replace trigger tg3
before update on Persons
begin
    dbms_output.put_line('before update tg3');
end;

insert into Persons (id, name) values(11, 'name_11');
update Persons set name = '11_name' where id = 11;
delete from Persons where id = 11;
commit;

select * from Persons;

-- 5
create or replace trigger tg4
before insert or update or delete on Persons
for each row
begin
    dbms_output.put_line('before for each row');
end;

delete Persons where id > 5;
update Persons set name = 'Donald Trump' where id < 4;
rollback;

-- 6
create or replace trigger tg5
before insert or update or delete on Persons
begin
    if inserting then
        dbms_output.put_line('before inserting');
    elsif updating then
        dbms_output.put_line('before updating');
    elsif deleting then
        dbms_output.put_line('before deleting');
    end if;
end;

-- 7
create or replace trigger tg6
after insert on Persons
begin
    dbms_output.put_line('after insert');
end;

create or replace trigger tg7
after delete on Persons
begin
    dbms_output.put_line('after delete');
end;

create or replace trigger tg8
after update on Persons
begin
    dbms_output.put_line('after update');
end;

-- 8
create or replace trigger tg9
after insert or update or delete on Persons
for each row
begin
    dbms_output.put_line('after for each row');
end;

-- 9
create table AUDIT1
(
    OperationDate date,
    OperationType varchar2(100), 
    TriggerName varchar2(100),
    Data varchar2(100) 
);

-- 10
create or replace trigger tg10
before insert or update or delete on Persons
for each row 
begin
    if inserting then
        insert into AUDIT1(OperationDate, OperationType, TriggerName, Data)
        values (sysdate, 'Insert', 'before', concat('old:'||:old.id||:old.name, 'new:'||:new.id||:new.name));
    elsif updating then
        insert into AUDIT1(OperationDate, OperationType, TriggerName, Data)
        values (sysdate, 'Update', 'before', concat('old:'||:old.id||:old.name, 'new:'||:new.id||:new.name));
    elsif deleting then
        insert into AUDIT1(OperationDate, OperationType, TriggerName, Data)
        values (sysdate, 'Delete', 'before', concat('old:'||:old.id||:old.name, 'new:'||:new.id||:new.name));
    end if;
end;

create or replace trigger tg11
after insert or update or delete on Persons
for each row
begin
    if inserting then
        insert into AUDIT1(OperationDate, OperationType, TriggerName, Data)
        values (sysdate, 'Insert', 'after', concat('old:'||:old.id||:old.name, 'new:'||:new.id||:new.name));
    elsif updating then
        insert into AUDIT1(OperationDate, OperationType, TriggerName, Data)
        values (sysdate, 'Update', 'after', concat('old:'||:old.id||:old.name, 'new:'||:new.id||:new.name));
    elsif deleting then
        insert into AUDIT1(OperationDate, OperationType, TriggerName, Data)
        values (sysdate, 'Delete', 'after', concat('old:'||:old.id||:old.name, 'new:'||:new.id||:new.name));
    end if;
end;

CREATE OR REPLACE TRIGGER tg101
BEFORE INSERT OR UPDATE OR DELETE ON Persons
DECLARE
    v_operation_type VARCHAR2(10);
BEGIN
    IF INSERTING THEN
        v_operation_type := 'Insert';
    ELSIF UPDATING THEN
        v_operation_type := 'Update';
    ELSIF DELETING THEN
        v_operation_type := 'Delete';
    END IF;

    IF v_operation_type IS NOT NULL THEN
        INSERT INTO AUDIT1(OperationDate, OperationType, TriggerName, Data)
        SELECT sysdate, v_operation_type, 'tg101', 'Operation: ' || v_operation_type || ', Table: Persons'
        FROM dual;
    END IF;
END;

CREATE OR REPLACE TRIGGER tg100
AFTER INSERT OR UPDATE OR DELETE ON Persons

DECLARE
    v_operation_type VARCHAR2(10);
BEGIN
    IF INSERTING THEN
        v_operation_type := 'Insert';
    ELSIF UPDATING THEN
        v_operation_type := 'Update';
    ELSIF DELETING THEN
        v_operation_type := 'Delete';
    END IF;

    IF v_operation_type IS NOT NULL THEN
        INSERT INTO AUDIT1(OperationDate, OperationType, TriggerName, Data)
        SELECT sysdate, v_operation_type, 'tg100', 'Operation: ' || v_operation_type || ', Table: Persons'
        FROM dual;
    END IF;
END;

select * from Audit1;
truncate table Audit1;

-- 11 
insert into Persons (id, name) values (15, 'oxxxy');

-- 12
CREATE OR REPLACE TRIGGER tg12
BEFORE DROP ON SCHEMA
BEGIN
    RAISE_APPLICATION_ERROR(-20000, 'Do not drop ' || ORA_DICT_OBJ_TYPE || ' ' || ORA_DICT_OBJ_NAME);
END;

alter trigger tg12 disable;
drop table Audit1;

-- 13 
create view v1 as select * from Persons;
select * from v1;

create or replace trigger tg13
instead of insert or update or delete on v1
for each row
begin
    if inserting then 
        dbms_output.put_line('insert: ' || concat('old:'||:old.id||:old.name, 'new:'||:new.id||:new.name));
    elsif updating then 
        dbms_output.put_line('update: ' || concat('old:'||:old.id||:old.name, 'new:'||:new.id||:new.name));
    elsif deleting then 
        dbms_output.put_line('delete: ' || concat('old:'||:old.id||:old.name, 'new:'||:new.id||:new.name));
    end if;
end;

insert into v1(id, name) values (33, 'captain');
update v1 set id = 444 where id = 33;
delete v1;
drop view v1;

-- 14
select * from Audit1;