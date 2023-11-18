create tablespace TS_PDB_PVG
  datafile 'TS_PDB_PVG1.dbf'
  size 7M
  autoextend on next 5M
  maxsize 20M
  extent management local;

create temporary tablespace TS_PDB_PVG_TEMP
  tempfile 'TS_PDB_PVG_TEMP1.dbf'
  size 5M
  autoextend on next 3M
  maxsize 30M;

--drop role RL_PDB_PVGCORE;
create role RL_PDB_PVGCORE;

grant connect, create session, create any table, drop any table, create any view,
drop any view, create any procedure, drop any procedure to RL_PDB_PVGCORE;

--drop profile PF_PDB_PVGCORE;
create profile PF_PDB_PVGCORE1 limit
  password_life_time 365
  sessions_per_user 5
  failed_login_attempts 5
  password_lock_time 1
  password_reuse_time 10
  password_grace_time default
  connect_time 180
  idle_time 45;

--drop user U1_PVG_PDB;
aler user U1_PVG_PDB1 identified by 123457
default tablespace TS_PDB_PVG quota unlimited on TS_PDB_PVG
temporary tablespace TS_PDB_PVG_TEMP
profile PF_PDB_PVGCORE
account unlock
password expire;

grant RL_PDB_PVGCORE to U1_PVG_PDB1;

------------------------------------ Задание №7
-- U1_PVG_PDB
create table PVG_table ( x number(2), y varchar(5));

--alter user U1_PVG_PDB1 grant quota 

insert into PVG_table values (1, 'first');
insert into PVG_table values (3, 'third');
commit;

select * from PVG_table;

------------------------------------ Задание №8
-- SYSTEM
select * from DBA_ROLES;
select * from DBA_PROFILES;
select * from ALL_USERS;

select * from DBA_DATA_FILES;
select * from DBA_TEMP_FILES;
select GRANTEE, PRIVILEGE from DBA_SYS_PRIVS;

------------------------------------ Задание №9
-- CDB
create user C##PVG identified by 12345;
grant connect, create session, alter session, create any table,
drop any table to C##PVG container = all;
-- PDB
grant create session to C##PVG;


------------------------------------ Задание №13
alter pluggable database PVG_PDB close immediate;
drop pluggable database PVG_PDB including datafiles;
drop user C##PVG;