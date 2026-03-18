/*
    DDL : DATA DEFINITION LANGUAGE
    - 데이터 정의 언어
    - 오라클에서 제공하는 객체(OBJECT)를 세로 만들고(CREATE), 구조를 변경하고(ALTER), 구조 자체를 삭제하는(DROP) 명령문
    - 즉, DB를 이루고 있는 구조물 자체를 정의하는 명령문

    --> DB 관리자, 설계자만 사용
    

    오라클의 객체 OBJECT
    - 오라클 DB를 이루고 있는 구조물

    객체 종류
    - 테이블 TABLE
    - 뷰 VIEW : 조회용 임시 테이블 (EX. INLINE VIEW)
    - 시퀀스 SEQUENCE : 동작의 순서를 정의
    - 인덱스 INDEX : SELECT문 조회 속도 상승용 = 검색 알고리즘 설정용일듯
    - 패키지 PACKAGE
    - 트리거 TRIGGER : 두 개의 쿼리문을 연속으로 실행하고 싶을 때 사용
    - 프로시저 PROCEDURE : 함수에 포함되어 있는 개념
    - 함수 FUNCTION : 우리가 아는 그 함수 PARAMETER 유무 차이로 프로시저, 함수 구분
    - 동의어 SYNONYM : 테이블에 고정되게 설정한 별칭
    - 사용자 USER
*/


/*
    < CREATE TABLE >

    - TABLE : 행과 열로 구성되는 가장 기본적인 DB 객체 (구조물)
    - 모든 데이터는 항상 테이블을 통해 저장
    > 데이터를 보관하려면 테이블을 무조건 생성해야함

    [표현법]
    CREATE TABLE 테이블명 (
        컬럼명 자료형,
        컬럼명 자료형,
        ...
    );

    < ORACEL 자료형 >
    - 문자열 CHARACTER (CHAR(크기) / VARCHAR2(크기))
    > 크기는 BYTE 단위로 지정
        - 숫자, 영문자, 특수문자 : 1BYTE 취급
        - 그 외 문자            : 3BYTE 취급

        - CHAR : 최대 2000 BYTE 지정 가능, 고정 길이 문자열 (고정된 크기를 입력된 값이 해당 크기보다 작으면 공백 문자로 채워서 저장)
        > 들어올 글자 수가 정해져 있을때 유리 : 성별, 전화번호, 주민번호 등
        - VARCHAR2 : 최대 4000 BYTE 지정 가능, 가변 길이 문자열 (적은 값이 들어오면 그 값에 맞춰 저장 공간 크기를 줄임)
        > 들어올 데이터의 크기를 예상할 수 없을 때 사용 : 게시글 제목, ID, PW 등 (VAR는 가변, 2는 2배라는 뜻)
        - CLOB : 최대 128 TB 저장 가능(대용량 문자열 자료형), 대체로 문자열 관련 함수 적용 불가
        > 들어울 데이터의 크기가 매우 클 경우 사용 : 게시글 내용 등


    - 숫자 NUMBER : 정수, 실수 상관없이 모두 보관 가능


    - 날짜 DATE : 년, 월, 일, 시, 분, 초 포함한 자료형
*/

-- 회원들의 데이터를 담을 수 있는 테이블 (ID, PW, NAME, SIGN_UP_DATE) MEMBER TABLE 생성
CREATE TABLE MEMBER (
    MEMBER_ID VARCHAR2(20),
    MEMBER_PW VARCHAR2(20),
    MEMBER_NAME VARCHAR2(20),
    MEMBER_DATE DATE
);
--> TABLE MEMBER CREATED
--> 한 계정 내에 동일한 이름의 테이블명 중복 불가
--> 한 테이블 내에 동일한 이름의 컬럼명 중복 불가
--> 이름을 지을 때 대소문자 구분 안함
--> VARCHAR2 TYPE이여도 크기를 오버해서 입력은 불가하기에 넉넉하게 지정하는게 좋음

