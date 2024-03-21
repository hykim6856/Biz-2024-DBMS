-- 학생성적 데이터
use scoredb;

show tables;

SELECT 
    ST.*, SC.s_subject, SC.s_socore
FROM
    tbl_student ST
        JOIN
    tbl_score SC ON ST.st_num = SC.s_stnum;

SELECT 
    ST.st_num, ST.st_name, ST.st_dept, SC.s_subject, SC.s_score
FROM
    tbl_student ST
        JOIN
    tbl_score SC ON ST.st_num = SC.s_stnum;
    
-- 학생-성적 테이블을 join 하여 확인을 하면
-- 성적테이블의  연관 데이터 개수 만큼 레코드(row) 가 출력된다.
-- 일반적인 데이터 확인 하는데는 큰 문제가 없지만 보고서 형식의 출력을 원할때는 다소 불편한 모양이다.

-- 이럴때 키 (pK)를 기준으로 1개의 레코드 만 출력되고 연관된 데이터를 가로 방향으로 나열하는 방법

-- 조건문을 이용하여 국
SELECT 
    ST.st_num,
    ST.st_name,
    IF(SC.s_subject = '국어', SC.s_score, 0)
FROM
    tbl_student ST
        JOIN
    tbl_score SC
WHERE
    ST.st_num = 'S0001';
    
    -- 위의 결과에서 국어점수는 표시가 되고, 나머지 점수는 0으로 나타난다.
    -- 표시된 '국어'
    
    SELECT ST.st_num, ST.st_name,
    sum(if(SC.s_subject ='국어', SC.s_score,0)) AS 국어,
    sum(if(SC.s_subject ='영어', SC.s_score,0)) AS 영어,
    sum(if(SC.s_subject ='수학', SC.s_score,0)) AS 수학,
    sum(if(SC.s_subject ='음악', SC.s_score,0)) AS 음악,
    sum(if(SC.s_subject ='미술', SC.s_score,0)) AS 미술,
    sum(if(SC.s_subject ='데이터베이스', SC.s_score,0)) AS db,
    sum(if(SC.s_subject ='소프트웨어공학', SC.s_score,0)) AS sw
    from tbl_student ST
    JOIN
    tbl_score SC
    ON ST.st_num = SC.s_stnum
	GROUP BY ST.st_num, ST.st_name;
    
    /*my sql 통계함수
    sum():합계, AVG() : 평균, count() : 개수
    MAX():최대값, Min(): 최솟값
    
    my sql 수학함수
    round() 실수(float) 를 소숫점 반올림하여 값 정리하기
    round(값, 소숫자리수)
    round(3.62) 결과는 4, round(3.62,1): 결과는 3,6
    
    */
    -- if 명령이 없는 dbms 에서 pivot 사용하기
    
    SELECT ST.st_num, ST.st_name,
    max(CASE WHEN SC.s_subject ='국어' THEN SC.s_score ELSE 0 END) AS 국어,
    max(if(SC.s_subject ='영어', SC.s_score,0)) AS 영어,
    max(if(SC.s_subject ='수학', SC.s_score,0)) AS 수학,
    sum(SC.s_score) AS 총점,
    Round(AVG(SC.s_score),1) as 평균
    from tbl_student ST
    JOIN
    tbl_score SC
    ON ST.st_num = SC.s_stnum
	GROUP BY ST.st_num, ST.st_name;
    
     -- if 명령이 없는 dbms 에서 pivot 사용하기
    
    SELECT ST.st_num, ST.st_name,
    max(CASE WHEN SC.s_subject ='국어' THEN SC.s_score ELSE 0 END) AS 국어,
    max(CASE WHEN SC.s_subject ='영어' THEN SC.s_score ELSE 0 END) AS 영어,
    max(CASE WHEN SC.s_subject ='수학' THEN SC.s_score ELSE 0 END) AS 수학,
    sum(SC.s_score) AS 총점,
    Round(AVG(SC.s_score),1) as 평균
    from tbl_student ST
    JOIN tbl_score SC
    ON ST.st_num = SC.s_stnum
	GROUP BY ST.st_num, ST.st_name;
    
    -- 전체학생 중에서 
    -- '국어점수' 가 '60점 이상인 학생' 의 총점과 평균 계산하기
