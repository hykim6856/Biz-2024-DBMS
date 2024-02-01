-- 매입매출
DROP DATABASE edb;
CREATE DATABASE edb;
USE edb;
SHOW TABLES;
SELECT * FROM tbl_members;

DESC tbl_iolist;
-- 정의된 FK 를 삭제하기
ALTER TABLE tbl_iolist
DROP FOREIGN KEY FK_PCODE;

-- FK 정의
-- TABLE 간의 참조무결성관계를 설정하기
-- 1:N 관계의 Table 에서 N의 위치에 있는 table 에 선언
ALTER TABLE tbl_iolist
ADD CONSTRAINT FK_PCODE
FOREIGN KEY (io_pcode)
REFERENCES tbl_products(p_code);

