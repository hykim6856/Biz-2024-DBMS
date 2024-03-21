
CREATE TABLE tbl_student(
s_code VARCHAR2(6) PRIMARY KEY,
s_name nVARCHAR2(10) NOT NULL,
s_dept nVARCHAR2(20),
s_grade INT,
s_tel VARCHAR2(13),
s_address nVARCHAR2(125)

);

CREATE TABLE tbl_test(
t_code VARCHAR2(6) PRIMARY KEY,
t_name nVARCHAR2(10) NOT NULL
);

CREATE TABLE tbl_student_test (
  st_scode	VARCHAR2(6)			NOT NULL,
  st_tcode VARCHAR2(6)			NOT NULL,
  st_score INT,
CONSTRAINT AH_PK PRIMARY KEY(st_scode,st_tcode,st_score)
);


select * from tbl_student order by s_code;
select * from tbl_test;
select * from tbl_student_test;


DROP TABLE tbl_student;
DROP TABLE tbl_test;
DROP TABLE tbl_student_test;


-- ================================




