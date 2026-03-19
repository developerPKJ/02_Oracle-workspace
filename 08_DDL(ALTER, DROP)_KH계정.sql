/*
    <DDL - DATEA DEFINITION LANGUAGE>
    - ORACLE DB를 이루는 OBJCET를 새로이 생성하거나 수정, 삭제하는 구문들

    주의)
    UPDATE : 데이터 내용 수정
    DELETE : 데이터 내용 삭제

    ALTER : 테이블 구조 수정
    DROP : 테이블 구조 삭제
*/

/*
    < ALTER >
    - 객체 구조를 수정하는 구문

    > 테이블 수정
    - ALTER TABLE 테이블명 (수정할 내용);

    - 수정할 내용 부분
    1. 컬럼 추가 / 수정 / 삭제
    2. 제약조건 추가 / 삭제 - 제약조건은 수정이 안됨 삭제 후 다시 추가해야 함
    3. 테이블명 / 컬럼명 / 제약조건명 수정
*/

CREATE TABLE DEPT_COPY AS
SELECT * FROM DEPARTMENT;

-- 1. 컬럼 추가 / 수정 / 삭제
-- 1.1 컬럼 추가

SELECT * FROM DEPT_COPY;

-- CNAME 컬럼 추가
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20);

-- LNAME 컬럼 추가 (DEFAULT 값 설정)
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT '한국';

-- 1.2 컬럼 수정
-- 자료형 수정 : MODIFY 수정할컬럼명 바꿀자료형
-- DEFAULT 값 수정 : MODIFY 수정할컬럼명 DEFAULT 바꿀값

-- DEPT_COPY 테이블의 DEPT_ID 컬럼의 데이터 타입을 CHAR(3)로 변경
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);
-- 자료형 변경 시 주의사항
-- 1) 기존 데이터가 새로운 자료형으로 변환될 수 있어야 함
    -- 변환 뿐 아니라 데이터의 크기도 고려해야 함
-- 2) 자료형 변경이 불가능한 경우 오류 발생

SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER(2);
-- column to be modified must be empty to change datatype,
-- 자료형이 다른경우

ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(10) DEFAULT '부서명';
-- cannot decrease column length because some value is too big
-- 이미 담겨져 있는 값들 보다 작게 크기를 설정할 경우

ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(40)
                      MODIFY LOCATION_ID VARCHAR2(2);
-- 이렇게 여러개를 한 번에 수정할 수도 있음


-- 기본값 수정
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT '미국';
-- DEFAULT는 제약조건이 아니기에 수정 가능
-- 그리고 이미 존재하는 데이터에는 영향을 주지 않음
-- 즉, 기존에 DEFAULT로 저장한 값들이 DEFAULT를 수정한다고 해서 바뀌지는 않음

DROP TABLE DEPT_COPY2;

CREATE TABLE DEPT_COPY2
AS (
    SELECT * FROM DEPT_COPY
)

SELECT * FROM DEPT_COPY2;

ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID;

SELECT * FROM DEPT_COPY2;

ROLLBACK;
-- DDL 구문으로 실행해서 이미 COMMIT이 된 상태이므로 ROLLBACK이 안됨

ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_TITLE;

ALTER TABLE DEPT_COPY2 DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY2 DROP COLUMN CNAME;
-- 그럼 묶어서 삭제는 안되나?
/*
ALTER TABLE DEPT_COPY2 DROP COLUMN LOCATION_ID,
                       DROP COLUMN CNAME;
*/
-- ,로 연결이 안된다는 것을 알 수있음
-- DROP COLUMN은 한 번에 하나씩만 삭제 가능

SELECT * FROM DEPT_COPY2;

ALTER TABLE DEPT_COPY2 DROP COLUMN LNAME;
-- "cannot drop all columns in a table"
-- 테이블의 모든 컬럼을 삭제할 수는 없음
-- 마지막 컬럼 삭제만 오류발생
-- > 테이블에 최소 한개의 컬럼은 남아있어야함
-- > 따라서 방지 목적으로 ,로 연결은 못하게 막아둠


----------------------------------------------------------------------

-- 2. 제약조건 추가 / 삭제

-- 2.1 제약조건 추가 ADD
-- PRIMARY KEY 제약조건 추가 : ADD PRIMARY KEY (컬럼명)

-- FOREIGN KEY 제약조건 추가 : ADD FOREIGN KEY (컬럼명) REFERENCES 참조테이블(참조컬럼)

-- UNIQUE 제약조건 추가 : ADD UNIQUE (컬럼명)

-- CHECK 제약조건 추가 : ADD CHECK (조건식)

-- NOT NULL 제약조건 추가 : MODIFY 컬럼명 NOT NULL

-- 제약조건명도 추가하고 싶으면 ADD 뒤에 CONSTRAINT 제약조건명 을 붙여주면 됨
-- 제약조건명을 추가할 때, 한 계정 내에서 중복되지 않도록 주의해야 함