-- 테이블 생성 확인
-- > 1. 접속 탭 - 해당 계정 - 테이블 정보 직접 확인
-- > 2. 단순 SELECT 문 사용
SELECT * FROM MEMBER;
-- > 3. 데이터 딕셔너리를 이용해 테이블 정보 확인
    -- 데이터 딕셔너리 : 다양한 객체들의 정보를 저장하고 있는 시스템 테이블(오직 조회 용도)
    -- EX) DB의 모든 계정 정보, DB의 모든 테이블 정보, DB의 모든 컬럼 정보
    -- USER TABLE : 현재 이 계정이 가지고 있는 테이블들의 전반적인 구조를 확인할 수 있는 데이터 딕셔너리
SELECT * FROM USER_TABLES;
    -- USER_TAB_COLUMNS : 현재 이 계정이 가지고 있는 테이블들의 모든 컬럼 정보들을 조회할 수 있는 데이터 딕셔너리
SELECT * FROM USER_TAB_COLUMNS;


-- 컬럼에 COMMENT(주석)을 달려면
COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PW IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원이름';
COMMENT ON COLUMN MEMBER.MEMBER_DATE IS '회원가입일';
-- 권장사항


-- INSERT : 만들어진 테이블에 데이터를 추가하는 구문(순서 주의)
-- INSERT INTO 테이블명 VALUES(컬럼값1, 컬럼값2, 컬럼값3, ...);
INSERT INTO MEMBER VALUES('USER02', 'PASS01', '홍길동', '2021-01-02');
-- 컬럼의 순서를 반드시 맞춰서 넣어야함

SELECT * FROM MEMBER;

INSERT INTO MEMBER VALUES('USER01', 'PASS01', '고길동', '2021-01-02');

INSERT INTO MEMBER VALUES('USER03', 'PASS03', '강호동', SYSDATE);

INSERT INTO MEMBER VALUES(NULL, NULL, NULL, SYSDATE);
-- 보면 ID, PW, NAME에 NULL 값이 허용되어 있음
-- 이건 TABLE 생성시 NULL을 비허용 하지 않았기 때문




/*
    1. NOT NULL 제약조건
    - 컬럼에 NULL을 제한하는 제약조건
*/
CREATE TABLE MEM_NOT_NULL (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL
);

INSERT INTO MEM_NOT_NULL VALUES(1, 'ID01', 'PW01');
INSERT INTO MEM_NOT_NULL VALUES(1, 'ID01', NULL);
/*
    Error report -
    SQL Error: ORA-01400: cannot insert NULL into ("DDL"."MEM_NOT_NULL"."MEM_PWD")
*/

SELECT * FROM MEM_NOT_NULL;
DROP TABLE MEM_NOT_NULL;

/*
    2. UNIQUE 제약조건
    - 컬럼에 중복값을 제한하는 제약조건
    - 데이터 삽입 / 수정 시 기존에
    - 컬럼 레벨 
*/
-- 컬럼 레벨 방식
CREATE TABLE MEM_UNIQUE (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE CHAR(13),
    EMAIL VARCHAR2(30)
);
-- 한 컬럼에 여러 개의 제약조건을 걸 수 있음
-- 컬럼레벨방식의 경우 띄어쓰기(공백)으로 구분해서 나열하면 됨

SELECT * FROM MEM_UNIQUE;

-- 테이블 삭제 (DROP)
DROP TABLE MEM_UNIQUE;


-- 테이블 레벨 방식
-- : 컬럼명들을 모두 나열한 뒤 마지막에 어느 컬럼에 어떤 제약조건을 걸지 나열하는 방식
CREATE TABLE MEM_UNIQUE (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE CHAR(13),
    EMAIL VARCHAR2(30),

    UNIQUE(MEM_ID)
);
-- NOT NULL은 컬럼 레벨 방식만 가능함

SELECT * FROM MEM_UNIQUE;
DROP TABLE MEM_UNIQUE;

-- CONSTRAINTS(제약조건) 탭에서 제약조건 확인가능

INSERT INTO MEM_UNIQUE VALUES(1, 'USER01', 'PASS01', 'JOHN', 'MAN', '010-1234-1234', 'USER@MAIL.COM');
INSERT INTO MEM_UNIQUE VALUES(2, 'USER02', 'PASS02', 'TOM', NULL, NULL, NULL);
INSERT INTO MEM_UNIQUE VALUES(3, 'USER02', 'PASS03', 'HARRY', NULL, NULL, NULL); -- UNIQUE 조건 위배

