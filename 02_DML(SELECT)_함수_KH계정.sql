/*
    < 함수 FUNCTION >
    
    - 하나의 기능 단위, 자바로 따지면 메소드와 같은 존재
    - 매개변수로 전달된 값들을 읽어 처리한 (계산한) 결과를 반환
    
    [ 종류 ]
    
    - 단일행 함수 : N 개의 값을 읽어서 N 개의 결과를 리턴
                  즉, 매 행마다 함수 실행 후 매 행의 결과를 모두 리턴
    
    - 그룹 함수 (집계 함수) : N 개의 값을 읽어서 1 개의 결과로 리턴
                           즉, 매 행을 하나의 그룹별로 묶어서 실행 후 결과를 리턴
    
    * 단일행 함수와 그룹 함수는 동시에 함께 사용할 수 없다!!
      왜? 결과 (RESULT SET) 행의 갯수가 서로 다르기 때문
      (아까 공부했던 DISTINCT 를 여러번 못쓰는 이유와 같음)
      (항상 데이터베이스의 테이블, RESULT SET 과 같은 데이터를 나타내는 표 형식은 반듯반듯 네모 모양이여만 함!!)
*/

--------------------------------------------------------------------------------

----- < 단일행 함수 > -----

/*
    < 문자열과 관련된 함수 > - 자바에서 String 관련 유용한 메소드들과 비슷
    
    LENGTH / LENGTHB
    
    - LENGTH(STR) : 해당 전달된 문자열의 글자 수 반환
    - LENGTHB(STR) : 해당 전달된 문자열의 바이트 수 반환
    
    STR : '문자열' / 문자열 타입의 컬럼명
    결과값은 NUMBER 타입으로 반환
    
    숫자, 영문, 특수문자 : '!', '~', 'A', 'a', '1' 등
                         오라클에서 한 글자 당 1BYTE 로 취급됨
    한글 : 'ㄱ', 'ㅣ', 'ㅁ', '김' 등
          오라클에서 한 글자 당 3BYTE 로 취급됨
*/

SELECT LENGTH('오라클!'), LENGTHB('오라클!') -- 4, 10
  FROM DUAL;
--> DUAL : 가상테이블, DUMMY TABLE
--         리터럴을 가지고 단순 연산식 또는 함수식을 처리한 결과를 곧바로 출력해보고 싶을 때
--         FROM 절에 기술하는 임의의 테이블명 (흰 도화지 역할)

-- EMPLOYEE 테이블의 컬럼에 적용
SELECT EMAIL
     , LENGTH(EMAIL)
     , LENGTHB(EMAIL)
     , EMP_NAME
     , LENGTH(EMP_NAME)
     , LENGTHB(EMP_NAME)
  FROM EMPLOYEE;

--------------------------------------------------------------------------------

/*
    INSTR
    
    - INSTR(STR) : 전달된 문자열로부터 특정 문자의 위치값을 반환
    
    INSTR(STR, '특정문자', 찾을위치의시작값, 순번)
    
    STR : '문자열' / 문자열 타입의 컬럼명
    결과값은 NUMBER 타입으로 반환
    
    찾을위치의시작값
    1 : 앞에서부터 찾겠다. (생략 시 기본값)
    -1 : 뒤에서부터 찾겠다.
*/

SELECT INSTR('AABAACAABBAA', 'B' /* , 1 */)
  FROM DUAL; -- 3 ('B' 는 앞에서부터 3번째 글자입니다)
--> 찾을위치의시작값, 순번 생략 시 기본적으로
--  "앞에서부터 첫번째" 글자의 위치를 알려줌 (1부터 셈!!)

SELECT INSTR('AABAACAABBAA', 'B', 1)
  FROM DUAL; -- 3 (맨 앞의 'B' 는 앞에서부터 3번째 글자입니다)
--> 찾을위치의시작값을 1로 설정해 두면 "앞에서부터 찾아줌"

SELECT INSTR('AABAACAABBAA', 'B', -1 /* , 1 */)
  FROM DUAL; -- 10 (맨 뒤의 'B' 는 앞에서부터 10번째 글자입니다)
--> 찾을위치의시작값을 -1로 설정해 두면 "뒤에서부터 찾아줌"  
  
SELECT INSTR('AABAACAABBAA', 'B', 1, 1)
  FROM DUAL;
--> 순번 생략 시 1 이 기본값임!! (첫번째 문자 라는 뜻)

SELECT INSTR('AABAACAABBAA', 'B', 1, 2)
  FROM DUAL; -- 9 (앞에서부터 두번째로 나오는 B 의 위치는 9번째 글자입니다)
--> 순번을 2로 설정해 두면 "두번째 문자" 의 위치를 찾아줌

SELECT INSTR('AABAACAABBAA', 'B', -1, 2)
  FROM DUAL; -- 9 (뒤에서부터 두번째로 나오는 B 의 위치는 9번째 글자입니다)
--> 항상 자릿수를 셀 때에는 앞에서부터 세서 알려줌!!

-- EMPLOYEE 테이블에 적용
-- EMAIL 컬럼으로부터 @ 의 위치를 알아내고 싶음!!
SELECT EMAIL, INSTR(EMAIL, '@') AS "@의 위치"
  FROM EMPLOYEE;

--------------------------------------------------------------------------------

/*
    SUBSTR
    
    - SUBSTR(STR, POSITION, LENGTH)
    : 전달된 문자열로부터 특정 문자열을 추출해서 반환
      (자바로 치면 .substring() 메소드와 유사)

    STR : '문자열' / 문자열 타입의 컬럼명
    POSITION : 문자열 추출을 시작할 위치
    LENGTH : 추출할 문자의 갯수 (생략 가능)
             생략 시 끝까지 추출하겠다. 라는 의미
    
    결과값은 CHARACTER (문자열) 타입으로 반환
*/

SELECT SUBSTR('SHOWMETHEMONEY', 7)
  FROM DUAL; -- THEMONEY
--> 7번째 글자부터 끝까지 추출하겠다. (LENGTH 생략)

SELECT SUBSTR('SHOWMETHEMONEY', 5, 2)
  FROM DUAL; -- ME
--> 5번째 글자부터 2개만 추출하겠다.

