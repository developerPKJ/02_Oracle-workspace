/*
    < SUBQUERY >
    - 서브쿼리는 하나의 쿼리 안에 또 다른 쿼리가 포함된 형태
    - 서브쿼리는 괄호로 감싸져 있으며, 일반적으로 SELECT 문이 사용됨

    메인 쿼리 안에 서브쿼리 - 서브쿼리 우선 실행, RESULT SET 바탕으로 메인쿼리 실행
*/
-- 김유화 사원과 같은 부서
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '김유화';

--> DEPT_CODE = 'D6' --> 김유화 사원과 같은 부서인 사람들
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6'
AND EMP_NAME != '김유화';
-- >> 2번에 걸쳐서 검색해야하는 번거러움

-- 서브쿼리를 사용하여 한 번에 검색
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (
    SELECT DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME = '김유화'
)
AND EMP_NAME != '김유화';


-- 전체 사원들의 평균 급여보다 더 많은 급여를 받고 있는 사원들의 사번, 이름, 직급코드 조회
SELECT E.EMP_ID, E.EMP_NAME, J.JOB_CODE, J.JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND E.SALARY > (
    SELECT AVG(SALARY)
    FROM EMPLOYEE
);


/*
    서브 쿼리의 종류
    - 서브쿼리 부분만 실행 했을 때, RESULT SET이 몇 행 몇 열이냐에 따라 구분

    1. 단일 행, (단일 열) 서브쿼리 : 1행 1열
    2. 다중 행, (단일 열) 서브쿼리 : 여러 행 1열
    3. (단일 행), 다중 열 서브쿼리 : 1행 여러 열
    4. 다중 행, 다중 열 서브쿼리 : 여러 행 여러 열

    > 서브쿼리를 수행한 결과가 몇행 몇열이냐에 따라 메인쿼리에서 사용할 수 있는 연산자의
    종류가 달라짐, 그래서 서브쿼리를 구분하는 것
*/

/*
    1. 단일행 (단일열) 서브쿼리  :  SINGLE ROW SUBQUERY
    일반적인 연산자 사용 가능 : =, >, <, >=, <=, !=
*/
-- 전 직원의 평균 급여보다 더 작게 받는 사원들의 사원명, 직급코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (
    SELECT AVG(SALARY)
    FROM EMPLOYEE
);

-- 최한선 사원과 같은 부서의 사원들의 사번, 이름, 전화번호, 직급명
-- ORACLE 전용 구문
SELECT EMP_ID, EMP_NAME, PHONE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE(+)
AND E.DEPT_CODE = (
    SELECT DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME = '최한선'
)
AND E.EMP_NAME != '최한선';
-- ANSI 표준 구문
SELECT EMP_ID, EMP_NAME, PHONE, JOB_NAME
FROM EMPLOYEE E
LEFT JOIN JOB J
ON E.JOB_CODE = J.JOB_CODE
WHERE E.DEPT_CODE = (
    SELECT DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME = '최한선'
)
AND E.EMP_NAME != '최한선';

-- 부서별 급여 합이 가장 큰 부서 하나만을 조회(부서코드, 부서명, 급여합)
SELECT E.DEPT_CODE, D.DEPT_TITLE, SUM(SALARY) AS TOTAL_SALARY
FROM EMPLOYEE E
JOIN DEPARTMENT D
ON E.DEPT_CODE = D.DEPT_ID
GROUP BY E.DEPT_CODE, D.DEPT_TITLE
HAVING SUM(SALARY) = (
    SELECT MAX(SUM(SALARY))
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
);

-------------------------------------------------------------------

/*
    2. 다중 행 (단일 열) 서브쿼리  :  MULTI ROW SUBQUERY
    일반적인 연산자 사용 불가 : (NOT) IN, ANY, ALL 연산자 사용

    - (NOT) IN (서브쿼리) : 서브쿼리의 결과로 반환된 값들 중에서 하나라도 일치하면 TRUE
    - 부등호 ANY (서브쿼리) : 서브쿼리의 결과로 반환된 값들 중에서 하나라도 조건을 만족하면 TRUE
    - 부등호 ALL (서브쿼리) : 서브쿼리의 결과로 반환된 값들 모두가 조건을 만족해야 TRUE
*/
-- IN
-- 과장과 같은 급여를 받는 사원들의 사번, 이름, 직급명, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND E.SALARY IN (
    SELECT SALARY
    FROM EMPLOYEE E, JOB J
    WHERE E.JOB_CODE = J.JOB_CODE
    AND J.JOB_NAME = '과장'
);

-- ANY
-- 과장보다 급여가 많은 대리들의 사번, 이름, 직급명, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND E.SALARY > ANY (
    SELECT SALARY
    FROM EMPLOYEE E, JOB J
    WHERE E.JOB_CODE = J.JOB_CODE
    AND J.JOB_NAME = '과장'
)
AND JOB_NAME = '대리';

