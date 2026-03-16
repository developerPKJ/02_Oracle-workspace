/*
    < GROUP BY 절 >
    
    - 주로 그룹 함수와 묶여서 쓰이고, 그룹을 묶어줄 기준을 제시할 수 있는 구문
    - GROUP BY 절에서 제시된 기준별로 그룹을 묶을 수 있음
    
    예) EMPLOYEE 테이블 기준 23개행이 저장됨 (즉, 23명의 정보가 담겨있음)
    - GROUP BY 절을 쓰지 않은 경우 그룹 함수 결과가 1개로 나왔음!!
    - GROUP BY 절을 쓰면 내가 제시한 기준에 대한 갯수별로 그룹이 각각 묶임!! 결과도 그 갯수별로 나옴!!
*/

-- 전체 사원들의 총 급여 합
SELECT SUM(SALARY)
  FROM EMPLOYEE;
--> 전체 23명의 사원들을 하나의 그룹으로 묶어서 급여의 총합을 구한 결과임!!

-- 각 부서별 총 급여 합
SELECT DEPT_CODE, SUM(SALARY)
  FROM EMPLOYEE
 GROUP BY DEPT_CODE;
-- 23명의 사원들은 총 7개의 부서에 각각 속해있음 (NULL 포함)
--> 23명을 7그룹으로 나눠보겠다.
--  (그래서 SUM 의 결과도 그룹별로 구하게 되므로 총7개 나옴)

-- 각 부서별 사원 수
SELECT DEPT_CODE, COUNT(*)
  FROM EMPLOYEE
 GROUP BY DEPT_CODE;
--> 마찬가지로 총 7개의 그룹으로 나뉘고 결과도 7개로 나옴

-- 각 직급별 사원 수
SELECT JOB_CODE, COUNT(*)
  FROM EMPLOYEE
 GROUP BY JOB_CODE;
--> 23명의 사원들은 총 7개의 직급에 각각 해당됨 
--  23명을 7그룹으로 나눠보겠다.
--> 총 7개의 그룹으로 나뉘고 결과도 7개로 나옴  

-- 각 직급별 직급코드, 총 급여의 합, 사원수, 보너스를 받는 사원 수, 평균 급여, 최고 급여, 최소 급여
SELECT JOB_CODE
     , SUM(SALARY) "총 급여의 합"
     , COUNT(*) "사원 수"
     , COUNT(BONUS) "보너스를 받는 사원 수"
     , ROUND(AVG(SALARY)) "평균 급여"
     , MAX(SALARY) "최고 급여"
     , MIN(SALARY) "최소 급여"
  FROM EMPLOYEE
 GROUP BY JOB_CODE;

-- 각 부서별 부서코드, 사원수, 보너스를 받는 사원 수, 사수가 있는 사원 수, 평균 급여
SELECT NVL(DEPT_CODE, '미정') "부서코드"
     , COUNT(*) "사원 수"
     , COUNT(BONUS) "보너스를 받는 사원 수"
     , COUNT(MANAGER_ID) "사수가 있는 사원 수"
     , ROUND(AVG(SALARY)) "평균 급여"            -- 3
  FROM EMPLOYEE                                 -- 1
 GROUP BY DEPT_CODE                             -- 2
 ORDER BY 부서코드 ASC;                          -- 4
--> GROUP BY 절에서는 별칭을 사용할 수 없다!!
--  왜? SELECT 절 보다 GROUP BY 절이 먼저 실행되기 때문임!!

-- 성별 별 사원 수
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남자',
                                   '2', '여자') "성별"
     , COUNT(*) "사원 수"
  FROM EMPLOYEE
 GROUP BY SUBSTR(EMP_NO, 8 ,1);
--> GROUP BY 절에는 무조건 컬럼명만 들어가라는 법은 없다.
--  함수식의 결과로도 그룹핑을 할 수 있음!!

--> GROUP BY 는 쉽게 생각해서 전체 데이터들을 내가 원하는 기준에 따라
--  여러 갈래로 나누어 주는 역할임!!
--  주로 통계 자료를 뽑아낼 때 많이 쓰임!!

--------------------------------------------------------------------------------

/*
    < HAVING 절 >
    
    - 그룹에 대한 조건을 제시하고 싶을 때 사용되는 구문
    - 즉, 그룹함수식이 포함된 조건식을 제시하는 용도임!!
*/

-- 각 부서별 평균 급여가 300만원 이상인 부서들만 조회
SELECT DEPT_CODE, ROUND(AVG(SALARY))
  FROM EMPLOYEE
 WHERE AVG(SALARY) >= 3000000
 GROUP BY DEPT_CODE;
--> group function is not allowed here 라고 오류 발생!!
--  (WHERE 절에는 그룹함수식이 포함될 수 없음)

-- 이 경우 사용할 수 있는게 HVAING 절임!!
SELECT DEPT_CODE, ROUND(AVG(SALARY))
  FROM EMPLOYEE
 GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000
 ORDER BY DEPT_CODE ASC;

-- 각 직급 별 총 급여 합이 1000만원 이상인 직급코드, 급여 합
SELECT JOB_CODE, SUM(SALARY)
  FROM EMPLOYEE
 GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000;

-- 각 부서 별 보너스를 받는 사원이 없는 부서만을 조회
SELECT DEPT_CODE, COUNT(BONUS)
  FROM EMPLOYEE
 GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;

--> 왜? WHERE 절에서는 그룹함수식을 쓰지 못할까?
--  그 이유는 WHERE 절이 GROUP BY 절 보다 먼저 실행되기 때문임!!

--------------------------------------------------------------------------------

