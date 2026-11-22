-- 1.
ALTER TABLE Student ADD CONSTRAINT check_program_stu
  CHECK (program IN ('BSc','BEng','MSc','PhD'));

-- 2.
ALTER TABLE Employee ADD CONSTRAINT check_position
  CHECK (position IN ('dean','faculty','scientist','postdoc','secretary',
                      'accountant','technician','engineer','lab manager'));

-- 3.
ALTER TABLE ResearchProject ADD CONSTRAINT check_status_project
  CHECK (status IN ('Proposed','Active','Suspended','Completed','Cancelled'));

-- 4.
ALTER TABLE Participates ADD CONSTRAINT check_role
  CHECK (role IN ('PI','Co-PI','Collaborator'));

-- 5.
ALTER TABLE EquipmentUnit ADD CONSTRAINT check_status_unit
  CHECK (status IN ('InService','UnderMaintenance','OutOfService','Retired'));

-- 6.
ALTER TABLE Reservation ADD CONSTRAINT check_status_reservation
  CHECK (status IN ('Pending','Approved','Rejected','Cancelled','Completed'));

-- 7.
ALTER TABLE Maintenance ADD CONSTRAINT check_type_maint
  CHECK (type IN ('Preventive','Corrective'));

-- 8.
ALTER TABLE Maintenance ADD CONSTRAINT check_outcome_maint
  CHECK (outcome IN ('Resolved','FollowUpRequired'));

-- 9.
ALTER TABLE CalibrationRecord ADD CONSTRAINT check_result
  CHECK (result IN ('Pass','Fail','Adjusted'));

-- 10.
ALTER TABLE Budget ADD CONSTRAINT check_budget_amounts
  CHECK (amountGranted >= 0 AND amountDisbursed >= 0
         AND amountDisbursed <= amountGranted);

-- 11.
ALTER TABLE EquipmentUnit ADD CONSTRAINT check_price_unit
  CHECK (purchaseCost >= 0);

-- 12.
ALTER TABLE Certification ADD CONSTRAINT check_validity
  CHECK (validityPeriod > 0);

-- 13.
ALTER TABLE Maintenance ADD CONSTRAINT check_cost_main
  CHECK (cost >= 0);

-- 14.
ALTER TABLE Consumable ADD CONSTRAINT check_reorder
  CHECK (reorderThreshold >= 0);

-- 15.
ALTER TABLE Supplies ADD CONSTRAINT check_unit_price
  CHECK (unitPrice >= 0);

-- 16.
ALTER TABLE Stocks ADD CONSTRAINT check_quantity_hand
  CHECK (quantityOnHand >= 0);

-- 17.
ALTER TABLE Consumes ADD CONSTRAINT check_quantity_used
  CHECK (quantityUsed > 0);

-- 18.
ALTER TABLE Person ADD CONSTRAINT check_date
  CHECK (endDate IS NULL OR endDate >= startDate);

-- 19.
ALTER TABLE ResearchProject ADD CONSTRAINT check_project_dates
  CHECK (endDate >= startDate);

-- 20.
ALTER TABLE Budget ADD CONSTRAINT check_budget_dates
  CHECK (endDate >= startDate);

-- 21.
ALTER TABLE Holds ADD CONSTRAINT check_time
  CHECK (expirationDate > issueDate);

-- 22.
ALTER TABLE Reservation ADD CONSTRAINT check_time_sanity_res
  CHECK (plannedEnd > plannedStart);

-- 23.
ALTER TABLE Maintenance ADD CONSTRAINT check_time_sanity_main
  CHECK (endTS >= startTS);

-- 24.
ALTER TABLE CalibrationRecord ADD CONSTRAINT calibration_date
  CHECK (nextDueDate > calibDate);


-- Rejected statements (error 3819)

-- 1. rejected
UPDATE Student SET program = 'Master' WHERE pid = 8;

-- 2. rejected
UPDATE Employee SET position = 'cook' WHERE pid = 7;

-- 3. rejected
UPDATE ResearchProject SET status = 'Unknown' WHERE code = 'P1';

-- 4. rejected
UPDATE Participates SET role = 'Boss' WHERE pid = 2 AND projectCode = 'P1';

-- 5. rejected
UPDATE EquipmentUnit SET status = 'Broken' WHERE serialNo = 'U1';

-- 6. rejected
UPDATE Reservation SET status = 'Done' WHERE resId = 1;

-- 7. rejected
UPDATE Maintenance SET type = 'Random' WHERE serialNo = 'U6';

-- 8. rejected
UPDATE Maintenance SET outcome = 'Maybe' WHERE serialNo = 'U6';

-- 9. rejected
UPDATE CalibrationRecord SET result = 'Excellent' WHERE serialNo = 'U5';

-- 10. rejected (negative amount)
UPDATE Budget SET amountGranted = -1 WHERE budgetLine = 'B1';
-- 10. rejected (disbursed greater than granted)
UPDATE Budget SET amountDisbursed = amountGranted + 1 WHERE budgetLine = 'B1';

-- 11. rejected
UPDATE EquipmentUnit SET purchaseCost = -5 WHERE serialNo = 'U1';

-- 12. rejected
UPDATE Certification SET validityPeriod = 0 WHERE code = 'C1';

-- 13. rejected
UPDATE Maintenance SET cost = -1 WHERE serialNo = 'U6';

-- 14. rejected
UPDATE Consumable SET reorderThreshold = -1 WHERE consId = 1;

-- 15. rejected
UPDATE Supplies SET unitPrice = -1 WHERE suppId = 1 AND consId = 1 AND labId = 1;

-- 16. rejected
UPDATE Stocks SET quantityOnHand = -1 WHERE labId = 1 AND consId = 1;

-- 17. rejected
UPDATE Consumes SET quantityUsed = 0 WHERE resId = 1 AND labId = 1 AND consId = 1;

-- 18. rejected
INSERT INTO Person
VALUES (12,'karim','hayssoufi','karim.hayssoufi@um6p.ma','SHBM','2027-05-29','2026-05-29');

-- 19. rejected
UPDATE ResearchProject SET endDate = '2000-01-01' WHERE code = 'P1';

-- 20. rejected
UPDATE Budget SET endDate = '2000-01-01' WHERE budgetLine = 'B1';

-- 21. rejected
UPDATE Holds SET expirationDate = '2020-01-01' WHERE pid = 2 AND certCode = 'C1';

-- 22. rejected
UPDATE Reservation SET plannedEnd = plannedStart WHERE resId = 1;

-- 23. rejected
UPDATE Maintenance SET endTS = startTS - INTERVAL 1 HOUR WHERE serialNo = 'U6';

-- 24. rejected
UPDATE CalibrationRecord SET nextDueDate = '2020-01-01' WHERE serialNo = 'U5';