#### psmysqlcondbdeliflyway
#####tracking changes
######create db
```
mysql -u root -p
create user 'dev'@'localhost';
grant all on *.* to 'dev'@'localhost';
exit
```
```
mysql -u dev
create database pay;
```
go to flyway/conf/flyway.conf edit
```
flyway.url=jdbc:mysql://localhost/payroll
flyway.user=dev
```
test:
```
flyway info
```
init git:

######create first table
flyway/sql/V1__create_employee.sql       (format: V1_2__name) beginning with capitalv,,version number, followedby two __
```
create table employees(
	id int not null auto_increment,
first varchar(20) not null,
last varchar(20) not null,
primary key(id)
)engine=InnoDB;
```
migrate:
```
flyway migrate
```
get metadata of a table:
```
select * from payroll.schema_version;
```
better to use padre number, like 001  

create second table V002__add_titles.sql,rename V1__create_employee.sql to V001__create_employee.sql 
```
create table titles(
id int not null auto_increment,
title varchar(200) not null,
primary key(id)
)engine=InnoDB;

insert into titles (title) values ('start');

insert into titles (title) values ('end');
```
migrate again.
######adding table relationship

#####dev workflow
######push restore
```
mysqldump -u dev payroll > dev.backup.sql
```
create restore.dev.bat
```
@echo off
set db=payroll
set create = "drop database if exists %db%;create database %db%;"
echo %create%
mysql -u dev -e %create%
```

restore:
```
mysql -u dev payroll < dev.backup.sql
```
###### try
add a query in mysql workbench V005__add_employees_phone.sql
```
ALTER table payroll.employees add column phone varchar(10) null after title_id;
```
and drop
```
alter table payroll.employees drop column phone;
```
###### restore failed migration
create V006__consolidate.sql
```
alter table employees add column name varchar(10) null;
update employees set name = concat(first,' ',last);
alter table employeees drop column last,drop column first;   -- note three e here  employeees 
```
if failed, using
```
flyway repair
```
after fixed employeee to employee,
```
flyway migrate
```
######correct mistake in a migration
last we dropped two columns, so, mistake.we need to update view.add
```
alter view employee_positions as 
select employees.id as employee_id, name,title from employees left join titles on employees.title_id=titles.id;
```

```
flyway validate
```
to validate whether current script apply to database.  

Then repair: manually execute new script in mysql workbench, then run
```
flyway repair
```

#####reverse engineer
using toad from dell. (schema compare)tools->compare->schema compare  
create V007__add_employees_birth.sql
```
alter table employees add column birth datetime null;
```
create a new conf file under conf
```
compare.conf
```
edit
```
flyway.url=......payroll_compare
```
run:
```
flyway -configFile=conf\compare.conf info
```
######creating comparison db
using clean command, same as drop db and recreate empty db.
```
flyway -configFile=conf\compare.conf clean
```
migrate to specific version
```
flyway -configFile=conf\compare.conf -target=5 migrate
```

#####pulling
######
collaborate with other developers:  
backup local db first, pull git repo

#####delivery workflow
download teamcity,set
```
name: Test
build configID: Payroll_TestDropAndCreateDbFromMigrations
```