SELECT SUBSTR('SHOWMETHEMONEY', 1, 6)
  FROM DUAL; -- SHOWME

--> 주의할 점 : 자바에서 문자열의 글자를 셀 때 0 부터 셌었음!! (인덱스 개념)
--             오라클에서는 문자열의 글자를 셀 때 1 부터 셈!!

SELECT SUBSTR('SHOWMETHEMONEY', -8, 3)
  FROM DUAL; -- THE
--> POSITION 을 음수로 제시할 경우 "뒤에서부터 N번째" 라는 뜻임!!
--> 뒤에서부터 8번째 글자로부터 3개를 추출하겠다.

-- EMPLOYEE 테이블에 적용
-- 주민등록번호에서 성별 부분만 추출해서 남자(1) / 여자(2) 체크
SELECT EMP_NAME
     , EMP_NO
     , SUBSTR(EMP_NO, 8, 1) "성별"
  FROM EMPLOYEE;

-- 남자사원들만 조회 (사원명, 급여)
SELECT EMP_NAME, SALARY
  FROM EMPLOYEE
-- WHERE (SUBSTR(EMP_NO, 8, 1) = '1') OR (SUBSTR(EMP_NO, 8, 1) = '3');
 WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3');

-- 여자사원들만 조회 (사원명, 급여)
SELECT EMP_NAME, SALARY
  FROM EMPLOYEE
-- WHERE (SUBSTR(EMP_NO, 8, 1) = '2') OR (SUBSTR(EMP_NO, 8, 1) = '4');
 WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4');
--> 함수식은 SELECT 절 뿐만 아니라 WHERE 절에서도 활용 가능하다!!

-- 이메일에서 ID 부분만 추출해서 조회 (첫번째 글자 ~ @ 전까지)
SELECT EMP_NAME
     , EMAIL
     , SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') - 1) "ID"
  FROM EMPLOYEE;
--> 함수 호출 구문 안에서 함수 호출 구문을 또 중첩해서 사용 가능!!

--------------------------------------------------------------------------------

/*
    LPAD / RPAD
    
    - LPAD / RPAD(STR, 최종적으로반환할문자열의길이(바이트), 덧붙일문자)
    : 제시한 문자열에 임의의 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 N 바이트만큼의 문자열을 만들어서 반환
    
    STR : '문자열' / 문자열 타입의 컬럼명
    결과값은 CHARACTER (문자열) 타입으로 반환
    
    덧붙일문자는 생략 가능함!! (생략 시, 공백 문자가 덧붙여짐)
*/

SELECT LPAD(EMAIL, 16 /* ' ' */)
  FROM EMPLOYEE;
--> EMAIL 왼쪽에 (L) 공백문자를 추가해서 총 16바이트짜리 문자열로 만들어서 반환

SELECT LPAD(EMAIL, 16, '#')
  FROM EMPLOYEE;

SELECT RPAD(EMAIL, 16, '#')
  FROM EMPLOYEE;
--> EMAIL 오른쪽에 (R) '#' 을 추가해서 총 16바이트짜리 문자열로 만들어서 반환

-- 주민등록번호 조회 시, 621235-1****** (마스킹 처리) 로 보여지게끔
SELECT RPAD('621235-1', 14, '*')
  FROM DUAL;
--> 주민등록번호는 총 14글자, 14바이트 짜리 문자열!!

-- 모든 직원의 주민번호를 마스킹처리 해서 보고싶음!!
-- 1단계. SUBSTR 함수를 이용해서 주민번호 앞 8 자리 추출
SELECT SUBSTR(EMP_NO, 1, 8)
  FROM EMPLOYEE;

-- 2단계. RPAD 함수를 중첩해서 주민번호 뒤 6자리에 * 붙이
SELECT EMP_NAME
     , RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*') AS 주민번호
  FROM EMPLOYEE;

-- RPAD 함수 없이도 가능
SELECT EMP_NAME
     , SUBSTR(EMP_NO, 1, 8) || '******' AS 주민번호
  FROM EMPLOYEE;
  
--------------------------------------------------------------------------------

/*
    LTRIM / RTRIM
    
    - LTRIM / RTRIM(STR, 제거할문자)
    : 문자열의 왼쪽 또는 오른쪽에서 제거할 문자들을 찾아서 제거한 나머지 문자열을 반환
    
    STR : '문자열' / 문자열 타입의 컬럼명
    결과값은 CHARACTER 타입으로 반환
    
    제거할문자는 생략 가능 (생략 시, 공백을 제거해줌)
*/

SELECT LTRIM('       K     H' /* , ' ' */)
  FROM DUAL;
--> 제거할문자를 생략하면 공백문자가 제거됨!!

SELECT LTRIM('0001230456000', '0')
  FROM DUAL;
--> LTRIM 은 왼쪽 제거

SELECT RTRIM('0001230456000', '0')
  FROM DUAL;
--> RTRIM 은 오른쪽 제거

-- 양쪽을 다 지우고 싶다면? 중첩 사용 가능
SELECT RTRIM(LTRIM('0001230456000', '0'), '0')
  FROM DUAL;

SELECT LTRIM('123123KH123', '123')
  FROM DUAL;
--> 제거할 문자열을 통으로도 제시 가능!!

SELECT LTRIM('ACABACCKH', 'ABC')
  FROM DUAL;
--> 문자열을 통으로 제시하더라도 통으로 제거하는게 아니라 문자 하나하나가 다 존재하면 제거하는 원리임!!

--------------------------------------------------------------------------------

/*
    TRIM

    - TRIM(BOTH/LEADING/TRAILING '제거할문자' FROM STR) 
    : 문자열의 앞/뒤/양쪽에 있는 특정 문자를 제거한 나머지 문자열을 반환
    
    STR : '문자열' / 문자열 타입의 컬럼명
    결과값은 CHARACTER 타입으로 반환
    
    BOTH/LEADING/TRAILING 은 생략 가능 (생략 시, BOTH 가 기본값임!! 양쪽을 제거하겠다)    
*/

SELECT TRIM('       K      H        ')
  FROM DUAL;
