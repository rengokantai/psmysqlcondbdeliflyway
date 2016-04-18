create view employee_positions as 
select employees.id as employee_id, first,last,title from employees left join titles on employees.title_id=titles.id;