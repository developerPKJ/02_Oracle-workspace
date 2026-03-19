/*
    < DML - DATA MANIPULATION LANGUAGE >
    
    - 데이터 조작 언어
    - 테이블에 새로운 데이터를 삽입 하거나 (INSERT), 기존의 데이터를 수정 하거나 (UPDATE), 기존의 데이터를 삭제 하는 (DELETE) 구문들
    
    - 데이터 조회용 구문인 SELECT 문도 DML 임!! (DQL 로 분류하기도 함)
    
    => SELECT 문 과 INSERT, UPDATE, DELETE 문의 차이라고 한다면
       SELECT 문은 100번, 1000번, ... 실행하더라도 테이블의 내용물이 변화하지 X (단순 조회용도이기 때문)
       INSERT, UPDATE, DELETE 구문은 1번만 실행하더라도 테이블의 내용물이 변화함 O
*/

/*
    1. INSERT
    
    - 테이블에 새로운 "행" 을 추가하는 구문
    
    [ 표현법 ]
    
    1) INSERT INTO 테이블명 VALUES(값1, 값2, 값3, ...);
    
    - 해당 테이블의 "모든 컬럼에 대해서" 추가하고자 하는 값을 내가 직접 VALUES(여기) 안에 제시해서 
      "한 행" 단위로 INSERT 하고자 할 때 사용
    - 주의할 점 : 항상 컬럼의 순번을 지켜서 VALUES(여기) 안에 값을 나열해야함!! 
                 해당 테이블의 컬럼 갯수를 맞춰서 값을 나열해야함!!
                 > 만약 값을 부족하게 제시한 경우 : NOT ENOUGH VALUES 오류
                 > 만약 값을 더 많이 제시한 경우 : TOO MANY VALUES 오류
*/

-- EMPLOYEE 테이블에 사원 정보를 추가
-- 홍석준 사원의 정보를 추가
INSERT INTO EMPLOYEE VALUES(223
                          , '홍석준'
                          , '011221-3111111'
                          , 'sj_hong@kh.or.kr'
                          , '01098765432'
                          , 'D3'
                          , 'J4'
                          , 'S1'
                          , 6500000
                          , NULL
                          , NULL
                          , SYSDATE
                          , NULL
                          , DEFAULT);
--> 1 행 이(가) 삽입되었습니다.

SELECT * FROM EMPLOYEE;

-- 김갑생 사원의 정보를 추가하기
INSERT INTO EMPLOYEE VALUES(900
                          , '김갑생'
                          , '900312-2345678'
                          , 'gs_kim@kh.or.kr'
                          , '01043215678'
                          , 'D1'
                          , 'J7'
                          , 'S3'
                          , 4000000
                          , 0.1
                          , 200
                          , SYSDATE
                          , NULL
                          , DEFAULT);
--> 1 행 이(가) 삽입되었습니다.

SELECT * FROM EMPLOYEE;

SELECT *
  FROM EMPLOYEE
 WHERE EMP_ID = 223;

SELECT *
  FROM EMPLOYEE
 WHERE EMP_ID = 900;

-- 주의사항 : 컬럼의 갯수를 정확히 맞춰서 제시해야한다!!

INSERT INTO EMPLOYEE VALUES(901, '고길동');
--> 값을 적게 제시하면 not enough values 오류 발생!!

INSERT INTO EMPLOYEE VALUES(901
                          , '고길동'
                          , '910523-1234567'
                          , 'user02@kh.or.kr'
                          , '01078912345'
                          , 'D1'
                          , 'J6'
                          , 'S3'
                          , 4100000
                          , NULL
                          , 200
                          , SYSDATE
                          , NULL
                          , DEFAULT
                          , 1);
--> 값을 오버해서 제시하면 too many values 오류 발생!!

--------------------------------------------------------------------------------

