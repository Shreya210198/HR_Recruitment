--- Create database for Recruitment

create database recruitment

use recruitment

-- create a structure or schema for your data as a container

create table Hr_recruitment
(Position varchar(max),	full_name varchar(max),	Gender varchar(max),Salary varchar(max),Department varchar(max),
DepartmentName varchar(max),Division varchar(max),	AssignmentCategory varchar(max),Title varchar(max),
HiringAnalyst varchar(max),	VacancyStatus varchar(max),	VacancyDate varchar(max),	BudgetDate	varchar(max),
PostingDate	varchar(max),InterviewDate varchar(max),	OfferDate varchar(max),	AcceptanceDate	varchar(max),
SecurityCheckDate varchar(max),	Hire varchar(max))

select * from HR_recruitment


--- Let's insert the data in this container

-- path of my file-- "C:\Users\sreya\Downloads\Hr_recruitement.csv"

bulk insert Hr_recruitment
from "C:\Users\sreya\Downloads\Hr_recruitement.csv"
with (fieldterminator=',',rowterminator='\n', firstrow=2, maxerrors=40)


select column_name, data_type
from information_schema.columns
where table_name='Hr_recruitment' 


alter table hr_recruitement
alter 

select * from hr_recruitment

select column_name, data_type
from information_schema.columns
where table_name='Hr_recruitment' 

--- Position-- we are keeping as it is though they are sequential numbers used as a key(id)
-- Name- varchar is fine, we'll remove the delimeter (:)
-- Gen-varchar
--Salary- decimal
--Depart- Departname- varchar
--Division- varchar
--assignment cat- varchar
--title- hiring analyst- vacancy status- varchar
-- All dates columns need to be in date datatype

alter table hr_recruitment
alter column salary decimal (10,2)

--- there must be some non numeric values

select * from hr_recruitment
where isnumeric(salary)=0   

-- this function will check the non numeric values which are restricting to change the datatype


alter table hr_recruitment
alter column vacancydate date

alter table hr_recruitment
alter column budgetdate date

alter table hr_recruitment
alter column Hiredate date

--- Check for duplicates--

select * from Hr_recruitment

select distinct count(*) from hr_recruitment

select * from Hr_recruitment

-- dense_rank, Rank, row_number
-- which window func will provide the unique sequence

with dupl_rows as(select *, row_number() over(partition by position order by position) as row_num
from hr_recruitment)
select * from dupl_rows
where row_num>1

-- there is no duplicate rows in our data

select * from hr_recruitment
where isnumeric(salary)=0

select * from hr_recruitment
where salary  like '%[@#$%^&*)_+=-]%' or salary  like '%[-]%'


-- I need to remove the special characters from the salary to make in the numeric format

--- consider there are n numbers of non numeric values

--- DML- Update

update Hr_recruitment set salary= case when Salary like '%[@#$%^&*)_+=-]%' or salary  like '%[-]%' Then 
	replace(replace(salary,substring(salary,patindex('%[~!@#$%&*^()_+-]%',salary),1),''),'-','')
	else salary end 

	Select Salary, case when Salary like '%[@#$%^&*)_+=-]%' or salary  like '%[-]%' Then 
	replace(replace(salary,substring(salary,patindex('%[~!@#$%&*^()_+-]%',salary),1),''),'-','') 
	else salary end from hr_recruitment
	where isnumeric(salary)=0


	select salary, case when salary='3906%2' then '39062'
					when salary='390^62' then '39062'
					when salary='7281--2' then '72812' else salary end from hr_recruitment
					where isnumeric(salary)=0
