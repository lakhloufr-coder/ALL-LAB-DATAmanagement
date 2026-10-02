
use university ;

create table Professor(
ssn int ,
rankpr int  , 
speciality varchar(25) not null , 
dep_id int , 
age int,
primary key (ssn) ,
foreign key (dep_id) references Dept_Mang(dno) );

create table Dept_Mang(
dno int  ,
dname varchar(20) , 
office varchar(20),
ssn_Mang int ,
primary key (dno) ,
pc_time time , 
foreign key (ssn_Mang) references Professor(ssn) );

create table Project_Mang_Pro (
pid int , 
sponsar varchar(30) ,
start_date date not null ,
end_date date not null, 
budget int ,
Mang_id int NOT NULL ,   
primary key(pid) , 
foreign key (prof_id) references Professor(ssn)) ;


create table Work_in(
ssn int not null , 
pro_id int not null ,
primary key (ssn , pro_id ) , 
foreign key (ssn) references Professor(ssn) , 
foreign key (Mang_id) references Project_Mang_Pro(pid) );


create table Graduate(
ssn int , 
age int  not null ,
cin_advisor int not null , 
primary key (ssn),
deg_prog varchar(20) , 
namegr varchar(20) , 
dep_id int , 
foreign key (dep_id) references Dept_Mang(dno) , 
foreign key (cin_advisor) references Graduate(ssn) ); 
create table Work_proj(
 ssn int , 
pid int NOT NULL  ,
ssn_prof int not NULL , 

primary key (ssn , pid) , 
foreign key (ssn) references Graduate(ssn) ,
foreign key (pid) references  Project_Mang_Pro(pid) , 
foreign key (ssn_prof) references Professor(ssn) ) ;