/*
    2) INSERT INTO 테이블명(컬럼명1, 컬럼명2, 컬럼명3, ..)
                    VALUES(값1, 값2, 값3, ..);
                    
    - 해당 테이블의 "특정 컬럼들만 선택해서" 그 컬럼에 추가할 값만 제시하고자 할 때 사용
    - 하지만 그래도 "한 행" 단위로 추가가 되기 때문에 선택이 안된 컬럼은 기본적으로 NULL 로 채워짐!!
      단, DEFAULT 가 지정되었는 컬럼이 선택이 안됬을 경우에는 DEFAULT 값으로 채워짐!!
    - 주의할 점 : NOT NULL 제약조건이 걸려있는 컬럼은 반드시 선택 해서 직접 값을 제시해야함!!
                 단, 아무리 NOT NULL 제약조건이 걸려있는 컬럼이더라도
                 DEFAULT 설정이 되어있는 컬럼은 선택 안해도 된다!! (DEFAULT 값이 들어갈꺼니깐)      
*/

-- EMPLOYEE 테이블에 박말똥 사원의 정보 추가
INSERT INTO EMPLOYEE(EMP_ID
                   , EMP_NAME
                   , EMP_NO
                   , DEPT_CODE
                   , JOB_CODE
                   , SAL_LEVEL
                   , HIRE_DATE)
              VALUES(901
                   , '박말똥'
                   , '021231-4567890'
                   , 'D3'
                   , 'J7'
                   , 'S6'
                   , SYSDATE);
--> 1 행 이(가) 삽입되었습니다.

SELECT * FROM EMPLOYEE;

-- 마찬가지로 컬럼의 갯수, 순서에 맞춰서 VALUES(여기) 에 값들을 나열해야함!!
--> 위의 컬럼명의 갯수보다 값을 적게 제시하면 : NOT ENOUGH VALUES 오류 발생
--  위의 컬럼명의 갯수보다 값을 더 많이 제시하면 : TOO MANY VALUES 오류 발생

--------------------------------------------------------------------------------

/*
    3) INSERT INTO 테이블명(컬럼명들)
       (서브쿼리);
    
    - VALUES 로 값을 직접 나열해서 제시하는 대신에
      서브쿼리로 조회한 결과값들 (RESULT SET) 을 "통째로" INSERT 해주는 구문
    - 한번에 여러행을 INSERT 시킬 수 있다.  
    - 테이블명 옆에 (컬럼명들) 은 생략 가능함!! (단, 그 테이블의 모든 컬럼에 값을 넣을 경우에만)
*/

-- 연습용 새로운 테이블 먼저 만들기
CREATE TABLE EMP_01 (
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    DEPT_TITLE VARCHAR2(20)
);

SELECT * FROM EMP_01;

-- 전체 사원들의 사번, 이름, 부서명을 조회한 결과를 EMP_01 테이블에 통째로 추가
INSERT INTO EMP_01 /* (EMP_ID, EMP_NAME, DEPT_TITLE) */
(
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE
      FROM EMPLOYEE, DEPARTMENT
     WHERE DEPT_CODE = DEPT_ID(+)
);
--> 26개 행 이(가) 삽입되었습니다.

SELECT * FROM EMP_01;

-- 데이터 복구 (INSERT 하기 전으로 되돌림)
ROLLBACK;

SELECT * FROM EMP_01;

-- 전체 사원들의 사번, 이름 까지만 조회한 결과를 EMP_01 에 추가
INSERT INTO EMP_01(EMP_ID, EMP_NAME)
(
    SELECT EMP_ID, EMP_NAME
      FROM EMPLOYEE
);
--> 26개 행 이(가) 삽입되었습니다.

SELECT * FROM EMP_01;

--------------------------------------------------------------------------------

/*
    2. INSERT ALL
    
    - 한번에 두 개 이상의 테이블에 각각 INSERT 할 때 사용
      (단, 그 때 사용되는 서브쿼리가 동일한 경우 사용 가능)    
*/