/*
    Error report -
    ORA-00001: unique constraint (DDL.SYS_C007034) violated
*/
/*
    - UNIQUE 제약조건 위반으로 오류가 발생하지만,
    > NOT NULL 위반과는 다르게 정확하게 오류 위치를 알려주지 않음
    - 제약 조건명을 제시해서 어느 부분에서 오류가 났는지는 알려줌
    > 위의 SYS_C~~~ 가 제약 조건명임

    - 제약조건 부여 시 직접 제약조건명을 지정해서 사용하면
    > 이후 제약조건 위배로 오류 발생 시 어디서 발생했는지 추정가능
*/

/*
    제약조건명 지정 방법(권장)

    -- 컬럼 레벨 방식
    CREATE TABLE 테이블명 (
        컬럼명 자료형 CONSTRAINT 제약조건명 제약조건
    )

    -- 테이블 레벨 방식
    CREATE TABLE 테이블명 (
        컬럼명 자료형,
        ...,
        CONSTRAINT 제약조건명 제약조건(컬럼명)
    )

    -- 두 방식 모두 CONSTRAINT 제약조건명은 생략 가능(DEFAULT)
    -- 테이블명_컬럼명_제약조건약자 와 같은 형태로 제약조건명을 지음

*/

CREATE TABLE MEM_CON_NM (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) CONSTRAINT MEM_PWD_NN NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE CHAR(13),
    EMAIL VARCHAR2(30),

    CONSTRAINT MEM_ID_UNI UNIQUE(MEM_ID)
);

INSERT INTO MEM_CON_NM VALUES(1, 'USER01', 'PASS01', 'HONG', NULL, NULL, NULL);
INSERT INTO MEM_CON_NM VALUES(1, 'USER02', NULL, 'KIM', NULL, NULL, NULL);
INSERT INTO MEM_CON_NM VALUES(1, 'USER01', 'PASS03', 'JUN', NULL, NULL, NULL);

-- 입력값에 단어조차도 제약하고 싶음
/*
    CHERCK 제약조건
    - 컬럼에 기록될 수 있는 값에 대한 조건식을 설정할 수 있음
    > CHECK(조건식);
*/
CREATE TABLE MEM_CHECK (
    NEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    -- GENDER CHAR(3) CHECK(GENDER = '남' OR GENDER = '여'),
    GENDER CHAR(3) CONSTRAINT MEM_CH_IN CHECK(GENDER IN ('남', '여')),
    PHONE CHAR(13),
    EMAIL VARCHAR2(30)
);

SELECT * FROM MEM_CHECK;
DROP TABLE MEM_CHECK;

INSERT INTO MEM_CHECK VALUES(1, 'USER01', 'PASS01', 'KIM', '남', '010-1234-5678', 'TEST@NAVER.COM');
INSERT INTO MEM_CHECK VALUES(1, 'USER02', 'PASS02', 'NAM', '여', '010-1234-5678', 'TEST@NAVER.COM');
INSERT INTO MEM_CHECK VALUES(1, 'USER03', 'PASS03', 'NAM', NULL, '010-1234-5678', 'TEST@NAVER.COM');
-- 남, 여 조건 있지만 NOT NULL은 아니라서 NULL 가능
INSERT INTO MEM_CHECK VALUES(1, 'USER04', 'PASS04', 'JUN', 'MAN', '010-1234-5678', 'TEST@NAVER.COM');
-- CHECK CONSTRAINT 위배 발생


/*
    4. PRIMARY KEY
    - 각 테이블에서 각 행들의 정보를 유일하게 식별 할 수 있는 컬럼에 부여하는 제약조건

    - NOT NULL + UNIQUE 제약조건이 동시에 부여된 것과 동일한 효과

    - ID 컬럼은 이미 NOT NULL + UNIQUE 제약조건이 있으니 ID를 PRIMARY KEY로 설정해도 됨(설계자 마음)
    - PRIMARY KEY의 후보키 : CANDIDATE KEY
    - 문자열은 내부적으로 조회할 때 동등비교 연산 속도가 느림 -> MEM_ID
    - 그래서 숫자형이 더 유리하기에 보통은 PK로 숫자형 컬럼을 설정하는 경우가 많음 -> MEM_NO 컬럼을 PK로 설정 (인위적 식별자)
    - 그냥 MEM_NO 없애고 MEM_ID를 PK로 설정해도 되긴 함(본식별자)

    - PK는 한 테이블에 하나만 설정 가능
*/
CREATE TABLE MEM_PRI (
    NEM_NO NUMBER CONSTRAINT MEM_PRI_PK PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    -- GENDER CHAR(3) CHECK(GENDER = '남' OR GENDER = '여'),
    GENDER CHAR(3) CONSTRAINT MEM_CH_IN CHECK(GENDER IN ('남', '여')),
    PHONE CHAR(13),
    EMAIL VARCHAR2(30)
);

