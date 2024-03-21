
CREATE TABLE tbl_address (
a_code	VARCHAR2(6)		PRIMARY KEY	,
a_name	NVARCHAR2(20)	NOT NULL		,
a_tel	VARCHAR2(15)	NOT NULL		,
a_addr	NVARCHAR2(125)			,
a_hobby1	NVARCHAR2(20)			,
a_hobby2	nVARCHAR2(20)			,
a_hobby3	nVARCHAR2(20)			

);


SELECT COUNT (*) FROM tbl_address;
SELECT * FROM tbl_address;

-- 이름 순으로 오름차순 정렬하여 select 하기

desc
order

SELECT * FROM TBL_ADDRESS ORDER BY A_NAME ;

-- 이름, 전화번호, 취미1 칼럼만 나타나도록 pROJECTION 실행


SELECT a_name, a_TEL, a_hobby1 FROM tbl_address;

-- 이름 칼럼에 민 이란 단어가 포함된 리스트만 SELECTION 하라

SELECT * FROM tbl_address WHERE A_NAME LIKE '%민%' ORDER BY A_NAME;

-- 취미1 의 각 취미별 인원수를 계산하기
SELECT A_HOBBY1, COUNT(*)
FROM TBL_ADDRESS
GROUP BY A_HOBBY1
ORDER BY COUNT(A_HOBBY1) DESC;

-- 주소록 테이블에는 취미1 , 취미2, 취미3 이 있다..
-- 여행이 취미인 사람 리스트를 출력하기
SELECT *
FROM tbl_address
WHERE A_HOBBY1 LIKE '%여행%'
   OR A_HOBBY2 LIKE '%여행%'
   OR A_HOBBY3 LIKE '%여행%';
   
   -- 중복된 데이터 없이 취미 리스트 만들기
   --SELECT a_hobby1 FROM tbl_address WHERE a_hobby1 IS NOT NULL GROUP BY a_hobby1
   -- OR a_hobby2 IS NOT NULL GROUP BY a_hobby2
  -- OR a_hobby3 IS NOT NULL GROUP BY a_hobby3;
   
SELECT a_hobby1 AS hobby FROM tbl_address WHERE a_hobby1 IS NOT NULL
UNION
SELECT a_hobby2 AS hobby FROM tbl_address WHERE a_hobby2 IS NOT NULL
UNION
SELECT a_hobby3 AS hobby FROM tbl_address WHERE a_hobby3 IS NOT NULL;


SELECT *
FROM (
    SELECT a_hobby1 AS hobby FROM tbl_address WHERE a_hobby1 IS NOT NULL
    UNION
    SELECT a_hobby2 FROM tbl_address WHERE a_hobby2 IS NOT NULL
    UNION
    SELECT a_hobby3 FROM tbl_address WHERE a_hobby3 IS NOT NULL
) hobbies
ORDER BY hobby;


-- DROP AND CREATE
TRUNCATE TABLE tbl_address;
SELECT * FROM tbl_address;


SELECT * FROM (
    SELECT a_code AS 코드, a_hobby1 AS 취미 FROM tbl_address WHERE a_hobby1 IS NOT NULL GROUP BY a_code, a_hobby1 UNION
    SELECT a_code, a_hobby2 FROM tbl_address WHERE a_hobby2 IS NOT NULL GROUP BY a_code, a_hobby2 UNION
    SELECT a_code, a_hobby3 FROM tbl_address WHERE a_hobby3 IS NOT NULL GROUP BY a_code, a_hobby3
)
ORDER BY 코드, 취미;

DROP TABLE tbl_addr_hobby;

-- 취미 정보를 저장할 테이블 생성
CREATE TABLE tbl_hobby(
h_code	VARCHAR2(6)	NOT NULL	PRIMARY KEY	,
h_name	nVARCHAR2(20)	NOT NULL,
h_rem	VARCHAR2(125)	
);

CREATE TABLE tbl_addr_hobby (
    r_acode VARCHAR2(6) NOT NULL,
    r_hcode VARCHAR2(6) NOT NULL,
    CONSTRAINT ah_pk PRIMARY KEY (r_acode, r_hcode)
);