-- 연습용 새로운 테이블 먼저 생성하기
-- 첫번째 테이블 : 급여가 300만원 이상인 사원들의 사번, 사원명, 직급명에 대해 보관할 테이블
CREATE TABLE EMP_JOB (
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    JOB_NAME VARCHAR2(20)
);

-- 두번째 테이블 : 급여가 300만원 이상인 사원들의 사번, 사원명, 부서명에 대해 보관할 테이블
CREATE TABLE EMP_DEPT (
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    DEPT_TITLE VARCHAR2(20)
);

SELECT * FROM EMP_JOB;
SELECT * FROM EMP_DEPT;

-- 급여가 300만원 이상인 사원들의 사번, 이름, 직급명, 부서명 조회하는 SELECT 문
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE
  FROM EMPLOYEE
  LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
  JOIN JOB USING (JOB_CODE)
 WHERE SALARY >= 3000000;

/*
    [ 표현법 ]

    1) INSERT ALL
       INTO 테이블명1 VALUES(컬럼명1, 컬럼명2, 컬럼명3, ..)
       INTO 테이블명2 VALUES(컬럼명1, 컬럼명2, 컬럼명3, ..)
       ...
       (서브쿼리);
*/

-- 위에서 만들어본 SELECT 문 (서브쿼리로 이용 예정) 의 조회 결과로부터 (RESULT SET 으로 부터)
-- EMP_JOB 테이블에는 급여가 300만원 이상인 사원들의 EMP_ID, EMP_NAME, JOB_NAME 컬럼값만 삽입
-- EMP_DEPT 테이블에는 급여가 300만원 이상인 사원들의 EMP_ID, EMP_NAME, DEPT_TITLE 컬럼값만 삽입
INSERT ALL
INTO EMP_JOB VALUES(EMP_ID, EMP_NAME, JOB_NAME) -- 10 개 행 삽입
INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_TITLE) -- 10 개 행 삽입
(
    SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE
      FROM EMPLOYEE
      LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
      JOIN JOB USING (JOB_CODE)
     WHERE SALARY >= 3000000 -- 결과가 총 10 개 행
);
--> 20개 행 이(가) 삽입되었습니다.
--  서브쿼리의 실행 결과는 총 10 개 행!!
--  각각 EMP_JOB, EMP_DEPT 테이블에 각각 10 개 행씩 INSERT 가 되면서 총 20 개의 행이 INSERT 되는 상황!!

SELECT * FROM EMP_JOB;
SELECT * FROM EMP_DEPT;

-- INSERT ALL 시 조건을 사용해서도 각 테이블에 값 INSERT 가능!!
-- 사번, 사원명, 입사일, 급여를 저장할 수 있는 테이블 생성

-- 첫번째 테이블 : 2010 년 이전에 입사한 사원들 정보만 저장 (미만) - EMP_OLD
CREATE TABLE EMP_OLD
AS (
        SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
          FROM EMPLOYEE
         WHERE 1 = 0
);

-- 두번째 테이블 : 2010 년 이후에 입사한 사원들 정보만 저장 (이상) - EMP_NEW
CREATE TABLE EMP_NEW
AS (
        SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
          FROM EMPLOYEE
         WHERE 1 = 0
);

SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

-- 2010 년도 이전 입사자들 정보 조회 (사번, 이름, 입사일, 급여)
-- 2010 년도 이후 입사자들 정보 조회 (사번, 이름, 입사일, 급여)
SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
  FROM EMPLOYEE
-- WHERE HIRE_DATE < '2010/01/01'; -- 2010 년 이전 입사 : 총 9명
 WHERE HIRE_DATE >= '2010/01/01'; -- 2010 년 이후 입사 : 총 17명

--------------------------------------------------------------------------------

/*
    2) INSERT ALL
       WHEN 조건식1 THEN INTO 테이블명1 VALUES(컬럼명1, 컬럼명2, ..)
       WHEN 조건식2 THEN INTO 테이블명2 VALUES(컬럼명1, 컬럼명2, ..)
       ..
       (서브쿼리);
*/