--> 기본적으로 문자열만 제시했을 때 양쪽에 있는 공백을 제거 (자바의 .trim() 메소드와 동일)

SELECT TRIM(/* BOTH */ 'Z' FROM 'ZZZKHZZZ')
  FROM DUAL;
--> 생략 시 BOTH 가 기본값 (양쪽 제거)

SELECT TRIM(BOTH 'Z' FROM 'ZZZKHZZZ')
  FROM DUAL;

SELECT TRIM(LEADING 'Z' FROM 'ZZZKHZZZ')
  FROM DUAL;
--> LEADING : 앞쪽만 제거 (== LTRIM 함수 실행 결과와 동일)

SELECT TRIM(TRAILING 'Z' FROM 'ZZZKHZZZ')
  FROM DUAL;
--> TRAILING : 뒤쪽만 제거 (== RTRIM 함수 실행 결과와 동일)

--------------------------------------------------------------------------------

/*
    LOWER / UPPER / INITCAP
    
    - LOWER(STR) : 다 소문자로 변경 (자바의 .toLowerCase() 메소드에 대응) 
    - UPPER(STR) : 다 대문자로 변경 (자바의 .toUpperCase() 메소드에 대응)
    - INITCAP(STR) : 각 단어 앞글자만 대문자로 변경 (단, 단어의 기준은 띄어쓰기 기준)
    
    STR : '문자열' / 문자열 타입의 컬럼명
    결과값은 CHARACTER 타입으로 반환
*/

SELECT LOWER('Welcome To My World!')
  FROM DUAL;

SELECT UPPER('Welcome To My World!')
  FROM DUAL;

SELECT INITCAP('welcome to my world!')
  FROM DUAL;

SELECT INITCAP('welcometomyworld!')
  FROM DUAL;
--> 단어의 구분 기준은 띄어쓰기임!!

--------------------------------------------------------------------------------

/*
    CONCAT
    
    - CONCAT(STR1, STR2)
    : 전달된 두 문자열을 하나로 합친 결과를 반환
    
    STR1, STR2 : '문자열' / 문자열 타입의 컬럼명
    결과값은 CHARACTER 타입으로 반환
*/

SELECT CONCAT('가나다', 'ABC')
  FROM DUAL;

SELECT '가나다' || 'ABC'
  FROM DUAL;

SELECT '가나다' || 'ABC' || '123'
  FROM DUAL;

-- CONCAT 을 이용할 경우?
SELECT CONCAT('가나다', 'ABC', '123')
  FROM DUAL;
--> invalid number of arguments 오류 발생!!
--  (매개변수의 갯수가 유효하지 않음)
--> 항상 두개의 문자열만 제시 가능!!

SELECT CONCAT(CONCAT('가나다', 'ABC'), '123')
  FROM DUAL;
--> 3개 이상 연결하고 싶다면 중첩해서 사용 가능!!

--------------------------------------------------------------------------------

/*
    REPLACE
    
    - REPLACE(STR, 찾을문자, 바꿀문자)
    : 문자열로 부터 찾을문자를 찾아서 바꿀문자로 바꾼 문자열을 반환
    
    STR : '문자열' / 문자열 타입의 컬럼명
    결과값은 CHARACTER 타입으로 반환
*/

SELECT REPLACE('서울시 강남구 역삼동', '역삼동', '삼성동')
  FROM DUAL;

-- EMPLOYEE 테이블에 적용
-- 모든 사원의 이메일 주소 도메인값을
-- 'kh.or.kr' 을 'iei.or.kr' 로 변경해서 조회
SELECT EMP_NAME
     , EMAIL "원래 이메일"
     , REPLACE(EMAIL, 'kh.or.kr', 'iei.or.kr') "바뀐 이메일"
  FROM EMPLOYEE;

--------------------------------------------------------------------------------

/*
    < 숫자와 관련된 함수 > - 자바의 Math 클래스 에서 제공하던 메소드들과 비슷
    
    ABS
    
    - ABS(NUMBER) : 절대값을 구해주는 함수
*/

SELECT ABS(-10)
  FROM DUAL;

SELECT ABS(-19.2)
  FROM DUAL;
--> NUMBER (숫자) 타입은 정수든 실수든 상관없이 다 포함임!!

--------------------------------------------------------------------------------

/*
    MOD
    
    - MOD(NUMBER1, NUMBER2) : NUMBER1 에서 NUMBER2 로 나눈 나머지를 반환해주는 함수
                              (오라클에서는 모듈러 연산자 % 가 없음!!)
*/

SELECT MOD(10, 3)
  FROM DUAL;

SELECT MOD(-10, 3)
  FROM DUAL;

SELECT MOD(10.9, 3)
  FROM DUAL;
--> NUMBER 타입은 정수, 실수 구분이 없기 때문에, 실수와 정수 사이에 자유롭게 연산 가능!!

--------------------------------------------------------------------------------

/*
    ROUND
    
    - ROUND(NUMBER, 위치) : 반올림 처리해주는 함수
    
    위치 : 소숫점 아래 N 번째 자리에서 반올림, 생략 가능 (생략 시, 기본값은 0)
*/

SELECT ROUND(123.456 /* , 0 */)
  FROM DUAL; -- 123

SELECT ROUND(123.456, 0)
  FROM DUAL; -- 123

SELECT ROUND(123.456, 1)
  FROM DUAL; -- 123.5
  
SELECT ROUND(123.456, 2)
  FROM DUAL; -- 123.46
  
SELECT ROUND(123.456, 3)
  FROM DUAL; -- 123.456
  
SELECT ROUND(123.456, 4)
  FROM DUAL; -- 123.456

SELECT ROUND(123.456, -1)
  FROM DUAL; -- 120

SELECT ROUND(123.456, -2)
  FROM DUAL; -- 100

--------------------------------------------------------------------------------

/*
    CEIL
    
    - CEIL(NUMBER) : 올림 처리해주는 함수, 무조건 소숫점 아래의 수를 올림 처리 (자릿수 조정 X)
*/

SELECT CEIL(123.000001)
  FROM DUAL; -- 124

--------------------------------------------------------------------------------

/*
    FLOOR
    
    - FLOOR(NUMBER) : 소숫점 아래의 수를 무조건 버림 처리
                      (자릿수 지정 X)
*/

