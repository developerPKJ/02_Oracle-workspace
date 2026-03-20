/*
    < VIEW 뷰 >
    
    - SELECT (쿼리문) 을 텍스트로 저장해둘 수 있는 객체
      (자주 쓰이는 긴 SELECT 문을 한번 잘 저장해 두면 매번 조회 시마다 그 긴 SELECT 문을 다시 쓸 필요가 없음!!)
    - 조회용 임시 테이블 같은 존재
    - 실제 데이터가 담겨있는 것은 아님!! (데이터 저장용도 X)
*/

-- 뷰를 쓰는 이유
-- 예) "한국" 에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명, 직급명을 조회하시오
SELECT EMP_ID
     , EMP_NAME
     , DEPT_TITLE
     , SALARY
     , NATIONAL_NAME
     , JOB_NAME
  FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N, JOB J
 WHERE E.DEPT_CODE = D.DEPT_ID(+)
   AND D.LOCATION_ID = L.LOCAL_CODE(+)
   AND L.NATIONAL_CODE = N.NATIONAL_CODE(+)
   AND E.JOB_CODE = J.JOB_CODE -- 연결고리에 대한 조건
   AND N.NATIONAL_NAME = '한국'; -- 추가적인 조건
--> 업무상 위의 긴 쿼리문이 자주 많이 쓰일 경우
--  매번 필요할 때 마다 위의 쿼리문을 매번 계속 기술해서 쓰기에는 너무 귀찮음!! (실수할 수도 있고)

/*
    1. VIEW 생성 방법 (CREATE)
    
    [ 표현법 ]
    
    CREATE VIEW 뷰명
    AS (서브쿼리);
    
    또는
    
    CREATE OR REPLACE VIEW 뷰명
    AS (서브쿼리);
    
    - OR REPLACE 는 생략 가능하다.
      뷰 생성 시 기존에 중복된 이름의 뷰가 있다면 해당 뷰를 갱신 (변경) 하는 옵션
      뷰 생성 시 기존에 중복된 이름의 뷰가 없다면 그냥 새롭게 뷰를 만들어줌!!
    
    - 서브쿼리로 기술한 SELECT 문 자체가 저장되는 원리임!!
*/

-- 위의 복잡했던 SELECT 문을 뷰로 저장해보기
CREATE VIEW VW_EMPLOYEE
AS (
        SELECT EMP_ID
             , EMP_NAME
             , DEPT_TITLE
             , SALARY
             , NATIONAL_NAME
             , JOB_NAME
          FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N, JOB J
         WHERE E.DEPT_CODE = D.DEPT_ID(+)
           AND D.LOCATION_ID = L.LOCAL_CODE(+)
           AND L.NATIONAL_CODE = N.NATIONAL_CODE(+)
           AND E.JOB_CODE = J.JOB_CODE
);

--> 현재 KH 계정에 뷰 생성 권한이 없어서 오류 발생
--  ORA-01031: insufficient privileges
--  (불충분한 권한)

--> 관리자 계정에서 GRANT CREATE VIEW TO KH; 구문으로 권한 부여 하기
-- 아래의 구문만 관리자 계정에서 실행할것!!
GRANT CREATE VIEW TO KH;

--> 위의 뷰 생성 구문 다시 실행
--  이제는 잘 생성됨!!

SELECT * FROM VW_EMPLOYEE;

-- 한국에서 근무하는 사원들만 보기
SELECT *
  FROM VW_EMPLOYEE
 WHERE NATIONAL_NAME = '한국';

-- 러시아에서 근무하는 사원들만 보기
SELECT *
  FROM VW_EMPLOYEE
 WHERE NATIONAL_NAME = '러시아';

-- 일본에서 근무하는 사원들의 사번, 이름, 직급명, 보너스를 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, BONUS
  FROM VW_EMPLOYEE
 WHERE NATIONAL_NAME = '일본';
--> "BONUS": invalid identifier
--  VW_EMPLOYEE 뷰에는 BONUS 컬럼이 없음에도 불구하고 조회하려고 해서 오류남

-- BONUS 컬럼이 없는 뷰에서 보너스도 같이 조회하고 싶은 경우
-- 방법1. 해당 뷰를 삭제하고 BONUS 컬럼을 추가한 뷰로 다시 생성해서 조회
-- 방법2. CREATE OR REPLACE VIEW 명령어를 사용하는 방법