-- 위에서 작성했던 SELECT 문을 응용해서 INSERT ALL 구문 적용
INSERT ALL
WHEN HIRE_DATE < '2010/01/01' THEN INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY) -- 9 명만 INSERT
WHEN HIRE_DATE >= '2010/01/01' THEN INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY) -- 17 명만 INSERT
(
    SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
      FROM EMPLOYEE -- 결과가 총 26 개 행
);
--> 26개 행 이(가) 삽입되었습니다.

SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

--> 항상 INSERT 구문 실행 성공 시
--  "N개 행 이(가) 삽입되었습니다." 문구가 나옴!!
--> 반대로 INSERT 구문 실행 실패 시 0 개 행이 삽입된다고 보면 됨!!

--------------------------------------------------------------------------------

/*
    3. UPDATE
    
    - 테이블에 이미 기록된 기존의 데이터를 "수정" 하는 구문
      (테이블의 내용물은 변화하지만 행의 갯수는 변하지 않음)
      
    [ 표현법 ]
    
    UPDATE 테이블명
       SET 컬럼명 = 바꿀값
         , 컬럼명 = 바꿀값
         , 컬럼명 = 바꿀값
         , ...              => 한번에 여러개의 컬럼값을 동시 변경 가능
                               (= 는 대입연산을 뜻함!! , 로 나열해야함!! AND 아님!!)
     WHERE 조건식;           => WHERE 절은 생략 가능
                               WHERE 절을 생략할 경우 WHERE TRUE 로 해석됨!!
                               (해당 테이블의 전체 행의 데이터가 일괄적으로 다 변경됨!!)
*/

-- 테스트용 복사본 테이블 생성
CREATE TABLE DEPT_COPY
AS (
        SELECT *
          FROM DEPARTMENT
);

SELECT * FROM DEPT_COPY;

-- DEPT_COPY 테이블의 'D9' 부서의 부서명을
-- '총무부' --> '전략기획팀' 으로 변경
UPDATE DEPT_COPY
   SET DEPT_TITLE = '전략기획팀'  -- 대입연산자
 WHERE DEPT_ID = 'D9';          -- 동등비교연산자
--> 1 행 이(가) 업데이트되었습니다.

SELECT * FROM DEPT_COPY;

-- 데이터 변경사항 픽스
COMMIT;

-- DEPT_COPY 테이블의 D7 부서의 부서명을
-- '해외영업3부' --> '교육부' 로 변경
UPDATE DEPT_COPY
   SET DEPT_TITLE = '교육부'
 WHERE DEPT_ID = 'D7';
--> 1 행 이(가) 업데이트되었습니다.

SELECT * FROM DEPT_COPY;

-- 픽스
COMMIT;

-- 연습용 복사본 테이블 생성
CREATE TABLE EMP_SALARY
AS (
        SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
          FROM EMPLOYEE
);

SELECT * FROM EMP_SALARY;

-- EMP_SALARY 테이블의 김가현 사원의 급여를 1000만원으로 수정
UPDATE EMP_SALARY
   SET SALARY = 10000000
 WHERE EMP_NAME = '김가현';
--> 1 행 이(가) 업데이트되었습니다.
--> 마침 김가현이라는 이름을 가진 사원은 단 한명뿐이여서 1개 행만 정확히 업데이트 된 상황임!!
--  하지만 동명이인이 몇명 더 있었다면 그만큼 더 수정됬을거임!!
--  문법 자체로는 문제가 전혀 없는게 맞으나, 실제 업무에 적용하기에는 리스크가 큰 쿼리문임!!

SELECT * FROM EMP_SALARY;

-- EMP_SALARY 테이블의 정우주 사원의 급여를 3800000 원, BONUS 를 0.2 로 수정
UPDATE EMP_SALARY
   SET SALARY = 3800000
     , BONUS = 0.2
 WHERE EMP_NAME = '정우주';
