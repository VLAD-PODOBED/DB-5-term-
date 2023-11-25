------------------------------------ Задание №1
select * from dba_pdbs;
select * from v$pdbs;

------------------------------------ Задание №2
select * from v$instance;

------------------------------------ Задание №3
select * from SYS.PRODUCT_COMPONENT_VERSION;
 
------------------------------------ Задание №4
create pluggable database PVG_PDB admin user pdb_admin identified by 1234
roles = (DBA) file_name_convert =('D:\ORACLE\ORADATA\ORCL\PDBSEED', 'D:\бд\LABA3');

alter session set "_ORACLE_SCRIPT" = true;

alter pluggable database PVG_PDB open;

select * from dba_tablespaces;
select * from dba_roles;
select * from dba_users;
------------------------------------ Задание №5
select * from dba_pdbs;
------------------------------------ Задание №6
-- PDB
create tablespace TS_PDB_PVG
  datafile 'TS_PDB_PVG.dbf'
  size 7M
  autoextend on next 5M
  maxsize 20M
  extent management local;

create temporary tablespace TS_PDB_PVG_TEMP
  tempfile 'TS_PDB_PVG_TEMP.dbf'
  size 5M
  autoextend on next 3M
  maxsize 30M;

--drop role RL_PDB_PVGCORE;
create role RL_PDB_PVGCORE;

grant connect, create session, create any table, drop any table, create any view,
drop any view, create any procedure, drop any procedure to RL_PDB_PVGCORE;

--drop profile PF_PDB_PVGCORE;
create profile PF_PDB_PVGCORE limit
  password_life_time 365
  sessions_per_user 5
  failed_login_attempts 5
  password_lock_time 1
  password_reuse_time 10
  password_grace_time default
  connect_time 180
  idle_time 45;

--drop user U1_PVG_PDB;
create user U2_PVG_PDB identified by 123456
default tablespace TS_PDB_PVG quota unlimited on TS_PDB_PVG
temporary tablespace TS_PDB_PVG_TEMP
profile PF_PDB_PVGCORE
account unlock
password expire;

grant RL_PDB_PVGCORE to U2_PVG_PDB;

select * from dba_users where username = 'U2_PVG_PDB';


alter session set "_ORACLE_SCRIPT" = true;

CREATE ROLE RL_PDB_PVG;
GRANT ALL PRIVILEGES TO RL_PDB_PVG;
GRANT CREATE SESSION TO RL_PDB_PVG;
COMMIT;

CREATE PROFILE PF_PDB_PVG LIMIT
PASSWORD_LIFE_TIME 180
SESSIONS_PER_USER 3
FAILED_LOGIN_ATTEMPTS 7
PASSWORD_LOCK_TIME 1
PASSWORD_REUSE_TIME 10
PASSWORD_GRACE_TIME DEFAULT
CONNECT_TIME 180
IDLE_TIME 30;

CREATE USER U3_PVG_PDB IDENTIFIED BY 12345
PROFILE PF_PDB_PVG
ACCOUNT UNLOCK;

ALTER USER U3_PVG_PDB QUOTA 2M ON TS_PDB_PVG;
GRANT CREATE TABLE TO U3_PVG_PDB;
GRANT INSERT ON PVG_table TO U3_PVG_PDB;
GRANT CREATE SESSION TO U3_PVG_PDB;
------------------------------------ Задание №7
-- U3_PVG_PDB
create table PVG_table ( x number(2), y varchar(5));
GRANT CREATE TABLE TO U3_PVG_PDB;

insert into PVG_table values (1, 'first');
insert into PVG_table values (3, 'third');
commit;

select * from PVG_table1;


CREATE TABLE PVG_table1
(
    Name nvarchar2(20),
    NumberOfGroup number(2)
)TABLESPACE TS_PDB_PVG;

DROP TABLE PVG_table;

INSERT INTO PVG_table1 (Name, NumberOfGroup) VALUES ('Oracle', 6);
INSERT INTO PVG_table1 (Name, NumberOfGroup) VALUES ('Oracle', 4);
commit;

------------------------------------ Задание №8
-- SYSTEM
select * from DBA_ROLES;
select * from DBA_PROFILES;
select * from ALL_USERS;

select * from DBA_DATA_FILES;
select * from DBA_TEMP_FILES;
select GRANTEE, PRIVILEGE from DBA_SYS_PRIVS;

------------------------------------ Задание №9
CREATE USER C##PVG2 IDENTIFIED BY 12345
ACCOUNT UNLOCK;

GRANT CREATE SESSION TO C##PVG2;

------------------------------------ Задание №12
SELECT *  FROM DBA_DATA_FILES;

------------------------------------ Задание №13
alter pluggable database PVG_PDB close immediate;
drop pluggable database PVG_PDB including datafiles;
drop user C##PVG;