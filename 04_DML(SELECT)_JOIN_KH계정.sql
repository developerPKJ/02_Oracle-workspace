/*
    < JOIN >
    - 2개 이상의 테이블에서 데이터를 함께 조회 할 때 사용되는 구문
    - 결과물은 하나의 result set으로 반환

    관계형 테이터베이스에서는
    최소한의 데이터로 각각의 테이블에 데이터를 쪼개서 보관
    > 데이터 중복을 최소화하기 위해(테이블을 쪼개는 과정 : 정규화)

    --> JOIN을 통해서 여러 테이블에서 데이터를 함께 조회해야 함
    > 아무 테이블끼리 join해서 조회하는 것은 아니고, 서로 연관되어 있는 컬럼을 기준으로
    매칭시켜 조회해야 함
*/

-- EMPLOYEE 테이블의 사번, 사원명, 부서코드, 부서명 알고싶음
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;
-- 그런데 부서명은 EMPLOYEE 테이블에 없음
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;
-- EMPLOYEE 테이블과 DEPARTMENT 테이블을 JOIN해서 조회해야 함

-- > 위를 보면 DEPT_CODE와 DEPT_ID가 서로 연관되어 있음
-- > 이를 기준으로 두 테이블을 조인해서 조회


-- EMPLOYEE 테이블로부터 전체 사원들의 사번, 사원명, 직급코드, 직급명을 알고자함
-- 위의 예시와 마찬가지로 EMPLOYEE 테이블에선 사번 사원명 직급코드는 알지만
-- 직급명은 알 수 없음
-- > EMPLOYEE 테이블과 JOB 테이블을 JOIN해서 조회해야 함


/*
    JOIN은 ORACLE 전용 구문과
    ANSI 표준 구문이 있음
    - ORACLE 전용 구문 : ORACLE DBMS에서만 사용 가능
    - ANSI 표준 구문 : ORACLE DBMS 뿐만 아니라 다른 DBMS에서도 사용 가능

    오라클 전용 구문            |         ANSI 표준 구문
    ============================================================
    등가 조인(EQUAL JOIN)      |       내부 조인(INNER JOIN)
    -----------------------------------------------------------
    포괄 조인                  |      외부 조인
    LEFT JOIN                 |       LEFT OUTER JOIN
    RIGHT JOIN                |       RIGHT OUTER JOIN
                              |       FULL OUTER JOIN -> 오라클 전용 구문에선 불가
    ----------------------------------------------------------
    카테시안 곱                |       크로스 조인
    CAARTESIAN PRODUCT        |       CROSS JOIN
    -----------------------------------------------------------
                        자체 조인 (SELF JOIN)
                    비등가 조인 (NON-EQUAL JOIN)

*/

/*
    1. 등가 조인 (EQUAL JOIN) / 내부 조인 (INNER JOIN)
    - 연결고리에 해당하는 컬럼값이 일치하는 행들만 조인되서 조회(일치하지 않으면 제외)
*/

-- 오라클 전용 구문
-- FROM 절에 조회하고자 하는 테이블명들을 나열
-- WHERE 절에 매칭시킬 컬럼명에 대한 조건식 기술

-- 전체 사원들의 사번, 사원명, 부서코드, 부서명을 같이 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;
-- DEPT_CODE가 NULL인 사원은 조회되지 않음
-- > DEPT_TITLE에 NULL이 존재하지 않기 때문
-- DEPT_ID가 D3, D4, D7인 부서는 조회되지 않음
-- > DEPT_CODE에 D3, D4, D7이 존재하지 않기 때문
------------------------------------------------------
-- 사번, 사원명, 직급코드, 직급명 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE JOB_CODE = JOB_CODE;
-- COLUMN AMBIGUOUSLY DEFINED 오류 발생

-- 해결 방법 1 : 테이블명.컬럼명으로 명확하게 구분해서 조회
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;
-- 해결 방법 2 : 테이블명에 별칭을 붙여서 조회
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;
--====================================================
-- ANSI 표준 구문
-- FROM 절에 조회하고자 하는 테이블명 하나만 기술
-- FROM 절 뒤에 JOIN 키워드절에서 조회하고자 하는 다른 테이블명 기술
-- ON 절에 매칭시킬 컬럼명에 대한 조건식 기술(USING/ON)

