USE rlms_lab6;

-- PE3
ALTER TABLE Student
  ADD CONSTRAINT check_program_stu
  CHECK (program IN ('BSc','BEng','MSc','PhD'));
UPDATE Student SET program = 'Master' WHERE pid = 8;

-- PE4
ALTER TABLE Employee
  ADD CONSTRAINT check_position
  CHECK (position IN ('dean','faculty','scientist','postdoc','secretary',
                      'accountant','technician','engineer','lab manager'));
UPDATE Employee SET position = 'cook' WHERE pid = 7;

-- PR1
ALTER TABLE ResearchProject
  ADD CONSTRAINT check_status_project
  CHECK (status IN ('Proposed','Active','Suspended','Completed','Cancelled'));
UPDATE ResearchProject SET status = 'Unknown' WHERE code = 'P1';

-- PR3
ALTER TABLE Participates
  ADD CONSTRAINT check_role
  CHECK (role IN ('PI','Co-PI','Collaborator'));
UPDATE Participates SET role = 'Boss' WHERE pid = 2 AND projectCode = 'P1';

-- EQ3
ALTER TABLE EquipmentUnit
  ADD CONSTRAINT check_status_unit
  CHECK (status IN ('InService','UnderMaintenance','OutOfService','Retired'));
UPDATE EquipmentUnit SET status = 'Broken' WHERE serialNo = 'U1';

-- RE2
ALTER TABLE Reservation
  ADD CONSTRAINT check_status_reservation
  CHECK (status IN ('Pending','Approved','Rejected','Cancelled','Completed'));
UPDATE Reservation SET status = 'Done' WHERE resId = 1;

-- MA2
ALTER TABLE Maintenance
  ADD CONSTRAINT check_type_maint
  CHECK (type IN ('Preventive','Corrective'));
UPDATE Maintenance SET type = 'Random' WHERE serialNo = 'U6';

-- MA2
ALTER TABLE Maintenance
  ADD CONSTRAINT check_outcome_maint
  CHECK (outcome IN ('Resolved','FollowUpRequired'));
UPDATE Maintenance SET outcome = 'Maybe' WHERE serialNo = 'U6';

-- CA2
ALTER TABLE CalibrationRecord
  ADD CONSTRAINT check_result
  CHECK (result IN ('Pass','Fail','Adjusted'));
UPDATE CalibrationRecord SET result = 'Excellent' WHERE serialNo = 'U5';

-- BD1
ALTER TABLE Budget
  ADD CONSTRAINT check_budget_amounts
  CHECK (amountGranted >= 0 AND amountDisbursed >= 0
         AND amountDisbursed <= amountGranted);
UPDATE Budget SET amountGranted = -1 WHERE budgetLine = 'B1';
UPDATE Budget SET amountDisbursed = amountGranted + 1 WHERE budgetLine = 'B1';

-- EQ3
ALTER TABLE EquipmentUnit
  ADD CONSTRAINT check_price_unit
  CHECK (purchaseCost >= 0);
UPDATE EquipmentUnit SET purchaseCost = -5 WHERE serialNo = 'U1';

-- CE2
ALTER TABLE Certification
  ADD CONSTRAINT check_validity
  CHECK (validityPeriod > 0);
UPDATE Certification SET validityPeriod = 0 WHERE code = 'C1';

-- MA2
ALTER TABLE Maintenance
  ADD CONSTRAINT check_cost_main
  CHECK (cost >= 0);
UPDATE Maintenance SET cost = -1 WHERE serialNo = 'U6';

-- CO2
ALTER TABLE Consumable
  ADD CONSTRAINT check_reorder
  CHECK (reorderThreshold >= 0);
UPDATE Consumable SET reorderThreshold = -1 WHERE consId = 1;

-- CO4
ALTER TABLE Supplies
  ADD CONSTRAINT check_unit_price
  CHECK (unitPrice >= 0);
UPDATE Supplies SET unitPrice = -1 WHERE suppId = 1 AND consId = 1 AND labId = 1;

-- CO7
ALTER TABLE Stocks
  ADD CONSTRAINT check_quantity_hand
  CHECK (quantityOnHand >= 0);
UPDATE Stocks SET quantityOnHand = -1 WHERE labId = 1 AND consId = 1;

-- CO9
ALTER TABLE Consumes
  ADD CONSTRAINT check_quantity_used
  CHECK (quantityUsed > 0);
UPDATE Consumes SET quantityUsed = 0 WHERE resId = 1 AND labId = 1 AND consId = 1;

-- PE1
ALTER TABLE Person
  ADD CONSTRAINT check_date
  CHECK (endDate IS NULL OR endDate >= startDate);
INSERT INTO Person
VALUES (12,'karim','hayssoufi','karim.hayssoufi@um6p.ma','SHBM','2027-05-29','2026-05-29');

-- PR1
ALTER TABLE ResearchProject
  ADD CONSTRAINT check_project_dates
  CHECK (endDate >= startDate);
UPDATE ResearchProject SET endDate = '2000-01-01' WHERE code = 'P1';

-- BD1
ALTER TABLE Budget
  ADD CONSTRAINT check_budget_dates
  CHECK (endDate >= startDate);
UPDATE Budget SET endDate = '2000-01-01' WHERE budgetLine = 'B1';

-- CE4
ALTER TABLE Holds
  ADD CONSTRAINT check_time
  CHECK (expirationDate > issueDate);
UPDATE Holds SET expirationDate = '2020-01-01' WHERE pid = 2 AND certCode = 'C1';

-- RE2
ALTER TABLE Reservation
  ADD CONSTRAINT check_time_sanity_res
  CHECK (plannedEnd > plannedStart);
UPDATE Reservation SET plannedEnd = plannedStart WHERE resId = 1;

-- MA2
ALTER TABLE Maintenance
  ADD CONSTRAINT check_time_sanity_main
  CHECK (endTS >= startTS);
UPDATE Maintenance SET endTS = startTS - INTERVAL 1 HOUR WHERE serialNo = 'U6';

-- CA2
ALTER TABLE CalibrationRecord
  ADD CONSTRAINT calibration_date
  CHECK (nextDueDate > calibDate);
UPDATE CalibrationRecord SET nextDueDate = '2020-01-01' WHERE serialNo = 'U5';