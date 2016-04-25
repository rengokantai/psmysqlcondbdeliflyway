@echo off
set db=payroll
set backup=dev.backup.before.sql
mysqldump -u dev -e %db% > %backup%