SELECT FLOOR(123.789)
  FROM DUAL; -- 123

SELECT FLOOR(100.99999999999)
  FROM DUAL;

-- EMPLOYEE 테이블에 적용
-- 각 직원별로 고용일로부터 오늘까지의 근무일수 구하기
--> 근무일수 = 오늘날짜 - 고용일
--  (일 수 단위로 계산되지만, 시/분/초 까지 계산되기 때문에 소숫점이 지저분했었음!!)
SELECT EMP_NAME
     , HIRE_DATE
     , SYSDATE
     , CONCAT(FLOOR(SYSDATE - HIRE_DATE), '일') "근무일수"
  FROM EMPLOYEE;

--------------------------------------------------------------------------------

/*
    TRUNC

    - TRUNC(NUMBER, 위치) : 위치 지정 가능한 버림 처리 해주는 함수    
                            위치 생략 가능 (생략 시, 기본값은 0, 소숫점 뒤를 모두 버림 처리)
*/

SELECT TRUNC(123.756 /* , 0 */)
  FROM DUAL; -- 123

SELECT TRUNC(123.756, 0)
  FROM DUAL; -- 123

SELECT TRUNC(123.756, 1)
  FROM DUAL; -- 123.7

SELECT TRUNC(123.756, 2)
  FROM DUAL; -- 123.75

SELECT TRUNC(123.756, 3)
  FROM DUAL; -- 123.756

SELECT TRUNC(123.756, -1)
  FROM DUAL; -- 120

SELECT TRUNC(123.756, -2)
  FROM DUAL; -- 100
--> 마찬가지로 위치값을 음수로 지정 가능 (소숫점 위로 위치 지정)

--------------------------------------------------------------------------------

/*
    < 날짜 관련 함수 >
    
    DATE 타입 : 년, 월, 일, 시, 분, 초 를 다 포함한 자료형
    
    - SYSDATE : 현재 이 컴퓨터의 시스템 날짜를 반환하는 키워드
*/

SELECT SYSDATE
  FROM DUAL; -- DATE 타입

SELECT '26/03/13'
  FROM DUAL; -- CHARACTER 타입

--> RESULT SET 의 값 보기 버튼 (연필 버튼) 으로 타입 확인해볼 것!!

-- MONTHS__BETWEEN(DATE1, DATE2)
-- 두 날짜 사이의 "개월 수" 반환
-- 단, DATE1 이 더 미래의 날짜여야지만 양수로 나옴!!
-- 즉, DATE2 가 더 미래의 날짜라면 결과가 음수로 나옴!!

-- EMPLOYEE 테이블로부터
-- 각 직원별로 고용일에서부터 오늘까지의 근무일수와 근무개월수 조회
SELECT EMP_NAME
     , FLOOR(SYSDATE - HIRE_DATE) || '일' "근무일수"
     , FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월' "근무개월수"
  FROM EMPLOYEE;
--> 결과가 지저분하게 소숫점이 나오는 이유는 
--  월보다 작은 단위인 일, 시, 분, 초에 대한 연산 또한 함께 들어가기 때문!!

-- ADD_MONTHS(DATE, NUMBER)
-- 특정 날짜에 해당 숫자만큼의 개월수를 더한 날짜를 반환 (특정 날짜로부터 몇 달 후를 보겠다)
-- (DATE 타입 반환)

-- 오늘 날짜로부터 5개월 후
SELECT ADD_MONTHS(SYSDATE, 5)
  FROM DUAL;

-- EMPLOYEE 테이블에 적용
-- 전체 사원들의 직원명, 입사일, 입사 후 3개월이 흘렀을 때의 날짜 조회
SELECT EMP_NAME
     , HIRE_DATE
     , ADD_MONTHS(HIRE_DATE, 3) "수습 종료일"
  FROM EMPLOYEE;

-- NEXT_DAY(DATE, 요일을나타내는값(문자/숫자))
-- 특정 날짜에서 가장 가까운 해당 요일을 찾아 그 날짜를 반환
SELECT NEXT_DAY(SYSDATE, '일요일')
  FROM DUAL;

SELECT NEXT_DAY(SYSDATE, '일')
  FROM DUAL;

SELECT NEXT_DAY(SYSDATE, 1)
  FROM DUAL;
--> 1 : 일요일, 2 : 월요일, 3 : 화요일, 4 : 수요일, 5 : 목요일, 6 : 금요일, 7 : 토요일

-- 오늘 날짜 (26/03/13 - 금) 기준으로 가장 가까운 목요일을 찾아보기!!
SELECT NEXT_DAY(SYSDATE, 5)
  FROM DUAL;
--> 앞으로 다가오는 날짜 중에서 가장 가까운 목요일임!!

SELECT NEXT_DAY(SYSDATE, 'SUNDAY')
  FROM DUAL;
--> 현재 시스템 언어가 KOREAN 이기 때문에 오류 발생!!

-- 언어 변경
ALTER SESSION SET NLS_LANGUAGE = 'AMERICAN';
--> Session이(가) 변경되었습니다.

SELECT NEXT_DAY(SYSDATE, 'SUNDAY')
  FROM DUAL;

SELECT NEXT_DAY(SYSDATE, '일요일')
  FROM DUAL;
--> 반대로 한글이 안됨

-- 원상복귀
ALTER SESSION SET NLS_LANGUAGE = 'KOREAN';
--> Session이(가) 변경되었습니다.

SELECT NEXT_DAY(SYSDATE, '일요일')
  FROM DUAL;

-- LAST_DAY(DATE)
-- 해당 특정 날짜 달의 마지막 날짜를 구해서 반환
-- (DATE 타입 반환)

SELECT LAST_DAY(SYSDATE)
  FROM DUAL;

-- EMPLOYEE 테이블에 적용
-- 전체 사원들의 이름, 입사일, 입사한 달의 마지막 날짜 조회
SELECT EMP_NAME
     , HIRE_DATE
     , LAST_DAY(HIRE_DATE)
  FROM EMPLOYEE;