--> 1 행 이(가) 업데이트되었습니다.
--> 마찬가지로 마침 정우주라는 이름의 사원이 단 한명뿐이였기 때문에 문제 없이 한명의 정보만 잘 수정됨!!
--  하지만 이름은 언제든지 동명이인이 있을 수 있기 때문에 실제 업무에 적용하기에는 리스크가 큰 쿼리문임!!

SELECT * FROM EMP_SALARY;

-- UPDATE 문 사용 시 주의할점
-- 정확히 1건의 데이터에 대해서만 수정하고 싶다면 WHERE 절에는 PRIMARY KEY 제약조건 내지 UNIQUE 제약조건에
-- 대한 동등비교식을 제시하는 것이 제일 좋다!!

--> 위의 쿼리문들을 보완하자면..
UPDATE EMP_SALARY
   SET SALARY = 10000000
-- WHERE EMP_NAME = '김가현';
 WHERE EMP_ID = 200; -- 더 안전한 쿼리문 (한명만 정확하게 찝어주니까)
 
UPDATE EMP_SALARY
   SET SALARY = 3800000
     , BONUS = 0.2
-- WHERE EMP_NAME = '정우주'; 
 WHERE EMP_ID = 215; -- 더 안전한 쿼리문 (한명만 정확하게 찝어주니까)
 
-- 픽스
COMMIT;

-- UPDATE 구문 내에서 WHERE 절을 생략할 경우..? 
UPDATE EMP_SALARY
   SET SALARY = 1000000;
--> 26개 행 이(가) 업데이트되었습니다.

SELECT * FROM EMP_SALARY;
--> 실수로라도 WHERE 절 을 생략하게 되면 해당 테이블의 모든 행에 대한 해당 컬럼값들이 일괄적으로 다 변경됨!! (신중하게 하자)

-- 복구
ROLLBACK;

SELECT * FROM EMP_SALARY;

-- 만약 상황에 따라 모든 값들을 일괄적으로 바꿔야 할 경우가 생긴다면?
-- EMP_SALARY 테이블의 전체 사원의 급여를 기존의 급여에 20 프로 인상한 금액으로 변경
-- (기존급여 * 1.2)
UPDATE EMP_SALARY
   SET SALARY = SALARY * 1.2 -- SALARY *= 1.2 안됨!! (오라클에는 복합대입연산자가 없음!!)
 WHERE 1 = 1; -- 항상 TRUE 인 조건식을 제시함!! (모든 행이 다 변경, WHERE 절 생략과 똑같은 효과)
--> 26개 행 이(가) 업데이트되었습니다.

SELECT * FROM EMP_SALARY;

/*
    * UPDATE 문 안에서도 서브쿼리를 이용 가능하다.
    
    [ 표현법 ]
    
    UPDATE 테이블명
       SET 컬럼명 = (서브쿼리)
     WHERE 조건식;
     
    또는
    
    UPDATE 테이블명
       SET 바꿀내용
     WHERE 조건식 = (서브쿼리);
*/

-- EMP_SALARY 테이블에서 박말똥 사원의 부서코드를 김가현 사원의 부서코드로 변경
-- 1) 우선 김가현 사원의 부서코드부터 알아내기
SELECT DEPT_CODE
  FROM EMP_SALARY
 WHERE EMP_NAME = '김가현'; -- 'D9'
 
-- 2) 박말똥 사원의 부서코드를 'D9' 로 변경
UPDATE EMP_SALARY
   SET DEPT_CODE = (
                        SELECT DEPT_CODE
                          FROM EMP_SALARY
                         WHERE EMP_NAME = '김가현' -- 결과는 1행 1열
   )
 WHERE EMP_NAME = '박말똥';
--> 1 행 이(가) 업데이트되었습니다.

SELECT * FROM EMP_SALARY;

