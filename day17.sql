테이블 타입의 변수
pl/sql에서 배열을 표현하는 방법

set serveroutput on;
select
    empno
from
    tmp1
;

형식
테이블 타입 정의하는 방법
type 테이블이름 is table of 데이터타입1
index by 데이터타입2;

1)
데이터타입1
변수에 기억될 데이터의 형태
데이터타입2
배열의 위치값을 사용할 데이터의 형태(99.9% binary_integer : 0,1,2,3,...)

2)
형식) 변수이름 테이블이름;
정의된 테이블이름의 형태로 변수를 만드세요.


테이블타입이란 변수는 존재하지 않는다.
따라서 먼저 테이블 타입을 정의하고
정의된 테이블 타입을 이용해서 변수를 선언해야 한다.

for명령

형식1)
for 변수이름 in (질의명령) loop
    처리내용;
    ...
end loop;
의미: 질의명령의 결과를 변수에 한줄씩 기억한 후 원하는 내용을 처리하도록 한다.

형식2)
for 변수이름 in 시작값..종료값 loop
    처리내용;
end loop;
의미) 시작값에서 종료값까지 1씩 증가시키면서 처리내용을 반복시킨다.

예제) 부서번호를 알려주면 해당부서  소속의 사원들의 이름, 직급, 급여를 조회해서 출력하도록 
프로시저()를 만들어서  실행하세요.

create or replace procedure p2_emp_info01
(
    dno emp.deptno%type
)
is 
type name_table is table of emp.ename%type
index by binary_integer;

type job_talbe is table of emp.job%type
index by binary_integer;


type sal_table is table of emp.sal%type
index by binary_integer;

name name_table;--자동배열
vjob job_talbe;
vsal sal_talbe;

i binary_integer :=0;


begin
    dbms_output.enable;
    for tmp in (
        select
            ename, job, sal
        from
            tmp1
        where
        deptno=dno
    )
    
    loop
    
    i:=i+1;
    
    name(i):= tmp.ename;
    vjob(i):= tmp.job;
    vsal(i):= tmp.sal;
    end loop;
    
    dbms_output.put_line('i: ' || i)
    
    for cnt in 1.. i loop
        dbms_output.put_line('사원이름'|| name(cnt));
        dbms_output.put_line('사원직급'|| vjob(cnt));
        dbms_output.put_line('사원급여'|| vsal(cnt));
    end loop;
end;
/

execute p2_emp_info01(10);

2.레코드 타입
강제로 멤버를 가지는 변수를 만드는 방법
%rowtype은 하나의 테이블을 이용해서 멤버 변수를 자동으로 만드는 방법이다.
레코드 타입은 사용자가 지정한 멤버 변수를 만들 수 있다는 차이점이있다.

1.레코드 타입을 정의한다.
type 레코드 이름 is recode(
멤버변수이름1 데이터타입,
멤버변수이름2 데이터타입,
...
);

2.정의된 레코드 타입을 이용해서 변수를 선언한다. 
변수이름 record 이름;
create or replace procedure nameinfo_proc01
(
    IRUM EMP.ENAME%TYPE
)
is
    TYPE EMP_RECORD01 IS RECORD(
    NAME    EMP.ENAME%TYPE,
    IJOB    EMP.JOB%TYPE,
    ISAL    EMP.SAL%TYPE,
    IGRADE  SALGRADE.GRADE%TYPE);

    vemp EMP_RECORD01;
    
begin
    select
        ename, job, sal, grade
    into
        vemp.name, vemp.ijob,vemp.isal,vemp.igrade
    from
        emp, salgrade
    where
        sal between losal and hisal
        and ename=irum
    ;
    dbms_output.put_line('사원이름: '|| vemp.name);
    dbms_output.put_line('사원직급: '|| vemp.ijob);
    dbms_output.put_line('사원급여: '|| vemp.isal);
    dbms_output.put_line('사원급여등급: '|| vemp.igrade);
end;
/

exec nameinfo_proc01('KING');