-- 전체 사원들의 사번, 사원명, 부서코드, 부서명을 같이 조회
-- KEY 값의 이름이 서로 다른 경우 : ON 절만 가능
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
/*INNER */JOIN DEPARTMENT
ON DEPT_CODE = DEPT_ID;
------------------------------------------------------
-- 사번, 사원명, 직급코드, 직급명 조회
-- KEY 값의 이름이 서로 같은 경우 : USING 절도 가능
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB
ON EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB
USING(JOB_CODE);
-- USING 절을 사용할 경우 공통 KEY를 테이블명.컬럼명으로 조회할 경우
-- column part of USING clause cannot have qualifier 오류 발생
--======================================================
-- 특이 케이스
-- KEY 컬럼명이 동일한 경우 NATURAL JOIN 가능
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB;
-- 가능은하지만 권장하지는 않음
-- > 두 개의 테이블에 일치하는 KEY가 유일하게 한개만 존재하는 경우
--======================================================
-- 연결고리 조건식 뿐만 아니라 추가적인 조건식도 함께 기술 가능
-- 직급이 대리인 사원들의 사번, 이름, 급여, 직급명 조회
-- > ORACLE 전용 구문
SELECT  EMP_ID, EMP_NAME, SALARY, JOB_NAME
FROM    EMPLOYEE, JOB
WHERE   EMPLOYEE.JOB_CODE = JOB.JOB_CODE
AND     JOB_NAME = '대리';

-- > ANSI 표준 구문
SELECT  EMP_ID, EMP_NAME, SALARY, JOB_NAME
FROM    EMPLOYEE
JOIN    JOB
ON      EMPLOYEE.JOB_CODE = JOB.JOB_CODE
WHERE   JOB_NAME = '대리';

SELECT  EMP_ID, EMP_NAME, SALARY, JOB_NAME
FROM    EMPLOYEE
JOIN    JOB
USING(JOB_CODE)
WHERE   JOB_NAME = '대리';


-- 실습 문제
-- 1. 부서가 인사관리부인 사원들의 사번, 사원명, 보너스 조회
-- 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_TITLE = '인사관리부';
-- ANSI 표준 구문
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE
JOIN DEPARTMENT
ON DEPT_CODE = DEPT_ID
WHERE DEPT_TITLE = '인사관리부';

-- 2. 부서가 총무부가 아닌 사원들의 사원명, 급여, 입사일 조회
-- 오라클 전용 구문
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_TITLE != '총무부';
-- ANSI 표준 구문
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
JOIN DEPARTMENT
ON DEPT_CODE = DEPT_ID
WHERE DEPT_TITLE != '총무부';

-- 3. 보너스를 받는 사람들의 사번, 사원명, 보너스, 부서명 조회
-- 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND BONUS IS NOT NULL;
-- ANSI 표준 구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT
ON DEPT_CODE = DEPT_ID
WHERE BONUS IS NOT NULL;

-- 4. 아래의 두 테이블을 참고해서 
-- 부서코드, 부서명, 지역코드, 지역명 (LOCAL_NAME) 조회
SELECT * FROM DEPARTMENT; -- DEPT_ID, DEPT_TITLE, LOCATION_ID
SELECT * FROM LOCATION;   -- LOCAL_CODE, NATIONAL_CODE, LOCAL_NAME
-- 오라클 전용 구문
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;
-- ANSI 표준 구문
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION
ON LOCATION_ID = LOCAL_CODE;



/*
    2. 포괄 조인 / 외부 조인
    - 연결고리에 해당하는 컬럼값이 일치하는 행들 뿐만 아니라, 
      일치하지 않는 행들도 함께 조회
    - 일치하지 않는 행들은 NULL로 조회

    1) LEFT JOIN : 왼쪽 테이블을 기준으로 조인
    2) RIGHT JOIN : 오른쪽 테이블을 기준으로 조인
    3) FULL OUTER JOIN : 양쪽 테이블 모두를 기준으로 조인
       (오라클 전용 구문에선 불가)
*/

-- EMPLOYEE 테이블로부터 전체 사원들의 사원명, 급여, 부서명 조회
-- ANSI 표준 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT
ON DEPT_CODE = DEPT_ID;
-- DEPT_CODE가 NULL인 사원은 조회되지 않음(2명 누락)