CREATE OR REPLACE VIEW VW_EMPLOYEE
AS (
        SELECT EMP_ID
             , EMP_NAME
             , DEPT_TITLE
             , SALARY
             , NATIONAL_NAME
             , JOB_NAME
             , BONUS
          FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N, JOB J
         WHERE E.DEPT_CODE = D.DEPT_ID(+)
           AND D.LOCATION_ID = L.LOCAL_CODE(+)
           AND L.NATIONAL_CODE = N.NATIONAL_CODE(+)
           AND E.JOB_CODE = J.JOB_CODE
);
--> View VW_EMPLOYEE이(가) 생성되었습니다.

SELECT EMP_ID, EMP_NAME, JOB_NAME, BONUS
  FROM VW_EMPLOYEE
 WHERE NATIONAL_NAME = '일본';
--> 기존의 뷰 변경 후 오류가 사라졌음!!

-- "뷰는 논리적인 가상테이블이다."
-- 즉, 실질적으로 데이터를 저장하고 있지 않음!!
-- 단순히 "SELECT 문" 이 텍스트로 저장되어있음!!

-- 참고)
-- USER_VIEWS : 해당 계정이 가지고 있는 VIEW 들에 대한 내용을 담고 있는 데이터 딕셔너리
SELECT * FROM USER_VIEWS;

--------------------------------------------------------------------------------

/*
    * 뷰 생성 시 컬럼에 별칭 부여하기
    
    - 서브쿼리의 SELECT 절에 함수식 또는 연산식이 포함된 경우 반드시 별칭을 부여해야함!!
*/

-- 사원의 사번, 이름, 직급명, 성별, 근무년수를 조회할 수 있는 SELECT 문을 뷰로 정의
-- 우선 SELECT 문 먼저 써보기
SELECT EMP_ID
     , EMP_NAME
     , JOB_NAME
     , DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남'
                                  , '2', '여'
                                  , '3', '남'
                                       , '여')
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
  FROM EMPLOYEE
  JOIN JOB USING (JOB_CODE);

-- 위의 SELECT 문을 저장할 수 있는 VIEW 생성!!
CREATE OR REPLACE VIEW VW_EMP_JOB
AS (
        SELECT EMP_ID
             , EMP_NAME
             , JOB_NAME
             , DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남'
                                          , '2', '여'
                                          , '3', '남'
                                               , '여')
             , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
          FROM EMPLOYEE
          JOIN JOB USING (JOB_CODE)
);
--> must name this expression with a column alias
--  서브쿼리의 SELECT 절에 별칭을 지정하지 않아서 오류 발생!!
--  ALIAS : 별칭

CREATE OR REPLACE VIEW VW_EMP_JOB
AS (
        SELECT EMP_ID
             , EMP_NAME
             , JOB_NAME
             , DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남'
                                          , '2', '여'
                                          , '3', '남'
                                               , '여') "성별"
             , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) "근무년수"
          FROM EMPLOYEE
          JOIN JOB USING (JOB_CODE)
);
--> View VW_EMP_JOB이(가) 생성되었습니다.

SELECT * FROM VW_EMP_JOB;

-- 또 다른 방법으로도 별칭 부여 가능!!
-- 단, 모든 컬럼에 대한 별칭을 다 기술해야할 때 주로 사용!!
CREATE OR REPLACE VIEW VW_EMP_JOB (사번, 사원명, 직급명, 성별, 근무년수)
AS (
        SELECT EMP_ID
             , EMP_NAME
             , JOB_NAME
             , DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남'
                                          , '2', '여'
                                          , '3', '남'
                                               , '여') 
             , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 
          FROM EMPLOYEE
          JOIN JOB USING (JOB_CODE)
);

SELECT * FROM VW_EMP_JOB;

-- 뷰의 컬럼에 별칭을 지정했다면?
--> 앞으로 조회 시 메인쿼리 부분에서 별칭 사용 가능

-- 여자인 사원들의 사원명, 직급명 조회
SELECT 사원명, 직급명
  FROM VW_EMP_JOB
 WHERE 성별 = '여';

-- 근무년수가 20년 이상인 사원들만 조회
SELECT *
  FROM VW_EMP_JOB
 WHERE 근무년수 >= 20;

-- 뷰를 삭제하고자 한다면?
-- [ 표현법 ]
-- DROP VIEW 뷰명;
DROP VIEW VW_EMP_JOB;
--> View VW_EMP_JOB이(가) 삭제되었습니다.

SELECT *
  FROM VW_EMP_JOB;
--> table or view does not exist
--> 뷰 삭제 후 조회 불가!!
--  단, 뷰가 삭제되었다고 해서 데이터가 삭제된건 아님!!

--------------------------------------------------------------------------------

