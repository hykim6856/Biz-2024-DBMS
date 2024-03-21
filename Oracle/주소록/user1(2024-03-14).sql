-- 여기는 user1 화면입니다.

-- SHOW TABLES 명령이 오라클에는 없다.
-- USER1 사용자 권한으로  볼 수 있는 모든 테이블
SELECT * FROM all_tables WHERE owner = 'USER1';

-- 현재접속한 사용자의 스키마에 등록된 table
SELECT * FROM user_tables;

-- DBA 권한으로 볼 수 있는 table;
SELECT * FROM dba_tables;

/*
도메인 : 테이블의 칼럼 타입 (데이터 타입과 크기)
문자열 : CHAR(고정문자열), VARCHAR(가변문자열)
CHAR 타입의 칼럼에 순수 숫자형 문자열을 저장하면
dB 마다 특성이 달라 select 등을 수행할때 불편함이 많다.
char 타입을 사용하려면 반드시 알파벳 문자가 있는 형태로 설계하는 것이 좋다.
그래서 문자열의 경우 varchar 를 사용해도 큰 문제가 없으므로 
고정문자열로 varchar로 사용하자
char : 최대 영숫자 2000 자 까지 
varchar : 최대 영숫자 4000자 까지

오라클 최근 버ㅓㅈㄴ에서는 carchar, nvarchar 대신 varchar2,nvarchar2,

유니코드 문자열 : nCHA, nVARCHAR 
영 숫자 이외의 2byte 형 문자 (한글, 한자, 아랍어 등) 을 저장하는 칼럼

큰 문자열 : LONG(2,000,000), CLOB(4,000,000), nClOB(유니코드, 4,000,000)

숫자형: NUMBER, FLOAT, BINARY_DOUBLE
    NUMBER : 가변형 숫자
  NUMBER : 정수형 38자리, 소수점이하 127 자리
  NUMBER(5) : 정수형 최대 5자리
  NUMBER(5,2) : 정수형 최대 5자리 소수점이하 2자리
    FLOAT : 실수 형

*/

CREATE TABLE tbl_sample (
    seq NUMBER PRIMARY KEY,
    title NVARCHAR2(50) NOT NULL,
    content NVARCHAR2(400) NOT NULL
);

/*
PK(기본키)
테이블의 데이터들의 무결성을 유지하기 위한 상징적인 칼럼
모든 테이블에는 기본키가 있어야한다.
기본키는 유일해야하고, not null 이어야한다.
일반적으로 MAster Table 에는 코드 체계를 만들어 PK 를 설정한다.
학생테이블 = 학번이 PK, 사원테이블 = 사번이PK
과목테이블 = 과목코드 PK


전통적으로 pk 는 정수형으로 설정하고, 일련번호를 부여하는 방식을 많이 사용한다.
대부분의 db에는 auto increment 속성이 있어서 pk 칼럼을 설정한다.
하지만, 오라클 11 이하ㄴ의 버전에는 auto increment 속성이 아예 없다.
오라클 12c 이상에서는 속성은 추가되었지만 만드는 방법이 매우 복잡하다.
NUMBER GEVERATED ALWAYS AS IDENTIFY

오라클에서 auto increment 를 실행하기 위해서는 sequence 라는 객체를 생성하여 사용한다.
*/

CREATE SEQUENCE seq_sample
INCREMENT BY 1
START WITH 1;

SELECT seq_sample.NEXTVAL from dual;
INSERT INTO tbl_sample (seq, title, content )
VALUES (seq_sample.NEXTVAL, '오늘날', '오늘은 목요일 내일은 금요일');


SELECT * FROM tbl_sample;

SELECT * FROM dual;

-- DULA Table
-- 표준 SQL 에서 SELECT 는 fROM 절이 없어도 실행이 가능하다.
-- 하지만 ORACLE (PL*SQL)의 SELECT 는 FROM 절이 없으면 오류가 난다.
-- 일반적인 테스트 연산등을 수행할 때 DUAL TABLE 을 사용한다.

-- 현재 DBMS 프로그램에서는 worktable 의 pk 를 일련번호가 아닌 uuid 문자열로 하도록 권장한다.


SELECT 30+40 FROM DUAL;
SELECT 40*2 FROM DUAL;
--

SELECT 30*40 FROM tbl_sample;