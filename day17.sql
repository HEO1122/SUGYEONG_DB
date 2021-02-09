���̺� Ÿ���� ����
pl/sql���� �迭�� ǥ���ϴ� ���

set serveroutput on;
select
    empno
from
    tmp1
;

����
���̺� Ÿ�� �����ϴ� ���
type ���̺��̸� is table of ������Ÿ��1
index by ������Ÿ��2;

1)
������Ÿ��1
������ ���� �������� ����
������Ÿ��2
�迭�� ��ġ���� ����� �������� ����(99.9% binary_integer : 0,1,2,3,...)

2)
����) �����̸� ���̺��̸�;
���ǵ� ���̺��̸��� ���·� ������ ���弼��.


���̺�Ÿ���̶� ������ �������� �ʴ´�.
���� ���� ���̺� Ÿ���� �����ϰ�
���ǵ� ���̺� Ÿ���� �̿��ؼ� ������ �����ؾ� �Ѵ�.

for���

����1)
for �����̸� in (���Ǹ��) loop
    ó������;
    ...
end loop;
�ǹ�: ���Ǹ���� ����� ������ ���پ� ����� �� ���ϴ� ������ ó���ϵ��� �Ѵ�.

����2)
for �����̸� in ���۰�..���ᰪ loop
    ó������;
end loop;
�ǹ�) ���۰����� ���ᰪ���� 1�� ������Ű�鼭 ó�������� �ݺ���Ų��.

����) �μ���ȣ�� �˷��ָ� �ش�μ�  �Ҽ��� ������� �̸�, ����, �޿��� ��ȸ�ؼ� ����ϵ��� 
���ν���()�� ����  �����ϼ���.

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

name name_table;--�ڵ��迭
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
        dbms_output.put_line('����̸�'|| name(cnt));
        dbms_output.put_line('�������'|| vjob(cnt));
        dbms_output.put_line('����޿�'|| vsal(cnt));
    end loop;
end;
/

execute p2_emp_info01(10);

2.���ڵ� Ÿ��
������ ����� ������ ������ ����� ���
%rowtype�� �ϳ��� ���̺��� �̿��ؼ� ��� ������ �ڵ����� ����� ����̴�.
���ڵ� Ÿ���� ����ڰ� ������ ��� ������ ���� �� �ִٴ� ���������ִ�.

1.���ڵ� Ÿ���� �����Ѵ�.
type ���ڵ� �̸� is recode(
��������̸�1 ������Ÿ��,
��������̸�2 ������Ÿ��,
...
);

2.���ǵ� ���ڵ� Ÿ���� �̿��ؼ� ������ �����Ѵ�. 
�����̸� record �̸�;
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
    dbms_output.put_line('����̸�: '|| vemp.name);
    dbms_output.put_line('�������: '|| vemp.ijob);
    dbms_output.put_line('����޿�: '|| vemp.isal);
    dbms_output.put_line('����޿����: '|| vemp.igrade);
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

3.���ڵ� Ÿ���� �迭
-���� �ΰ��� ����Ŭ PL/SQL Ÿ���� ȥ���ؼ� ����� ��.

1. ���ڵ� Ÿ���� ����(��� ������ ���� ����)
2. �̰��� �̿��ؼ� �ٽ� ���̺� Ÿ���� ���� ����Ѵ�.( �迭 ����)