/*
    EXTRACT : 날짜로부터 년도 또는 월 또는 일 정보만 추출해서 반환
              (NUMBER 타입 반환)

    [ 표현법 ]
    - EXTRACT(YEAR FROM DATE) : 특정 날짜로부터 년도만 추출
    - EXTRACT(MONTH FROM DATE) : 특정 날짜로부터 월만 추출 
    - EXTRACT(DAY FROM DATE) : 특정 날짜로부터 일만 추출  
*/

-- 오늘 날짜로부터 각각 년도, 월, 일을 추출해서 출력
SELECT SYSDATE AS 오늘날짜
     , EXTRACT(YEAR FROM SYSDATE) AS 년도 -- 2026
     , EXTRACT(MONTH FROM SYSDATE) AS 월 -- 3
     , EXTRACT(DAY FROM SYSDATE) AS 일 -- 13
  FROM DUAL;

-- EMPLOYEE 테이블에 적용
-- 전체 사원들의 사원명, 입사년도, 입사월, 입사일 조회
SELECT EMP_NAME
     , HIRE_DATE
     , EXTRACT(YEAR FROM HIRE_DATE) 입사년도
     , EXTRACT(MONTH FROM HIRE_DATE) 입사월
     , EXTRACT(DAY FROM HIRE_DATE) 입사일
  FROM EMPLOYEE
 ORDER BY 입사년도 ASC, 입사월 ASC, 입사일 ASC;

-- 전체 사원들의 사원명, 입사년도, 근무연차(= 오늘 년도 - 입사일 년도) 조회
SELECT EMP_NAME
     , EXTRACT(YEAR FROM HIRE_DATE) 입사년도
     , EXTRACT(YEAR FROM SYSDATE) 올해
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 근무연차
  FROM EMPLOYEE
 ORDER BY 근무연차 DESC;

--------------------------------------------------------------------------------

/*
    < 형변환 함수 >
    
    NUMBER / DATE => CHARACTER
    
    - TO_CHAR(NUMBERE/DATE, '포맷')
    : 숫자형 또는 날짜형 데이터를 문자형 타입으로 변환
      (CHARACTER 타입 반환)
*/

-- NUMBER => CHARACTER
SELECT TO_CHAR(1234)
  FROM DUAL; -- 1234 => '1234'
--> 포맷은 생략 가능!!  
  
SELECT TO_CHAR(1234, '00000')
  FROM DUAL; -- 1234 => '01234' : 빈칸을 0 으로 채워줌
  
SELECT TO_CHAR(1234, '99999')
  FROM DUAL; -- 1234 => '1234' : 빈칸을 공백으로 채워줌
  
SELECT TO_CHAR(1234, 'L00000')
  FROM DUAL; -- 1234 => '\01234' 
--> L : LOCAL, 현재 설정된 나라의 화폐단위 기호
  
SELECT TO_CHAR(1234, 'L99999')
  FROM DUAL; -- 1234 => '\1234'

-- 달러기호로 보고싶다면?
SELECT TO_CHAR(1234, '$99999')
  FROM DUAL; -- 1234 => '$1234'

-- 보통 돈을 셀 때에는 실수하지 말라고 3자리마다 , 를 찍음!!
-- 1234원 --> 1,234원
SELECT TO_CHAR(1234, 'L99,999')
  FROM DUAL; -- 1234 => '\1,234'

-- EMPLOYEE 테이블에 적용
-- 급여정보를 3자리마다 , 로 구분해서 출력
SELECT EMP_NAME
     , TO_CHAR(SALARY, 'L999,999,999') "급여 정보"
  FROM EMPLOYEE;

-- DATE => CHARACTER
SELECT SYSDATE
  FROM DUAL;

SELECT TO_CHAR(SYSDATE)
  FROM DUAL; -- 26/03/13 => '26/03/13'

-- 날짜 출력 시 포맷 지정
SELECT TO_CHAR(SYSDATE, 'YY/MM/DD')
  FROM DUAL;
--> 포맷 생략 시에도 기본 포맷은 'YY/MM/DD'

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')
  FROM DUAL; -- '2026-03-13'

SELECT TO_CHAR(SYSDATE, 'PM HH:MI:SS')
  FROM DUAL; -- '오전 10:29:35'
--> AM/PM : 오전/오후 (아무거나 써도 알아서 알려줌)
--  HH : 시간
--  MI : 분
--  SS : 초

SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS')
  FROM DUAL;
--> HH24 : 24시간 형식

SELECT TO_CHAR(SYSDATE, 'MON DY, YYYY')
  FROM DUAL; -- '3월 금, 2026'
--> MON : N월
--  DY : '요일' 뺀 형태 (월, 화, 수, ..)

--> 포맷은 다양하며, 조합은 내 마음대로임!!

-- 년도로써 쓸 수 있는 포맷
SELECT TO_CHAR(SYSDATE, 'YYYY')
     , TO_CHAR(SYSDATE, 'RRRR')
     , TO_CHAR(SYSDATE, 'YY')
     , TO_CHAR(SYSDATE, 'RR')
     , TO_CHAR(SYSDATE, 'YEAR')
  FROM DUAL;
--> YEAR : 영어로 년도수를 출력 (스펠링)

-- 월로써 쓸 수 있는 포맷
SELECT TO_CHAR(SYSDATE, 'MM')
     , TO_CHAR(SYSDATE, 'MON')
     , TO_CHAR(SYSDATE, 'MONTH')
     , TO_CHAR(SYSDATE, 'RM')
  FROM DUAL;
--> RM : 해당 월을 로마숫자로 표기 

-- 일로써 쓸 수 있는 포맷
SELECT TO_CHAR(SYSDATE, 'D')
     , TO_CHAR(SYSDATE, 'DD')
     , TO_CHAR(SYSDATE, 'DDD')
  FROM DUAL;
--> D : 1주일 기준 몇일째 (일요일부터 셈)
--  DD : 1달 기준 몇일째 (1일부터 셈)
--  DDD : 1년 기준 몇일째 (1월 1일부터 셈)

-- 요일로써 쓸 수 있는 포맷
SELECT TO_CHAR(SYSDATE, 'DY')
     , TO_CHAR(SYSDATE, 'DAY')
  FROM DUAL;
--> DY : '요일' 을 뺀 형태
--  DAY : '요일' 을 붙인 형태