/*
    * 생성된 뷰를 이용해서 DML (INSERT, UPDATE, DELETE) 문도 사용 가능
    
    - 단, 뷰를 통해서 데이터 내용을 변경하게 되면
      실제 데이터가 담겨있는 실질적인 테이블 (원본 테이블, BASE TABLE) 에 적용이 된다!!
*/

-- 테스트용 뷰 생성
CREATE OR REPLACE VIEW VW_JOB
AS (
        SELECT *
          FROM JOB
);

SELECT * FROM VW_JOB; -- 뷰를 조회
SELECT * FROM JOB; -- 원본 테이블을 조회

-- 뷰에 INSERT
INSERT INTO VW_JOB VALUES('J8', '인턴'); 
--> 1 행 이(가) 삽입되었습니다.
--> 뷰명을 제시했음에도 불구하고 INSERT 가 잘 됨

SELECT * FROM VW_JOB; -- 뷰를 조회
SELECT * FROM JOB; -- 원본 테이블을 조회
--> 아무리 뷰에 INSERT 를 하더라도
--  뷰에 데이터가 실제로 INSERT 되는 것이 아니라
--  그 뷰를 만들기 위한 원본 테이블 (베이스 테이블) 에 INSERT 되는 것!!

-- JOB_CODE 가 J8 인 JOB_NAME 을 '알바' 로 UPDATE
UPDATE VW_JOB
   SET JOB_NAME = '알바'
 WHERE JOB_CODE = 'J8';
--> 1 행 이(가) 업데이트되었습니다.

SELECT * FROM VW_JOB;
SELECT * FROM JOB;
--> UPDATE 또한 마찬가지로 원본 테이블 내용이 변경됨!!

-- JOB_CODE 가 'J8' 인 행 삭제
DELETE
  FROM VW_JOB
 WHERE JOB_CODE = 'J8';
--> 1 행 이(가) 삭제되었습니다.

SELECT * FROM VW_JOB;
SELECT * FROM JOB;
--> DELETE 또한 원본 테이블에서 삭제됨!!

/*
    * 하지만 뷰를 가지고 DML 이 불가능한 경우가 더 많음!!
      (왜냐? 뷰는 애초에 조회용도로 만들어진 개념이기 때문에)
      
    1) 뷰에 정의되어있지 않은 컬럼을 조작하는 경우
    2) 뷰에 정의되어있지 않은 컬럼 중에 베이스 테이블 상에 NOT NULL 제약조건이 지정된 경우
    3) 산술연산식 또는 함수식을 통해 뷰를 정의한 경우
    4) 그룹함수나 GROUP BY 절이 포함된 경우
    5) DISTINCT 구문이 포함된 경우
    6) JOIN 을 이용해서 여러 테이블을 매칭시켜 놓은 경우
*/

-- 예1)
CREATE OR REPLACE VIEW VW_JOB
AS (
        SELECT JOB_CODE
          FROM JOB
);

SELECT * FROM VW_JOB;

INSERT INTO VW_JOB(JOB_CODE, JOB_NAME) 
            VALUES('J8', '인턴');
--> "JOB_NAME": invalid identifier
--> 아무리 뷰에 DML 을 해도 어차피 원본테이블에 적용되니까
--  그래서 뷰에 INSERT 구문을 적용할 때 뷰에 없던 컬럼을 제시해서 INSERT 하려고 했던 것!!
--> 하지만 그 뷰 자체에 JOB_NAME 컬럼은 존재하지 않아서 오류 발생!!

UPDATE VW_JOB
   SET JOB_NAME = '인턴'
 WHERE JOB_CODE = 'J7';
--> "JOB_NAME": invalid identifier
--> UPDATE 불가

DELETE 
  FROM VW_JOB
 WHERE JOB_NAME = '사원';
--> "JOB_NAME": invalid identifier
--> DELETE 불가

--> 현재 VW_JOB 뷰에 존재하지 않는 JOB_NAME 컬럼에 (물론 원본 테이블에는 존재하는 컬럼이지만)
--  값을 추가, 수정, 삭제하고자 해서 오류 발생!!
--  (아무리 원본 테이블에는 해당 컬럼이 있어도 정작 뷰에는 없으면 X)

-- 예2)
CREATE OR REPLACE VIEW VW_EMP_SAL
AS (
        SELECT EMP_ID, EMP_NAME, SALARY, SALARY * 12 "연봉"
          FROM EMPLOYEE
);

SELECT * FROM VW_EMP_SAL;

INSERT INTO VW_EMP_SAL VALUES(400, '박말순', 3000000, 36000000);
--> virtual column not allowed here
--  이 경우에는 원본테이블인 EMPLOYEE 테이블에 애초에 "연봉" 을 나타내는 컬럼이 존재하지 않아서 불가!!