CREATE OR REPLACE PROCEDURE EX01_PROC01(
    VJOB EMP.JOB%TYPE
)
IS
type NAME_TABLE is table of EMP.ENAME%TYPE
index by BINARY_INTEGER;

TYPE SAL_TABLE IS TABLE OF EMP.SAL%TYPE
INDEX BY BINARY_INTEGER;

TYPE DNAME_TABLE IS TABLE OF DEPT.DNAME%TYPE
INDEX BY BINARY_INTEGER;

NAME NAME_TABLE;
VSAL SAL_TABLE;
VDNAME DNAME_TABLE;

I BINARY_INTEGER:=0;



BEGIN


END;
/

3.레코드 타입의 배열
-위의 두가지 오라클 PL/SQL 타입을 혼용해서 사용한 것.

1. 레코드 타입을 선언(멤버 변수를 가진 변수)
2. 이것을 이용해서 다시 테이블 타입을 만들어서 사용한다.( 배열 변수)

CREATE OR REPLACE PROCEDURE JOB_INFO(
    JIKGP EMP.JOB%TYPE
)
IS
    TYPE EMP_TAB IS TABLE OF EMP%ROWTYPE
    INDEX BY BINARY_INTEGER;
    
    JEMP EMP_TAB;
    I BINARY_INTEGER;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('#####TMP내용####### ');
    FOR TMP IN(SELECT ENAME, SAL, HIREDATE FROM EMP WHERE JOB=JIKGP) LOOP
    
      
    DBMS_OUTPUT.PUT_LINE('사원이름: '|| TMP.ENAME);  
    DBMS_OUTPUT.PUT_LINE('사원급여: '|| TMP.SAL);
    DBMS_OUTPUT.PUT_LINE('입사일  : '|| TMP.HIREDATE);
    
    I:=I+1;
    JEMP(I).ENAME:= TMP.ENAME;
    JEMP(I).SAL:=TMP.SAL;
    JEMP(I).HIREDATE:=TMP.HIREDATE;
    
     
    END LOOP;
     DBMS_OUTPUT.PUT_LINE(' ');
     DBMS_OUTPUT.PUT_LINE('#####JEMP내용####### ');
    FOR CNT IN 1..I LOOP
    
          
    DBMS_OUTPUT.PUT_LINE('사원이름: '|| JEMP(CNT).ENAME);  
    DBMS_OUTPUT.PUT_LINE('사원급여: '|| JEMP(CNT).SAL);
    DBMS_OUTPUT.PUT_LINE('입사일  : '|| JEMP(CNT).HIREDATE);
    
    END LOOP;

END;
/

EXECUTE JOB_INFO('CLERK');


--3
CREATE OR REPLACE PROCEDURE EX03_PROC01
(
    HDATE  EMP.HIREDATE%TYPE
)
IS
    TYPE EMP_TAB IS TABLE OF EMP%TYPE
    INDEX BY BINARY_INTEGER;
    
    HEMP EMP_TAB;
    I BINARY_INTEGER;

BEGIN
    FOR TMP IN (SELECT ENAME, JOB, DEPTNO, SAL, SALGRADE 
                FROM EMP,SALGRADE 
                WHERE
                SAL BETWEEN LOSAL AND HISAL AND
                HIREDATE= HDATE
                )
    LOOP
    
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || TMP.ENAME);
    DBMS_OUTPUT.PUT_LINE('사원직급 : ' || TMP.JOB);
    DBMS_OUTPUT.PUT_LINE('부서 : ' || TMP.DEPTNO);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || TMP.SAL;
    DBMS_OUTPUT.PUT_LINE('급여등급 : ' || TMP.SALGRADE);
    
    I:=I+1;
    HEMP(I).ENAME := TMP.ENAME;
    HEMP(I).JOB := TMP.JOB;
    HEMP(I).DEPTNO := TMP.DEPTNO;
    HEMP(I).SAL := TMP.SAL;
    HEMP(I).SALGRADE := TMP.SALGRADE;
    
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(' HEMP내용'
    FOR CNT IN 1..I LOOP
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || HEMP(CNT).ENAME);
    DBMS_OUTPUT.PUT_LINE('사원직급 : ' || HEMP(CNT).JOB);
    DBMS_OUTPUT.PUT_LINE('부서 : ' || HEMP(CNT).DEPTNO);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || HEMP(CNT).SAL;
    DBMS_OUTPUT.PUT_LINE('급여등급 : ' || HEMP(CNT).SALGRADE);
    END LOOP;
    