-- ALL (사원 < 대리 < 과장 < 차장 < 부장)
-- 과장인데 차장보다 급여 많은 직원 조회
-- ORACLE 전용 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND E.SALARY > ALL (
    SELECT SALARY
    FROM EMPLOYEE E, JOB J
    WHERE E.JOB_CODE = J.JOB_CODE
    AND J.JOB_NAME = '차장'
)
AND J.JOB_NAME = '과장';

-- ANSI 표준 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
LEFT JOIN JOB
USING(JOB_CODE)
WHERE SALARY > ALL(
    SELECT SALARY
    FROM EMPLOYEE
    LEFT JOIN JOB
    USING(JOB_CODE)
    WHERE JOB_NAME = '차장'
)
AND JOB_NAME = '과장';



/*
    3. (단일행) 다중열 서브쿼리  :  MULTI COLUMN SUBQUERY
    일반적인 연산자 사용 가능 : =, >, <, >=, <=, !=
*/
-- 이남훈 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (
    SELECT DEPT_CODE, JOB_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME = '이남훈'
);
-- > 컬러명들 = 서브쿼리로 한번에 일괄 동등비교 가능
-- > 앞쪽 컬럼명들과 서브쿼리 결과 컬럼명의 나열 순서가 일치해야함
-- 추가로 서브쿼리 대신 값들의 나열은 불가함(문법적으로 불가)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = ('D1', 'J1');
-- 이러면 오류 발생


-- 김규민 사원과 같은 부서코드, 같은 직급코드를 가진 사원들 조회
-- 사번 이름 직급코드 사수사번
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (
    SELECT DEPT_CODE, JOB_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME = '김규민'
)
AND EMP_NAME != '김규민';


/*
    4. 다중 행, 다중 열 서브쿼리  :  MULTI ROW MULTI COLUMN SUBQUERY
    일반적인 연산자 사용 불가 : (NOT) IN, ANY, ALL 연산자 사용

    - (NOT) IN (서브쿼리) : 서브쿼리의 결과로 반환된 값들 중에서 하나라도 일치하면 TRUE
    - 부등호 ANY (서브쿼리) : 서브쿼리의 결과로 반환된 값들 중에서 하나라도 조건을 만족하면 TRUE
    - 부등호 ALL (서브쿼리) : 서브쿼리의 결과로 반환된 값들 모두가 조건을 만족해야 TRUE
*/
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) = ('J2', 3700000)
OR (JOB_CODE, SALARY) = ('J7', 1380000);
-- 위에서와 마찬가지로 컬럼값 여러개를 한번에 묶어서 리터럴들과 동등 비교 불가

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (
    ('J2', 3700000),
    ('J7', 1380000)
);
-- IN 연산자와 함께 서브쿼리 대신 값들의 나열은 가능
-- 하지만 비효율적

-- 부서별 최소 급여
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (
    SELECT DEPT_CODE, SALARY
    FROM EMPLOYEE
    WHERE (DEPT_CODE, SALARY) IN (
        SELECT DEPT_CODE, MIN(SALARY)
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
    )
)
ORDER BY DEPT_CODE;

-- 부서별 최대 급여
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (
    SELECT DEPT_CODE, MAX(SALARY)
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
)
ORDER BY DEPT_CODE;

-- IN 연산자는 내부적으로 동등비교를 해주기 때문에 NULL에 대한 비교는 불가
-- > NVL 함수로 NULL을 다른 값으로 대체해서 비교 가능
SELECT EMP_ID, EMP_NAME, NVL(DEPT_CODE, 'UNKNOWN') AS DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (NVL(DEPT_CODE, 'UNKNOWN'), SALARY) IN (
    SELECT NVL(DEPT_CODE, 'UNKNOWN'), MAX(SALARY)
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
)
ORDER BY DEPT_CODE;


/*
    번외 SUBQUERY
    FROM 절에 서브쿼리 사용(SELECT 절에도 가능한데 비권장)
    : INLINE VIEW : FROM 절에 서브쿼리를 사용해서 마치 테이블처럼 활용하는 방법

    - RESULT SET을 테이블 대신 이용
*/
SELECT EMP_ID, EMP_NAME, ANNUAL_SALARY, DEPT_CODE
FROM (
    SELECT  EMP_ID,
            EMP_NAME,
            ((SALARY * NVL(BONUS, 0)) + SALARY) * 12 AS ANNUAL_SALARY,
            DEPT_CODE
    FROM EMPLOYEE
)
WHERE ANNUAL_SALARY > 30000000;
-- INLINE VIEW에서 컬럼에 별칭을 부여하고 조회를 시작하기 때문에
-- 바깥 WHERE 절에서도 별칭으로 조회 가능

-- INLINE VIEW 사용 예시(실무에서 많이 씀)
-- 1. TOP-N 분석 : DB상의 데이터들 중 최상위 N개의 데이터만 조회하는 방법


