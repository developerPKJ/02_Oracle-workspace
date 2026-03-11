/*
    SQL (Structured Query Language)
    > 구조화된 질의 언어
    > DBMS에서 사용되는 명령문들을 SQL문 내지 쿼리문이라고 함

    종류
    - DQL : Data Query Language, 데이터 검색, SELECT
    - DML : Data Manipulation Language, 데이터 조작, INSERT, UPDATE, DELETE
    - DDL : Data Definition Language, 데이터 정의, CREATE, ALTER, DROP
    - DCL : Data Control Language, 데이터 제어, GRANT, REVOKE, ... (DQL, DML, DDL 외의 다른 것들 모두)
        - TCL : Transaction Control Language, 트랜잭션 제어, COMMIT, ROLLBACK, SAVEPOINT
*/

/*
    SELECT
    : DQL, DML 의 종류로서 테이블로부터 데이터를 조회하거나 검색할 때 사용되는 명렁어(데이터 추출)
        RESULT SET : SELECT문을 통해 조회된 데이터들의 결과물

    SELECT 컬럼명1, 컬럼명2, ...
    FROM 테이블명;
*/
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

select emp_id, emp_name, salary
from employee;
-- 대소문자 구분 없음, 가독성 때문에 보통 대문자로 작성
    -- 오직 비밀번호만 대소문자 구분함
    -- camel case가 불가 -> snake case로 작성("_")
-- JAVA는 대소문자 구분함

-- EMPLOYEE 테이블의 모든 컬럼을 조회하는 방법
SELECT *
FROM EMPLOYEE;

-- 실습 문제
-- 1. JOB 테이블의 모든 컬럼 조회
    SELECT * FROM JOB;    
-- 2. JOB 테이블의 직급명 컬럼만 조회
    SELECT JOB_NAME FROM JOB;
-- 3, DEPARTMENT 테이블의 모든 컬럼 조회
    SELECT * FROM DEPARTMENT;
-- 4. EMPLOYEE 테이블의 직원명, 이메일, 전화번호, 입사일 컬럼만 조회
    SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE FROM EMPLOYEE;
-- 5. EMPLOYEE 테이블의 입사일, 직원명, 급여 컬럼만 조회
    SELECT HIRE_DATE, EMP_NAME, SALARY FROM EMPLOYEE;

------------------------------------------------------------------

/*
    <컬럼 값을 통한 산술연산>
    사칙연산자를 이용해 계산 결과 도출 가능
*/
SELECT EMP_NAME, SALARY, SALARY * 12 AS ANNUAL_SALARY
FROM EMPLOYEE;
-- 일부로 연봉 컬럼을 안만든 이유
-- > 급여(월급) 컬럼은 유동적일 수 있기에, 월급 컬럼을 수정하면 그에 따라 연봉 컬럼도 모두 수정해줘야 함
-- > 무결성 손상

-- 이 때, 연봉 컬럼을 파생 컬럼이라고 부름
-- 설계 측면에서 파생 컬럼으로 가능한 것은 최대한 만들지 않는 것이 좋음

-- EMPLOYEE 테이블에서 직원명, 월급, 보너스, 보너스 포함 연봉
SELECT EMP_NAME, SALARY, BONUS, SALARY * (1 + BONUS) AS ANNUAL_SALARY
FROM EMPLOYEE;
-- 산술 연산 과정에서 NULL이 포함된 경우, 결과도 NULL이 됨

-- EMPLOYEE 테이블로부터 직원명, 입사일, 근무일수(=오늘날짜 - 입사일)
-- DATE 타입 (날짜 타입 - 년, 월, 일, 시, 분, 초) 끼리도 산술 연산 가능
-- 오늘 날짜 : SYSDATE
SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE AS 근무일수
FROM EMPLOYEE;
-- 결과 값이 소수점이 나오는 이유 : DATE 타입 안에 시, 분, 초에 대한 연산도 수행되어서

------------------------------------------------------------------------

/*
    < 컬럼 명에 별칭 부여하기 >
    AS 별칭명
    : 컬럼명 대신 별칭을 사용하여 조회 결과의 가독성을 높이는 방법
    
    별칭을 사용할 때, AS 키워드는 생략 가능
    하지만, 띄어쓰기나 특수문자가 포함된 경우에는 반드시 따옴표로 묶어야 함
*/
SELECT  EMP_NAME AS 직원명, 
        SALARY AS "월급",
        BONUS 보너스,
        SALARY * BONUS "보너스 포함 연봉"
FROM EMPLOYEE;
