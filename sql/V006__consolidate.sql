alter table employees add column name varchar(10) null;
update employees set name = concat(first,' ',last);
alter table employees drop column last,drop column first;
alter view employee_positions as 
select employees.id as employee_id, name,title from employees left join titles on employees.title_id=titles.id;