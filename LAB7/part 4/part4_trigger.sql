-- PART 4 : Triggers

-- 1 participation 
delimiter //
create trigger participates_insert
before insert on Participates
for each row
begin
  if new.pid in (select pid from Administrative) then
    signal sqlstate '45000' set message_text = 'administrative staff cannot participate';
  elseif new.role in ('PI','Co-PI') and new.pid not in (select pid from Academic) then
    signal sqlstate '45000' set message_text = 'PI or Co-PI must be Academic';
  elseif new.role = 'PI' and exists (select 1 from Participates where projectCode = new.projectCode and role = 'PI') then
    signal sqlstate '45000' set message_text = 'project already has a PI';
  elseif new.role = 'Co-PI' and exists (select 1 from Participates where projectCode = new.projectCode and role = 'Co-PI') then
    signal sqlstate '45000' set message_text = 'project already has a Co-PI';
  end if;
end //

create trigger participates_update
before update on Participates
for each row
begin
  if new.pid in (select pid from Administrative) then
    signal sqlstate '45000' set message_text = 'administrative staff cannot participate';
  elseif new.role in ('PI','Co-PI') and new.pid not in (select pid from Academic) then
    signal sqlstate '45000' set message_text = 'PI or Co-PI must be Academic';
  elseif new.role = 'PI' and exists (select 1 from Participates where projectCode = new.projectCode and role = 'PI' and not (pid = old.pid and projectCode = old.projectCode)) then
    signal sqlstate '45000' set message_text = 'project already has a PI';
  elseif new.role = 'Co-PI' and exists (select 1 from Participates where projectCode = new.projectCode and role = 'Co-PI' and not (pid = old.pid and projectCode = old.projectCode)) then
    signal sqlstate '45000' set message_text = 'project already has a Co-PI';
  end if;
end //
delimiter ;

-- valid
insert into Participates values (4,'P2','Co-PI');
update Participates set role='PI' where pid=2 and projectCode='P1';
-- rejected
insert into Participates values (5,'P1','Collaborator');
insert into Participates values (6,'P2','Co-PI');
insert into Participates values (4,'P1','PI');
update Participates set role='Co-PI' where pid=2 and projectCode='P1';


-- 2 double booking 
delimiter //
create trigger reserves_insert
before insert on Reserves
for each row
begin
  declare s varchar(20);
  declare d timestamp;
  declare f timestamp;
  select status, plannedStart, plannedEnd into s, d, f from Reservation where resId = new.resId;
  if s = 'Approved' and exists (select 1 from Reserves rs join Reservation r on r.resId = rs.resId
                                where rs.serialNo = new.serialNo and r.resId <> new.resId
                                and r.status = 'Approved' and d < r.plannedEnd and f > r.plannedStart) then
    signal sqlstate '45000' set message_text = 'unit already reserved in this period';
  end if;
end //

create trigger reservation_update
before update on Reservation
for each row
begin
  if new.status = 'Approved' and exists (select 1 from Reserves a join Reserves b on b.serialNo = a.serialNo and b.resId <> a.resId
                                         join Reservation r on r.resId = b.resId
                                         where a.resId = new.resId and r.status = 'Approved'
                                         and new.plannedStart < r.plannedEnd and new.plannedEnd > r.plannedStart) then
    signal sqlstate '45000' set message_text = 'unit already reserved in this period';
  end if;
end //
delimiter ;

-- valid
insert into Reservation values (20,'2026-11-22 10:00:00','2027-01-10 09:00:00','2027-01-11 18:00:00','Test','Approved',2,'P1',3);
insert into Reserves values (20,'U1');
-- rejected
insert into Reservation values (21,'2026-11-22 10:00:00','2026-10-31 09:00:00','2026-11-01 18:00:00','Test','Approved',2,'P1',3);
insert into Reserves values (21,'U1');
insert into Reservation values (22,'2026-11-22 10:00:00','2026-10-31 09:00:00','2026-11-01 18:00:00','Test','Pending',2,'P1',NULL);
insert into Reserves values (22,'U1');
update Reservation set status='Approved', approverPid=3 where resId=22;


-- 3 certifications 
delimiter //
create trigger reserves_certification
before insert on Reserves
for each row
begin
  declare p int;
  declare d timestamp;
  select madeByPid, plannedStart into p, d from Reservation where resId = new.resId;
  if exists (select 1 from EquipmentUnit u join Requires rq on rq.modelId = u.modelId
             where u.serialNo = new.serialNo
             and not exists (select 1 from Holds h where h.pid = p and h.certCode = rq.certCode and h.expirationDate >= d)) then
    signal sqlstate '45000' set message_text = 'missing or expired certification';
  end if;
end //
delimiter ;

