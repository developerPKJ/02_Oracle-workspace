/*
    < DCL - DATA CONTROL LANGUAGE >
    
    - 데이터 제어 언어
    - 계정에게 시스템권한 또는 객체접근권한을 부여 (GRANT) 하거나 회수 (REVOKE) 하는 언어
    - 데이터 변경 내용을 픽스해주는 COMMIT, 데이터 변경 내용을 복구해주는 ROLLBACK 또한 DCL 로 분류됨
      하지만 COMMIT, ROLLBACK 은 TCL (TRANSACTION CONTROL LANGUAGE) 로 분류하기도 함!!
      
    * 권한 부여 (GRANT)
    
    - 시스템권한 : 특정 DB 에 접근하는 권한, 객체들을 생성할 수 있는 권한
    - 객체접근권한 : 특정 객체들에 접근해서 "조작" 할 수 있는 권한
    
    [ 표현법 ]
    
    GRANT 권한명1, 권한명2, .. TO 계정명;
    
    - 시스템권한의 종류
    
    CREATE SESSION : 계정에 접속할 수 있는 권한
    CREATE TABLE : 테이블을 생성할 수 있는 권한
    CREATE VIEW : 뷰를 생성할 수 있는 권한
    CREATE SEQUENCE : 시퀀스를 생성할 수 있는 권한
    CREATE USER : 계정을 생성할 수 있는 권한
    ...
*/

-- 1. SAMPLE 일반 계정 생성
CREATE USER SAMPLE IDENTIFIED BY SAMPLE;
--> User SAMPLE이(가) 생성되었습니다.

--> 계정을 생성하고 접속할 수 있는 권한인 CREATE SESSION 권한을 부여하지 않았더니
--  접속 시 lacs CREATE SESSION privileges : logon denied 오류 발생!!

-- 2. SAMPLE 계정에 접속하기 위한 CREATE SESSION 권한 부여
GRANT CREATE SESSION TO SAMPLE;
--> Grant을(를) 성공했습니다.

-- 3_1. SAMPLE 계정에 테이블을 생성할 수 있는 CREATE TABLE 권한 부여
GRANT CREATE TABLE TO SAMPLE;
--> Grant을(를) 성공했습니다.

-- 3_2. SAMPLE 계정에 TABLE SPACE 공간 할당해주기
-- (ALTER 구문을 통해 SAMPLE 계정을 변경)
ALTER USER SAMPLE QUOTA 2M ON SYSTEM;
--> QUOTA : 할당하다 (나눠주다)
--> 2M : 2 MEGA BYTE
--> User SAMPLE이(가) 변경되었습니다.

-- 4. SAMPLE 계정에 뷰를 생성할 수 있는 CREATE VIEW 권한 부여
GRANT CREATE VIEW TO SAMPLE;
--> Grant을(를) 성공했습니다.

--------------------------------------------------------------------------------

/*
    * 객체접근권한 (객체권한)
    
    - 특정 객체들을 조작할 수 있는 권한
      (즉, DML 구문들을 실행할 수 있는 권한)
    - SELECT, INSERT, UPDATE, DELETE 가 가능해짐
    
    [ 표현법 ]
    
    GRANT 권한종류 ON 특정객체종류명 TO 계정명;
    
    권한종류        |   특정객체종류
    ---------------------------------------------------------
    SELECT         |   TABLE, VIEW, SEQUENCE
    INSERT         |   TABLE, VIEW
    UPDATE         |   TABLE, VIEW
    DELETE         |   TABLE, VIEW
    
    예)
    특정 XXX 라는 테이블에 SELECT 할 수 있는 권한만 부여하고 싶음!!
    GRANT SELECT ON XXX TO 계정명;
*/

-- SAMPLE 계정에 객체접근권한을 아직 부여하지 않은 상태임!!

-- 5. SAMPLE 계정에 KH.EMPLOYEE 테이블을 조회할 수 있는 권한 부여
GRANT SELECT ON KH.EMPLOYEE TO SAMPLE;
--> Grant을(를) 성공했습니다.

-- 6. SAMPLE 계정에 KH.DEPARTMENT 테이블을 조회할 수 있는 권한 부여
GRANT SELECT ON KH.DEPARTMENT TO SAMPLE;
--> Grant을(를) 성공했습니다.

-- 7. SAMPLE 계정에 KH.DEPARTMETN 테이블에 행을 삽입할 수 있는 권한 부여
GRANT INSERT ON KH.DEPARTMENT TO SAMPLE;
--> Grant을(를) 성공했습니다.

--------------------------------------------------------------------------------

-- 우리는 그동안 최소한의 권한을 부여할 때 CONNECT, RESOURCE 를 부여했었음!!
-- GRANT CONNECT, RESOURCE TO 계정명;

/*
    < 롤 ROLE >
    
    - "특정 비슷한 권한들" 을 하나의 "집합" 으로 묶어놓은 것
    
    CONNECT : CREATE SESSION
             (데이터베이스 계정에 접속할 수 있는 권한이 묶여있는 집합)
    RESOURCE : CREATE TABLE, CREATE SEQUENCE, ...
               (최소한의 작업 권한들이 묶여있는 집합,
                즉, 특정 객체들을 생성 및 관리할 수 있는 권한들의 집합)
               단, VIEW 를 생성하는 CREATE VIEW 권한은 빠져있음!!
*/

-- 데이터 딕셔너리 (ROLE_SYS_PRIVS) 를 통해 오라클에 어떤 롤이 있고,
-- 어떤 롤에 어떤 권한들이 집합으로 묶여있는지 확인 가능!!
SELECT *
  FROM ROLE_SYS_PRIVS
 WHERE ROLE IN ('CONNECT', 'RESOURCE');

--> 앞으로는 작업 시 늘 하던대로 CONNECT, RESOURCE 만 주고 들어갈 것!!

--------------------------------------------------------------------------------

/*
    * 권한 회수 (REVOKE)
    
    - 권한을 회수할 때 (뺏을 때) 사용하는 명령
    
    [ 표현법 ]
    
    REVOKE 권한명1, 권한명2, .. FROM 계정명;
*/

-- 8. SAMPLE 계정에서 테이블을 생성할 수 있는 CREATE TABLE 권한을 회수해보기
REVOKE CREATE TABLE FROM SAMPLE;
--> Revoke을(를) 성공했습니다.