--> INSERT 뿐만 아니라 UPDATE 와 DELETE 구문 또한 불가능할 것!!

--> 위와 같이 뷰에 DML 문이 처리 안되는 경우가 더 많음!!

ROLLBACK;

--------------------------------------------------------------------------------

/*
    * VIEW 생성 시 사용 가능한 옵션들
    
    [ 최종 상세 표현법 ]
    
    CREATE [OR REPLACE] [FORCE/NOFORCE] VIEW 뷰명
    AS (서브쿼리)
    WITH CHECK OPTION
    WITH READ ONLY;
    
    1) OR REPLACE 
    해당 뷰 이름이 이미 존재 하면 갱신시켜주는 옵션
    해당 뷰 이름이 존재하지 않으면 새로이 생성해줌
    
    2) FORCE/NOFORCE
    - FORCE : 서브쿼리에 기술된 테이블이 실제로 존재하지 않아도 "강제로" 뷰를 생성
    - NOFORCE : 서브쿼리에 기술된 테이블이 반드시 존재해야지만 뷰가 생성 (생략 시 기본값)
    
    3) WITH CHECK OPTION
    서브쿼리의 조건절 (WHERE 절) 에 기술된 내용에 만족되는 값들로만
    뷰에 DML 이 가능하게끔 해주는 옵션
    만약 조건에 부합하지 않는 값으로 DML 구문을 실행하는 순간 오류 발생!!
    
    4) WITH READ ONLY
    뷰에 대해 조회만 가능하게끔 막아주는 옵션
    (DML 수행 불가)
*/

-- 2) FORCE/NOFORCE
CREATE OR REPLACE /* NOFORCE */ VIEW VW_TEST
AS (
        SELECT TCODE, TNAME, TCONTENT
          FROM TT -- table or view does not exist
);
--> table or view does not exist
--  TT 라는 테이블이 존재하지 않아서 뷰 생성 시 오류 발생

CREATE OR REPLACE FORCE VIEW VW_TEST
AS (
        SELECT TCODE, TNAME, TCONTENT
          FROM TT -- table or view does not exist
);
--> 경고: 컴파일 오류와 함께 뷰가 생성되었습니다.
--  실행도 되고 뷰도 생성이 되나 "경고" 가 뜸!!

SELECT * FROM VW_TEST;
--> view "KH.VW_TEST" has errors
--  강제로 만들어진 뷰는 조회 불가 (오류 발생)
--  단, 접속 탭에서는 확인 가능함!!

-- 주로 추후에 해당 테이블이 만들어질 것 같을 때 쓰임!!

CREATE TABLE TT (
    TCODE NUMBER,
    TNAME VARCHAR2(30),
    TCONTENT VARCHAR2(50)
);
--> Table TT이(가) 생성되었습니다.

SELECT * FROM VW_TEST;
--> 해당 원본 테이블이 만들어 지는 순간부터 조회 시 오류 X

-- 3) WITH CHECK OPTION
CREATE OR REPLACE VIEW VW_EMP
AS (
        SELECT *
          FROM EMPLOYEE
         WHERE SALARY >= 3000000
)
WITH CHECK OPTION;

SELECT * FROM VW_EMP;
--> 급여가 300 만원 이상인 사원들만 조회할 수 있는 뷰 생성 (WITH CHECK OPTION)

-- VIEW 에 UPDATE 문 적용
UPDATE VW_EMP
   SET SALARY = 10000
 WHERE EMP_ID = 200;
--> view WITH CHECK OPTION where-clause violation
--  서브쿼리의 WHERE 절에 적혀있는 조건에 맞는 값으로만 DML 가능!!

UPDATE VW_EMP
   SET SALARY = 10000000
 WHERE EMP_ID = 200;
--> 서브쿼리의 WHERE 절에 적혀있는 조건에 맞기 때문에 UPDATE 가 되었음!!

ROLLBACK;

-- 4) WITH READ ONLY
CREATE OR REPLACE VIEW VW_EMP_BONUS
AS (
        SELECT EMP_ID, EMP_NAME, BONUS
          FROM EMPLOYEE
         WHERE BONUS IS NOT NULL
)
WITH READ ONLY;

SELECT * FROM VW_EMP_BONUS;

DELETE
  FROM VW_EMP_BONUS
 WHERE EMP_ID = 200;
--> cannot perform a DML operation on a read-only view
--  READ ONLY VIEW 이기 때문에 DML 연산이 불가!!



















  