-- 임지혜 사원의 급여와 보너스를 정홍주 사원의 급여와 보너스값으로 변경
-- 1) 우선 정홍주 사원의 급여와 보너스값을 구하기
SELECT SALARY, BONUS
  FROM EMP_SALARY
 WHERE EMP_NAME = '정홍주'; -- 3468000 / NULL
 
-- 2) 위에서 구한 값으로 임지혜 사원의 급여와 보너스를 변경
UPDATE EMP_SALARY
   SET SALARY = (
                    SELECT SALARY
                      FROM EMP_SALARY
                     WHERE EMP_NAME = '정홍주' -- 결과가 1행 1열
   )
     , BONUS = (
                    SELECT BONUS
                      FROM EMP_SALARY
                     WHERE EMP_NAME = '정홍주' -- 결과가 1행 1열
     )
 WHERE EMP_NAME = '임지혜';
--> 1 행 이(가) 업데이트되었습니다.
--> 단일행 단일열 서브쿼리 2개를 쓴 버전

SELECT * FROM EMP_SALARY;

UPDATE EMP_SALARY
   SET (SALARY, BONUS) = (
                            SELECT SALARY, BONUS
                              FROM EMP_SALARY
                             WHERE EMP_NAME = '정홍주' -- 결과가 1행 2열
   )
 WHERE EMP_NAME = '임지혜';
--> 단일행 다중열 서브쿼리 버전

SELECT * FROM EMP_SALARY; 

-- UPDATE 시 주의사항
--> 값을 수정할 때도 제약조건에 맞는 값으로 수정해야함!! (위배되면 안됨)

-- 지민석 사원의 사번을 200 으로 변경 (EMPLOYEE 테이블에서 시도!!)
/*
UPDATE EMP_SALARY
   SET EMP_ID = 200
 WHERE EMP_NAME = '지민석';

-- 수습
UPDATE EMP_SALARY
   SET EMP_ID = 220
 WHERE EMP_NAME = '지민석';
 
SELECT * FROM EMP_SALARY;

-- 위에서 EMP_SALARY 테이블 복제 시 PRIMARY KEY 제약조건은 복사되지 않았기 때문에...
*/

UPDATE EMPLOYEE
   SET EMP_ID = 200
 WHERE EMP_NAME = '지민석';
--> unique constraint (KH.EMPLOYEE_PK) violated 오류 발생!!
--  PRIMARY KEY 제약조건에 위배되기 때문에 UPDATE 불가

-- 사번이 200 번인 사원의 이름을 NULL 로 변경 (EMPLOYEE 에서 작업)
UPDATE EMPLOYEE
   SET EMP_NAME = NULL
 WHERE EMP_ID = 200;
--> cannot update ("KH"."EMPLOYEE"."EMP_NAME") to NULL 오류 발생!!
--  NOT NULL 제약조건에 위배되기 때문에 UPDATE 불가

-- 픽스
COMMIT;

--> 항상 UPDATE 구문 실행 성공 시
--  "N 행 이(가) 업데이트되었습니다." 문구가 나옴!!
--  즉, UPDATE 구문 실행 실패 시 0 개 행이 UPDATE 된다고 생각하면 됨!!

--------------------------------------------------------------------------------

/*
    4. DELETE
    
    - 테이블에 기록된 기존의 데이터를 "삭제" 하는 구문
    
    [ 표현법 ]
    
    DELETE
      FROM 테이블명
     WHERE 조건식;    => WHERE 절은 생략 가능
                        WHERE 절 생략 시 WHERE TRUE 를 뜻하기 때문에
                        생략 시 해당 테이블의 모든 행이 다 지워짐!!
*/

DELETE
  FROM EMPLOYEE;
--> 26개 행 이(가) 삭제되었습니다.
--> WHERE 절 생략 시 EMPLOYEE 테이블의 모든 행 전체 삭제

SELECT * FROM EMPLOYEE;

-- 복구
ROLLBACK;

SELECT * FROM EMPLOYEE;

-- EMPLOYEE 테이블로부터 김갑생과 박말똥 사원의 데이터를 지우기
DELETE
  FROM EMPLOYEE