-- LEFT OUTER JOIN
-- > 왼편에 기술된 테이블의 데이터는 누락 없이 전체 조회
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
LEFT /*OUTER*/ JOIN DEPARTMENT
ON DEPT_CODE = DEPT_ID;
-- DEPT_CODE가 NULL인 사원도 조회됨
-- DEPT_CODE가 NULL인 사원은 DEPT_TITLE이 NULL로 조회됨
------------------------------------------------------
-- ORACLE 전용 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);
-- DEPT_CODE가 NULL인 사원도 조회됨
-- DEPT_CODE가 NULL인 사원은 DEPT_TITLE이 NULL로 조회됨
-- 기준이 "아닌" 컬럼명에 (+) 기호가 붙음
--======================================================
-- ANSI 표준 구문
-- RIGHT OUTER JOIN
-- > 오른편에 기술된 테이블의 데이터는 누락 없이 전체 조회
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
RIGHT /*OUTER*/ JOIN DEPARTMENT
ON DEPT_CODE = DEPT_ID;
-------------------------------------------------------
-- ORACLE 전용 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;
-- DEPT_ID가 D3, D4, D7인 부서도 조회됨
-- DEPT_CODE가 NULL인 사원은 조회되지 않음

------------------------------------------------------
-- FULL OUTER JOIN
-- > 양쪽 테이블 모두를 기준으로 조인
-- ORACLE 전용 구문에서는 FULL OUTER JOIN이 불가, ANSI 표준 구문에서만 FULL OUTER JOIN 가능
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
FULL /*OUTER*/ JOIN DEPARTMENT
ON DEPT_CODE = DEPT_ID;
-- DEPT_CODE가 NULL인 사원도 조회됨
-- DEPT_ID가 D3, D4, D7인 부서도 조회됨



/*
    3. 카테시안 곱 / 크로스 조인 - 실무에서 사용할 일은 거의 없음
    - 모든 테이블의 각 행들이 서로 맵핑된 데이터가 조회됨(곱집합)
    - 두 테이블의 모든 행들이 모두 곱해진 행들의 조합이 출력됨

    1) 카테시안 곱 : ORACLE 전용 구문
    2) 크로스 조인 : ANSI 표준 구문

    - JOIN 구문 작성 중 WHERE 절을 누락하는 실수로 인해 발생할 수 있는 결과
    - 필요로 하지 않는 방대한 데이터를 출력하게 되어서 과부화 위험이 있음
*/
-- 사원명, 부서명 조회
-- ORACLE 전용 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT;
-- WHERE 절 누락로 인해 EMPLOYEE 테이블의 모든 행과 DEPARTMENT 테이블의 모든 행이 서로 곱해진 결과가 조회됨

-- ANSI 표준 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT;



/*
    4. 비등가 조인(NON-EQUAL JOIN)
    - 연결고리에 대한 조건식에 '='(동등비교 연산자, 등호) 대신에 다른 비교 연산자 사용
    - 예시 : '>', '<', '>=', '<='
*/
-- EMPLOYEE 테이블로부터 사원명, 급여
SELECT *
FROM SAL_GRADE;

-- EMPLOYEE 테이블에 SAL_LEVER 컬럼이 없다는 가정 하에 진행
-- 오라클 전용 구문
SELECT EMP_NAME, SALARY, SAL_GRADE.SAL_LEVEL AS 예측값, EMPLOYEE.SAL_LEVEL AS 실제값
FROM EMPLOYEE, SAL_GRADE
--WHERE MIN_SAL <= SALARY AND SALARY <= MAX_SAL;
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;   -- BETWEEN 연산자 사용 가능, 동일함

-- ANSI 표준 구문
SELECT EMP_NAME, SALARY, SAL_GRADE.SAL_LEVEL AS 예측값, EMPLOYEE.SAL_LEVEL AS 실제값
FROM EMPLOYEE
JOIN SAL_GRADE
ON SALARY BETWEEN MIN_SAL AND MAX_SAL;
-- ANSI 구문 형식으로 비등가 조인을 하고 싶으면 무조건 ON 절을 사용해야 함
-- USING 절은 동등비교 연산자(=)만 사용 가능하기 때문

