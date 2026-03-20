-- 현재 SAMPLE 계정은 
-- 접속할 수 있는 CREATE SESSION 권한만 부여받은 상태임!!

CREATE TABLE TEST (
    TEST_ID NUMBER
);
--> insufficient privileges 오류 발생!!
--  (불충분한 권한들)

-- 3_1. SAMPLE 계정에 테이블을 생성할 수 있는 CREATE TABLE 권한이 없기 때문에 오류 발생

-- CREATE TABLE 권한 부여받은 후
CREATE TABLE TEST (
    TEST_ID NUMBER
);
--> no privileges on tablespace 'SYSTEM' 오류 발생!!
--  TABLE SPACE : 테이블들이 모여있는 (저장되는) 공간
--  'SYSTEM' : 오라클에서 기본적으로 제공하는 TABLE SPACE 공간명

-- 3_2. TABLE SPACE 가 할당되지 않아서 오류 발생

-- TABLE SPACE 공간 할당받은 후
CREATE TABLE TEST (
    TEST_ID NUMBER
);
--> Table TEST이(가) 생성되었습니다.
--> TABLE 생성 완료!!

-- 위의 테이블 생성 권한 (CREATE TABLE) 을 부여받게 되면
-- 해당 계정이 소유하고 있는 테이블들을 "조작" 하는 것도 가능해짐!!
-- (CREATE TABLE 권한 내에 테이블들에 DML 구문을 사용할 수 있는 권한도 포함)
--> SELECT, INSERT, UPDATE, DELETE 문 다 가능해짐!!

SELECT * FROM TEST;

INSERT INTO TEST VALUES(1);
INSERT INTO TEST VALUES(2);

SELECT * FROM TEST;
--> UPDATE, DELETE 문 까지도 가능함!!

-- 뷰 만들어 보기
CREATE VIEW V_TEST
AS (
        SELECT *
          FROM TEST
);
--> insufficient privileges 오류 발생!!
--  (불충분한 오류들)

-- 4. 뷰를 생성할 수 있는 CREATE VIEW 권한이 부여되지 않았기 때문에 오류 발생

-- CREATE VIEW 권한 부여받은 후
CREATE VIEW V_TEST
AS (
        SELECT *
          FROM TEST
);
--> View V_TEST이(가) 생성되었습니다.
--> VIEW 생성 완료!!

--------------------------------------------------------------------------------

-- SAMPLE 계정에서 KH 계정의 테이블에 접근해서 조회해보기 (SELECT)
SELECT *
  FROM EMPLOYEE;
--> table or view does not exist 오류 발생!!
--  기본적으로 테이블명을 그냥 적으면 현재 이 계정 내의 테이블을 찾음!!
--  (이 SAMPLE 계정 내에는 EMPLOYEE 테이블 존재 X)

--> 그래서 우리는 KH 계정의 EMPLOYEE 테이블로써 조회하고싶은것!!
--  이 경우, 계정명.테이블명 으로 접근 가능하다.
SELECT *
  FROM KH.EMPLOYEE;
--> table or view does not exist 오류 발생!!
--  KH 계정의 테이블에 접근해서 조회할 수 있는 권한이 없기 때문에 오류가 발생

-- 5. KH 계정의 테이블에 접근해서 조회할 수 있는 권한이 없어서 오류

-- SELECT ON 권한 부여 후
SELECT *
  FROM KH.EMPLOYEE;
--> KH 계정의 EMPLOYEE 테이블 조회 성공!!

SELECT *
  FROM KH.DEPARTMENT;
--> 마찬가지로 KH 계정의 DEPARTMENT 테이블에 접근할 수 있는 권한이 없기 때문에 오류

-- 6. 마찬가지로 KH 계정의 DEPARTMENT 테이블에 SELECT 할 수 있는 권한이 없었음

-- SELECT ON 권한 부여 후
SELECT *
  FROM KH.DEPARTMENT;

-- SAMPLE 계정에서 KH 계정의 DEPARTMENT 테이블에 접근해서 행 삽입해보기
INSERT INTO KH.DEPARTMENT VALUES('D0', '회계부', 'L2');
--> insufficient privileges 오류 발생!!

-- 7. KH 계정의 DEPARTMENT 테이블에 접근해서 행을 삽입할 수 있는 권한이 없음

-- INSERT ON 권한 부여 후
INSERT INTO KH.DEPARTMENT VALUES('D0', '회계부', 'L2');
--> 1 행 이(가) 삽입되었습니다.
--> KH.DEPARTMENT 테이블에 INSERT 성공!!

SELECT *
  FROM KH.DEPARTMENT; -- SAMPLE 계정에서 실행 (반영 되서 보임)
  
SELECT *
  FROM DEPARTMENT; -- KH 계정에서 실행 (반영 안되 보임)

--> 항상 INSERT, UPDATE, DELETE 문은 실행했다고 해서 데이터 변경 내용이
--  곧바로 적용되지 않고, 항상 COMMIT 명령문을 통해 픽스시켜야 변경 내용이 적용됨!!
--  (그래서 정작 KH 계정에서 SELECT 문을 실행했을 때 반영되지 않아 보임)

COMMIT; -- SAMPLE 계정에서 실행
--> 이제서야 KH 계정에서 SELECT 문을 실행했을 때 반영 되서 보이게 됨!!

--------------------------------------------------------------------------------

-- CREATE TABLE 권한 REVOKE 후
CREATE TABLE TEST2 (
    TEST_ID NUMBER
);
--> insufficient privileges 오류 발생!!

-- 8. SAMPLE 계정에서 테이블을 생성할 수 없도록 권한을 회수했기 때문에 오류 발생