INSERT INTO MEM_PRI VALUES(1, 'USER01', 'PASS01', 'KIM', '남', '010-1234-5678', 'TEST@NAVER.COM');
INSERT INTO MEM_PRI VALUES(NULL, 'USER02', 'PASS02', 'NAM', '여', '010-1234-5678', 'TEST@NAVER.COM');
-- PRIMARY KEY 제약조건 위배 발생(NULL 허용 불가)
INSERT INTO MEM_PRI VALUES(1, 'USER03', 'PASS03', 'NAM', NULL, '010-1234-5678', 'TEST@NAVER.COM');
-- PRIMARY KEY 제약조건 위배 발생(중복 허용 불가)
INSERT INTO MEM_PRI VALUES(2, 'USER04', 'PASS04', 'JUN', '남', '010-1234-5678', 'TEST@NAVER.COM');


SELECT * FROM MEM_PRI;
DROP TABLE MEM_PRI;


/*
    5. FOREIGN KEY 외래키 제약조건

    - 해당 컬럼에 다른 테이블에 존재한느 값이 들어와야 할 경우 그 컬럼에 부여하는 제약조건
    - 다른 테이블(부모)을 참조한다 라고 표현
    - 참조된 다른 테이블이 제공하고 있는 컬럼 값만 입력 가능
    - FOREIGN KEY 제약조건으로 다른 테이블 간의 관계를 형성할 수 있음 (JOIN)

    - 컬럼 레벨 방식
    CREATE TABLE 테이블명 (
        컬럼명 자료형 (CONSTRAINT 제약조건명) REFERENCES 참조테이블(참조컬럼)
    )

    - 테이블 레벨 방식
    CREATE TABLE 테이블명 (
        컬럼명 자료형,
        ...,
        (CONSTRAINT 제약조건명) FOREIGN KEY(컬럼명) REFERENCES 참조테이블(참조컬럼)
    )

    - 참조 컬럼도 생략할 수 있는데, 이 경우 참조 테이블의 PK 컬럼을 참조하게 됨
*/
-- 부모테이블이 먼저 생성되어 있어야함!
-- 회원 등급에 대한 데이터(등급코드, 등급명)을 보관하는 MEM_GRADE 테이블
CREATE TABLE MEM_GRADE (
    GRADE_CODE CHAR(2) PRIMARY KEY,
    GRADE_NAME VARCHAR2(20) NOT NULL
);

INSERT INTO MEM_GRADE VALUES('G1', '일반');
INSERT INTO MEM_GRADE VALUES('G2', '우수');
INSERT INTO MEM_GRADE VALUES('G3', 'VIP');

SELECT * FROM MEM_GRADE;
DROP TABLE MEM_GRADE;

-- 자식테이블
-- 기존 회원 정보에 등급 정보까지 포함한 MEM테이블
CREATE TABLE MEM (
    NEM_NO NUMBER CONSTRAINT MEM_PRI_PK PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CONSTRAINT MEM_CHECK_IN CHECK(GENDER IN ('남', '여')),
    PHONE CHAR(13),
    EMAIL VARCHAR2(30),
    GRADE_CODE CHAR(2) CONSTRAINT MEM_GRADE_FK REFERENCES MEM_GRADE(GRADE_CODE)
);

SELECT * FROM MEM;
DROP TABLE MEM;

INSERT INTO MEM VALUES(1, 'USER01', 'PASS01', 'KIM', '남', '010-1234-5678', 'TEST@NAVER.COM', 'G1');
INSERT INTO MEM VALUES(2, 'USER02', 'PASS02', 'NAM', '여', '010-1234-5678', 'TEST@NAVER.COM', 'G2');
INSERT INTO MEM VALUES(3, 'USER03', 'PASS03', 'JUN', '남', '010-1234-5678', 'TEST@NAVER.COM', 'G3');

