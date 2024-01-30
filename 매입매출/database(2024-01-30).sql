-- 매입매출
/*
MySQL DataBase Dump 하기
=> Database Schema 를 통째로 파일로 백업하기
다른 DB 에서 사용하거나
DB를 새로 설치할 경우 사전에 기존의 사용하던 DB 를
백업하기
	메뉴의 Server / Data Export 를 선택하고
	백업할 Database 와 폴더를 선택한다
복원하기
	기존의 Database Schema 가 없으면
	복원할 Database Schema 를 생성
    메뉴의 Server / Data Import 를 선택하여
    백업파일이 저장된 폴더를 선택한다
    백업할때의 Databas Schema 와 같은 이름으로
    Database 를 생성해 둔다
*/
DROP DATABASE ecountDB;
CREATE DATABASE ecountdb;


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
 from tbl_iolist, tbl_products
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
 
 /*
 table 과 table을 연계하는 과정에서 
 참조무결성이 되어있지 않은 경우도 매우 많다
 이때는 절대 EQ JOIN 을 사용해서는 안된다.
 참조 무결성이 되지 않은 table 을 EQ JOIN 으로 연계하는 경우
 보여지는 데이터가 누락되거나, 전혀 엉뚱한 리스트가 보여질 수 있다. 
  
  이때는 EQ JOIN 이 아닌 OUTTER(혹은 INNER) JOIN 을 사용해야한다.
  INNER JOIN 은 실무에서 별로 사용하지 않고
  주로 outter join 을 사용한다.
  outter join 에는 left out join, right out join 이 있으며 
  주로 left out join 을 사용한다.
  left out join 은 out 키워드를 생략하고
  일반적으로 left join이라고 명명한다.
 */
 
 
 /*
 키워드 왼쪽에 있는 테이블 전체를 펼쳐 놓고, 
 tbl_iolist.io_pcode 값으로 
  키워드 오른쪽 테이블(tbl_products)의 p_code 값을 조건(on)으로 select 한다.
  이때 tbl_products 테이블에 해당조건과 일치하는 값이 있으면 그 데이터를 같이 보여주고 
  없으면 null로 표현하여 보여주기
 */
 
 -- 매입매출과 거래처 정보를 연계한 join
  select io_seq, io_date, io_time, 
 io_pcode, p_name,p_item, p_comp, 
 io_dcode, io_div, io_quan, io_iprice,io_oprice
 from tbl_iolist
 left join tbl_products
 on io_pcode=p_code;
 
 select io_seq, io_date, io_time, 
 io_pcode,
 io_dcode, d_name, d_ceo, d_tel, d_addr,
 io_div, io_quan, io_iprice,io_oprice
 from tbl_iolist
 left join tbl_depts
 on io_pcode=d_code;
 -- -------------------------------------------------
 -- 뷰 만들기.
 /*
 view 의 생성
 복잡한select 명령문을 자주 사용해야하는 경우
 사용할때마다 명령을 입력해야하는 번거로움이 존재한다
 이때 복잡한 select 명령문을 view 로 등록해두면
 마치 물리적인 table 을 조회하는 것과 똑같이 
 select 를 실행하여 결과를 확인할 수 있다.
 
 view 를 생성할때 "projection 을 적절히 수행"하여
 view를 만들어두고 권한이 제한적인 관리자(사용자)에게
 해당 
 
 view에도 변화된 데이터가 조회된다.
 
 요즘의 db 소프트웨어에서는 view 를 통하여 제한적으로 crud가 모두 가능하다.
 초기 뷰는 select only 로 사용되었다.
 
 */
 CREATE VIEW view_iolist AS 
 (
	select io_seq, io_date, io_time, 
	 io_pcode, p_name,p_item, p_comp, 
	 io_dcode, d_name, d_ceo, d_tel, d_addr,
	 io_div, io_quan, io_iprice,io_oprice
	 from tbl_iolist
	 left join tbl_depts
	 on io_pcode=d_code
	  left join tbl_products
	 on io_pcode=p_code
     );
     
select * from view_iolist;
select * from view_iolist
order by io_pcode;

select * from view_iolist 
where io_date between '2023-02-01' and '2023-02-29';

select io_date, io_pcode, p_name
from view_iolist;

select io_date, io_pcode, p_name,
io_quan * io_iprice as 매입금액,
io_quan * io_oprice as 매출금액
from view_iolist
order by io_date;

-- 상품명 별로 매입 매출 전체 합산 구하기
select io_pcode, p_name,
sum(io_quan * io_iprice) as 매입합계,
sum(io_quan * io_oprice) as 매출합계
from view_iolist
group by io_pcode, p_name
order by p_name;

-- 상품명 별로 매입 매출 합산을 구하고
-- 매입, 매출금액이 많은 상품부터 정렬하여 나열하기
-- 합계와 합산은 개념적으로 약간 다른의미
-- 합산은 통계와 연관된단어

select io_pcode, p_name,
sum(io_quan * io_iprice) as 매입합산,
sum(io_quan * io_oprice) as 매출합산
from view_iolist
group by io_pcode
order by 매입합산 desc, 매출합산 desc;
-- db 소프트웨어에 따라 order by  alias 를
-- 사용할 수 없는 경우도 있다. 이때는 식을 사용하아ㅕ
-- order by sum(io_quan * io_iprice) desc,
-- sum(io_quan * io_oprice) desc


select io_pcode, p_name,
sum(io_quan * io_iprice) as 매입합산,
sum(io_quan * io_oprice) as 매출합산
from view_iolist
group by io_pcode
having 매입합산 > 536199
order by 매입합산 desc, 매출합산 desc;

--  매입매출 데이터에서 매입항목(io_div =1)만 select
-- 상품코드, 상품명, 매입합계를 출력
select io_div,
sum(io_quan * io_iprice) as 매입합산,
sum(io_quan * io_oprice) as 매출합산
from view_iolist
group by io_div='1'
having io_div;

select io_div,
sum(io_quan * io_iprice) as 매입합산,
sum(io_quan * io_oprice) as 매출합산
from view_iolist
where io_div='1'
group by io_div;