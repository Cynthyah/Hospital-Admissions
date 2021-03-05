use hospital_admissions

--6.	Show all the staff who have a salary equal to 25000. List their first name and last name.
select fname, lname from staff where salary = 25000

--7.	Show all the staff who have a salary greater than 40k, list their first and last names as NAME.
select concat(fname, ' ',lname) 'NAME' from staff where salary > 40000

--8.	Identify all staff who do not have a salary equal to 25k.
select fname, lname from staff where salary != 25000

--9.	Identify all staff who have a salary less than 60k.
select fname, lname from staff where salary < 60000

--10.	Identify all staff who have a salary between 40k and 60k
select fname, lname from staff where salary >= 40000 and salary <= 60000
select fname, lname from staff where salary between 40000 and 60000

--11.	Identify all staff who have a salary of either 25k or 20k.
select fname, lname,salary from staff where salary = 25000 or salary = 20000

--12.	How many employees are there?
select count(staff_id) 'Total of employees' from staff

--13.	What is the max salary?
select top 1 fname,lname, salary 'Top Salary' from staff 
order by salary desc

--14.	What is the min salary?
select top 1 fname,lname, salary 'Worst Salary' from staff where salary is not NULL
order by salary 

--15.	What is the average salary?
select avg(salary) 'Average Salary' from staff

--16.	Who has the max salary? List the first and last names as NAME
select top 1 concat(fname,' ',lname) 'NAME' from staff 
order by salary desc

--17.	Who has the min salary? List the first and last names as NAME and their city and county as ADDRESS.
select top 1 concat(fname,' ',lname) 'NAME', concat(city.city_desc,'-',county.county_desc) 'ADDRESS' from staff 
inner join staff_add on staff_add.staff_id = staff.staff_id
inner join county    on county.co_id = staff_add.co_id
inner join city      on city.city_id = staff_add.city_id
where salary is not NULL
order by salary 

--18.	Who is in the Accident and Emergency Department? List the first name, last name, department name.
select fname, lname, dept.dname from staff
inner join dept on dept.dept_id = staff.dept_id
where staff.dept_id = 'AE'

--19.	Who in the General Medical department earns more than 50k? 
--List the first name, last name, department name and salary.
select fname, lname, dept.dname, salary from staff
inner join dept on dept.dept_id = staff.dept_id
where staff.dept_id = 'GENMED' and salary > 50000
order by salary

--20.	Who is born before 1.1.1970 in the general medical department? Name, department name and age.
select concat(fname,' ',lname) 'Name', dept.dname 'Department', datediff(year,dob,GETDATE()) 'Age' from staff
inner join dept on dept.dept_id = staff.dept_id
where staff.dept_id = 'GENMED' and dob < '01/01/1970'
order by dob

--21.	Who does not work in the General Medical Department? Show the names.
select concat(fname,' ',lname) 'Name', dept.dname 'Department' from staff
inner join dept on dept.dept_id = staff.dept_id
where staff.dept_id != 'GENMED'

--22.	What are the total wages paid for each department? Show dept name and the amount.
select dept.dname 'Department',sum(staff.salary) 'Wages paid' from staff
inner join dept on dept.dept_id = staff.dept_id
group by dept.dname

--25.	Now show the total expenses for each employees. List name, address and total expenses.
select concat(staff.fname, ' ', staff.lname) 'Name', concat(staff_add.address1,'-',staff_add.address2) 'Address', expenses.amount 'Total Expenses' from staff
inner join staff_add on staff_add.staff_id = staff.staff_id
full join expenses  on expenses.staff_id = staff.staff_id
order by staff.fname

--26.	Sum the expenses by department	
select dept.dname, sum(expenses.amount) 'Total Expenses' from dept
inner join staff     on staff.dept_id = dept.dept_id
inner join expenses  on expenses.staff_id = staff.staff_id
group by dept.dname

--27.	Show the expense for all employees who earn 60k or more. List name, dept name, expenses and salary.
select concat(fname,' ', lname) 'Name', dept.dname 'Department', expenses.amount 'Expenses', salary 'Salary' from staff
inner join dept      on dept.dept_id = staff.dept_id
full join expenses  on expenses.staff_id = staff.staff_id
where salary >= 60000 