SELECT 
    ST.st_num, 
    sum(if(SC.s_subject ='국어', SC.s_score,0)) AS 국어,
    sum(SC.s_score) AS 총점,
    AVG(SC.s_score) AS 평균
FROM tbl_student ST
JOIN tbl_score SC 
	ON ST.st_num = SC.s_stnum
WHERE SC.s_score >= 60
    AND SC.s_subject = '국어'
GROUP BY ST.st_num
HAVING SUM(IF(SC.s_subject = '국어', SC.s_score, 0 )) >=60
ORDER BY ST.st_num;

-- =======================
SELECT  ST.st_num, ST.st_name, SUM(SC.s_score) AS 총점,
    ROUND(AVG(SC.s_score), 1) AS 평균
FROM  tbl_student ST
JOIN  tbl_score SC ON ST.st_num = SC.s_stnum
WHERE  ST.st_num IN ( SELECT  ST.st_num
        FROM  tbl_student ST
        JOIN  tbl_score SC ON ST.st_num = SC.s_stnum
        WHERE  SC.s_score >= 60 AND SC.s_subject = '국어'
    )
GROUP BY 
    ST.st_num, ST.st_name;
    -- =======================
    
-- WHERE 절에 Pk 를 기준으로 조건을 주면 결과는  0..1 한개의 객체
-- WHERE 절에 PK 가 아닌 칼럼으로 조건을 주면
--  결과는 0..N List(배열)type 의 데이터이다.
-- LIST<String> type의 데이터가 출력된다.

SELECT 
    ST.st_num, 
    sum(if(SC.s_subject ='국어', SC.s_score,0)) AS 국어,
    sum(SC.s_score) AS 총점,
    AVG(SC.s_score) AS 평균
FROM tbl_student ST
	JOIN tbl_score SC 
		ON ST.st_num = SC.s_stnum
WHERE  ST.st_num in (
SELECT st_num FROM tbl_score BS WHERE
BS.s_subject = '국어'
and SC.s_score >= 60
)
GROUP BY ST.st_num;
    
    
/*
서브 쿼리를 사용하여 성적테이블로 부터 국어점수가 60점 이상인 학생들의 list<학번> 데이터를 찾는다.
그리고 찾아진 list 를 where 조건으로 하여 학생테이블의 데이터를 selection 한다.
그리고 , join 을 실행하고 group by 를 실행하고 총점과 평균을 계산한다.

전체 데이터를 group  by 하고 국어 점수를 계산한 후
having 절을 통하여 조건을 주어 원하는 결과를 찾는 것 보다ㅣ
효율적인 연산이 된다.
*/

-- 전체 학생의 국어 점수 총점과 평균을 계산하시오.

SELECT 
    ST.st_num, 
    ST.st_name, 
    SC.s_subject, -- tbl_score 테이블의 s_subject 열
    SC.s_score,
    (SELECT SUM(s_score) FROM tbl_score WHERE s_subject = '국어') AS 총점,
    (SELECT AVG(s_score) FROM tbl_score WHERE s_subject = '국어') AS 평균
FROM 
    tbl_student ST
JOIN 
    tbl_score SC ON ST.st_num = SC.s_stnum
WHERE SC.s_subject = '국어';
-- =====
SELECT 
    SUM(IF(s_subject = '국어', s_score, 0)) AS 총점,
    AVG(IF(s_subject = '국어', s_score, NULL)) AS 평균
FROM 
    tbl_score;
-- =====
SELECT 
    SUM(s_score) AS 총점,
    AVG(s_score) AS 평균
FROM 
    tbl_score
    where s_subject = '국어';

-- 전체 학생의 국어 점수 총점, 수학점수 총점, 영어점수 총점.


SELECT 
    SUM(IF(s_subject = '국어', s_score, 0)) AS 국어총점,
    SUM(IF(s_subject = '영어', s_score, 0)) AS 영어총점,
    SUM(IF(s_subject = '수학', s_score, 0)) AS 수학총점
FROM 
    tbl_score;
    
-- =
select s_subject as 과목,
sum(s_score)
from tbl_score
where s_subject in ('국어','영어','수학')
group by s_subject;