select count(*) from tbl_address;
select count(*) from tbl_hobby;
select count(*) from tbl_addr_hobby;

ALTER TABLE tbl_addr_hobby
ADD CONSTRAINT fk_addr
FOREIGN KEY (r_acode)
REFERENCES tbl_address(a_code);


ALTER TABLE tbl_addr_hobby
ADD CONSTRAINT fk_hobby
FOREIGN KEY(r_hcode)
REFERENCES tbl_hobby(h_code);


-- 정규화가 완료된 후 주소록 테이블에 불필요한 칼럼(hobby1, hobby2, hobby3) 없애기
ALTER TABLE tbl_adress DROP COLUMN a_hobby1;
ALTER TABLE tbl_adress DROP COLUMN a_hobby2;
ALTER TABLE tbl_adress DROP COLUMN a_hobby3;


-- 주소록의 데이터의 개인들이 어떤 취미를 갖는지 알고 싶다.
SELECT *
FROM tbl_address
    JOIN tbl_addr_hobby
        ON a_code = r_acode
    JOIN tbl_hobby
        ON r_hcode = h_code;
        
-- 주소록의 데이터의 개인들이 어떤 취미를 갖는지 알고 싶다.
SELECT A.* ,AH.r_hcode, H.h_name
FROM tbl_address A
    JOIN tbl_addr_hobby AH
        ON a_code = r_acode
    JOIN tbl_hobby H
        ON r_hcode = h_code;
        
-- 위의 SELECT(조회) 쿼리를 view_address 라는 이름의 view 로 생성하기        
CREATE VIEW view_address
AS (
SELECT A.* ,AH.r_hcode, H.h_name
FROM tbl_address A
    JOIN tbl_addr_hobby AH
        ON a_code = r_acode
    JOIN tbl_hobby H
        ON r_hcode = h_code
);

-- view 를 사용하여 주소록에서 각 취미별로 몇명이 속해 있는지 계산
select h_name, count(*) from view_address group by view_address.h_name;
/*
database의 간단한 산술 통계 계산 
개수, 합계, 평균, 최대값,최소값
COUNT SUM(), AVG(), MAX(), MIN()

산술통계를 할때 거의 필수적으로 포함되는 group by 절이 필요
*/

-- 조건 없이 전체 데이터의 개수
SELECT COUNT(*) FROM view_address;

-- 취미별로 라는 조건이 있으면 이때는 GROUP BY 가 필수이다.
-- 취미(취미코드, 취미명) 라는 칼럼으로 그룹핑을 하고
-- 그 그룹 내에 속한 레코드들의 개수가 몇개인가 
SELECT r_hcode, h_name,COUNT(*) FROM view_address
GROUP BY r_hcode, h_name
ORDER BY h_name;

-- 문자열 칼럼의 데이터 범위를 지정하여 확인하기
SELECT a_name, r_hcode, h_name FROM view_address
WHERE h_name BETWEEN '마술' AND '스키'
ORDER BY h_name;

SELECT a_name, r_hcode, h_name FROM view_address
WHERE h_name >= '마술' AND h_name <= '스키'
ORDER BY h_name;

-- 다중 OR 조건문
SELECT a_name, r_hcode, h_name FROM view_address
WHERE h_name = '마술' OR h_name = '사격' OR h_name = '쇼핑'
OR h_name = '스쿼시'
ORDER BY h_name;

-- AND 조건문은 BETWEEN 키워드를 사용하여 코드를 다소 간소화 할 수 있다.
-- 다중 OR 조건문을 간소화 하는 키워드를 찾아 sQL 을 작성

SELECT a_name, r_hcode, h_name FROM view_address
WHERE h_name IN ('마술','사격','쇼핑','스쿼시')
ORDER BY h_name;

((SELECT r_hcode, h_name,count(*) FROM view_address
WHERE h_name IN ('마술','사격','쇼핑')
Group BY r_hcode, h_name
ORDER BY count(*) DESC;))


-- 취미가 '마술', '사격', '여행' 인 사람들의 참여 인원수를 계산하기
SELECT h_name, count(*) FROM view_address
WHERE h_name IN ('마술','사격', '여행')
GROUP BY h_name;