-- Задание №1
grant create sequence, create cluster, create synonym, create public synonym, create materialized view to U3_PVG_PDB;
grant CREATE CLUSTER to U3_PVG_PDB;
grant insert CLUSTER ABC to U3_PVG_PDB;
-- sys in pdb
grant select on SYS.DBA_CLUSTERS to U3_PVG_PDB;
grant select on SYS.DBA_TABLES to U3_PVG_PDB;
grant execute on DBMS_MVIEW to U3_PVG_PDB;

GRANT INSERT ON T1 TO U3_PVG_PDB;

-- Задание №2
CREATE SEQUENCE S1
INCREMENT BY 10
START WITH 1000
NOMINVALUE
NOMAXVALUE
NOCYCLE
NOCACHE
NOORDER;

select * from S1;

-- DROP SEQUENCE S1;

COMMIT;

SELECT S1.nextval FROM dual;
SELECT S1.currval FROM dual;

-- Задание №3 и №4
CREATE SEQUENCE S2
START WITH 10
INCREMENT BY 10
MAXVALUE 100
NOCYCLE;
COMMIT;

SELECT S2.nextval FROM dual;
SELECT S2.currval FROM dual;

ALTER SEQUENCE S2 INCREMENT BY 100;

-- DROP SEQUENCE S2;

-- Задание №5
CREATE SEQUENCE S3
START WITH 10
INCREMENT BY -10
MINVALUE -100
MAXVALUE 20
NOCYCLE
ORDER;
COMMIT;

SELECT S3.nextval FROM dual;
SELECT S3.currval FROM dual;

ALTER SEQUENCE S3 INCREMENT BY -100;

-- DROP SEQUENCE S3;

COMMIT;

-- Задание №6
CREATE SEQUENCE S4
START WITH 1
INCREMENT BY 1
MAXVALUE 10
CYCLE
CACHE 5
NOORDER;
COMMIT;

SELECT S4.nextval FROM dual;
SELECT S4.currval FROM dual;

-- DROP SEQUENCE S4;

-- Задание №7
SELECT * FROM SYS.ALL_SEQUENCES WHERE SEQUENCE_OWNER = 'U3_PVG_PDB';

-- Задание №8

create table T1
(
    N1 number(20),
    N2 number(20),
    N3 number(20),
    N4 number(20)
) cache storage
(
    buffer_pool keep
);
  
  CREATE SEQUENCE S1;
CREATE SEQUENCE S2;
CREATE SEQUENCE S3;
CREATE SEQUENCE S4;

ALTER USER U3_PVG_PDB QUOTA 2M ON T1;

SELECT GRANTEE, PRIVILEGE
FROM DBA_TAB_PRIVS
WHERE TABLE_NAME = 'T1';

GRANT SELECT ON S1 TO pdb_admin;
GRANT SELECT ON S2 TO U3_PVG_PDB;
GRANT SELECT ON S3 TO U3_PVG_PDB;
GRANT SELECT ON S4 TO U3_PVG_PDB;
GRANT INSERT ON T1 TO U3_PVG_PDB;

SELECT GRANTEE, PRIVILEGE
FROM DBA_TAB_PRIVS
WHERE T1 IN ('S1', 'S2', 'S3', 'S4');


INSERT INTO T1 (N1, N2, N3, N4) VALUES (S1.nextval, S2.nextval, S3.nextval, S4.nextval);

select * from T1;

-- Задание №9
CREATE CLUSTER ABC
(
    X number(10),
    V varchar(12)
    )HASHKEYS 200;
COMMIT;

-- DROP CLUSTER ABC;

-- Задание №10
CREATE TABLE A
(
    XA number(10),
    VA varchar(12),
    ZA number(2)
)CLUSTER ABC(XA, VA);

-- DROP TABLE A;

-- Задание №11
CREATE TABLE B
(
    XB number(10),
    VB varchar(12),
    ZB number(2)
)CLUSTER ABC(XB, VB);

-- DROP TABLE B;

-- Задание №12
CREATE TABLE C
(
    XC number(10),
    VC varchar(12),
    ZC number(2)
)CLUSTER ABC(XC, VC);

-- DROP TABLE C;

-- Задание №13
SELECT * FROM USER_TABLES;
SELECT * FROM USER_CLUSTERS;

-- Задание №14
CREATE SYNONYM SYNONC FOR C;
COMMIT;

-- DROP SYNONYM SYNONC;

SELECT * FROM SYNONC;

-- Задание №15
CREATE PUBLIC SYNONYM SYNONB FOR B;
COMMIT;

-- DROP PUBLIC SYNONYM SYNONB;

SELECT * FROM SYNONB;

-- Задание №16
CREATE TABLE First_table
(
    Some_number number(2) primary key,
    Some_string nvarchar2(20)
);

-- DROP TABLE First_table;

CREATE TABLE Second_table
(
    Second_string nvarchar2(20),
    Second_number number(2),
    constraint Some_number_fk foreign key (Second_number) references First_table(Some_number)
);

-- DROP TABLE Second_table;

COMMIT;

INSERT INTO First_table (Some_number, Some_string) VALUES (1, 'First string');
INSERT INTO First_table (Some_number, Some_string) VALUES (2, 'Second string');
INSERT INTO Second_table (Second_string, Second_number) VALUES ('First string', 1);
INSERT INTO Second_table (Second_string, Second_number) VALUES ('Second string', 2);

CREATE VIEW V1 AS SELECT * FROM First_table JOIN Second_table St on First_table.Some_number = St.Second_number;
SELECT * FROM V1;

-- DROP VIEW V1;

-- Задание №17
CREATE MATERIALIZED VIEW MV
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND NEXT SYSDATE+NUMTODSINTERVAL(2, 'minute')
AS SELECT * FROM First_table LEFT JOIN Second_table St on First_table.Some_number = St.Second_number;

-- DROP MATERIALIZED VIEW MV;

SELECT * FROM MV;
COMMIT;