-- 비등가 조인 예시
-- 인터넷 쇼핑몰 검색 필터링 기능
-- 인터넷 쇼핑몰 회원 등급 테이블



/*
    5. 자체 조인(SELF JOIN)
    - 하나의 테이블을 두 번 이상 참조해서 조인하는 경우
    - 자기 자신과 조인한다는 의미에서 자체 조인이라고 불림
    - 자체 조인을 하기 위해서는 테이블에 별칭을 붙여서 조회해야 함

    - AMBIGUOUSLY 오류 발생 주의
*/
-- 사원의 사수에 대한 정보가 ID라 누구인지 파악이 어려움
-- EMPLOYEE 테이블로부터 사원명, 사수의 사원명 자체 조회
SELECT EMP_ID, EMP_NAME, SALARY, MANAGER_ID
FROM EMPLOYEE;

SELECT * FROM EMPLOYEE E; -- 사원에 대한 정보 도출용
SELECT * FROM EMPLOYEE M; -- 사수에 대한 정보 도출용

-- 사원의 사번, 사원명, 사원의 부서코드, 사원의 급여
-- 사수의 사번, 사수명, 사수의 부서코드, 사수의 급여
-- 오라클 전용 구문
SELECT  E.EMP_ID "사원의 사번",
        E.EMP_NAME "사원명",
        E.DEPT_CODE "사원의 부서코드",
        E.SALARY "사원의 급여",
        M.EMP_ID "사수의 사번",
        M.EMP_NAME "사수명",
        M.DEPT_CODE "사수의 부서코드",
        M.SALARY "사수의 급여"
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID;

-- 사수가 없더라도 전체 정보를 조회하고 싶음(사원 기준) - 포괄 조인
SELECT  E.EMP_ID "사원의 사번",
        E.EMP_NAME "사원명",
        E.DEPT_CODE "사원의 부서코드",
        E.SALARY "사원의 급여",
        M.EMP_ID "사수의 사번",
        M.EMP_NAME "사수명",
        M.DEPT_CODE "사수의 부서코드",
        M.SALARY "사수의 급여"
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID(+);

-- ANSI 표준 구문
SELECT  E.EMP_ID "사원의 사번",
        E.EMP_NAME "사원명",
        E.DEPT_CODE "사원의 부서코드",
        E.SALARY "사원의 급여",
        M.EMP_ID "사수의 사번",
        M.EMP_NAME "사수명",
        M.DEPT_CODE "사수의 부서코드",
        M.SALARY "사수의 급여"
FROM EMPLOYEE E
JOIN EMPLOYEE M
ON E.MANAGER_ID = M.EMP_ID;

-- OUTER JOIN
SELECT  E.EMP_ID "사원의 사번",
        E.EMP_NAME "사원명",
        E.DEPT_CODE "사원의 부서코드",
        E.SALARY "사원의 급여",
        M.EMP_ID "사수의 사번",
        M.EMP_NAME "사수명",
        M.DEPT_CODE "사수의 부서코드",
        M.SALARY "사수의 급여"
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M
ON E.MANAGER_ID = M.EMP_ID
ORDER BY E.EMP_ID /*ASC*/; -- 사원 번호 기준으로 오름차순 정렬

-- NVL 함수 활용해서 NULL인 경우 예외 처리
SELECT  E.EMP_ID "사원의 사번",
        E.EMP_NAME "사원명",
        NVL(E.DEPT_CODE, '부서 없음') "사원의 부서코드",
        E.SALARY "사원의 급여",
        NVL(M.EMP_ID, '사수 없음') "사수의 사번",
        NVL(M.EMP_NAME, '사수 없음') "사수명",
        NVL(M.DEPT_CODE, '사수 없음') "사수의 부서코드",
        NVL(M.SALARY, 0) "사수의 급여"  -- 급여는 숫자 자료형으로 만들었기 때문에 자료형 충돌 주의
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M
ON E.MANAGER_ID = M.EMP_ID
ORDER BY E.EMP_ID ASC;



-- 사원의 부서코드 뿐만 아니라 부서명도 보고 싶다면
-- 사수 또한 마찬가지로 한다면

