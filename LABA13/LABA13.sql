ALTER SESSION SET nls_date_format='dd-mm-yyyy hh24:mi:ss';

create user C##PVGPDB IDENTIFIED by 1234;

GRANT UNLIMITED TABLESPACE TO C##PVGPDB;

GRANT ALL ON T_RANGE TO C##PVGPDB;


--1
create table T_RANGE
(
  id number,
  time_id date
)
partition by range(id)
(
  partition p1 values less than (100),
  partition p2 values less than (200),
  partition p3 values less than (300),
  partition pmax values less than (maxvalue)
);

insert into T_RANGE(id, time_id) values(1,'01-02-2022');
insert into T_RANGE(id, time_id) values(150,'01-02-2022');
insert into T_RANGE(id, time_id) values(250,'01-02-2022');
insert into T_RANGE(id, time_id) values(350,'01-02-2022');
commit;

select * from T_RANGE partition(p1);
select * from T_RANGE partition(p2);
select * from T_RANGE partition(p3);
select * from T_RANGE partition(pmax);
-- drop table T_RANGE;

--2
create table T_INTERVAL
(
  id number,
  time_id date
)
partition by range(time_id) interval (numtoyminterval(1,'month'))
(
  partition p0 values less than  (to_date ('1-4-2000', 'dd-mm-yyyy')),
  partition p1 values less than  (to_date ('1-8-2010', 'dd-mm-yyyy')),
  partition p2 values less than  (to_date ('1-12-2022', 'dd-mm-yyyy'))
);
-- drop table  T_INTERVAL;

insert into T_INTERVAL(id, time_id) values(1,'01-01-1999');
insert into T_INTERVAL(id, time_id) values(150,'01-01-2009');
insert into T_INTERVAL(id, time_id) values(510,'01-01-2014');
--insert into T_INTERVAL(id, time_id) values(710,'01-01-2020');
commit;

select * from T_INTERVAL partition(p0);
select * from T_INTERVAL partition(p1);
select * from T_INTERVAL partition(p2);
select * from T_INTERVAL;

-- 3
--drop table T_HASH
create table T_HASH
(
  str varchar2 (50),
  id number
)
partition by hash (str)
(
  partition k1,
  partition k2,
  partition k3
);

insert into T_HASH (str,id) values('asdssawesd', 1);
insert into T_HASH (str,id) values('gxdghghffdh', 2);
insert into T_HASH (str,id) values('/.....,,,,', 3);
insert into T_HASH (str,id) values('oiouuuoiu', 4);
commit;

select * from T_HASH partition(k1);
select * from T_HASH partition(k2);
select * from T_HASH partition(k3);
select * from T_HASH ;

--4
--drop table T_LIST
create table T_LIST
(
  x char(3)
)
partition by list (x)
(
  partition p1 values ('a', 'b', 'c'),
  partition p2 values ('d', 'e', 'f'),
  partition p3 values ('g'),
  partition p4 values (default)
);

insert into  T_LIST(x) values('a');
insert into  T_LIST(x) values('d');
insert into  T_LIST(x) values('g');
insert into  T_LIST(x) values('y');
commit;

select * from T_LIST partition (p1);
select * from T_LIST partition (p2);
select * from T_LIST partition (p3);
select * from T_LIST partition (p4);
select * from T_LIST;

--5,6
alter table T_RANGE enable row movement;
alter table T_INTERVAL  enable row movement;
alter table T_HASH  enable row movement;
alter table T_LIST enable row movement;

update T_RANGE partition(p1) set id=200 where id = 1;
update T_INTERVAL partition(p0) set time_id = '01-01-2015' where time_id = '01-01-1999';
update T_HASH partition(k1) set str='erlkf2efrsd' where str = 'oiouuuoiu';
update T_LIST partition(p1) set x='f' where x = 'a';

select * from T_RANGE  partition(p1);
select * from T_INTERVAL partition(p0);
select * from T_HASH partition(k2);
select * from T_LIST partition(p2);

select * from T_RANGE;
select * from T_INTERVAL;
select * from T_HASH;
select * from T_LIST;

--7
alter table T_RANGE merge partitions p1,p2 into partition p5;
select * from T_RANGE partition(p5);

--8
alter table T_INTERVAL split partition p2 at (to_date ('1-06-2018', 'dd-mm-yyyy')) into (partition p6, partition p5);

select * from T_INTERVAL partition (p5);
select * from T_INTERVAL partition (p6);

--9
--drop table T_LIST1
create table T_LIST1(x char(3));
alter table T_LIST exchange partition  p2 with table T_LIST1 without validation;

select * from T_LIST partition (p2);
select * from T_LIST1;

CREATE TABLE PODOBEDVLAD (
    customer_id NUMBER,
    customer_name VARCHAR2(50),
    region VARCHAR2(50)
)
PARTITION BY LIST (region)
(
    PARTITION north VALUES ('North'),
    PARTITION south VALUES ('South'),
    PARTITION east VALUES ('East'),
    PARTITION west VALUES ('West'),
    PARTITION other VALUES (DEFAULT)
);

INSERT INTO PODOBEDVLAD (customer_id, customer_name, region) VALUES (5, 'LESHA', 'North');
INSERT INTO PODOBEDVLAD (customer_id, customer_name, region) VALUES (2, 'VLAD', 'North');
INSERT INTO PODOBEDVLAD (customer_id, customer_name, region) VALUES (3, 'NIKITA', 'South');
INSERT INTO PODOBEDVLAD (customer_id, customer_name, region) VALUES (4, 'DIMA', 'Central');

SELECT * FROM PODOBEDVLAD PARTITION (north);
SELECT * FROM PODOBEDVLAD;
