DROP DATABASE IF EXISTS employees;
CREATE DATABASE IF NOT EXISTS employees;
USE employees;

SELECT 'CREATING DATABASE STRUCTURE' as 'INFO';


DROP TABLE IF EXISTS dept_emp,
                     dept_manager,
                     titles,
                     salaries, 
                     employees, 
                     departments;

/*!50503 set default_storage_engine = InnoDB */;
/*!50503 select CONCAT('storage engine: ', @@default_storage_engine) as INFO */;

CREATE TABLE employees (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      ENUM ('M','F')  NOT NULL,    
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE departments (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE  KEY (dept_name)
);

CREATE TABLE dept_manager (
   emp_no       INT             NOT NULL,
   dept_no      CHAR(4)         NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
   FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
   PRIMARY KEY (emp_no,dept_no)
); 

CREATE TABLE dept_emp (
    emp_no      INT             NOT NULL,
    dept_no     CHAR(4)         NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no)  ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE titles (
    emp_no      INT             NOT NULL,
    title       VARCHAR(50)     NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,title, from_date)
) 
; 

CREATE TABLE salaries (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
) 
; 

CREATE OR REPLACE VIEW dept_emp_latest_date AS
    SELECT emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM dept_emp
    GROUP BY emp_no;

# shows only the current department for each employee
CREATE OR REPLACE VIEW current_dept_emp AS
    SELECT l.emp_no, dept_no, l.from_date, l.to_date
    FROM dept_emp d
        INNER JOIN dept_emp_latest_date l
        ON d.emp_no=l.emp_no AND d.from_date=l.from_date AND l.to_date = d.to_date;
        
     
     
/*
Insert at least 15 new employees:
With salaries that are between a range of 5,000 and 50,000 of different gender
5 employees must have at least two salaries in different ranges of dates and different amounts
10 employees belong to more than one department
5 employees are managers
All employees have a degree and at least 5 titles are from 2020
At least 3 employees have the same name
*/
/*EMPLOYESS*/ /*At least 3 employees have the same name*/
insert into employees (emp_no, birth_date, first_name, last_name, gender, hire_date) values('0', '1985-12-21', 'Miguel', 'Dominguez', 'M', now());
insert into employees (emp_no, birth_date, first_name, last_name, gender, hire_date) values('1', '1985-09-23', 'Matias', 'Patrignani', 'M', now());
insert into employees (emp_no, birth_date, first_name, last_name, gender, hire_date) values('2', '1985-02-12', 'Ivan', 'Escribano', 'M', now());
insert into employees (emp_no, birth_date, first_name, last_name, gender, hire_date) values('3', '1985-11-11', 'Volha', 'Afanasenka', 'F', now());
insert into employees (emp_no, birth_date, first_name, last_name, gender, hire_date) values('4', '1985-12-03', 'Miguel', 'Dominguez', 'M', now());
insert into employees (emp_no, birth_date, first_name, last_name, gender, hire_date) values('5', '1985-05-05', 'Miguel', 'Dominguez', 'M', now());
insert into employees (emp_no, birth_date, first_name, last_name, gender, hire_date) values('6', '1985-03-21', 'Julio', 'Macias', 'M', now());
insert into employees (emp_no, birth_date, first_name, last_name, gender, hire_date) values('7', '1985-08-13', 'Andrea', 'Franconetti', 'F', now());
insert into employees (emp_no, birth_date, first_name, last_name, gender, hire_date) values('8', '1985-08-13', 'Sefi', 'Cohen', 'M', now());
insert into employees (emp_no, birth_date, first_name, last_name, gender, hire_date) values('9', '1985-06-05', 'Alejandro', 'Avila', 'M', now());
insert into employees (emp_no, birth_date, first_name, last_name, gender, hire_date) values('10', '1985-01-21', 'Jose', 'Valenzuela', 'M', now());
insert into employees (emp_no, birth_date, first_name, last_name, gender, hire_date) values('11', '1985-10-31', 'Alejandro', 'Steger', 'M', now());
insert into employees (emp_no, birth_date, first_name, last_name, gender, hire_date) values('12', '1985-03-19', 'Roger', 'Delgado', 'M', now());
insert into employees (emp_no, birth_date, first_name, last_name, gender, hire_date) values('13', '1985-05-02', 'Adrià', 'Vallès', 'M', now());
insert into employees (emp_no, birth_date, first_name, last_name, gender, hire_date) values('14', '1985-4-2', 'Alicia', 'Cembranos', 'F', now());
insert into employees (emp_no, birth_date, first_name, last_name, gender, hire_date) values('15', '1985-04-12', 'Manu', 'Sancho', 'M', now());
select * from employees;
truncate employees;