INSERT INTO MEM VALUES(4, 'USER04', 'PASS04', 'LEE', '남', '010-1234-5678', 'TEST@NAVER.COM', 'G0');
-- ORA-02291: integrity constraint (DDL.MEM_GRADE_FK) violated - parent key not found
-- FOREIGN KEY 제약조건 위배 발생(참조 테이블에 존재하지 않는 값 입력 불가)

INSERT INTO MEM VALUES(5, 'USER05', 'PASS05', 'PARK', '여', '010-1234-5678', 'TEST@NAVER.COM', NULL);
-- FOREIGN KEY 제약조건은 기본적으로 NULL 허용됨

-- ORACLE 전용 구문
SELECT M.NEM_NO, M.MEM_ID, M.MEM_NAME, MG.GRADE_NAME
FROM MEM M, MEM_GRADE MG
WHERE M.GRADE_CODE = MG.GRADE_CODE(+);

-- ANSI 표준 구문
SELECT M.NEM_NO, M.MEM_ID, M.MEM_NAME, MG.GRADE_NAME
FROM MEM M
LEFT JOIN MEM_GRADE MG
ON M.GRADE_CODE = MG.GRADE_CODE;


SELECT * FROM MEM_GRADE;    -- G1, G2, G3
SELECT * FROM MEM;          -- G1, G2, G3, NULL

-- 그럼 MEB_GRADE 테이블에서 G1, G2, G3 데이터 삭제해보자
/*
    데이터 삭제 구문 DELETE
    DELETE FROM 테이블명 WHERE 조건식;
*/
DELETE
FROM MEM_GRADE
WHERE GRADE_CODE = 'G1';
-- ORA-02292: integrity constraint (DDL.MEM_GRADE_FK) violated - child record found
-- FOREIGN KEY 제약조건 위배 발생(참조된 데이터는 삭제 불가)

-- MEM_GRADE 테이블에 G4 데이터 추가
INSERT INTO MEM_GRADE VALUES('G4', '테스트');

DELETE
FROM MEM_GRADE
WHERE GRADE_CODE = 'G4';
-- G4 데이터는 참조된 데이터가 없으니 삭제 가능

-- 그렇다면 참조 중인 데이터를 삭제하려면 어떻게 해야할까?
-- 자식 테이블 생성 시 FOREIGN KEY 제약조건에 참조된 데이터를 삭제할 때 참조 중인 데이터를 어떻게 처리할 건지 옵션으로 지정가능
/*
    삭제옵션
    1. ON DELETE SET NULL : 참조된 데이터 삭제 시 참조 중인 데이터의 값을 NULL로 변경
    2. ON DELETE CASCADE : 참조된 데이터 삭제 시 참조 중인 데이터도 함께 삭제
    3. ON DELETE RESTRICTED(DEFAULT) : 참조된 데이터 삭제 시 참조 중인 데이터가 존재하면 삭제 불가
*/
CREATE TABLE MEM (
    NEM_NO NUMBER CONSTRAINT MEM_PRI_PK PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    MEM_GRADE CHAR(2),
    GENDER CHAR(3) CONSTRAINT MEM_CHECK_IN CHECK(GENDER IN ('남', '여')),
    PHONE CHAR(13),
    EMAIL VARCHAR2(30),

    UNIQUE(MEM_ID), CONSTRAINT MEM_GRADE_FK FOREIGN KEY(MEM_GRADE) REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE SET NULL
    -- 테이블 레벨 방식으로도 여러개 가능
);

SELECT * FROM MEM;
DROP TABLE MEM;

INSERT INTO MEM VALUES(1
                     , 'user01'
                     , 'pass01'
                     , '홍길동'
                     , 'G1'
                     , '남'
                     , '010-1234-1234'
                     , NULL);

INSERT INTO MEM VALUES(2
                     , 'user02'
                     , 'pass02'
                     , '김갑생'
                     , 'G2'
                     , NULL
                     , NULL
                     , 'user02@naver.com');

INSERT INTO MEM VALUES(3
                      , 'user03'
                      , 'pass03'
                      , '박말순'
                      , 'G1'
                      , '여'
                      , NULL
                      , NULL);