-- 2026년 03월 13일 (금) 포맷으로 적용시키고 싶음
SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" (DY)')
  FROM DUAL;
--> 포맷 이외의 다른 문자가 들어갈 경우 "년", "월", "일" 처럼 쌍따옴표로 감싸줘야함!!
--  (특수기호는 안감싸줘도됨)

-- EMPLOYEE 테이블에 적용
-- 모든 사원들의 사원명, 입사일 (위의 포맷 적용) 조회
-- 단, 2010년 이후에 입사한 사람들만 (2010년 포함)
SELECT EMP_NAME
     , TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일" (DY)') 입사일
  FROM EMPLOYEE
 WHERE EXTRACT(YEAR FROM HIRE_DATE) >= 2010;

--------------------------------------------------------------------------------

/*
    NUMBER / CHARACTER => DATE
    
    - TO_DATE(NUMBER/CHARACTER, '포맷')
    : 숫자형 또는 문자열 데이터를 날짜형으로 변환 (DATE 타입 반환)
*/

SELECT TO_DATE(20210101)
  FROM DUAL;

SELECT TO_DATE('20210101')
  FROM DUAL;

-- 포맷을 지정하는 경우
SELECT TO_DATE(20210101, 'YYYYMMDD')
  FROM DUAL;
--> RESULT SET 상으로는 YY/MM/DD 로 보이지만
--  값 보기 버튼을 클릭할 경우 제대로된 날짜 형식으로 나옴!!

SELECT TO_DATE('041030 143021', 'YYMMDD HH24MISS')
  FROM DUAL;

-- TO_DATE 함수 호출 시 주의사항
SELECT TO_DATE(000101)
  FROM DUAL; -- 000101 (X) / 101 (O)
--> 0 으로 시작하는 숫자를 제시할 수 없다!!

SELECT TO_DATE('000101')
  FROM DUAL;
--> 만약 0으로 시작하는 년도를 제시하고 싶다면 반드시 문자열로 제시해주면 됨!!

-- 날짜 포맷 사용 시 주의사항
SELECT TO_DATE('140630', 'YYMMDD')
  FROM DUAL; -- 2014년 6월 30일
  
SELECT TO_DATE('980630', 'YYMMDD')
  FROM DUAL; -- 2098년 6월 30일
--> TO_DATE 함수를 이용해서 DATE 형식으로 변환 시
--  두자리 년도에 대해 YY 포맷을 적용시킬 경우 "무조건 현재 세기 기준" 으로 나오게 됨!!

SELECT TO_DATE('140630', 'RRMMDD')
  FROM DUAL; -- 2014년 6월 30일
  
SELECT TO_DATE('980630', 'RRMMDD')
  FROM DUAL; -- 1998년 6월 30일
--> R : ROUND 의 약자 (반올림) 
--> 두자리 년도에 대해 RR 포맷을 적용할 경우
--  50 이상이면 이전세기로, 50 미만이면 현재세기로 표현
  
--------------------------------------------------------------------------------

/*
    CHARACTER => NUMBER
    
    - TO_NUMBER(CHARACTER, 포맷)
    : 문자열 데이터를 숫자형으로 변환 (NUMBER 타입 반환)
*/

-- 문자열이 숫자로만 이루어져 있을 경우 대체로 숫자로 자동형변환이 됨!!
SELECT '123' + '123'
  FROM DUAL; -- 246
--> 내부적으로 문자열이 숫자 타입으로 자동형변환 후 덧셈 연산

SELECT *
  FROM EMPLOYEE
 WHERE SUBSTR(EMP_NO, 8, 1) IN (2, 4);
--> 문자열과 숫자 타입 간의 "동등비교" 연산 (자동형변환으로 인해)

-- 자동형변환이 안되는 특이케이스
SELECT '10,000,000' + '550,000'
  FROM DUAL;
--> 문자 (,) 가 포함되어있기 때문에 자동형변환이 불가!!
--  (자바로 따지면 파싱할 때 NumberFormatException 와 유사한 상황)

-- 이런 상황에서는 TO_NUMBER 함수 활용이 필수!!
SELECT TO_NUMBER('10,000,000', '99,999,999')
     + TO_NUMBER('550,000', '999,999')
  FROM DUAL;

SELECT TO_NUMBER('00123')
  FROM DUAL; -- 123

--------------------------------------------------------------------------------

/*
    < NULL 처리 함수 >

    - NULL 값은 산술연산 불가, 비교연산 또한 불가하기 때문에
      이를 보완하기 위해 주로 사용
*/

-- NVL(컬럼명, 해당컬럼값이NULL일경우반환할값)
-- 해당 컬럼값이 존재할 경우 기존의 컬럼값을 그대로 반환,
-- 해당 컬럼값이 존재하지 않을 경우 (즉, NULL 일 경우) 내가 제시한 특정값 (두번째 인자값) 을 반환

-- EMPLOYEE 테이블로부터 사원명, 부서코드를 조회
-- 단, 부서코드가 NULL 인 경우 '부서 배치 미정' 으로 출력
SELECT EMP_NAME, NVL(DEPT_CODE, '부서 배치 미정')
  FROM EMPLOYEE;

-- EMPLOYEE 테이블로부터 사원명, 사수의사번을 조회
-- 단, 사수가 없을 경우 (사수의사번이 NULL 인 경우) '사수 없음' 으로 출력
SELECT EMP_NAME
     , NVL(MANAGER_ID, '사수 없음')
  FROM EMPLOYEE;

-- EMPLOYEE 테이블로부터 사원명, 보너스를 조회
-- 단, 보너스를 안받는 경우 NULL 이 아니라 0 으롤 출력
SELECT EMP_NAME
     , NVL(BONUS, 0)
  FROM EMPLOYEE;

-- 위의 구문을 응용하면 이제는 보너스 포함 연봉을 제대로 조회 가능함!!
SELECT EMP_NAME
     , SALARY
     , NVL(BONUS, 0)
     , ((SALARY * NVL(BONUS, 0)) + SALARY) * 12 "보너스 포함 연봉"
  FROM EMPLOYEE;
--> 산술 연산식 안쪽에서도 사용 가능!!