-- ORACLE 전용 구문
SELECT  E.EMP_ID "사원의 사번",
        E.EMP_NAME "사원명",
        NVL(E.DEPT_CODE, '부서 없음') "사원의 부서코드",
        NVL(D1.DEPT_TITLE, '부서 없음') "사원의 부서명",
        E.SALARY "사원의 급여",

        NVL(M.EMP_ID, '사수 없음') "사수의 사번",
        NVL(M.EMP_NAME, '사수 없음') "사수명",
        NVL(M.DEPT_CODE, '사수 없음') "사수의 부서코드",
        NVL(D2.DEPT_TITLE, '사수 없음') "사수의 부서명",
        NVL(M.SALARY, -1) "사수의 급여"
FROM EMPLOYEE E, EMPLOYEE M, DEPARTMENT D1, DEPARTMENT D2
WHERE E.MANAGER_ID = M.EMP_ID(+)
AND E.DEPT_CODE = D1.DEPT_ID(+)
AND M.DEPT_CODE = D2.DEPT_ID(+)
ORDER BY E.EMP_ID ASC;

-- ANSI 표준 구문
SELECT  E.EMP_ID "사원의 사번",
        E.EMP_NAME "사원명",
        NVL(E.DEPT_CODE, '부서 없음') "사원의 부서코드",
        NVL(D1.DEPT_TITLE, '부서 없음') "사원의 부서명",
        E.SALARY "사원의 급여",

        NVL(M.EMP_ID, '사수 없음') "사수의 사번",
        NVL(M.EMP_NAME, '사수 없음') "사수명",
        NVL(M.DEPT_CODE, '사수 없음') "사수의 부서코드",
        NVL(D2.DEPT_TITLE, '사수 없음') "사수의 부서명",
        NVL(M.SALARY, -1) "사수의 급여"
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M
ON E.MANAGER_ID = M.EMP_ID
LEFT JOIN DEPARTMENT D1
ON E.DEPT_CODE = D1.DEPT_ID
LEFT JOIN DEPARTMENT D2
ON M.DEPT_CODE = D2.DEPT_ID
ORDER BY E.EMP_ID ASC;
-- > 3개 이상의 테이블 조인 시에는 포괄 조인의 경우 연결된 모든 테이블들을 포괄시키는 조건으로 작성해야함

/*
    다중 조인
    - 3개 이상의 테이블을 조인하는 경우
    - N개 테이블을 조인하는 경우, N-1개의 JOIN 구문이 필요
*/

-- 사원명, 부서명, 직급명, 근무지역명, 근무국가명, 급여등급 조회
-- ORACLE 전용 구문
SELECT E.EMP_NAME, D.DEPT_TITLE, J.JOB_NAME, L.LOCAL_NAME, N.NATIONAL_NAME, S.SAL_LEVEL
FROM EMPLOYEE E, DEPARTMENT D, JOB J, LOCATION L, NATIONAL N, SAL_GRADE S
WHERE E.DEPT_CODE = D.DEPT_ID(+)
AND E.JOB_CODE = J.JOB_CODE(+)
AND D.LOCATION_ID = L.LOCAL_CODE(+)
AND L.NATIONAL_CODE = N.NATIONAL_CODE(+)
AND E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL
ORDER BY E.EMP_NAME ASC;

-- ANSI 표준 구문
SELECT E.EMP_NAME, D.DEPT_TITLE, J.JOB_NAME, L.LOCAL_NAME, N.NATIONAL_NAME, S.SAL_LEVEL
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D
ON E.DEPT_CODE = D.DEPT_ID
LEFT JOIN JOB J
ON E.JOB_CODE = J.JOB_CODE
LEFT JOIN LOCATION L
ON D.LOCATION_ID = L.LOCAL_CODE
LEFT JOIN NATIONAL N
ON L.NATIONAL_CODE = N.NATIONAL_CODE
JOIN SAL_GRADE S
ON E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL
ORDER BY E.EMP_NAME ASC;


-- 테이블을 잘개 쪼갤수록 데이터 중복이 최소화 - 무결성 향상, 관리 용이
-- 하지만 조인해서 조회해야 하는 테이블이 많아질수록 작성해야 하는 JOIN 구문이 많아지고, 복잡해짐
-- > 조인해야 하는 테이블이 많아질수록 쿼리 작성이 어려워지고, 가독성이 떨어짐(select문 성능 저하)
-- > INSERT, UPDATE, DELETE 구문의 성능은 향상됨