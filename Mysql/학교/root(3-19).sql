-- 성적데이터 처리
CREATE DATABASE scoreDB;
USE scoreDB;
CREATE TABLE tbl_temp_score (
    s_stnum VARCHAR(6),
    s_kor VARCHAR(10),
    s_eng VARCHAR(10),
    s_math VARCHAR(10),
    s_music VARCHAR(10),
    s_art VARCHAR(10),
    s_sw VARCHAR(10),
    s_db VARCHAR(10)
);

SELECT COUNT(*) FROM tbl_temp_score;
SELECT s_stnum, s_kor FROM tbl_temp_score;