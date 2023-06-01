

create database projects;
use projects;

ALTER TABLE `projects`.`human resources` 
RENAME TO  `projects`.`hr` ;

drop table hr;
SELECT * FROM hr;

alter table hr
change column ï»¿id emp_id varchar(20) NULL;

describe hr;

select birthdate from hr;

set sql_safe_updates = 0;


update hr
set birthdate = case
	when birthdate like '%/%' then date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
	when birthdate like '%-%' then date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    else NULL
end;

select birthdate from hr;

alter table hr
modify column hire_date date;

update hr
set hire_date = case
	when hire_date like '%/%' then date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
	when hire_date like '%-%' then date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    else NULL
end;


select hire_date from hr;


UPDATE hr
SET hire_date = STR_TO_DATE(hire_date, '%m/%d/%Y')
WHERE hire_date <> '' AND hire_date IS NOT NULL;


alter table hr
modify column hire_date date;

describe hr;


select termdate from hr;

update hr
set termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
where termdate is not null and termdate !='';

UPDATE hr
SET termdate = NULL
WHERE termdate = '';

select termdate from hr;

alter table hr
modify column termdate date;


describe hr;

alter table hr
add column age int;

select * from hr;

update hr
set age = timestampdiff(year, birthdate, curdate());


select birthdate, age from hr;
select min(age)  as youngest, max(age)  as oldest 
from hr;

-- Q1 What is the gender breakdown of employees in the company?


select gender, COUNT(*) as count
from hr
where age >= 18 AND termdate is not NULL
group by gender;



-- Q2 What is the race distribution of employees in the company?
select race, COUNT(*) as count
from hr
where age >= 18 AND termdate is not NULL
group by race
order by count desc;



-- Q3 What is the age distribution of employees in the company?
select min(age) as youngest, max(age) as oldest
from hr
where age >= 18 AND termdate is not NULL;

select
case
when age >=18 and age <=24 then '18-24'
when age >=25 and age <=34 then '25-34'
when age >=35 and age <=44 then '35-44'
when age >=44 and age <=54 then '44-54'
when age >=55 and age <=64 then '55-64'
else '65+'
end as age_group,
count(*) as count
from hr
where age >= 18 AND termdate is not NULL
group by age_group
order by age_group;

select
case
when age >=18 and age <=24 then '18-24'
when age >=25 and age <=34 then '25-34'
when age >=35 and age <=44 then '35-44'
when age >=44 and age <=54 then '44-54'
when age >=55 and age <=64 then '55-64'
else '65+'
end as age_group,gender,
count(*) as count
from hr
where age >= 18 AND termdate is not NULL
group by age_group, gender
order by age_group, gender;

-- Q4 How many employees work at headquartes versus remote locations?
select location, count(*) as count
from hr
where age >= 18 AND termdate is not NULL
group by location;

-- Q4 What is the average length of employment for employees who have been terminated?
select avg(datefiff(termdate, hire_date))/365 as avg_length_employment
from hr
where age >= 18 AND termdate<= curdate() and termdate is not NULL;


-- Q5 What is the average length of employment for employees who have been terminated?
select round(avg(datediff(termdate, hire_date))/365, 0) as avg_length_employment
from hr
where age >= 18 AND termdate<= curdate() and termdate is not NULL;




-- Q6 How does the gender distribution vary across departments and job titles?
select department, gender, count(*) as count 
from hr
where age >= 18 AND termdate<= curdate() and termdate is not NULL
group by department, gender
order by department;


-- Q7 what is the distribution of job titles across the company?
select jobtitle, count(*) as count 
from hr
where age >= 18 AND termdate<= curdate() and termdate is not NULL
group by jobtitle
order by jobtitle desc;

-- Q8 Which department has the highest turnover rate?
select department, total_count, terminated_count,terminated_count/total_count as termination_rate
from (select department,
		count(*) as total_count,
        sum(case when termdate is not null and termdate <= curdate() then 1 else 0 end) as terminated_count
from hr
where age >= 18
group by department
) as subquery
order by termination_rate desc;


-- Q9 What is the distribution of employees across locations by city and state?
select location_state, count(*) as count
from hr
where age >= 18 AND termdate<= curdate() and termdate is not NULL
group by location_state
order by count desc;


-- Q10 How is the employee coutn changed over time based on hire and term dates?
select 
year,
hires,
terminations,
hires - terminations as net_change,
round((hires - terminations)/hires * 100,2)  as net_change_percent
from (
		select year(hire_date) as year,
        count(*) as hires,
        sum(case when termdate is not null and termdate <= curdate() then 1 else 0 end) as terminations
from hr
where age >= 18 
group by year (hire_date)
) as subquery
order by year asc;

-- Q11 what si the tenure distribution for eah department?
select location_state, count(*) as count
from hr
where age >= 18 AND termdate<= curdate() and termdate is not NULL