-- WHERE EMP_NAME = '김갑생' OR EMP_NAME = '박말똥';
 WHERE EMP_NAME IN ('김갑생', '박말똥');
--> 2개 행 이(가) 삭제되었습니다.
--> 마찬가지로 이름의 경우는 동명이인이 생길 경우 해당되면 다 지워질 수 밖에 없음!!
--  UPDATE 문 때와 똑같이 PRIMARY KEY 내지 UNIQUE 제약조건에 대한 동등비교식을 제시해서 정확한 타겟들만 지워주는걸 권장!!

SELECT * FROM EMPLOYEE;

-- 픽스
COMMIT;

-- DEPARATMENT 테이블로부터 DEPT_ID 가 'D1' 인 부서 삭제
DELETE
  FROM DEPARTMENT
 WHERE DEPT_ID = 'D1';
--> integrity constraint (KH.SYS_C007135) violated - child record found
--> 삭제 안됨 (D1 을 가져다 쓰고 있는 자식데이터가 있기 때문)

-- DEPARTMENT 테이블로부터 DEPT_ID 가 'D7' 인 부서 삭제
DELETE
  FROM DEPARTMENT
 WHERE DEPT_ID = 'D7';
--> 1 행 이(가) 삭제되었습니다.
--> 삭제됨 (D7 을 가져다 쓰고 있는 자식데이터 없기 때문)

--> DELETE 구문 실행 시 "외래키" 제약조건을 생각해봐야함!!

-- 복구
ROLLBACK;

--> 항상 DELETE 구문 실행 성공 시
--  "N 행 이(가) 삭제되었습니다." 결과가 나옴!!
--  반대로 DELETE 구문 실행 실패 시 0 개 행이 삭제된다고 보면 됨!!

/*
    - INSERT 문은 어떤 용법을 쓰냐에 따라 한번에 1개 행씩 또는 여러 행씩 INSERT 될거냐가 갈림
    - UPDATE, DELETE 문은 WHERE 절을 어떻게 쓰냐에 따라 처리되는 행의 갯수가 매번 달라짐
    
    - SELECT 문의 실행 결과 : RESULT SET
    - INSERT, UPDATE, DELETE 문의 실행 결과 : 각각 추가, 수정, 삭제된 행의 갯수가 "정수" 로 나옴 
    
    - DELETE 문 또한 WHERE 절에서 서브쿼리 이용 가능!!
    예) 김가현 사원과 같은 부서의 사원들을 모두 삭제
*/

--------------------------------------------------------------------------------

/*
    * TRUNCATE
    
    - 테이블의 "전체 행" 을 삭제할 때 쓸 수 있는 구문 (절사, 절삭, 잘라내다)    
    - WHERE 절을 통해 별도의 조건식 제시 불가
    - DELETE 문 보다 수행속도가 빠름
    - ROLLBACK 이 불가함!! (DML 이 아닌 DDL 로 분류한다)
    
    [ 표현법 ]
    
    TRUNCATE TABLE 테이블명;            |       DELETE FROM 테이블명;
    -----------------------------------------------------------------------
    별도의 조건식 제시 불가               |       별도의 조건 제시가 가능
    수행속도가 빠름                      |       상대적으로 느림
    ROLLBACK 불가                       |       ROLLBACK 가능
*/

SELECT * FROM EMP_SALARY;

DELETE
  FROM EMP_SALARY;
--> 26개 행 이(가) 삭제되었습니다.

SELECT * FROM EMP_SALARY;

-- 복구
ROLLBACK;

SELECT * FROM EMP_SALARY;

TRUNCATE TABLE EMP_SALARY;
--> Table EMP_SALARY이(가) 잘렸습니다.

SELECT * FROM EMP_SALARY;

-- 복구
ROLLBACK;

SELECT * FROM EMP_SALARY;
--> ROLLBACK; 명령문을 통해 데이터 복구가 되지 않았음!!
    