END;
/

DECLARE 
    sdate varchar(2);
begin

    loop
    
        if sdate ='0' then
        exit;
        end if;
    end loop;
    
    
declare
    dan number;
begin
    dan :=5;
    for gop in 1..9 loop
        dbms_output.put_line(dan||'x'||gop||'='||(dan*gop));
    end loop;
end;
/

declare
    dan number;
begin
    dan :=2;
    for gop in 1..9 loop
        dbms_output.put_line(dan||'x'||gop||'='||(dan*gop));
    end loop;
end;
/

2.while 조건식1 loop
처리내용;
exit when 조건식2;
end loop;
=조건식 1이 참이면 반복 조건식2가 참이면 반복종료


declare
    i number:=0;
    dan number :=5;
begin
    loop
        i:=i+1;
        exit when i>9;
        dbms_output.put_line(dan||'x'||i||'='||(dan*i));
    end loop;
end;
/
3. do ~ while 명령
loop
    처리내용;
    ...
    
    exit when 조건식;
end loop;

조건문

if 명령
조건식의 조건이 참인 경우만 처리 거짓의 경우 처리없음1) if 조건식 then 처리내용; ... end if;

조건이 참, 거짓인 경우 2가지 모두 처리한다. 2)if 조건식 then  참인 경우 실행내용 else 거짓인 경우 실행내용 end if;

3)if 조건식1 then 처리내용1 elsif 조건식2 then 처리내용2 elsif 조건식3 then 처리내용3 ... else 처리내용n end if;


create or replace procedure salgrade_proc02
is
    type esal is record(
    name emp.ename%type,
    sal emp.sal%type,
    grade number(2)
    );
    
    type esal_tab is table of esal 
    index by binary_integer;
    
    egrade esal_tab;
    
    i binary_integer:=0;
    tgrade number(2);
begin
    for tmp in (
        select
            ename, sal
        from
            emp
    )
    loop
        i := i+1;
        egrade(i).name := tmp.ename;
        egrade(i).sal := tmp.sal;
        
        if (tmp.sal < 700) then
            tgrade := 0;
        elsif (tmp.sal <= 1200) then 
            tgrade := 1;
        elsif (tmp.sal <= 1400) then
            tgrade := 2;
        elsif (tmp.sal <= 2000) then
            tgrade := 3;
        elsif (tmp.sal <= 3000) then
            tgrade := 4;
        elsif (tmp.sal <= 9999) then
            tgrade := 5;
        end if;
         
        egrade(i).grade := tgrade;
    end loop;
    
    for cnt in 1 .. i loop
        DBMS_OUTPUT.PUT_LINE('사원이름 : ' ||egrade(cnt).name);
        DBMS_OUTPUT.PUT_LINE('급여 : ' || egrade(cnt).sal);
        DBMS_OUTPUT.PUT_LINE('급여등급 : ' || egrade(cnt).grade);
    END LOOP;
end;
/

exec salgrade_proc02;


#커서(cursor): 실제로 실행되는 질의 명령을 기억하는 변수

자주 사용하는 질의 명령을 한번만 만든 후 이것(질의 명령 자체)를 
변수에 기억해서 마치 변수를 사용하듯이 질의를 실행하는 것.

암시적 커서
-이미 오라클에서 제공하는 커서를 말한다.
우리가 지금까지 사용했듯디 직접 만들어서 실행된 질의 명령 자체를 의미한다.