-- 제약조건 추가 시 주의사항
-- 1) 기존 데이터가 제약조건을 만족해야 함
-- 2) 제약조건명은 계정 내에서 유일해야 함
-- 3) 제약조건끼리 충돌이 나지 않아야 함
-- 예시) PRIMARY KEY 제약조건과 UNIQUE 제약조건이 같은 컬럼에 동시에 존재할 수 없음
--      PRIMARY KEY 가 2개가 되는 것도 안됨

DROP TABLE DEPT_COPY2;
-- DEPT_COPY 테이블에서 응용
ALTER TABLE DEPT_COPY ADD CONSTRAINT PK_DEPT_COPY PRIMARY KEY (DEPT_ID);

ALTER TABLE DEPT_COPY ADD CONSTRAINT UQ_DEPT_COPY UNIQUE (DEPT_TITLE);

ALTER TABLE DEPT_COPY MODIFY LNAME CONSTRAINT NN_DEPT_COPY NOT NULL;


ALTER TABLE DEPT_COPY MODIFY CNAME NOT NULL;
-- cannot enable (KH.) - null values found
-- 이미 존재하는 데이터 중에 NULL이 있는 경우 NOT NULL 제약조건을 추가할 수 없음

ALTER TABLE DEPT_COPY ADD UNIQUE(LOCATION_ID);
-- cannot validate (KH.SYS_C007147) - duplicate keys found
-- 이미 존재하는 데이터 중에 중복된 값이 있는 경우 UNIQUE 제약조건을 추가할 수 없음


-- 2.2 제약조건 삭제 : DROP CONSTRAINT 제약조건명
ALTER TABLE DEPT_COPY DROP CONSTRAINT PK_DEPT_COPY;
ALTER TABLE DEPT_COPY DROP CONSTRAINT UQ_DEPT_COPY
                      MODIFY LNAME NULL;
-- 제약조건 삭제는 묶어서 처리 가능

-- NOT NULL 제약조건 삭제 시에도 제약조건명으로 삭제 가능
ALTER TABLE DEPT_COPY DROP CONSTRAINT SYS_C007138;



-- 3. 컬럼명 / 제약조건명 / 테이블명 수정 : RENAME
-- 3.1 컬럼명 수정
-- RENAME COLUMN 기존컬럼명 TO 새컬럼명
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

-- 주의 사항
ALTER TABLE DEPT_COPY RENAME COLUMN LNAME TO CNAME;
-- 한 테이블에 중복된 컬럼명 불가

-- 3.2 제약조건명 수정
-- RENAME CONSTRAINT 기존제약조건명 TO 새제약조건명
ALTER TABLE DEPT_COPY RENAME CONSTRAINT SYS_C007139 TO DEPT_COPY_LOCATION_ID_NN;

-- 3.3 테이블명 수정
-- RENAME TO 새테이블명 ( 앞에 이미 테이블 명이 나와 있어서 기존명이 필요 없음)
ALTER TABLE DEPT_COPY RENAME TO DEPT_COPY_RENAME;

SELECT * FROM DEPT_COPY;
SELECT * FROM DEPT_COPY_RENAME;

-- 주의 사항
-- > 한 계정 내에서 중복된 테이블명 불가

---------------------------------------------------------------------


/* 
    < DROP >

    - 객체를 삭제하는 구문

    - 테이블 삭제
    - DROP TABLE 테이블명;

    - 계정 삭제
    - DROP USER 계정명;

    ...
*/

-- DEPT_COPY_RENAME 테이블 삭제
DROP TABLE DEPT_COPY_RENAME;

SELECT * FROM DEPT_COPY_RENAME;
-- ORA-00942: table or view does not exist

ROLLBACK;

SELECT * FROM DEPT_COPY_RENAME;
-- DDL 구문이라 이미 COMMIT이 된 상태이므로 ROLLBACK이 안됨

-- 테이블 삭제 시 주의사항
-- 1) 테이블이 참조되고 있는 경우, 참조하는 객체를 먼저 삭제하거나 참조 관계를 제거해야 함(FOREIGN KEY)
-- > 어딘가에서 참조되고 있는 부모테이블은 삭제되지 않음(외래키 문제)

-- 1) 자식 테이블을 먼저 삭제한 수 부모테이블 삭제
/*
    참고)
    항상 CREATE 시에는 부모 테이블을 먼저 생성해야함
    항상 DROP 시에는 자식 테이블을 먼저 삭제해야함
*/
-- 2) 부모 테이블만 삭제하되, 맞물려 있는 제약조건을 같이 삭제하는 방법
-- > DROP TABLE 부모테이블명 CASCADE CONSTRAINT;

-- ALTER, DROP은 최대한 안쓰는 것이 좋음
-- 즉, 설계 단계서 부터 신중하게 테이블 구조를 설계하는 것이 중요