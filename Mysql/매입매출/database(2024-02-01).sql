-- 매입매출
drop database edb;
CREATE DATABASE edb;
USE ecountdb;
SHOW TABLES;
SELECT * FROM tbl_iolist; 
SELECT * FROM tbl_members; 
-- 데이터만 없애기
TRUNCATE tbl_members;
TRUNCATE tbl_iolist;

/*
기존의 Table 구조 변경하기 
칼럼의 이름을 변경하거나, 칼럼의 type 을 변경하는 일 
FK를 새로 설정하거나, PK 도 새로 설정 또는 변경하는 일
ALTER TABLE ... 명령을 사용하여 변경한다.

기존 table 구조를 변경할 때 발생할 수 있는 여러가지 문제
1. 칼럼의 Type 을 변경 : 문자열-> 숫자, 숫자-> 문자열, 저장공간 변경
	Type 의 형태에 따라 문제를 일으키는데, 보편적인 DB SW 에서는 문제가 발생하면 명령 실행 자체가 실패한다.
    하지만 간혹 대량의 데이터가 보관되어있는 경우, 실행이 진행되다가 중간에 중단되는 경우도 있다.
    이럴때 기존의 데이터에 손상이 가해지는 경우가 있다.
2. 칼럼의 이름 변경 : 연관된 여러 애플리케이션에서 해당 칼럼을 찾지 못하는 문제가 발생됨.

3. 제약조건 : FK, PK 등의 제약조건의 변경
	데이터의 무결성 보장이 해제되는 문제를 일으킨다.
*/

-- 칼럼의 이름과 타입변경
-- 1. m_pass 에 VARCHAR(50) 이라는 칼럼생성
-- 2. m_password 칼럼에 저장된 데이터를 m_pass 로 이동 또는 복사
-- 3. m_password 칼럼을 삭제
ALTER TABLE tbl_members
CHANGE m_password m_pass VARCHAR(50);
DESC tbl_members;

ALTER TABLE tbl_members
CHANGE m_pass m_password VARCHAR(125);

-- 칼럼의 type만 변경할때
ALTER TABLE tbl_members
MODIFY m_password VARCHAR(255);

-- 칼럼의 이름만 변경하고 싶을 때
ALTER TABLE tbl_members
CHANGE m_password m_pass VARCHAR(50);

-- FK 
ALTER TABLE tbl_iolist
ADD CONSTRAINT FK_PCODE
FOREIGN KEY (io_pcode)
REFERENCES tbl_products(p_code);

-- FK 삭제
ALTER TABLE tbl_iolist
DROP CONSTRAINT FK_PCODE;

SELECT * FROM tbl_members;
SELECT * FROM tbl_products;tbl_iolist
