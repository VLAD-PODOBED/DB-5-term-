create pluggable database PVG1_PDB admin user pdb_admin identified by 1234
roles = (DBA) file_name_convert =('D:\ORACLE\ORADATA\ORCL\PDBSEED', 'D:\αδ\pdb');

alter session set "_ORACLE_SCRIPT" = true;

alter pluggable database PVG1_PDB open;