CREATE OR REPLACE PROCEDURE JOB_INFO(
    JIKGP EMP.JOB%TYPE
)
IS
    TYPE EMP_TAB IS TABLE OF EMP%ROWTYPE
    INDEX BY BINARY_INTEGER;
    
    JEMP EMP_TAB;
    I BINARY_INTEGER;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('#####TMP����####### ');
    FOR TMP IN(SELECT ENAME, SAL, HIREDATE FROM EMP WHERE JOB=JIKGP) LOOP
    
      
    DBMS_OUTPUT.PUT_LINE('����̸�: '|| TMP.ENAME);  
    DBMS_OUTPUT.PUT_LINE('����޿�: '|| TMP.SAL);
    DBMS_OUTPUT.PUT_LINE('�Ի���  : '|| TMP.HIREDATE);
    
    I:=I+1;
    JEMP(I).ENAME:= TMP.ENAME;
    JEMP(I).SAL:=TMP.SAL;
    JEMP(I).HIREDATE:=TMP.HIREDATE;
    
     
    END LOOP;
     DBMS_OUTPUT.PUT_LINE(' ');
     DBMS_OUTPUT.PUT_LINE('#####JEMP����####### ');
    FOR CNT IN 1..I LOOP
    
          
    DBMS_OUTPUT.PUT_LINE('����̸�: '|| JEMP(CNT).ENAME);  
    DBMS_OUTPUT.PUT_LINE('����޿�: '|| JEMP(CNT).SAL);
    DBMS_OUTPUT.PUT_LINE('�Ի���  : '|| JEMP(CNT).HIREDATE);
    
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
    
    DBMS_OUTPUT.PUT_LINE('����̸� : ' || TMP.ENAME);
    DBMS_OUTPUT.PUT_LINE('������� : ' || TMP.JOB);
    DBMS_OUTPUT.PUT_LINE('�μ� : ' || TMP.DEPTNO);
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || TMP.SAL;
    DBMS_OUTPUT.PUT_LINE('�޿���� : ' || TMP.SALGRADE);
    
    I:=I+1;
    HEMP(I).ENAME := TMP.ENAME;
    HEMP(I).JOB := TMP.JOB;
    HEMP(I).DEPTNO := TMP.DEPTNO;
    HEMP(I).SAL := TMP.SAL;
    HEMP(I).SALGRADE := TMP.SALGRADE;
    
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(' HEMP����'
    FOR CNT IN 1..I LOOP
    DBMS_OUTPUT.PUT_LINE('����̸� : ' || HEMP(CNT).ENAME);
    DBMS_OUTPUT.PUT_LINE('������� : ' || HEMP(CNT).JOB);
    DBMS_OUTPUT.PUT_LINE('�μ� : ' || HEMP(CNT).DEPTNO);
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || HEMP(CNT).SAL;
    DBMS_OUTPUT.PUT_LINE('�޿���� : ' || HEMP(CNT).SALGRADE);
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

2.while ���ǽ�1 loop
ó������;
exit when ���ǽ�2;
end loop;
=���ǽ� 1�� ���̸� �ݺ� ���ǽ�2�� ���̸� �ݺ�����


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
3. do ~ while ���
loop
    ó������;
    ...
    
    exit when ���ǽ�;
end loop;

���ǹ�

if ���
���ǽ��� ������ ���� ��츸 ó�� ������ ��� ó������1) if ���ǽ� then ó������; ... end if;

������ ��, ������ ��� 2���� ��� ó���Ѵ�. 2)if ���ǽ� then  ���� ��� ���೻�� else ������ ��� ���೻�� end if;

3)if ���ǽ�1 then ó������1 elsif ���ǽ�2 then ó������2 elsif ���ǽ�3 then ó������3 ... else ó������n end if;


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
        DBMS_OUTPUT.PUT_LINE('����̸� : ' ||egrade(cnt).name);
        DBMS_OUTPUT.PUT_LINE('�޿� : ' || egrade(cnt).sal);
        DBMS_OUTPUT.PUT_LINE('�޿���� : ' || egrade(cnt).grade);
    END LOOP;
end;
/

exec salgrade_proc02;


#Ŀ��(cursor): ������ ����Ǵ� ���� ����� ����ϴ� ����

���� ����ϴ� ���� ����� �ѹ��� ���� �� �̰�(���� ��� ��ü)�� 
������ ����ؼ� ��ġ ������ ����ϵ��� ���Ǹ� �����ϴ� ��.

�Ͻ��� Ŀ��
-�̹� ����Ŭ���� �����ϴ� Ŀ���� ���Ѵ�.
�츮�� ���ݱ��� ����ߵ�� ���� ���� ����� ���� ��� ��ü�� �ǹ��Ѵ�.

���� Ŀ������ ���� ����(�������)�� �����Ѵ�.

sql%rowcount
������ ��Ÿ�� ���ڵ��� ������ ����� �������

sql%found
�������� �������� ��Ÿ���� �������

sql%notfound
�������� �������� ������ ��Ÿ���� �������

sql%isopen
Ŀ���� ������������� �˾Ƴ��� �������

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
        dbms_output.put_line('####����� �������� �ʽ��ϴ�.###');
    end if;
        if sql%found then
    
        dbms_output.put_line('|�����ȣ | ����̸�|');
        dbms_output.put_line(rpad('-',23,'-'));
        dbms_output.put_line('|'|| lpad(to_char(eno),8,' ') || '|'||rpad(name,8,' ')||'|');
        dbms_output.put_line(rpad('-',23,'-'));
    end if;
    exception when no_data_found then 
    dbms_output.put_line('####����� �������� �ʽ��ϴ�.###');
end;
/

exec getname01(7902);

exec getname01(7500);

