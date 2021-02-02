
create view v01
as 
    select 
        avg(sal) avg, max(sal) max
    from 
        emp
    ;
    
--1
select
   ename, sal, avg
from
   emp, v01
where
    sal<avg 
;

--2
select
    ename, empno, job, dname, sal, max
from
    emp e, dept d, v01
where
    e. deptno= d.deptno
    and 
    sal=max;

--3
create view v02
as
    select deptno, sum(sal) sum, avg(sal) avg, count(*) count from emp group by deptno;
    
-- drop view v02;
select
    ename, job, sal, e.deptno,dname, sum
from
    emp e, dept d, v02 v
where
    e. deptno=d. deptno
    and d.deptno= v.deptno
    and sum=(select max(sum) from v02);
--4
select
    ename, sal, grade, dname, avg
from
    emp e, dept d, salgrade, v02
where
    e.deptno=d.deptno
    and e.deptno=v02.deptno
    and sal between losal and hisal
    and sal>avg;
--5
select
    ename, job, sal, dname, avg, count
from
    emp e, dept d, v02
where
    e.deptno= d.deptno
    and e.deptno=v02.deptno
    and sal< avg
    and count=(select max(count) from v02);
    
    
--5.2   
select
    ename, job, sal, dname
    
from
    emp
where
    sal<(select avg(sal) from emp group by deptno)and max((select count(*)from emp group by deptno))
;

select
     sum(sal), avg(sal)
from
    emp
group by
    deptno;
select
    ename, sal, max, deptno
from
    emp join(
                select 
                    deptno dno, max(sal) max
                from
                    emp
                group by
                    deptno)
on 
    deptno=dno
where
    sal=max
order by
    deptno,ename
;
select
    rownum, r.*
from(
select
    empno, ename, sal, job
from
    emp
order by
    sal) r
;
select 
    rno, empno,ename, job, sal
from(
select
    rownum rno,empno,ename, job, sal
from
    (
        select
            empno, ename, job, sal
        from
            emp
        order by
            sal
            ))
where
    rno between 4 and 6
            ;
            
select
    rno, empno, ename, job,hiredate
from         
(select
    rownum rno,empno, ename, job, hiredate
from
    (select
        empno, ename, job, hiredate
    from
        emp
    order by
        hiredate)) 
where
    rno between 7 and 10;