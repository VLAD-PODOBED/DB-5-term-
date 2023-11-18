-- ������� �1
SELECT SUM(VALUE) FROM V$SGA;
-- ������� �2
SELECT * FROM V$SGA;
-- ������� �3
SELECT COMPONENT, GRANULE_SIZE, CURRENT_SIZE / GRANULE_SIZE AS RATIO FROM V$SGA_DYNAMIC_COMPONENTS;
-- ������� �4
SELECT CURRENT_SIZE FROM V$SGA_DYNAMIC_FREE_MEMORY;
-- ������� �5
SELECT COMPONENT, MAX_SIZE, CURRENT_SIZE FROM V$SGA_DYNAMIC_COMPONENTS;
-- ������� �6
SELECT COMPONENT, CURRENT_SIZE FROM V$SGA_DYNAMIC_COMPONENTS WHERE COMPONENT LIKE '%DEFAULT%' OR COMPONENT LIKE'%KEEP%'
                                                                OR COMPONENT LIKE '%RECYCLE%';
-- ������� �7
CREATE TABLE PVG5_table
(
    Id number(2)
)STORAGE ( BUFFER_POOL KEEP );
INSERT INTO PVG5_TABLE (ID) VALUES (1);
INSERT INTO PVG5_TABLE (ID) VALUES (2);
INSERT INTO PVG5_TABLE (ID) VALUES (3);
COMMIT;
SELECT SEGMENT_NAME, TABLESPACE_NAME, BUFFER_POOL FROM USER_SEGMENTS;    
-- ������� �8
CREATE TABLE Some_table
(
    Id number(2)
)STORAGE ( BUFFER_POOL DEFAULT );
INSERT INTO Some_table (ID) VALUES (1);
INSERT INTO Some_table (ID) VALUES (2);
INSERT INTO Some_table (ID) VALUES (3);
COMMIT;
SELECT SEGMENT_NAME, TABLESPACE_NAME, BUFFER_POOL FROM USER_SEGMENTS;
-- ������� �9
-- � �������: SHOW PARAMETER log_buffer;
-- ������� �10
SELECT (MAX_SIZE - CURRENT_SIZE) AS Free_space FROM V$SGA_DYNAMIC_COMPONENTS WHERE COMPONENT = 'large pool';
-- ������� �11
SELECT USERNAME, SERVICE_NAME, SERVER, OSUSER, MACHINE, PROGRAM FROM V$SESSION WHERE USERNAME iS NOT NULL;
-- ������� �12
SELECT NAME, DESCRIPTION FROM V$BGPROCESS WHERE PADDR != '00';
-- ������� �13
SELECT PNAME, PID, USERNAME, PROGRAM FROM V$PROCESS;
-- ������� �14
SELECT COUNT(*) FROM V$BGPROCESS WHERE PADDR != '00' AND NAME LIKE 'DBW%';
-- ������� �15
SELECT * FROM V$SERVICES;
-- ������� �16
SELECT * FROM V$DISPATCHER;
-- � �������: show parameter dispatchers;
-- ������� �17
-- OracleOraDB21Home1 TNSListener
-- ������� �18
-- listener.ora

-- ������� �19
-- lsnrctl
-- help --> start, stop,status - ready, blocked, unknown
-- services, version
-- servacls - get access control lists
-- reload - reload the parameter files and SIDs
-- save_config - saves configuration changes to parameter file

-- ������� �20
SELECT NAME, NETWORK_NAME FROM V$SERVICES;






                                            