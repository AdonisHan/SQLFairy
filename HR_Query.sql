--  1. . 이름이 'adam' 인 직원의 급여와 입사일을 조회하시오.
select first_name, salary, hire_date
from employees
where lower(first_name) = 'adam'
;


-- 2. 나라 명이 'united states of america' 인 나라의 국가 코드를 조회하시오.
select country_name 나라명, postal_code 국가코드
from locations l, countries c
where l.country_id = c.country_id
     and lower(country_name) = 'united states of america';

-- 3. 'Adam의 입사일은 95/11/02 이고, 급여는 7000 입니다.' 
select first_name ||'의 입사일은' || hire_date || '이고, 급여는' || salary ||'입니다.'
from employees
where lower(first_name) = 'Adam'
;
-- 4. 이름이 8글자 이상인 직원들의 이름, 급여, 입사일을 조회하시오.
select *
from employees
where length(first_name) >= 8
;

--  5. 96년도에 입사한 직원의 이름, 입사일을 조회하시오.
select first_name 이름, hire_date 입사일, salary 급여
from employees 
where hire_date like '1997%'
;

-- 6. 각 부서별 인원수를 조회하되 인원수가 5명 이상인 부서만 출력되도록 하시오. -- 
select department_name 부서명, count(*)
from departments d, employees e
where e.department_id = d.department_id
group by department_name
;

-- 7. 최대,최소 급여 -- 
select department_name, max(salary), min(salary)
from employees e, departments d
where e.department_id = d.department_id
group by department_name
;

-- 8. 부서가 50, 80 , 110번인 직원들 중에서 급여를 5천 이상 24000이하로 받는 직원들을 대상으로 부서별 평균급여 
-- 평균급여 8천이상인 부서 --

select department_id 부서아이디, round(avg(salary)) 평균급여
from employees
where department_id in (50,80,110) and salary between 5000 and 24000
group by department_id
having avg(salary) >= 8000
order by 2 desc;

-- 9. 직원들의 이름과 직급명(job_title)조회
select job_title, first_name
from employees e, jobs j
where e.job_id = j.job_id
;

-- 10. job_title = manager, 직책(job_title)이 'manager' 인 사람의 이름, 
-- 직책, 부서명을 조회하시오.

select first_name, job_title, department_name
from jobs j, employees e, departments d
where e.job_id = j.job_id and e.department_id = d.department_id
and lower(job_title) like '%manager'
;

/*** 11.
1. 사원 수가 4명 이상의 사원을 포함하고 있는 부서의 
2. 부서번호(department_id), 부서이름, 사원 수, 최고급여, 최저급여, 평균급여, 급여총액을 조회하여 출력하십시오. (평균급여 계산시 소수점 이하는 절사하십시오)
3.출력 결과는 부서에 속한 사원의 수가 많은 순서로 출력하고, 컬럼명은 아래 결과와 동일하게 출력하십시오. 
4. 사원 수가 동일할 경우 급여 총액이 많은 순으로 출력하십시오.   ***/

select d.department_id, d.department_name, count(*), max(e.salary), min(e.salary), round(avg(e.salary)), sum(e.salary)
from employees e, departments d
where e.department_id = d.department_id
group by d.department_id, d.department_name
having avg(e.salary) >= 8000
order by count(*) desc, sum(e.salary) desc
;

/*** 12.
1.급여 평균보다 연봉을 적게 받는 사원들 중
     2. 커미션을 받는 사원들의 사번(employee_id), 이름(first_name),
 성(last_name), 급여(salary), 커미션 퍼센트(commition_pct)를 출력 하시오.
 3. 커미션 퍼센트는 아래와 같이 보너스로 바꾼다.  ***/
 
select employee_id, first_name, last_name, salary, commission_pct bonus
from employees
where salary < (select avg(salary) from employees) and (commission_pct is not null)
;
 
 /***  13.
 1. Select 1999년 입사한(hire_date) 직원들의 사번(employee_id), 이름(first_name), 
 성(last_name), 부서명(department_name)을 조회합니다.
 2. 이때, 부서에 배치되지 않은 직원의 경우, ‘<NOT ASSIGNED>’로 보여주고 
 3. 정렬은 성(last_name) 을 기준으로 결과와 같이 출력합니다. ***/
 
select e.employee_id, e.first_name, e.last_name, ifnull(d.department_name, '<NOT ASSIGNED>')
from employees e, departments d
where (e.department_id = d.department_id) and substr(e.hire_date,1,2) = '99'
order by last_name;
;

/*** 14.
1. 업무명(job_title)이 ‘Sales’로 시작하는 직원 중에서 
	2.연봉(salary)이 10,000 이상, 20,000 이하인 
	3. 직원들의 이름(first_name), 성(last_name)과 연봉(salary)을 출력하시오.
	4. 단 급여가 많은 순으로 출력하시오. ***/

select j.job_title,first_name, e.last_name, e.salary
from employees e, departments d, jobs j
where e.department_id = d.department_id and j.job_id = e.job_id
and j.job_title in (select job_title from jobs where lower(job_title) like '%sales%')
and e.salary between 10000 and 20000
;

/*** 15.
입사 년도별 직원수를 출력하십시오. 
직원수가 많은 년도가 먼저 출력되도록 검색된 데이터를 정렬하여 출력되도록 하되 사원 수 가 10명 이상인 년도만 출력합니다. 
출력 결과는 예시와 동일하게 출력되어야 합니다. ***/

select count(*), substr(hire_date,1,2)
from employees
group by substr(hire_date,1,2)
having count(*) >10
order by count(*) desc;
;

/***16.
 1. 매니저 이면서, 
	2. Email의 길이가 5자리가 넘는 직원들의 
    3. 사번(employee_id), 이름(first_name), 부서ID(department_id), 이메일(email), 전화번호(phone_number)를 조회합니다.
    4. 이때, 사번이 작은 직원부터 출력합니다. ***/

select distinct e2.employee_id, e2.first_name, e2.department_id, e2.email, e2.phone_number
from employees e1, employees e2
where e1.manager_id = e2.manager_id and length(e1.email) >= 5
order by e2.employee_id
;

-- 17. department_id 가 90인 사람 기술하시오 --

select DEPARTMENT_ID, LOCATION_ID 
from departments 
where department_id in (90) 
;

-- 17 (2) department_id 가 90인 부서의 도시명을 알아내는 SELECT 문장을 기술하시오.
SELECT D.DEPARTMENT_ID 부서번호,L.CITY 도시명
FROM (
    SELECT DEPARTMENT_ID, LOCATION_ID
    FROM DEPARTMENTS
    WHERE DEPARTMENT_ID IN (90)
    )D
    , LOCATIONS L
WHERE D.LOCATION_ID = L.LOCATION_ID
;
/** 18.
과거: job_id 가 IT_Prog 였던 사원의 
현재: job_id, job_title, min_salary, max_salary 를 
실행결과와 같이 출력하시오. **/

select job_id, job_title, min_salary, max_salary
from jobs
where job_id in(

select job_id 
from employees
where employee_id in(

select employee_id 
from job_history
where job_id = 'IT_PROG'

)
)
;