-- Charindex()-- Patindex(

select salary, patindex('%[~!@#$%&*^()_+-]%',salary) from hr_recruitment
where isnumeric(salary)=0
select * from hr_recruitment
where salary like '%[^0-9]%'

select salary from hr_recruitment
where isnumeric(salary)=0

alter table hr_recruitment
alter column salary decimal(10,2)

select Column_name, data_type 
from information_schema.columns
where table_name='Hr_recruitment'

select full_name from Hr_recruitment

update Hr_recruitment set full_name=replace(full_name,':','')

select full_name , replace(full_name,':','') from hr_recruitment

select * from hr_recruitment

select Full_name from hr_recruitment
where full_name is null

select * from hr_recruitment
where vacancystatus='vacant'

---- on the basis of genders we can segregate the matrices
-- avg(salary) by the genders
--

select min(hiredate), max(hiredate), 
datediff(year, (select min(hiredate) from hr_recruitment), (select max(hiredate) from hr_recruitment)) 
from hr_recruitment;

-- I want to analyse the last 5 years recruitment summary with the maxdate(30-01-2015)
--- the HR_department wants to identify the departments with the potential skills gaps by analysing the avg sal difference 
---between the employees hired within the year of data who have been here more than 5 years

-- plan to execute the query for the desired output
--- identify what columns/fields are expecting as an output
-- does they are coming from physical storage(table) or need to calculate
-- if Physical storage data , whether it requires the filteration or any conditional labelling (Case when)
-- what calculation is required?
--- does it need any grouping (based on some fields need aggregate data)
-- if we have calculation based on calculated result use CTE(with)

--- our plan-- we need to go by the department so we can use group by in the main query
-- the lastdate is max(date) and a date which is 5 years earlier than date

select max(hiredate),round(dateadd(year, -5,(select max(hiredate) from hr_recruitment)) from hr_recruitment

select departmentname,GENDER, round(coalesce((avg(case when Hiredate>=dateadd(year,-1,max_date) then salary End)
						/* recently hired in a year*/
					-avg(case when hiredate<dateadd(year,-5,max_date) then salary end)),0),2)
					/* the hired employee 5 years ago*/
					avg_difference_insal
from ( select departmentname,
				HireDate,
				GENDER,
				Salary,
				vacancystatus,
				(select max(hiredate) from hr_recruitment) as max_date
				from hr_recruitment) as Hr_rcd
				where vacancystatus='Filled'
				group by departmentname,GENDER
				order by avg_difference_insal desc

-- Interpretation of  output-
-- we have 3 types of values in the result

SELECT MAX(HIREDATE) FROM Hr_recruitment

SELECT DATEADD(YEAR,-5,(SELECT MAX(HIREDATE) FROM Hr_recruitment)) FROM Hr_recruitment



select top (case when) , from (case when), where, group by, having, order by case when offset and fetch)

--
select dateadd(day,-5,getdate())

select datediff(day,'2024-04-12',getdate())
select * from hr_recruitment
where hiredate = (select max(hiredate) from hr_recruitment)



SELECT count(*) FROM HR_RECRUITMENT
SELECT count(full_name) FROM HR_RECRUITMENT
---SCENARIO 2-  The Department want to analyze the distribution of hired employees for various titles on each department

select  departmentname,title, Count(full_name) as Countof_emp from hr_recruitment
group by departmentname,title
order by Countof_emp 

-- find out the top 5 department where they hired more employees than the other departments

select  top 5 departmentname, Count(full_name) as Countof_emp from hr_recruitment
group by departmentname
order by Countof_emp desc

-- least five
select  top 5 departmentname, Count(full_name) as Countof_emp from hr_recruitment
group by departmentname
order by Countof_emp 

--Scenario 3- The Hiring department wants to identify the departments with the avg salaries of 
--employees and the percentage of employees
-- with the salaries where it is above then the department avg salaries

select departmentname, avg(salary), count(full_name) from Hr_recruitment
group by DepartmentName


select * from hr_recruitment
where salary >(select avg(salary) from hr_recruitment) and department='HHS'

-- I need to check the employees in the department where the salary is above then the  avg(salary) of that department

select * from Hr_recruitment
where department='HHS' and salary>73891.83   /* THIS IS GIVING US 706 ROWS WHICH ARE 46.66%*/
and salary(select avg(salary) from hr_recruitment and 

select avg(salary) from Hr_recruitment
where Department='HHS'      /*73891.83*/

---
-- Note: whenever we use CTE try to check on each level
 with Avg_salasdept As(Select departmentname, avg(salary) as avg_sal
						from Hr_recruitment
						group by DepartmentName)
/*select * from Avg_salasdept*/
select d.departmentname, avg_sal, count( case when h.salary>d.avg_sal then 1 end)*100.0/count(*) As Percamorethanavg
from Hr_recruitment H
inner join Avg_salasdept d
on d.DepartmentName=h.departmentname
group by d.DepartmentName,d.avg_sal
order by Percamorethanavg desc

-- assignment for tomorrow- comes up with the interpretation of this result(above query result)

select * from Hr_recruitment
where DepartmentName='Non-Departmental Account'
order by salary desc 


-- Continues (18-04-2024)

--- let's identify whether do we have multiple offer proposed befor the acceptance date


select position,count(full_name)
 from Hr_recruitment
 where AcceptanceDate is not null
 group by position
 having count(full_name) >1

 select distinct count(position) from Hr_recruitment

 -- observation- As we have all candidates count are distinct so no reoccurence of candidates with more than 1 offer is there.

 select hiringanalyst, count(full_name) as Hired_candidates from hr_recruitment
 group by HiringAnalyst

 -- Let's analyse the efficiency of Hiring_analyst
 -- calculate the average time to fullfill the position and offer acceptance by Hiring_analyst

 select * from Hr_recruitment

 -- plan your execution
 sele


 --select,top ,from, fetch & offset, group by,where, having, join, case when , order by
 -- syntactical order to write a query-- by the user 
 -- select(case when) top, from(case when),join, where,group by , having,order by , offset and fetch
 -- database arrange the data for execution
 --from & join,where,group by,having, select,order by, top and offset and fetch

  -- Let's analyse the efficiency of Hiring_analyst
 -- calculate the average time to fullfill the position and offer acceptance rate by Hiring_analyst

 with Performance as (select Hiringanalyst,title,avg(datediff(day,vacancydate,hiredate)) as avg_timetaken
 ,cast(sum(case when hiredate is not null then 1 else 0 end) as float)/count(*)*100 as acceptancerate
 from Hr_recruitment
 group by HiringAnalyst,title)

 select Hiringanalyst,avg_timetaken,title,concat(round(acceptancerate,2),'%') from performance
 where title='Accountant/Auditor III'
  

 select * from Hr_recruitment

 ---Department wants to identify where the time exeeded with the budgeted time limit

 select position,Departmentname, Datediff(day, vacancydate, hiredate) as Timetofullfill
 ,datediff(day, vacancydate,budgetdate) as Budgetedtimetofullfull
 from Hr_recruitment
 where Datediff(day, vacancydate, hiredate)>datediff(day, vacancydate,budgetdate)
 -- Observation- all hiredate is more than the budgetdate there is no hiring done on & before the budget time

 /*with Btime as (select position,Departmentname, Datediff(day, vacancydate, hiredate) as Timetofullfill
 ,datediff(day, vacancydate,budgetdate) as Budgetedtimetofullfull
 from Hr_recruitment
 where Datediff(day, vacancydate, hiredate)>datediff(day, vacancydate,budgetdate))

 select Departmentname,Count(Position) no_of_pos,avg(timetofullfill) as avg_time,avg(Budgetedtimetofullfull) as budg_time
  from Btime
 group by departmentname
 -- this is avg time to fullfill as per the department*/

 ---
 select * from Hr_recruitment

 -- find the longest and shortest time to full fill

 SELECT MAX(DATEDIFF(day, VacancyDate, OfferDate)) AS LongestTimeToFulfillment,  MIN(DATEDIFF(day, VacancyDate, OfferDate)) AS ShortestTimeToFulfillmentFROM Hr_recruitmentwhere hiredate is not null

 -- find the longest and shortest time to full fill as per the position

 select top 1 position, datediff(day, vacancydate,hiredate) as timetofill
 from Hr_recruitment
 where hiredate is not null
 order by timetofill 

  select top 1 position, datediff(day, vacancydate,hiredate) as timetofill
 from Hr_recruitment
 where hiredate is not null
order by timetofill desc

with timetofillCTE as(select position,datediff(day, vacancydate,hiredate) as timetofill
					 from Hr_recruitment)

select position, timetofill
 from timetofillcte
 where timetofill=(select max(timetofill) from timetofillCTE)

 union all

 select position, timetofill
 from timetofillcte
 where timetofill=(select min(timetofill) from timetofillCTE)

 ---

 select * from Hr_recruitment
 where vacancystatus='vacant'

 select department,vacancystatus, count(position) from Hr_recruitment
 /*where vacancystatus='vacant'*/
 group by department,vacancystatus

 --- assuming here that vacant position is the part of attrition in that department

 -- Identify the attrition rate in each department with the avg salaries

 select departmentname,
		avg(salary) as avg_sal, 
		Count(*) total_position,
		sum(case when vacancystatus='Vacant' then 1 else 0 end) as vacantpos,
		 cast(sum(case when vacancystatus='Vacant' then 1 else 0 end) as float)/count(*)*100 as attritionrate
		 from Hr_recruitment
		 group by departmentname
		 having cast(sum(case when vacancystatus='Vacant' then 1 else 0 end) as float)/count(*)*100>0
		 order by attritionrate desc
 
--- create a view for recruitment summary
--- Department name, count of positions, avgsal,filledposition, vacantposition
alter view recruitment_summ
As
select departmentname,
		count(*) as Pos_count,
		round(avg(salary) ,2) as avg_sal,
		sum(case when vacancystatus='vacant' then 1 else 0 end) as Vacant_pos,
		sum(case when vacancystatus='filled' then 1 else 0 end) as filled_pos
from Hr_recruitment
group by DepartmentName

select * from recruitment_summ