--28.	Show the details for anyone who got expenses in December and is born before 1.1.1975 
--Name, Address, age, dept and expenses.
select concat(fname,' ', lname) 'Name', concat(address1,'-',address2) 'Address', datediff(year,dob,getdate()) 'Age',dept.dname 'Department', expenses.amount 'Expenses', salary 'Salary' from staff
inner join dept      on dept.dept_id = staff.dept_id
inner join staff_add on staff_add.staff_id= staff.staff_id
full join expenses  on expenses.staff_id = staff.staff_id
where  staff.dob < '01/01/1975'
and month(expenses.months) = 12 

--29.	Who has the max amount of expenses in the year? List the name and amount.
--???????
select top 1 a.year, concat(staff.fname,' ', staff.lname) 'Name', a.amount from 
(select expenses.staff_id, year(expenses.months) as year, sum(expenses.amount)as amount from expenses
group by expenses.staff_id, year(expenses.months)) as a
inner join staff on staff.staff_id = a.staff_id
order by a.amount desc

--30.	Who has the min amount of expenses in the year? List the name and amount.
--????????
select top 1 a.year, concat(staff.fname,' ', staff.lname) 'Name', a.amount from 
(select expenses.staff_id, year(expenses.months) as year, sum(expenses.amount)as amount from expenses
group by expenses.staff_id, year(expenses.months)) as a
inner join staff on staff.staff_id = a.staff_id
order by a.amount 

--31.	What is the average amount of expenses?
select avg(expenses.amount) 'Average of expenses' from expenses 

--32.	How many expenses cheques were written? No link expenses and payment
--?????? select * from payment_method
select count(patient_fees.pay_method_id) 'Total Cheques' from patient_fees where patient_fees.pay_method_id = 3

--33.	Show the December expenses for each employee. Name, expenses and Date paid in the following format December 31st, 2011.
select concat(staff.fname, ' ',staff.lname) 'Name', expenses.amount,CONVERT(varchar, expenses.months, 107)  from expenses
inner join staff on staff.staff_id = expenses.staff_id
where month(expenses.months) = 12

--34.	Which employees did not get any expenses in March? Name, dept.
select concat(staff.fname,' ', staff.lname) 'Name', staff.dept_id from staff
where  not exists(select staff_id from expenses where expenses.staff_id = staff.staff_id and month(expenses.months) = 03)

--35.	List any staff whose last name is Williams – name, address, dept and salary.
select concat(fname,' ',lname) 'Name', concat(address1,' ',address2) 'Address', dname 'Department', salary from staff
inner join staff_add on staff_add.staff_id = staff.staff_id
inner join dept      on dept.dept_id = staff.dept_id
where  staff.lname = 'Williams'

--36.	List all the staff from a city beginning with K. Name, city and salary. Order by salary and then name.
select concat(fname,' ',lname) 'Name', city.city_desc 'City', salary from staff
inner join staff_add on staff_add.staff_id = staff.staff_id
inner join city      on city.city_id = staff_add.city_id
where  city.city_desc like 'K%'

--37.	Who is the oldest staff member who has less than 30k? List their Name, dept and salary. Order by salary.
select concat(fname,' ',lname) 'Name', dname 'Department', salary, dob from staff
inner join dept      on dept.dept_id = staff.dept_id
where dob = (select top 1 dob from staff where salary < 30000 order by dob)
and   staff.salary < 30000
order by salary

--39.	List all the staff and their qualifications. Show staff first and last name as Name and the qualification description. 
select concat(fname,' ',lname) 'Name', qual_desc 'Qualification' from staff
inner join staff_qual     on staff_qual.staff_id = staff.staff_id
inner join qualifications on qualifications.qual_id = staff_qual.qual_id

--40.	List all the staff names (first and last as Name), their roles descriptions, their department description.
select concat(fname,' ',lname) 'Name', job_title_desc 'Role', dname 'Department' from staff
inner join dept       on dept.dept_id = staff.dept_id
inner join job_titles on job_titles.job_title_id = staff.job_title_id

--41.	The manager wants to create an address book. 
--Show the first and last names and each of the address lines of both staff and patients.
--** 3 patients don't have information in table patient_address
select fname, lname, address1, address2 from staff
inner join staff_add on staff_add.staff_id = staff.staff_id
union 
select p_fname, p_lname, address1, address2 from patient
inner join patient_address on patient_address.patient_id = patient.patient_id

--42.	What rooms were never occupied by any patient? Name the rooms.
select room_desc 'Rooms never occupied' from rooms
where not exists(select room_id from patient_rooms where patient_rooms.room_id = rooms.room_id)

