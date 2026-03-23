/*
    < SEQUENCE >

    - 자동으로 번호를 발생시켜주는 역할을 하는 객체
    - 정수값을 순차적으로 생성해줌

    - PRIMARY KEY로 사용할 때 유용

    1. 객체 생성
    CREATE SEQUENCE 시퀀스명
    START WITH 시작값
    INCREMENT BY 증가값
    MAXVALUE 최대값
    MINVALUE 최소값
    CYCLE / NOCYCLE             --> 최대값에 도달했을 때 다시 시작값으로 돌아갈지 여부(순환 여부)
    CACHE 바이트크기 / NOCACHE   --> 캐시메모리 사용 여부 지정(CACHE_SIZE 기본값은 20 BYTE)

    - 위 옵션들은 생략 가능

    캐시메모리
    - 미리 앞으로 발생될 정수값을 생성해서 저장해두는 공간
    - 매번 호출할 때 마다 새로이 번호를 생성해서 주는 것보다, 캐시메모리 공간에 생성된 번호를 저장해두고 필요시 꺼내면 빠름
    - 해당 계정에 접속이 끊기면 캐시메모리에 저장된 번호는 사라짐
*/

/*
    오라클 접투사 - 명명규칙
    - 테이블 명 : TB_XXX
    - 뷰 명 : VW_XXX
    - 시퀀스 명 : SEQ_XXX
*/

DROP SEQUENCE SEQ_TEST;
CREATE SEQUENCE SEQ_TEST;

/*
    시퀀스가 제대로 만들어졌는지 확인
    - 1. 접속 탭에서 직접 확인
    - 2. USER_SEQUENCES 데이터 딕셔너리 통해서 확인 가능
    - USER_SEQUENCES : 현재 접속 중인 시퀀스 객체에 대한 정보를 담고 있는 데이터 딕셔너리
*/
SELECT * FROM USER_SEQUENCES;

-- 옵션을 생략한 경우 START WITH 1, MINVALUE 1, INCREMENT BY 1, MAXVALUE 9999999...,
-- NOCYCLE, CACHE 20이 기본값으로 설정됨


-- 한 계정 내에서 동일한 이름의 시퀀스는 생성 불가
CREATE SEQUENCE SEQ_EMPNO
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;


/*
    2. 시퀀스 사용 방법
    - 시퀀스명.CURRVAL : 현재 시퀀스의 값(CURRENT VALUE)
    - 시퀀스명.NEXTVAL : 다음 시퀀스의 값(NEXT VALUE)
        - NEXTVAL이 성공적으로 호출되면 CURRVAL도 자동으로 증가된 값으로 변경됨
*/

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL;
-- ORA-08002: sequence SEQ_EMPNO.CURRVAL is not yet defined in this session
-- NEXTVAL이 호출되기 전에는 CURRVAL이 정의되지 않음

SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL;  -- 300
-- DUAL : 오라클에서 제공하는 가상의 테이블
-- DUAL 테이블은 단 하나의 행과 하나의 열을 가지고 있으며
-- 주로 연산 결과를 반환하거나 시퀀스의 NEXTVAL과 CURRVAL을 조회할 때 사용됨

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL;  -- 300

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL;  -- 300

-- NEXTVAL이 호출될 때마다 CURRVAL도 함께 증가됨
-- 즉 NEXTVAL이 호출되지 않으면 CURRVAL은 계속해서 동일한 값을 유지함
SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL;  -- 305

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL;  -- 305

SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL;  -- 310

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL;  -- 310

SELECT *
FROM USER_SEQUENCES;

SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL;
-- ORA-08004: sequence SEQ_EMPNO.NEXTVAL exceeds MAXVALUE and cannot be instantiated
-- MAXVALUE에 도달했기 때문에 더 이상 시퀀스 번호를 생성할 수 없음

/*
    3. 시퀀스 변경

    - 시퀀스의 옵션을 변경할 때는 ALTER SEQUENCE 명령어 사용
    ALTER SEQUENCE 시퀀스명
    START WITH 시작값
    INCREMENT BY 증가값
    MAXVALUE 최대값
    MINVALUE 최소값
    CYCLE / NOCYCLE
    CACHE 바이트크기 / NOCACHE
    - 변경하고자 하는 옵션만 명시하면 되고, 생략된 옵션은 기본값으로 변경됨
    - START WITH는 변경 불가
    - 바꾸려면 DROP 후 재 생성
*/
ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 400;

SELECT * FROM USER_SEQUENCES;

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL;  -- 310

SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL;  -- 320
-- LAST_NUMBER 컬럼은 시퀀스의 다음 번호를 나타냄

-- 주의할 점
-- 시퀀스명.NEXTVAL은 되돌릴 수 없음

/*
    4. 시퀀스 삭제

    - DROP SEQUENCE 시퀀스명
*/
DROP SEQUENCE SEQ_EMPNO;

-- 당연히 삭제된 시퀀스는 사용할 수 없음
-- SEQUENCE DOES NOT EXIST 오류 발생

DROP SEQUENCE SEQ_TEST;
----------------------------------------------------------------------
-- 시퀀스가 사용되는 예시 --

-- 사원이 매번 추가될 때 마다 사번을 새롭게 발생시키는 시퀀스 생성

CREATE SEQUENCE SEQ_EID
START WITH 300
INCREMENT BY 1;

SELECT * FROM EMPLOYEE
ORDER BY EMP_ID;

-- EMPLOYEE 테이블에서 INSERT 구문 규칙
INSERT INTO EMPLOYEE VALUES (SEQ_EID.NEXTVAL,
                            ?,
                            ?,
                            ?,
                            ?,
                            ?,
                            ?,
                            ?,
                            ?,
                            ?,
                            ?,
                            SYSDATE,
                            NULL,
                            DEFAULT);
--> 실제 누군가가 입사하면 그 정보에 맞게 ? 부분만 채워서 실행시키면 됨
--> JAVA에서 SCANNER로 받고 ?를 채워서 실행시키면 됨 - JDBC가 담당

DELETE FROM EMPLOYEE
WHERE EMP_ID >= 300;