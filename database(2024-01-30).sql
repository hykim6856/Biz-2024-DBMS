-- 매입매출
/*
MySQL DataBase Dump
=> Database Schema
다른 DB에서 사용하거나
DB를 새로 설치할 경우  사전에 기존의 사용하던 DB를
백업하기
	메뉴의 Server / Data Export 를 선택하고
    백업할 Database 와 폴더를 선택한다.
복원히기 
	기존의 Database Schema가 없으면
    
	복원할 데이터 베이스 스키마를 생성
	메뉴의 Server / Data import 를 선택하여
    백업파일이 저장된 폴더를 선택한다
    백업할 때의 database Schema 와 같은 이름으로 Database를 생성해둔다.
    
*/
CREATE DATABASE ecountDB;
DROP DATABASE ecountdb;
DROP DATABASE newschema;

USE ecountDB;
SHOW TABLES;

/*
tbl_iolist table 의 데이터는 정규화(3정규화)가 완료된 상태이며,
 상품정보 거래처정보가 단기 외래키로 설정된 코드만 저장되어있다
 매입매출정보를 조회하면서, 상품정보와 거래처 정보를 연계하여
 보기 위해서는 Join을 실행해야한다.
 현재 Schema에 저장된 3개의 Taber은 "참조무결성" 관계가 설정되어있기 때문에
 EQ Join을 사용하여 데이터 조회에 문제가 없다.
 */
 
 
 -- 무조건적으로 두 테이블을 Join 하여 보기
 select *
 from tbl_iolist, tbl_product
 where io_pcode = p_code;
 
 -- 원하는 모양대로 조회결과를 확인하기 위해서는 
 -- 반드시 Projection 을 시행해야한다.
 -- Projection : 보고자 하는 모양대로 칼럼을 구헝하기
 select io_seq, io_date, io_time, 
 io_pcode, p_name,p_item, p_comp, 
 io_dcode, io_div, io_quan, io_iprice,io_oprice
 from tbl_iolist, tbl_products
 where io_pcode = p_code;
 
 /*join 을 통한 view 의 생성
 물리적인 2개이상의 테이블을 서로 연계하여 보고자 하는 모양의 
 view table을 출력하는 sql
 */
  select io_seq, io_date, io_time, 
 io_pcode, p_name,p_item, p_comp, 
 io_dcode, d_name, d_ceo, d_tel, d_addr,
 io_div, io_quan, io_iprice,io_oprice
 from tbl_iolist, tbl_products, tbl_depts
 where io_pcode = p_code and io_dcode = d_code;
 -- 이런것들이 join.(흐트러져있는데이터를 우리가 원하는 모양으로 보여주는것.)
 