참고 커서에는 내부 변수(멤버변수)가 존재한다.

sql%rowcount
실행결과 나타난 레코드의 갯수를 기억한 멤버변수

sql%found
실행결과가 존재함을 나타내는 멤버변수

sql%notfound
실행결과가 존재하지 않음을 나타내는 멤버변수

sql%isopen
커서가 만들어졌는지를 알아내는 멤버변수

create or replace procedure getname01(
    eno emp.empno%type
)
is
    name emp.ename%type;
begin
    select
        ename
    into
        name
    from
        emp
    where
        empno=eno
    ;
    if sql%notfound then
        dbms_output.put_line('####사원이 존재하지 않습니다.###');
    end if;
        if sql%found then
    
        dbms_output.put_line('|사원번호 | 사원이름|');
        dbms_output.put_line(rpad('-',23,'-'));
        dbms_output.put_line('|'|| lpad(to_char(eno),8,' ') || '|'||rpad(name,8,' ')||'|');
        dbms_output.put_line(rpad('-',23,'-'));
    end if;
    exception when no_data_found then 
    dbms_output.put_line('####사원이 존재하지 않습니다.###');
end;
/

exec getname01(7902);

exec getname01(7500);

명시적 커서
자주 사용하는 질의명령을 미리 만든 후 필요하면 질의명령을 변수를 이용해서 실행하도록 하는 것.

명시적 커서의 처리 순서
1. 명시적 커서를 만든다.
    (명시적 커서를 정의)
    
    형식 : cursor 커서이름 is 
            필요한 질의 명령
            ;
            
2. 반드시 커서를 프로시저에서 실행 가능하도록 조치한다.
    (커서를 오픈시킨다.)
    형식 : open 커서이름;

3. 질의 명령을 실행한다.
    (커서를 fetch시킨다.)
    형식: fetch 커서이름;
    
4. 사용이 끝난 커서는 회수한다.
    (커서를 close시킨다)
    형식 : close 커서이름;
    
참고/ 만약 커서가 for loop 명령 안에서 사용되면
        자동 open, fetch, close 가 된다.

    
create or replace procedure dinfo01(
    dno dept.deptno%type
)
is
    cursor d_info is 
        select 
            dname, avg(sal), count(*)
        from
            emp e,dept d
        where
            e. deptno=d.deptno
            and e.deptno =dno
        group by
            dname
      
    ;   
    d_name dept.dname%type;
    avg1 number;
    cnt number;
    
begin
    open d_info;
    
    fetch d_info into d_name, avg1, cnt;
    dbms_output.put_line('부서번호 : '||dno);
    dbms_output.put_line('부서이름 : '||d_name);
    dbms_output.put_line('부서평균 : '||round(avg1,2));
    dbms_output.put_line('부서원수 : '||cnt);
    
    close d_info;

end;
/

execute dinfo01(10);



creae or replace procedure dinfo02
is
    cursor d_info02 is 
    select
        dname, round(avg(sal),2) s_avg, count(*) cnt
    from
        emp e, dept d
    where
        e.deptno=d.deptno
    group by
        dname
    ;
begin
    for dinfo in d_info02 loop
    dbms_output.put_line('부서이름 : '||dinfo.dname);
    dbms_output.put_line('부서평균 : '||dinfo.s_avg);
    dbms_output.put_line('부서원수 : '||dinfo.cnt);
    
    end loop;
end;
/


참고/ 명시적 커서에도 멤버 변수를 사용할 수 있다.
멤버 변수의 종류에는 암시적 커서와 동일하다.

예제 사원들의 이름, 직급, 급여를 조회해서 출력하는 프로시저를 작성하고 실행하세요.
단 최종적으로 출력된 사원의 수(총 사원 수)를 같이 출력하세요


create or replace procedure einfo03
is 
    cursor info03 is 
    SELECT
        ENAME, JOB, SAL
    FROM
        EMP
    ;
    
    NAME EMP.ENAME%TYPE;
    IJOB EMP.JOB%TYPE;
    ISAL EMP.SAL%TYPE;
