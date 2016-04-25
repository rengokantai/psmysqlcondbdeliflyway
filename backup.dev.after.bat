@echo off
set db=payroll
set backup=dev.backup.after.sql
mysqldump -u dev -e %db% > %backup%