-- valid
insert into Reservation values (23,'2026-11-22 10:00:00','2026-12-10 09:00:00','2026-12-11 18:00:00','Test','Pending',2,'P1',NULL);
insert into Reserves values (23,'U3');
insert into Reserves values (23,'U7');
-- rejected
insert into Reservation values (24,'2026-11-22 10:00:00','2026-12-10 09:00:00','2026-12-11 18:00:00','Test','Pending',8,'P1',NULL);
insert into Reserves values (24,'U4');


-- 4 stock 
delimiter //
create trigger consumes_before
before insert on Consumes
for each row
begin
  declare q decimal(12,2);
  select quantityOnHand into q from Stocks where labId = new.labId and consId = new.consId;
  if new.quantityUsed <= 0 then
    signal sqlstate '45000' set message_text = 'quantityUsed must be > 0';
  elseif q is null then
    signal sqlstate '45000' set message_text = 'no stock for this lab and consumable';
  elseif new.quantityUsed > q then
    signal sqlstate '45000' set message_text = 'not enough stock';
  end if;
end //

create trigger consumes_after
after insert on Consumes
for each row
begin
  update Stocks set quantityOnHand = quantityOnHand - new.quantityUsed
  where labId = new.labId and consId = new.consId;
end //
delimiter ;

-- valid
select quantityOnHand from Stocks where labId=1 and consId=1;
insert into Consumes values (2,1,1,5.00);
select quantityOnHand from Stocks where labId=1 and consId=1;
-- rejected
insert into Consumes values (3,1,1,0);
insert into Consumes values (3,3,2,1);
insert into Consumes values (3,2,1,100);


-- 5 maintenance (AFTER INSERT / AFTER UPDATE sur Maintenance)
delimiter //
create trigger maintenance_insert
after insert on Maintenance
for each row
begin
  update EquipmentUnit set status = 'UnderMaintenance' where serialNo = new.serialNo;
end //

create trigger maintenance_update
after update on Maintenance
for each row
begin
  if old.outcome <> 'Resolved' and new.outcome = 'Resolved' then
    update EquipmentUnit set status = 'InService' where serialNo = new.serialNo;
  end if;
end //
delimiter ;

-- valid
insert into Maintenance values ('U2','2026-11-20 09:00:00','2026-11-20 12:00:00','Preventive','Test',100.00,'FollowUpRequired',6);
select serialNo, status from EquipmentUnit where serialNo = 'U2';
update Maintenance set outcome='Resolved' where serialNo='U2' and startTS='2026-11-20 09:00:00';
select serialNo, status from EquipmentUnit where serialNo = 'U2';
-- rule: only the unit of the record changes
select serialNo, status from EquipmentUnit where serialNo = 'U7';


-- 6 personnes 
delimiter //
create trigger student_insert
before insert on Student
for each row
begin
  if new.pid in (select pid from Employee) then
    signal sqlstate '45000' set message_text = 'already an employee';
  end if;
end //

create trigger employee_insert
before insert on Employee
for each row
begin
  if new.pid in (select pid from Student) then
    signal sqlstate '45000' set message_text = 'already a student';
  elseif new.position = 'dean' and new.supervisorPid is not null then
    signal sqlstate '45000' set message_text = 'the dean has no supervisor';
  end if;
end //

create trigger employee_update
before update on Employee
for each row
begin
  if new.position = 'dean' and new.supervisorPid is not null then
    signal sqlstate '45000' set message_text = 'the dean has no supervisor';
  elseif (new.pid in (select pid from Faculty) or new.pid in (select pid from Administrative))
     and new.supervisorPid not in (select pid from Employee where position = 'dean') then
    signal sqlstate '45000' set message_text = 'must report to the dean';
  end if;
end //

create trigger faculty_insert
before insert on Faculty
for each row
begin
  if (select supervisorPid from Employee where pid = new.pid)
     not in (select pid from Employee where position = 'dean') then
    signal sqlstate '45000' set message_text = 'faculty must report to the dean';
  end if;
end //

create trigger administrative_insert
before insert on Administrative
for each row
begin
  if (select supervisorPid from Employee where pid = new.pid)
     not in (select pid from Employee where position = 'dean') then
    signal sqlstate '45000' set message_text = 'administrative must report to the dean';
  end if;
end //
delimiter ;

-- valid
insert into Person values (30,'Test','Student','t.student@um6p.ma','UM6P','2026-11-01',NULL);
insert into Student values (30,'BSc');
insert into Person values (31,'Test','Faculty','t.faculty@um6p.ma','UM6P','2026-11-01',NULL);
insert into Employee values (31,'0631','D-1','faculty',1);
insert into Academic values (31);
insert into Faculty values (31);
-- rejected
insert into Student values (2,'PhD');
insert into Employee values (8,'0608','X-1','postdoc',2);
insert into Person values (32,'Test','Fac2','t.fac2@um6p.ma','UM6P','2026-11-01',NULL);
insert into Employee values (32,'0632','D-2','faculty',2);
insert into Academic values (32);
insert into Faculty values (32);
update Employee set supervisorPid=3 where pid=2;
update Employee set supervisorPid=2 where pid=1;