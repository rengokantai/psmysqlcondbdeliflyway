@echo off
set db=payroll
set dropandcreate="DROP DATABASE IF EXISTS %db%; CREATE DATABASE %db%;"
set backup=dev.backup.before.sql

mysql -u dev -e %dropandcreate%
mysql -u dev %db% < %backup%