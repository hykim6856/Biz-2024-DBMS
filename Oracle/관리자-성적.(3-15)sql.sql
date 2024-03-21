 -- 여기는 관리자 화면입니다.
 
 /*
 TableSpace : schoolDB
 DataFile : c:/app/data/shoolDB.dbf
 초기크기 : 00
 자동확장 : 00
 
 
사용지 : schoolUser
비번 12341234


 */
 CREATE TABLESPACE schoolDB
DATAFILE 'c:/app/data/schoolDB.dbf'
SIZE 1M AUTOEXTEND ON NEXT 1K;
 
 ALTER SESSION SET "_ORACLE_SCRIPT" = true;
 
CREATE USER schoolUser IDENTIFIED BY 12341234
DEFAULT TABLESPACE schoolDB; 

GRANT DBA TO schoolUser;
GRANT CREATE SESSION TO schoolUser;

--schoolUser 에게 tbl_student 테이블을 생성 하는 권한 부여하기
GRANT CREATE ANY TABLE TO schoolUser;
GRANT DROP ANY TABLE TO schoolUser;
GRANT ALTER ANY TABLE TO schoolUser;