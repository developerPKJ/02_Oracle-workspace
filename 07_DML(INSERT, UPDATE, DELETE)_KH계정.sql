/*
    < DML : Data Manipulation Language >
    - 데이터 조작 언어
    - 테이블에 새로운 데이터 삽입, 수정, 삭제하는 명령어
    - SELECT 문은 DQL(Data Query Language)로 분류하지만, 데이터 조작 언어의 일부로 대체로 간주함
*/

/*
    < INSERT >

    1. INSERT INTO 테이블명 VALUES (값1, 값2, ...);
    - 테이블의 모든 컬럼에 값을 삽입할 때 사용
    - 컬럼의 순서와 값의 순서 및 수량이 일치해야 함
*/
-- EMPLOYEE 테이블에 사원 정보 추가
INSERT INTO EMPLOYEE VALUES (223, '홍석준', '011221-1234567',
                            'hsj@company.com', '01012345678',
                            'D3', 'J4', 'S1', 6500000, NULL,
                            NULL, SYSDATE, NULL, DEFAULT);

SELECT * FROM EMPLOYEE;

INSERT INTO EMPLOYEE VALUES (224, '김민수', '020101-2345678',
                            'kms@company.com', '01023456789',
                            'D4', 'J5', 'S2', 7000000, 0.1,
                            200, SYSDATE, NULL, DEFAULT);

SELECT * FROM EMPLOYEE;

SELECT *
FROM EMPLOYEE
WHERE EMP_ID IN (223, 224);

DELETE FROM EMPLOYEE
WHERE EMP_ID IN (223, 224);
-- 주의사항

/*
    2. INSERT INTO 테이블명 (컬럼1, 컬럼2, ...) VALUES (값1, 값2, ...);
    - 특정 컬럼에만 값을 삽입할 때 사용
    - 지정하지 않은 컬럼은 기본값 또는 NULL로 삽입됨
*/

/*
    3. INSERT INTO 테이블명(컬럼명들) (서브쿼리);
    - 다른 테이블에서 데이터를 조회하여 삽입할 때 사용 
*/



--------------------------------------------------------------------

/*
    정리
     - INSERT 문은 방식에 따라 한번에 1행씩 혹은 여러 행씩 INSERT 가능
     - UPDATE, DELETE 문은 WHERE 절을 사용하는 방식에 따라 처리되는 행의 수가 달라짐

     - SELECT 문의 실행 결과 : RESULT SET
     - INSERT, UPDATE, DELETE 문의 실행 결과 : 추가, 수정, 삭제 된 행의 수가 정수로 나옴

     - DELETE 문도 WHERE 절에서 SUBQUERY 사용 가능
*/

/*
    TRUNCATE
    - 테이블의 모든 데이터를 삭제하는 명령어
    - DELETE 문과 달리 WHERE 절을 사용할 수 없음
    - DELETE 문보다 빠르게 데이터를 삭제하지만, 삭제된 데이터를 복구할 수 없음

    > TRUNCATE TABLE 테이블명;              |           DELETE FROM 테이블명;
    -------------------------------------------------------------------------
    모든 행 삭제 : O(1)                     | O(n) - 상대적 느림
    수행 속도 빠름                          |  수행 속도 느림
    롤백 불가능                             | 롤백 가능
*/
CREATE TABLE EMP_SALARY (
    EMP_ID NUMBER(5) PRIMARY KEY,
    SALARY NUMBER(10)
);

SELECT * FROM EMP_SALARY;

DELETE FROM EMP_SALARY;

TRUNCATE TABLE EMP_SALARY;

DROP TABLE EMP_SALARY;

ROLLBACK;

-- ROLLBACK : 트랜잭션을 취소하고 이전 상태로 되돌리는 명령어
-- COMMIT : 트랜잭션을 확정하여 변경 사항을 데이터베이스에 영구적으로 저장하는 명령어
-- 트랜잭션이 결정되는 순간 : COMMIT, ROLLBACK, DDL 실행 시 자동 COMMIT