/*DEPARTMENTS*/
INSERT into departments (dept_no, dept_name) values('0', 'Assembler Core');
INSERT into departments (dept_no, dept_name) values('1', 'Assembler 2022 Mar');
INSERT into departments (dept_no, dept_name) values('2', 'Assembleio 2022 Pre-Course');
select * from departments;
truncate departments;

/*DEPT_MANAGER*/ /*5 employees are managers*/
INSERT into dept_manager (emp_no, dept_no, from_date, to_date) values('0', '2', NOW() - INTERVAL 1 DAY, now());
INSERT into dept_manager (emp_no, dept_no, from_date, to_date) values('1', '2', NOW() - INTERVAL 2 DAY, now());
INSERT into dept_manager (emp_no, dept_no, from_date, to_date) values('1', '1', NOW() - INTERVAL 2 DAY, now());
INSERT into dept_manager (emp_no, dept_no, from_date, to_date) values('2', '2', NOW() - INTERVAL 5 DAY, now());
INSERT into dept_manager (emp_no, dept_no, from_date, to_date) values('2', '1', NOW() - INTERVAL 5 DAY, now());
INSERT into dept_manager (emp_no, dept_no, from_date, to_date) values('3', '2', NOW() - INTERVAL 1 DAY, now());
INSERT into dept_manager (emp_no, dept_no, from_date, to_date) values('4', '1', NOW() - INTERVAL 3 DAY, now());
INSERT into dept_manager (emp_no, dept_no, from_date, to_date) values('14', '1', NOW() - INTERVAL 7 DAY, now());
INSERT into dept_manager (emp_no, dept_no, from_date, to_date) values('15', '0', NOW() - INTERVAL 2 DAY, now());
select * from dept_manager;
truncate dept_manager;

