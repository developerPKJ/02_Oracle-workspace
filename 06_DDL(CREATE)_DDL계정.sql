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