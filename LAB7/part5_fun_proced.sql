-- 1.
delimiter //
create function availableUnits(mId int)
returns int
reads sql data
begin
  declare n int;
  select count(*) into n
  from EquipmentUnit E
  where E.modelId = mId and E.status = 'InService';
  return n;
end //
delimiter ;

-- 1. demonstration
select M.commercialName, availableUnits(M.modelId) as available_units
from EquipmentModel M;

-- 2.
delimiter //
create procedure RestockLab(in p_labId int, in p_consId int,
                            in p_qty decimal(12,2),
                            out p_newQuantity decimal(12,2))
begin
  if p_qty <= 0 then
    signal sqlstate '45000' set message_text = 'non-positive qty';
  end if;
  if not exists (select 1 from Stocks S
                 where S.labId = p_labId and S.consId = p_consId) then
    signal sqlstate '45000' set message_text = 'no stock for this laboratory and consumable';
  end if;
  update Stocks
  set quantityOnHand = quantityOnHand + p_qty, lastRestockDate = curdate()
  where labId = p_labId and consId = p_consId;

  select quantityOnHand into p_newQuantity
  from Stocks
  where labId = p_labId and consId = p_consId;
end //
delimiter ;

-- 2. demonstration, successful call
select quantityOnHand, lastRestockDate from Stocks where labId = 1 and consId = 1;
call RestockLab(1, 1, 10, @q);
select @q;
select quantityOnHand, lastRestockDate from Stocks where labId = 1 and consId = 1;

-- 2. demonstration, rejected
call RestockLab(1, 1, -5, @q);

-- 2. demonstration, rejected
call RestockLab(30, 29, 2, @q);