/*DEPT_EMP*/ /*10 employees belong to more than one department*/
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('0', '2', NOW() - INTERVAL 1 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('0', '1', NOW() - INTERVAL 1 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('1', '2', NOW() - INTERVAL 2 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('1', '1', NOW() - INTERVAL 2 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('2', '2', NOW() - INTERVAL 5 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('2', '1', NOW() - INTERVAL 5 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('3', '2', NOW() - INTERVAL 1 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('3', '1', NOW() - INTERVAL 1 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('4', '2', NOW() - INTERVAL 3 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('4', '1', NOW() - INTERVAL 3 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('5', '2', NOW() - INTERVAL 10 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('5', '1', NOW() - INTERVAL 10 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('6', '2', NOW() - INTERVAL 3 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('6', '1', NOW() - INTERVAL 3 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('7', '2', NOW() - INTERVAL 1 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('7', '1', NOW() - INTERVAL 1 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('8', '2', NOW() - INTERVAL 4 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('8', '1', NOW() - INTERVAL 4 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('9', '2', NOW() - INTERVAL 4 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('9', '1', NOW() - INTERVAL 4 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('10', '2', NOW() - INTERVAL 4 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('10', '1', NOW() - INTERVAL 4 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('11', '2', NOW() - INTERVAL 5 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('11', '1', NOW() - INTERVAL 5 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('12', '2', NOW() - INTERVAL 7 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('12', '1', NOW() - INTERVAL 7 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('13', '2', NOW() - INTERVAL 8 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('13', '1', NOW() - INTERVAL 8 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('14', '1', NOW() - INTERVAL 7 DAY, now());
INSERT into dept_emp (emp_no, dept_no, from_date, to_date) values('15', '0', NOW() - INTERVAL 2 DAY, now());
select * from dept_emp;
truncate dept_emp;

/*TITLES*/ /*All employees have a degree and at least 5 titles are from 2020*/
INSERT into titles (emp_no, title, from_date, to_date) values('0', 'ENG',DATE '2020-12-20', now());
INSERT into titles (emp_no, title, from_date, to_date) values('1', 'ENG',DATE '2020-12-20', now());
INSERT into titles (emp_no, title, from_date, to_date) values('1', 'MASTER',DATE '2020-12-20', now());
INSERT into titles (emp_no, title, from_date, to_date) values('1', 'SUPER MASTER',DATE '2020-12-20', now());
INSERT into titles (emp_no, title, from_date, to_date) values('1', 'EL MÁS MASTER',DATE '2020-12-20', now());
INSERT into titles (emp_no, title, from_date, to_date) values('1', 'EL MÁS MASTER del MASTER',DATE '2020-12-20', now());
INSERT into titles (emp_no, title, from_date, to_date) values('1', 'Cooking MASTER',DATE '2020-12-20', now());
INSERT into titles (emp_no, title, from_date, to_date) values('2', 'ENG', NOW() - INTERVAL 1 DAY, now());
INSERT into titles (emp_no, title, from_date, to_date) values('3', 'ENG', NOW() - INTERVAL 1 DAY, now());
INSERT into titles (emp_no, title, from_date, to_date) values('4', 'ENG', NOW() - INTERVAL 1 DAY, now());
INSERT into titles (emp_no, title, from_date, to_date) values('5', 'ENG', NOW() - INTERVAL 1 DAY, now());
INSERT into titles (emp_no, title, from_date, to_date) values('6', 'ENG', NOW() - INTERVAL 1 DAY, now());
INSERT into titles (emp_no, title, from_date, to_date) values('7', 'ENG', NOW() - INTERVAL 1 DAY, now());
INSERT into titles (emp_no, title, from_date, to_date) values('8', 'ENG', NOW() - INTERVAL 1 DAY, now());
INSERT into titles (emp_no, title, from_date, to_date) values('9', 'ENG', NOW() - INTERVAL 1 DAY, now());
INSERT into titles (emp_no, title, from_date, to_date) values('10', 'ENG', NOW() - INTERVAL 1 DAY, now());
INSERT into titles (emp_no, title, from_date, to_date) values('11', 'ENG', NOW() - INTERVAL 1 DAY, now());
INSERT into titles (emp_no, title, from_date, to_date) values('12', 'SCI-FI', NOW() - INTERVAL 1 DAY, now());
INSERT into titles (emp_no, title, from_date, to_date) values('13', 'SCI', NOW() - INTERVAL 1 DAY, now());
INSERT into titles (emp_no, title, from_date, to_date) values('14', 'ART', NOW() - INTERVAL 1 DAY, now());
INSERT into titles (emp_no, title, from_date, to_date) values('15', 'ENG', NOW() - INTERVAL 1 DAY, now());
select * from titles;
truncate titles;

/*SALARIES*/ /*5 employees must have at least two salaries in different ranges of dates and different amounts*/ /*With salaries that are between a range of 5,000 and 50,000 of different gender*/
INSERT into salaries (emp_no, salary, from_date, to_date) values('0', 25000, NOW() - INTERVAL 1 DAY, now());
INSERT into salaries (emp_no, salary, from_date, to_date) values('1', 50000, NOW() - INTERVAL 2 DAY, now());
INSERT into salaries (emp_no, salary, from_date, to_date) values('2', 5000, NOW() - INTERVAL 3 DAY, now());
INSERT into salaries (emp_no, salary, from_date, to_date) values('3', 35000, NOW() - INTERVAL 4 DAY, now());
INSERT into salaries (emp_no, salary, from_date, to_date) values('4', 30500, NOW() - INTERVAL 5 DAY, now());
INSERT into salaries (emp_no, salary, from_date, to_date) values('5', 10000, NOW() - INTERVAL 6 DAY, now());
INSERT into salaries (emp_no, salary, from_date, to_date) values('6', 25000, NOW() - INTERVAL 7 DAY, now());
INSERT into salaries (emp_no, salary, from_date, to_date) values('7', 50000, NOW() - INTERVAL 7 DAY, now());
INSERT into salaries (emp_no, salary, from_date, to_date) values('8', 20000, NOW() - INTERVAL 6 DAY, now());
INSERT into salaries (emp_no, salary, from_date, to_date) values('9', 25000, NOW() - INTERVAL 5 DAY, now());
INSERT into salaries (emp_no, salary, from_date, to_date) values('10', 25000, NOW() - INTERVAL 4 DAY, now());
INSERT into salaries (emp_no, salary, from_date, to_date) values('11', 25000, NOW() - INTERVAL 3 DAY, now());
INSERT into salaries (emp_no, salary, from_date, to_date) values('12', 10000, NOW() - INTERVAL 2 DAY, now());
INSERT into salaries (emp_no, salary, from_date, to_date) values('13', 23700, NOW() - INTERVAL 1 DAY, now());
INSERT into salaries (emp_no, salary, from_date, to_date) values('14', 25200, NOW() - INTERVAL 10 DAY, now());
INSERT into salaries (emp_no, salary, from_date, to_date) values('15', 25023, NOW() - INTERVAL 8 DAY, now());
INSERT into salaries (emp_no, salary, from_date, to_date) values('16', 25023, NOW() - INTERVAL 2 DAY, now());
select * from salaries;
truncate salaries;

/*
Update employees:
Change the name of an employee. To do this, generate a query that affects only a certain employee based on their name, surname and date of birth.
*/
select  * from employees;
update employees set first_name='Walber', last_name='Melo' where first_name = 'Miguel' and last_name='Dominguez' and birth_date='1985-12-03'; 
update employees set first_name= 'Javier', last_name='Fernández' where first_name = 'Miguel' and last_name='Dominguez' and birth_date='1985-05-05'; 
update employees set first_name='MIGUEL' where emp_no = 0;

/*Update departments:
Change the name of all departments.*/
select * from departments;
update departments set dept_name = 'oops everything is gone';

/*Select all employees with a salary greater than 20,000*/
select employees.* from employees join salaries where employees.emp_no = salaries.emp_no and salaries.salary >= 20000;
/*Select all employees with a salary below 10,000*/
select employees.* from employees join salaries where employees.emp_no = salaries.emp_no and salaries.salary <= 10000;
/*Select all employees who have a salary between 14.00 and 50,000*/
select employees.* from employees join salaries where employees.emp_no = salaries.emp_no and salaries.salary between 1400 and 50000;
/*Select the total number of employees*/
select count(emp_no) from employees order by emp_no;
/*Select the total number of employees who have worked in more than one department*/
select emp_no from dept_emp group by emp_no having count(dept_no)>1;
/*Select the titles of the year 2020*/
select title from titles where year(from_date) = 2020;
/*Select only the name of the employees in capital letters*/
SELECT * FROM employees where first_name regexp '^[A-Z]+$';
select upper(first_name) from employees;
/*Select the name, surname and name of the current department of each employee*/
select first_name, last_name, dept_name 
from employees as e join departments as d inner join dept_emp as m 
where m.emp_no = e.emp_no and m.dept_no = d.dept_no; 
/*Select the name, surname and number of times the employee has worked as a manager*/
select first_name, last_name, count(dept_no) as 'manager of' 
from employees as e inner join dept_manager as dm 
where dm.emp_no = e.emp_no group by e.emp_no;
/*Select the name of employees without any being repeated*/
select distinct first_name, last_name from employees;


/*Delete all employees with a salary greater than 20,000*/
delete from salaries where salary >=20000;
/*Remove the department that has more employees*/
delete from department where dept_no in (
select dept_no , count(emp_no) as total from dept_emp group by dept_no order by total desc limit 1);




/*STUFF*/
delete from department where dept_no in (
select dept_no , count(emp_no) as total from dept_manager group by dept_no having max(total));


select dept_no , count(emp_no) as total from dept_emp group by dept_no having max(total);

select dept_emp.dept_no, count(dept_manager.dept_no) from dept_emp natural inner join dept_manager;

select * from departments;
select * from dept_emp;
select * from dept_manager;

select e.first_name, d.dept_no from employees as e right join dept_manager as d on e.emp_no = d.emp_no;
select e.first_name, d.dept_no from employees as e join dept_manager as d where e.emp_no = d.emp_no;