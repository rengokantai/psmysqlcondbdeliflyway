@echo off
set db=payroll_ci
set dropandcreate="DROP DATABASE IF EXISTS %db%; CREATE DATABASE %db%;"

mysql -u dev -e %dropandcreate%
c:\flyway\flyway migrate -url=jdbc:mysql://localhost/%db%