--43.	What rooms had the most patients?
select top 5 count(patient_rooms.room_id) 'Total patients', rooms.room_desc from patient_rooms
inner join rooms on rooms.room_id = patient_rooms.room_id
group by room_desc
order by count(patient_rooms.room_id) desc

--44.	Show all the patients who are smokers list first and last names as Patient Name,
--their gender, DOB and their blood pressure.
--*** In this case each patient has more than 1 record
select concat(patient.p_fname,' ',patient.p_lname) 'Patient Name', patient.gender_id 'Gender', dob, blood_pressure,addmittion_dt 'Date/Time'
from patient_record
inner join patient on patient.patient_id = patient_record.patient_id
where patient_record.smoker = 'Y'
order by patient_record.patient_id, patient_record.addmittion_dt

--45.	Show the patient first and last name as Patient name, their gender, their 
--admission date and medical condition, the room they were located in and the fee that they paid along with the date.
---??? HERE WE HAVE A LOT OF INCONSISTENCE - DATE ARE NULL, ALL DATE_PAID ARE NULL, DONT HAVE LINK OF FEE AND ROOM
--- SOME ADMISSION DATE ARE IN DUPLICITY(ID_PATIENT = 3)

select concat(patient.p_fname,' ',patient.p_lname) 'Patient Name', patient.gender_id 'Gender', CAST(addmittion_dt AS DATE) 'Date' , medical_condition 'Medical Condition',
patient_rooms.room_id 'Room', patient_rooms.stay_st_dt 'Start Room'
from patient_record 
inner join patient      on patient.patient_id = patient_record.patient_id 
full join patient_rooms on patient_rooms.patient_id = patient_record.patient_id and patient_rooms.stay_st_dt = cast(patient_record.addmittion_dt as date)
full join patient_fees  on patient_fees.patient_id = patient_rooms.patient_id
where patient_record.patient_id is not null and patient_record.patient_id = 1
group by patient_record.patient_id, patient.p_fname,patient.p_lname, patient.gender_id, addmittion_dt, medical_condition,patient_rooms.room_id, patient_rooms.stay_st_dt
order by patient_record.patient_id, patient_record.addmittion_dt

-- Version Perri
SELECT DISTINCT patient.p_fname + ' ' + patient.p_lname AS 'Patient Name', gender.gender_desc,
CONVERT(CHAR(10),patient_record.addmittion_dt,101),patient_record.medical_condition,
patient_rooms.room_id, patient_fees.fee, patient_fees.date_paid
FROM patient
INNER JOIN gender ON patient.Gender_id = gender.gender_id
INNER JOIN patient_record ON patient.patient_id = patient_record.patient_id
INNER JOIN patient_fees ON patient_fees.patient_id = patient.patient_id
INNER JOIN patient_rooms ON patient_rooms.patient_id = patient.patient_id
where patient.patient_id=1

select * from patient_record where patient_id = 1 order by patient_record.addmittion_dt
select * from patient_rooms where patient_id = 1 order by patient_rooms.stay_st_dt
select * from patient_fees where patient_id = 1


--46.	What patients are not yet assigned to a room?
select patient_record.patient_id, patient.p_fname, patient.p_lname, patient_record.addmittion_dt from patient_record 
inner join patient on patient.patient_id = patient_record.patient_id
where not exists(select patient_rooms.patient_id from patient_rooms where patient_rooms.patient_id = patient_record.patient_id)

--47.	If employees were to get an increase of 10% next year then show the employee 
--first and last name as Employee Name, the current salary and the increased salary as Proposed Salary. 
--Also show the difference between both salary columns as Salary Difference.
select concat(fname,' ',lname) 'Employee Name', salary 'Current Salary', (salary+salary*0.10) 'Proposed Salary', salary*0.10 'Difference'
from staff

--48.	Everyone paid under 40k is going to get a 15% increase and all others will get a 10% increase. 
--Show the employee first and last name as Employee Name, the current salary and the increased salary as Proposed Salary.
--Also show the difference between both salary columns as Salary Difference.
select concat(fname,' ',lname) 'Employee Name', salary 'Current Salary', 
case when salary < 40000 then salary+salary*0.15
     else salary+salary*0.10
end 'Proposed Salary',
case when salary < 40000 then salary*0.15
     else salary*0.10
end 'Difference'
from staff;
 