begin
    OPEN INFO03;
        DBMS_OUTPUT.PUT_LINE('총 사원 수 : '|| INFO03%ROWCOUNT);

    LOOP
     FETCH INFO03 INTO NAME, IJOB, ISAL;
     DBMS_OUTPUT.PUT_LINE('사원이름 : ' ||NAME);
     DBMS_OUTPUT.PUT_LINE('사원직급 : ' ||IJOB);
     DBMS_OUTPUT.PUT_LINE('사원급여 : ' ||ISAL);
     EXIT WHEN INFO03%NOTFOUND;
     
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('총 사원 수 : '|| INFO03%ROWCOUNT);
    
    CLOSE INFO03;
end;
/

EXEC EINFO03;


커서에도 필요하면 파라미터를 받아서 사용할 수 있다.
CURSOR 커서이름(파라미터 변수 선언) IS
질의명령
;

CREATE OR REPLACE PROCEDURE EINFO04(
    DNO IN EMP.DEPTNO%TYPE
)
IS
    CURSOR GETNAME02(CDNO EMP.DEPTNO%TYPE) IS
        SELECT
            ENAME
        FROM
            EMP
        WHERE
            DEPTNO= CDNO
        ;

   -- NAME EMP.ENAME%TYPE;
BEGIN
        DBMS_OUTPUT.PUT_LINE('입력부서번호 : '|| DNO);
    FOR TMP IN GETNAME02(DNO) LOOP
        DBMS_OUTPUT.PUT_LINE('사원이름 : '|| TMP.ENAME);
    END LOOP;
        DBMS_OUTPUT.PUT_LINE('------------------------------');
        DBMS_OUTPUT.PUT_LINE('입력부서번호 : '|| 10);
    FOR TMP IN GETNAME02(10) LOOP
        DBMS_OUTPUT.PUT_LINE('사원이름 : '|| TMP.ENAME);
    END LOOP;
     DBMS_OUTPUT.PUT_LINE('------------------------------');
        DBMS_OUTPUT.PUT_LINE('입력부서번호 : '|| 20);
    FOR TMP IN GETNAME02(20) LOOP
        DBMS_OUTPUT.PUT_LINE('사원이름 : '|| TMP.ENAME);
    END LOOP;
     DBMS_OUTPUT.PUT_LINE('------------------------------');
        DBMS_OUTPUT.PUT_LINE('입력부서번호 : '|| 30);
    FOR TMP IN GETNAME02(30) LOOP
        DBMS_OUTPUT.PUT_LINE('사원이름 : '|| TMP.ENAME);
    END LOOP;
END;
/

EXEC EINFO04(30);


SELECT
    EMPNO
FROM
    TMP1
WHERE
    DEPTNO=30
    AND
    HIREDATE=(SELECT MAX(HIREDATE) FROM EMP WHERE DEPTNO =30)
;
참고/
WHERE CURRENT OF 절
-커서를 이용해서 다른 질의명령을 실행하기 위한 방법
마치 서브질의처럼 하나의 질의 명령을 실행할 때 필요한 서브질의를
커서로 만들어서 사용하는 방법

CREATE OR REPLACE PROCEDURE EDITJOB01(
    DNO EMP.DEPTNO%TYPE,
    IJOB EMP.JOB%TYPE
)
IS 
    CURSOR GETENO01 IS
                      SELECT EMPNO FROM TMP1
                      WHERE HIREDATE=(SELECT MAX(HIREDATE) FROM TMP1 WHERE DEPTNO =DNO)
                      FOR UPDATE
                    ;
BEGIN 
    FOR TMP IN GETENO01 LOOP
        UPDATE
            TMP1
        SET
            JOB=IJOB
        WHERE CURRENT OF GETENO01;
    END LOOP;
END;
/

EXEC EDITJOB01(10,'MANAGER');

EXEC EDITJOB01(20, 'MANAGER');
ROLLBACK;

