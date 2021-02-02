drop table tmp;

create table tmp
as select *from emp;


DROP VIEW TVIEW;
create view tview
as select ename, sal from Tmp; 

grant create any view to SCOTT;

SELECT * FROM TVIEW;
UPDATE 
    TVIEW
SET
    SAL=850
WHERE
    ENAME='SMITH'
;

SELECT
    ENAME, SAL
FROM
    TMP
WHERE
    ENAME='SMITH'
;
ROLLBACK;

CREATE VIEW TMPCALC
AS
    SELECT DEPTNO DNO, COUNT(*) CNT, MAX(SAL) MAX, MIN(SAL) MIN, AVG(SAL) AVG, SUM(SAL) SUM 
    FROM TMP GROUP BY DEPTNO;
    
SELECT
    ENAME, SAL, AVG,CNT
FROM
    TMP, TMPCALC
WHERE
    DEPTNO=DNO
    AND SAL>AVG
;

SELECT
    VIEW_NAME, TEXT
FROM
    USER_VIEWS
;
DROP VIEW VD20;

CREATE VIEW VD20
AS
    SELECT
        ENAME, JOB, DEPTNO
    FROM
        TMP
    WHERE
        DEPTNO=20
    WITH CHECK OPTION
    ;
INSERT INTO 
    VD20
VALUES('홍길동','영업',20
);
INSERT INTO 
    VD20
VALUES('고길동','환경',30
);


CREATE VIEW VD10
AS
SELECT 
ENAME, JOB, DEPTNO
FROM
TMP
WHERE
DEPTNO=20;

INSERT INTO
VD10
VALUES(
'고길동','환경',30);

CREATE VIEW VD30
AS 
    SELECT 
        ENAME, JOB, DEPTNO   
    FROM
        TMP
    WHERE
        JOB='MANAGER'
WITH READ ONLY
;
INSERT INTO
VD30
VALUES(
'고길동','환경',30);


CREATE OR REPLACE FORCE VIEW MEMBER_VIEW
AS
    SELECT 
        NAME, ID, MAIL
    FROM
        MEMBER
   WITH READ ONLY
;
CREATE VIEW EMPVIEW
AS 
    SELECT
        ENAME, JOB, DNAME, SAL, GRADE
    FROM 
        EMP E, DEPT D, SALGRADE S
    WHERE
        E. DEPTNO=D.DEPTNO AND
        SAL BETWEEN LOSAL AND HISAL
    ;

select
    deptno, sum(sal), avg(sal)
from
    emp
group by
    deptno
having
    sum(sal)=( select
                    max(sum(sal))
                from
                    emp
                group by
                    deptno)
                    ;