����� Ŀ��
���� ����ϴ� ���Ǹ���� �̸� ���� �� �ʿ��ϸ� ���Ǹ���� ������ �̿��ؼ� �����ϵ��� �ϴ� ��.

����� Ŀ���� ó�� ����
1. ����� Ŀ���� �����.
    (����� Ŀ���� ����)
    
    ���� : cursor Ŀ���̸� is 
            �ʿ��� ���� ���
            ;
            
2. �ݵ�� Ŀ���� ���ν������� ���� �����ϵ��� ��ġ�Ѵ�.
    (Ŀ���� ���½�Ų��.)
    ���� : open Ŀ���̸�;

3. ���� ����� �����Ѵ�.
    (Ŀ���� fetch��Ų��.)
    ����: fetch Ŀ���̸�;
    
4. ����� ���� Ŀ���� ȸ���Ѵ�.
    (Ŀ���� close��Ų��)
    ���� : close Ŀ���̸�;
    
����/ ���� Ŀ���� for loop ��� �ȿ��� ���Ǹ�
        �ڵ� open, fetch, close �� �ȴ�.

    
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
    dbms_output.put_line('�μ���ȣ : '||dno);
    dbms_output.put_line('�μ��̸� : '||d_name);
    dbms_output.put_line('�μ���� : '||round(avg1,2));
    dbms_output.put_line('�μ����� : '||cnt);
    
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
    dbms_output.put_line('�μ��̸� : '||dinfo.dname);
    dbms_output.put_line('�μ���� : '||dinfo.s_avg);
    dbms_output.put_line('�μ����� : '||dinfo.cnt);
    
    end loop;
end;
/


����/ ����� Ŀ������ ��� ������ ����� �� �ִ�.
��� ������ �������� �Ͻ��� Ŀ���� �����ϴ�.

���� ������� �̸�, ����, �޿��� ��ȸ�ؼ� ����ϴ� ���ν����� �ۼ��ϰ� �����ϼ���.
�� ���������� ��µ� ����� ��(�� ��� ��)�� ���� ����ϼ���


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
        DBMS_OUTPUT.PUT_LINE('�� ��� �� : '|| INFO03%ROWCOUNT);

    LOOP
     FETCH INFO03 INTO NAME, IJOB, ISAL;
     DBMS_OUTPUT.PUT_LINE('����̸� : ' ||NAME);
     DBMS_OUTPUT.PUT_LINE('������� : ' ||IJOB);
     DBMS_OUTPUT.PUT_LINE('����޿� : ' ||ISAL);
     EXIT WHEN INFO03%NOTFOUND;
     
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('�� ��� �� : '|| INFO03%ROWCOUNT);
    
    CLOSE INFO03;
end;
/

EXEC EINFO03;


Ŀ������ �ʿ��ϸ� �Ķ���͸� �޾Ƽ� ����� �� �ִ�.
CURSOR Ŀ���̸�(�Ķ���� ���� ����) IS
���Ǹ��
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
        DBMS_OUTPUT.PUT_LINE('�Էºμ���ȣ : '|| DNO);
    FOR TMP IN GETNAME02(DNO) LOOP
        DBMS_OUTPUT.PUT_LINE('����̸� : '|| TMP.ENAME);
    END LOOP;
        DBMS_OUTPUT.PUT_LINE('------------------------------');
        DBMS_OUTPUT.PUT_LINE('�Էºμ���ȣ : '|| 10);
    FOR TMP IN GETNAME02(10) LOOP
        DBMS_OUTPUT.PUT_LINE('����̸� : '|| TMP.ENAME);
    END LOOP;
     DBMS_OUTPUT.PUT_LINE('------------------------------');
        DBMS_OUTPUT.PUT_LINE('�Էºμ���ȣ : '|| 20);
    FOR TMP IN GETNAME02(20) LOOP
        DBMS_OUTPUT.PUT_LINE('����̸� : '|| TMP.ENAME);
    END LOOP;
     DBMS_OUTPUT.PUT_LINE('------------------------------');
        DBMS_OUTPUT.PUT_LINE('�Էºμ���ȣ : '|| 30);
    FOR TMP IN GETNAME02(30) LOOP
        DBMS_OUTPUT.PUT_LINE('����̸� : '|| TMP.ENAME);
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
����/
WHERE CURRENT OF ��
-Ŀ���� �̿��ؼ� �ٸ� ���Ǹ���� �����ϱ� ���� ���
��ġ ��������ó�� �ϳ��� ���� ����� ������ �� �ʿ��� �������Ǹ�
Ŀ���� ���� ����ϴ� ���

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