INSERT INTO MEM VALUES(4
                     , 'user04'
                     , 'pass04'
                     , '이순신'
                     , NULL
                     , NULL
                     , NULL
                     , NULL);

SELECT * FROM MEM;

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 'G1';
-- ON DELETE SET NULL 옵션이 설정되어 있으니 참조된 데이터 삭제 시 참조 중인 데이터의 값을 NULL로 변경
-- ON DELETE CASCADE 옵션이 설정되어 있으니 참조된 데이터 삭제 시 참조 중인 데이터도 함께 삭제

SELECT * FROM MEM_GRADE;
SELECT * FROM MEM;

DROP TABLE MEM;
DROP TABLE MEM_GRADE;

ROLLBACK; -- COMMIT 이전 상태로 되돌리는 구문

-- ON DELETE CASCADE 옵션은 잘 사용하지도 않고, 권장되지도 않음


/*
    참고)
    - 외래키 제약조건이 걸린 컬럼은 부모테이블과 JOIN 시 연결고리 역할을 함
    - 하지만 굳이 외래키 제약조건이 걸려있지 않더라도 JOIN 가능
    > 단 두 컬럼에 동일한 의미(비슷한 데이터)를 가지고 있어야 함

    EX. EMPLOYEE 테이블의 DEPT_CODE, JOB_CODE는 각각 DEPARTMENT 테이블의 DEPT_ID, JOB 테이블의 JOB_CODE와 JOIN이 가능하지만
    그렇다고 외래키 제약조건이 걸려있는 것은 아님
*/


-------------------------------------------------------------------------------------
-- KH 계정으로 실행 --

-- SUBQUERY를 이용한 테이블 생성(CTAS : CREATE TABLE AS SUBQUERY)
CREATE TABLE NEW_EMPLOYEE
AS (
    SELECT *
    FROM EMPLOYEE
);

SELECT * FROM NEW_EMPLOYEE;
DROP TABLE NEW_EMPLOYEE;

CREATE TABLE NEW_EMPLOYEE
AS (
    SELECT *
    FROM EMPLOYEE
    WHERE 1 = 0
);
-- WHERE 1 = 0 조건식은 항상 거짓이기에 DATA 없이 EMPLOYEE 테이블의 구조만 복사해서 NEW_EMPLOYEE 테이블 생성

-- CTAS를 사용해도 일부 제약조건은 복사되지 않음
-- CTAS를 사용해도 COMMENT는 복사되지 않음
SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'NEW_EMPLOYEE';

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'EMPLOYEE';

-- 전체 사원들 중 급여가 300 이상인 사원들의
-- 사번, 이름, 부서코드, 급여 컬럼만 복제
CREATE TABLE HIGH_SALARY_EMPLOYEE
AS (
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
    FROM EMPLOYEE
    WHERE SALARY >= 3000000
);

SELECT * FROM HIGH_SALARY_EMPLOYEE;
DROP TABLE HIGH_SALARY_EMPLOYEE;

-- 전체 사원의 사번, 사원명, 급여, 연봉 조회 결과를 테이블로
CREATE TABLE NEW_EMPLOYEE
AS (
    SELECT EMP_ID, EMP_NAME, SALARY, SALARY * 12 AS ANNUAL_SALARY
    FROM EMPLOYEE
);
-- 주의 : INLINE VIEW와 달리 CTAS에서는 컬럼명이 없으면 연산식, 함수식 사용 불가

/*
    테이블이 다 생성된 후 뒤늦게 제약조건을 추가하고 싶으면

    ALTER TABLE 테이블명
    ADD (CONSTRAINT 제약조건명) 제약조건(컬럼명);
*/
DROP TABLE NEW_EMPLOYEE;

ALTER TABLE NEW_EMPLOYEE
ADD CONSTRAINT NE_NO_PRI PRIMARY KEY(EMP_ID);

ALTER TABLE NEW_EMPLOYEE ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT(DEPT_ID);

ALTER TABLE NEW_EMPLOYEE ADD FOREIGN KEY(JOB_CODE) REFERENCES JOB(JOB_CODE);

ALTER TABLE DEPARTMENT ADD FOREIGN KEY(LOCATION_ID) REFERENCES LOCATION(LOCAL_CODE);

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'EMPLOYEE';

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'NEW_EMPLOYEE';