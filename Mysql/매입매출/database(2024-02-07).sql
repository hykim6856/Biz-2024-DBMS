-- iolist 작업화면
USE ecountDB;
SHOW TABLES;
DESC tbl_products;

/*
기존의 상품정보 테이블에 이미지 정보를 추가하기 위하여 칼럼을 추가하기
기존의 데이터가 있는 테이블에 새로운 칼럼을 추가하는 것은 테이블의 구조를 변경하는 것이다.
실무에서 운영중인 테이블의 구조를 변경하는 것은 매우 신중해야한다.
구조를 변경하는 명령이 실행되면, 사용중인 테이블은 락이 걸리고 모든 CRUD 가 금지된다.
만약 활발하게 조회 등이 발생하는 테이블의 경우 다른 Transaction 의 영향으로 전체 시스템에 문제가 발생할 수도 있다.
*/

-- 칼롬 추가하기
ALTER TABLE tbl_products
ADD COLUMN p_image_name
VARCHAR(255);

DESC tbl_products;

ALTER TABLE tbl_products
ADD COLUMN p_image_origin_name
VARCHAR(255);

SELECT * FROM tbl_products
ORDER BY p_image_name DESC;

-- LIKE 연산자
/* 문자열에 포함된 일부 값으로 조회하기
SELECT 명령문중에서 가장 느린 연산
SELECT WHERE 을 사용하면 Index 라는 것을 내부적으로 사용
또는 여러가지 검색 알고리즘을 사용하여 최적의 검색을 한다.
DBMS 에서는 보통 이진 TREE 를 응용한 검색을 많이 사용한다.

하지만 like 키워드가 있는 select 는 순차검색을 한다.
*/
SELECT * FROM tbl_products
WHERE p_name LIKE '%초코%';

-- like 연산자를 사용하여 selsect를 실행하는데 조건이 없다.
SELECT * FROM tbl_products
WHERE p_name LIKE '%%';