-- 전 직원 중 급여가 가장 높은 상위 5명
-- ROWNUM : 오라클에서 제공하는 가상 컬럼으로, 쿼리 결과에서 행의 순번을 나타냄
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5
ORDER BY SALARY DESC;
-- 위 쿼리는 ROWNUM이 정렬되기 전에 부여되기 때문에 원하는 결과가 나오지 않음
-- ROWNUM도 따라 움직여서 저렇게 조건을 걸면 상위가 아니라 정렬되기 전 조회된 상위 5명만 조회됨

SELECT ROWNUM, EMP_NAME, SALARY
FROM (
    SELECT EMP_NAME, SALARY
    FROM EMPLOYEE
    ORDER BY SALARY DESC
)
WHERE ROWNUM <= 5;
-- INLINE VIEW로 미리 정렬을 수행한 후 ROWNUM을 적용하여 상위 5명을 정확히 조회 가능
-- 핵심은 ORDER BY 절이 WHERE 절보다 먼저 실행되게 하는 점

-- INLINE VIEW 사용 주의 사항
SELECT ROWNUM, *
FROM (
    SELECT *
    FROM EMPLOYEE
    ORDER BY SALARY DESC
)
WHERE ROWNUM <= 5;
-- MISSING EXPRESSION 오류 발생
-- '*' 은 단독으로만 사용 가능, 다른 컬럼명과 함께 사용할 수 없음

-- > 이런 경우 ROWNUM의 경우 가상 컬럼이기 때문에 SELECT 절에 없어도 WHERE 절에서 사용할 수 있음
SELECT *
FROM (
    SELECT *
    FROM EMPLOYEE
    ORDER BY SALARY DESC
)
WHERE ROWNUM <= 5;

-- ROWNUM을 꼭 추가하고 싶다면, INLINE VIEW에 별칭을 부여해서 ROWNUM과 함께 조회 가능
SELECT ROWNUM, E.*
FROM (
    SELECT *
    FROM EMPLOYEE
    ORDER BY SALARY DESC
) E
WHERE ROWNUM <= 5;


-- 각 부서별 평균 급여가 가장 높은 3개의 부서의 부서코드, 평균 급여 조회
SELECT E.*
FROM (
    SELECT NVL(DEPT_CODE, 'NULL') ,AVG(SALARY) AS AVG_SALARY
    FROM EMPLOYEE
    GROUP BY NVL(DEPT_CODE, 'NULL')
    ORDER BY AVG_SALARY DESC
) E
WHERE ROWNUM <= 3;
-- INLINE VIEW 안에 함수식이 포함되어 있는 경우 컬럼에 별칭을 반드시 붙여줘야 함
-- 바깥 SELECT문에서 만약 * 이 아닌 함수식으로 호출하면 이중으로 함수를 적용하게 됨 = 오류 발생


-- 보너스 포함 연봉이 가장 높은 상위 5명
SELECT ROWNUM, E.*
FROM (
    SELECT  EMP_ID, EMP_NAME, SALARY, BONUS,
            SALARY * (1 + NVL(BONUS, 0)) * 12 AS ANNUAL_SALARY
    FROM EMPLOYEE
    ORDER BY ANNUAL_SALARY DESC
) E
WHERE ROWNUM <= 5;


-- 가장 최근에 입사한 사원 5명 조회(사원명, 급여, 입사일)
SELECT ROWNUM, E.*
FROM (
    SELECT EMP_NAME, SALARY, HIRE_DATE
    FROM EMPLOYEE
    ORDER BY HIRE_DATE DESC
) E
WHERE ROWNUM <= 5;


/*
    순위를 매기는 함수 = WINDOW FUNCTION

    - RANK() OVER(PARAMETER : 정렬 기준)
    : 공동 1위가 3명이면 다음 순위는 4등으로 (대회 방식)
    
    - DENSE_RANK() OVER(PARAMETER : 정렬 기준)
    : 공동 1위가 3명이여도 다음 순위는 2등

    주의사항
    - WINDOW FUNCTION은 SELECT 절에서만 사용 가능

*/
-- 사원들의 급여가 높은 순대로 순위 매겨 사원명, 급여, 순위 조회
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;
-- ORDER BY로 ROWNUM 통해 순위를 매기고 싶으면 INLINE VIEW를 이용해 ORDEF BY 절이 먼저 실행필요

-- RANK() OVER()
SELECT RANK() OVER(ORDER BY SALARY DESC) AS RANK, EMP_NAME, SALARY
FROM EMPLOYEE;

-- DENSE_RANK() OVER()
SELECT DENSE_RANK() OVER(ORDER BY SALARY DESC) AS RANK, EMP_NAME, SALARY
FROM EMPLOYEE;

SELECT RANK() OVER(ORDER BY SALARY DESC) AS RANK, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE RANK <= 5;
-- WHERE 절에는 RANK() OVER() 활용 불가


-- > INLINE VIEW + RANK() OVER()
SELECT E.*
FROM (
    SELECT  EMP_NAME,
            SALARY,
            RANK() OVER(ORDER BY SALARY DESC) AS RANK
    FROM EMPLOYEE
)
WHERE RANK <= 5;
-- RANK OVER를 이용해 TOP-N 분석을 쓰는 경우에도 INLINE VIEW 이용은 필수