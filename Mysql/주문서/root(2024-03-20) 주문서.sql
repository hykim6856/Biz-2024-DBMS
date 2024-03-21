-- 주문서 프로젝트
/*
주분서 excep 파일의 고객정보, 상품정보 데이터를 참조하여
1. 주문원장의 "상품코드" 칼럼의 데이터를 분리 후 
2. "주문내역" 테이블로 이전하는 정규화 실행
3. 주문원장, 주문내역, 고객정보, 상품정보
	4가지 Entity 의 개념적 모델링
4. 논리적, 물리적 모델링
5. Table 명세 생성

Database : tmp_orderDB
*/

create database tmp_orderDB;
use tmp_orderDB;

DROP TABLE tbl_custom;
DROP TABLE tbl_order;
DROP TABLE tbl_product;
DROP TABLE tbl_order_list;

CREATE TABLE tbl_custom (
    c_code VARCHAR(5) PRIMARY KEY,
    c_name VARCHAR(5) NOT NULL,
    c_tel VARCHAR(13)
);

CREATE TABLE tbl_product (
    p_code VARCHAR(6) PRIMARY KEY,
    p_name VARCHAR(20) NOT NULL,
    p_item VARCHAR(10),
    p_price INT
);

-- 주문원장
CREATE TABLE tbl_order_list (
    ol_code VARCHAR(6) PRIMARY KEY,
    ol_date VARCHAR(10),
    ol_ccode VARCHAR(5)
);

-- 주문내역
CREATE TABLE tbl_order (
    o_code VARCHAR(6),
    o_pcode VARCHAR(6)
    );

ALTER TABLE tbl_order
ADD CONSTRAINT fk_customer_code 
FOREIGN KEY (o_ccode) 
REFERENCES tbl_custom(c_code);


select * from tbl_custom;
select * from tbl_product;
select * from tbl_order_list;
SHOW INDEX FROM tbl_order_list;


SELECT * FROM (
SELECT o_code AS 주문코드, o_pcode1 AS 상품코드 FROM tbl_order WHERE o_pcode1 IS NOT NULL GROUP BY o_code, o_pcode1 UNION
SELECT o_code, o_pcode2 FROM tbl_order WHERE o_pcode2 IS NOT NULL GROUP BY o_code, o_pcode2 UNION
SELECT o_code, o_pcode3 FROM tbl_order WHERE o_pcode3 IS NOT NULL GROUP BY o_code, o_pcode3
) AS 주문내역
ORDER BY 주문코드, 상품코드;


-- 주문내역 테이블에 주문원장 테이블과의 관계를 정의하는 외래 키 추가
ALTER TABLE tbl_order
ADD CONSTRAINT fk_o_code FOREIGN KEY (o_code) REFERENCES tbl_order_list(ol_code);

-- tbl_custom 테이블에 외래 키 제약 조건 추가
ALTER TABLE tbl_custom
ADD CONSTRAINT fk_c_code FOREIGN KEY (c_code) REFERENCES tbl_order_list(ol_ccode);

-- tbl_order 테이블에 외래 키 제약 조건 추가
ALTER TABLE tbl_order
ADD CONSTRAINT fk_o_pcode FOREIGN KEY (o_pcode) REFERENCES tbl_product(p_code);

SELECT 
    tbl_order.o_code AS 주문번호,
    tbl_order_list.ol_date AS 거래일자,
    tbl_order_list.ol_ccode AS 고객코드,
    tbl_custom.c_name AS 고객명,
    tbl_custom.c_tel AS 연락처,
    tbl_order.o_pcode AS 상품코드
FROM 
    tbl_order
JOIN 
    tbl_order_list ON tbl_order.o_code = tbl_order_list.ol_code
JOIN 
    tbl_custom ON tbl_order_list.ol_ccode = tbl_custom.c_code;
