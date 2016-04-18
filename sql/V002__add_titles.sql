create table titles(
id int not null auto_increment,
title varchar(200) not null,
primary key(id)
)engine=InnoDB;

insert into titles (title) values ('start');

insert into titles (title) values ('end');