/*
    < SELECT 문의 표현법 및 실행 순서 >
    
    5. SELECT * / 조회할컬럼명 / 리터럴 / 산술연산식 / 함수식 AS "별칭"
    1.   FROM 조회할테이블명 / 가상테이블 (DUAL)
    2.  WHERE 조건식 <<-- 그룹함수는 안됨!!
    3.  GROUP BY 그룹기준에해당하는컬럼명 / 함수식
    4. HAVING 그룹함수에대한조건식
    6.  ORDER BY [정렬기준이되는컬럼명 / 별칭 / 컬럼순번] [ASC / DESC] [NULLS FIRST / NULLS LAST]
                                                       (생략가능)            (생략가능)
*/

--------------------------------------------------------------------------------

/*
    < 집합 연산자 SET OPERATOR >
    
    - 여러 개의 SELECT 문을 가지고 하나의 쿼리문으로 만들어주는 연산자
      (참고로 하나의 SELECT 문 실행 결과를 RESULT SET - 결과 집합 이라고 부른다!!)
      (SELECT 문 한번 실행 시 집합 한개가 만들어지는 꼴)
      
    - 주의할 점으로는 그 여러개의 SELECT 문의 SELECT 절이 같아야 함!!
    
    [ 종류 ]
    
    - UNION : 합집합
              두 쿼리문을 실행한 결과값을 더한 후 중복되는 부분은 한번 뺀 것 (OR 의 의미)    
    - INTERSECT : 교집합
                  두 쿼리문을 실행한 결과값의 중복된 결과값 부분 (AND 의 의미)
    - UNION ALL : 합집합 결과에 교집합 결과가 더해진 개념
                  즉, 두 쿼리문을 실행한 결과값을 더한 후 중복 제거를 하지 않는 개념
                  (중복된 결과가 나타날 수 있음!!)
    - MINUS : 차집합
              선행 쿼리문 결과값 빼기 후행 쿼리문 결과값의 결과
              (선행과 후행의 순서가 중요함!!)
*/

-- 참고) 
SELECT *
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D3';
--> SELECT 문을 통해 실행한 결과 (RESULT SET) 에 조회된 데이터가 하나도 없는 경우 (조회된 행이 0개일 경우)
--  "공집합" 이라고 부른다. (비어있는 집합, 데이터가 안들어가있는 집합)

-- 1. UNION (합집합)
-- 두 쿼리문을 수행한 결과값을 더하지만 중복되는 결과는 한번만 조회
-- 부서코드가 D5 이거나 급여가 300만원 초과인 사원들 조회
-- (사번, 사원명, 부서코드, 급여)

-- 부서코드가 D5 인 사원들만 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5';
--> 6명 조회 (박경준, 송경민, 안성훈, 유종규, 이남훈, 정우주)

-- 급여가 300만원 초과인 사원들 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY > 3000000;
--> 8명 조회 (김가현, 권기성, 김규민, 김영찬, 김유화, 유종규, 정우주, 정종욱)

-- 부서코드가 D5 이거나 또는 급여가 300만원 초과인 사원들 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5'
UNION -- 합집합 연산자
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY > 3000000;
--> 12명 조회 (6명 + 8명 - 2명)

-- 굳이 UNION 연산자 대신 OR 연산자를 이용할 수 있다.
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5'
    OR SALARY > 3000000;

-- 2. UNION ALL
-- 여러개의 쿼리 결과를 무조건 더하는 연산자
-- (중복되는 결과가 여러개 들어갈 수 있음!!)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY > 3000000;
--> 14명 조회 (6명 + 8명)

-- 참고)
-- UNION 연산보다 UNION ALL 연산의 속도가 더 빠르다.
-- UNION 연산은 내부적으로 UNION ALL 후 중복제거를 해서 결과를 반환

-- 3. INTERSECT (교집합)
-- 여러 쿼리문의 결과의 중복된 결과 부분을 한번만 조회
-- 부서 코드가 D5 이면서 급여까지도 300만원 초과인 사원들을 조회
-- (사번, 이름, 부서코드, 급여)

-- 부서 코드가 D5 인 사원들
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5';

-- 급여가 300만원 초과인 사원들
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY > 3000000;

-- 부서 코드가 D5 이면서 뿐만 아니라 급여까지도 300만원 초과인 사원들
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5'
INTERSECT -- 교집합 연산자
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY > 3000000;
--> 2명 조회

-- INTERSECT 연산자 대신 AND 연산자 이용해보기
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5'
   AND SALARY > 3000000;

-- 4. MINUS (차집합)
-- 선행 쿼리 결과에 후행 쿼리 결과를 뺀 나머지
-- 부서 코드가 D5 인 사원들 중 급여가 300만원 초과인 사원들을 제외하고 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5'
MINUS -- 차집합 연산자
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY > 3000000;
--> 6명 중 겹치는 2명을 제외하고 나머지 4명만 조회

-- 선행과 후행의 순서가 바뀐다면?
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY > 3000000
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5';
--> 8명 중 겹치는 2명을 제외하고 나머지 6명만 조회

-- 굳이 MINUS 연산을 안써도 가능
-- 부서 코드가 D5 인 사원들 중 급여가 300만원 초과인 사원들을 제외하고 조회
-- 부서 코드가 D5 인 사원들 중 급여가 300만원 이하인 사원들만 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5'
   AND SALARY <= 3000000;
--> 말장난 주의!!

--> 집합연산자 사용 시
--  항상 여러개의 SELECT 문의 SELECT 절이 같아야 한다!!

-- 대표적인 사용 예시)
-- 






















