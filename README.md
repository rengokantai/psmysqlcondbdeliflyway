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
```
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
