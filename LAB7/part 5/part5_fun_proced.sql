-- part 5
-- 1
delimiter //
create function availableUnits(mId INT)
returns int
reads sql data
begin 
declare n int ;
select count(*) into n from
EquipmentUnit E
where E.modelId=mId and E.status='InService' ;
return n ;
end //
delimiter ;

select M.commercialName , availableUnits(M.modelId) as available_units
from EquipmentModel M ;

-- 2
delimiter //
create procedure RestockLab(IN v_labId int ,IN v_consId int ,IN v_qty decimal(12,2), OUT newQuantity decimal(12,2))
begin 
if v_qty <=0 then signal sqlstate '45000' set message_text='non-positive qty';
end if ;
if not exists (select 1 from Stocks S
               where S.labId=v_labId and S.consId=v_consId) then 
               signal sqlstate '45000' set message_text='no stock for this laboratory and consumable';
end if ;
update Stocks 
set quantityOnHand=quantityOnHand+v_qty, lastRestockDate=curdate()
where labId=v_labId and consId=v_consId ;

select quantityOnHand into newQuantity
from Stocks
where labId=v_labId and consId=v_consId ; 
end //
delimiter ;

call RestockLab(1,1,10,@q) ;
select @q;
call RestockLab(1,1,-5,@q);
call RestockLab(30,29,2,@q);