-- NVL2(컬럼명, 결과값1, 결과값2)
-- 해당 컬럼값이 존재할 경우 결과값1 을 반환
-- 해당 컬럼값이 존재하지 않을 경우 (NULL 일 경우) 결과값2 를 반환

-- 보너스를 받는 사원은 '보너스 받음', 보너스를 받지 않는 사원은 '보너스 받지 않음' 으로 조회
SELECT EMP_NAME
     , BONUS
     , NVL2(BONUS, '보너스 받음', '보너스 받지 않음')
  FROM EMPLOYEE;

-- 부서코드가 있는 경우 '부서 배치 완료', 부서코드가 없는 경우 '부서 배치 미정' 으로 조회
SELECT EMP_NAME
     , DEPT_CODE
     , NVL2(DEPT_CODE, '부서 배치 완료', '부서 배치 미정')
  FROM EMPLOYEE;

-- 사수가 있는 경우 '사수 있음', 사수가 없는 경우 '사수 없음' 으로 조회
SELECT EMP_NAME
     , MANAGER_ID
     , NVL2(MANAGER_ID, '사수 있음', '사수 없음')
  FROM EMPLOYEE;
  
-- NULLIF(비교대상1, 비교대상2)
-- 비교대상1 과 비교대상2 가 일치할 경우 NULL 을 반환
-- 비교대상1 과 비교대상2 가 일치하지 않을 경우 비교대상1 을 반환
SELECT NULLIF('123', '123')
  FROM DUAL;

SELECT NULLIF('123', '456')
  FROM DUAL;
  
--------------------------------------------------------------------------------

/*
    < 선택 함수 >
    
    DECODE(비교대상컬럼명, 조건값1, 결과값1,
                         조건값2, 결과값2, 
                         조건값3, 결과값3,
                         ...,
                         조건값N, 결과값N,
                                 결과값)
    
    - 자바에서의 SWITCH문과 유사한 구조
    switch(동등비교대상자) {
    case 조건값1 : 결과값1; break;
    case 조건값2 : 결과값2; break;
    ...
    case 조건값n : 결과값n; break;
    default : 결과값;
    }
*/

-- EMPLOYEE 테이블로부터
-- 사번, 사원명, 주민번호, 성별 ('남' / '여') 조회
SELECT EMP_ID
     , EMP_NAME
     , EMP_NO
     , SUBSTR(EMP_NO, 8, 1) "성별"
     , DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남',
                                    '2', '여') "성별2"
  FROM EMPLOYEE;

-- 직원들의 급여를 인상시켜서 조회
-- 직급코드가 'J7' 인 경우 급여를 10% 인상해서
--          'J6' 인 경우 급여를 15% 인상해서
--          'J5' 인 경우 급여를 20% 인상해서
--          그 외의 직급들은 급여를 5% 인상해서 조회
SELECT EMP_NAME
     , JOB_CODE
     , SALARY "인상 전"
     , DECODE(JOB_CODE, 'J7', SALARY * 1.1,
                        'J6', SALARY * 1.15, 
                        'J5', SALARY * 1.2,
                              SALARY * 1.05) "인상 후"
  FROM EMPLOYEE;
--> 상황에 맞는 연산식 결과를 출력하는 용도로도 사용 가능!!

/*
    (함수는 아님!!)
    
    CASE WHEN THEN 구문
    
    - DECODE 선택함수와 비교하면 DECODE 함수는 내부적으로 "동등비교" 만 수행했었음!!
    - CASE WHEN THEN 구문으로는 특정 조건을 "디테일" 하게 제시 가능함!!
      (즉, 자바에서의 IF-ELSE IF문 느낌)

    [ 표현법 ]
    
    CASE WHEN 조건식1 THEN 결과값1
         WHEN 조건식2 THEN 결과값2
         ...
         WHEN 조건식N THEN 결과값N
                     ELSE 결과값
    END
*/

-- 사번, 사원명, 성별 조회 : DECODE 함수
SELECT EMP_ID
     , EMP_NAME
     , DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남',
                                    '2', '여',
                                    '3', '남',
                                    '4', '여') "성별"
  FROM EMPLOYEE;

-- CASE WHEN THEN 구문
SELECT EMP_ID
     , EMP_NAME
     , CASE WHEN SUBSTR(EMP_NO, 8, 1) = '1' THEN '남'
            WHEN SUBSTR(EMP_NO, 8, 1) = '2' THEN '여'
            WHEN SUBSTR(EMP_NO, 8, 1) = '3' THEN '남'
            WHEN SUBSTR(EMP_NO, 8, 1) = '4' THEN '여'
       END "성별"
  FROM EMPLOYEE;     

-- 조건식 축약
SELECT EMP_ID
     , EMP_NAME
     , CASE WHEN SUBSTR(EMP_NO, 8, 1) IN ('1', '3') THEN '남' 
                                                    ELSE '여'
       END "성별"
  FROM EMPLOYEE;

-- 직원들의 급여를 인상시켜서 조회
-- 직급코드가 'J7' 인 경우 급여를 10% 인상해서
--          'J6' 인 경우 급여를 15% 인상해서
--          'J5' 인 경우 급여를 20% 인상해서
--          그 외의 직급들은 급여를 5% 인상해서 조회
SELECT EMP_NAME
     , JOB_CODE
     , SALARY "인상 전"
     , CASE WHEN JOB_CODE = 'J7' THEN SALARY * 1.1
            WHEN JOB_CODE = 'J6' THEN SALARY * 1.15
            WHEN JOB_CODE = 'J5' THEN SALARY * 1.2
                                 ELSE SALARY * 1.05
       END "인상 후"
  FROM EMPLOYEE;

-- 사원명, 급여, 급여등급 (고급, 중급, 초급)
-- SALARY 값이 500만원 초과인 경우 '고급'
--            500만원 이하 350만원 초과인 경우 '중급'
--            350만원 이하인 경우 '초급'
SELECT EMP_NAME
     , SALARY
     , CASE WHEN 5000000 < SALARY THEN '고급'
            WHEN (3500000 < SALARY) 
             AND (SALARY <= 5000000) THEN '중급'
            -- WHEN SALARY <= 3500000 THEN '초급'
                                    ELSE '초급'
       END "급여 등급"
  FROM EMPLOYEE;
--> 위와 같이 동등비교가 아닌 범위를 제시하는 등의 조건식을 이용할 경우에는
--  DECODE 선택함수를 쓸 수 없게된다!!

--> 반대로 DECODE 함수 구문을 CASE WHEN THEN 구문으로는 언제든지 변경 가능!!

--------------------------------------------------------------------------------

----- < 그룹 함수 > -----

/*
    N 개의 값을 읽어서 1 개의 결과로 반환
    (하나의 그룹별로 함수 실행 후 결과를 반환)
    집계 함수 라고도 부른다.
*/

-- 1. SUM(숫자타입컬럼명)
-- 해당 컬럼값들의 총 합계를 구해서 반환해주는 함수

-- EMPLOYEE 테이블로부터 전체 사원들의 총 급여 합계
SELECT SUM(SALARY)
  FROM EMPLOYEE;

-- 부서 코드가 'D5' 인 사원들의 총 급여 합계
SELECT SUM(SALARY)
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5';
--> WHERE 절과 함께 사용 가능!!

-- 남자 사원들의 총 급여 합
SELECT SUM(SALARY)
  FROM EMPLOYEE
 WHERE SUBSTR(EMP_NO, 8, 1) = '1';

-- 2. AVG(숫자타입컬럼명)
-- 해당 컬럼값들의 평균값을 구해서 반환

-- 전체 사원들의 평균 급여
SELECT AVG(SALARY)
  FROM EMPLOYEE;

-- 평균 급여값의 반올림한 값으로 출력
SELECT ROUND(AVG(SALARY))
  FROM EMPLOYEE;
--> 그룹 함수를 실행한 결과를 가지고 단일행 함수를 중첩해서 또 호출할 수 있다!!

-- 참고) 단일행 함수와 그룹 함수를 함께 사용 불가!!
SELECT ROUND(SALARY), AVG(SALARY)
  FROM EMPLOYEE;
--> ROUND(SALARY) 의 결과는 23행
--  AVG(SALARY) 의 결과는 1행
--> 결과 행의 갯수가 반듯하게 맞아 떨어지지 않기 때문에 오류!! 절대 불가!!

-- 3. MIN(ANY타입컬럼명)
-- 해당 컬럼값들 중에서 가장 작은 값을 반환

-- EMPLOYEE 테이블로부터
-- 급여, 이름, 이메일, 입사일 기준 가장 "최소값" 구하기
SELECT MIN(SALARY), MIN(EMP_NAME), MIN(EMAIL), MIN(HIRE_DATE)
  FROM EMPLOYEE;
  
SELECT *
  FROM EMPLOYEE
 ORDER BY SALARY ASC;
--> MIN 함수의 동작 원리 : 값들을 오름차순으로 정렬 후 가장 위의 값을 반환 

-- 4. MAX(ANY타입컬럼명)
-- 해당 컬럼값들 중에서 가증 큰 값을 반환

-- 급여, 이름, 이메일, 입사일 기준 가장 "최대값" 구하기
SELECT MAX(SALARY), MAX(EMP_NAME), MAX(EMAIL), MAX(HIRE_DATE)
  FROM EMPLOYEE;

SELECT *
  FROM EMPLOYEE
 ORDER BY SALARY DESC;
--> MAX 함수의 동작 원리 : 값들을 내림차순으로 정렬 후 가장 위의 값을 반환

-- 5. COUNT(* / 컬럼명 / DISTINCT 컬럼명)
-- 조회된 행의 갯수를 세서 반환

-- COUNT(*)
-- 조회 결과에 해당하는 모든 행들의 갯수를 다 세서 반환

-- 전체 사원수에 대해서 조회
SELECT COUNT(*)
  FROM EMPLOYEE;
--> 총 23명

-- 여자 사원수만 조회
SELECT COUNT(*)
  FROM EMPLOYEE
 WHERE SUBSTR(EMP_NO, 8, 1) = '2';
--> 8명

-- 남자 사원수만 조회
SELECT COUNT(*)
  FROM EMPLOYEE
 WHERE SUBSTR(EMP_NO, 8, 1) = '1';
--> 15명

-- COUNT(컬럼명)
-- 제시한 해당 컬럼값이 NULL 이 아닌 것만 행의 갯수를 세서 반환

-- 부서 배치가 된 사원들의 수
-- (DEPT_CODE 가 NULL 이 아닌 사원들의 수)
SELECT COUNT(*)
  FROM EMPLOYEE
 WHERE DEPT_CODE IS NOT NULL;
--> 21명

-- COUNT(컬럼명) 을 이용하면 WHERE 절을 생략 가능!!
SELECT COUNT(DEPT_CODE)
  FROM EMPLOYEE;
--> 21명

-- 부서 배치가 된 여자 사원 수
SELECT COUNT(*)
  FROM EMPLOYEE
 WHERE DEPT_CODE IS NOT NULL
   AND SUBSTR(EMP_NO, 8, 1) = '2';
--> 7명

SELECT COUNT(DEPT_CODE)
  FROM EMPLOYEE
 WHERE SUBSTR(EMP_NO, 8, 1) = '2';
--> 7명

-- 사수가 있는 사원 수
SELECT COUNT(MANAGER_ID)
  FROM EMPLOYEE;
--> 16명

--> COUNT(*) 의 결과와 COUNT(컬럼명) 의 결과는 
--  해당 컬럼에 들어있는 값 중 NULL 이 하나도 없다면 항상 일치!!

-- COUNT(DISTINCT 컬럼명)
-- 제시한 해당 컬럼값에 중복값이 있을 경우 하나로만 갯수를 세서 반환 (이때, NULL 포함 X)

-- 우리 회사의 모든 부서의 갯수
SELECT COUNT(*)
  FROM DEPARTMENT;
--> 총 9개

-- 현재 사원들이 속해있는 부서의 갯수
SELECT COUNT(DISTINCT DEPT_CODE)
  FROM EMPLOYEE;
--> 6개

--> 우리 회사에는 총 9개의 부서가 있고, 그 중 3개의 부서는 비어있음!!






