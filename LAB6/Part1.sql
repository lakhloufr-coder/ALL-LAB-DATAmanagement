drop database if exists rlms;
create database rlms;
use rlms;

CREATE TABLE Person (
    pid INT PRIMARY KEY,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    affiliation VARCHAR(150) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE
);

CREATE TABLE Student (
    pid INT PRIMARY KEY,
    program VARCHAR(20) NOT NULL,
    FOREIGN KEY (pid) REFERENCES Person(pid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Employee (
    pid INT PRIMARY KEY,
    phone VARCHAR(30) NOT NULL,
    office VARCHAR(100) NOT NULL,
    position Varchar(100) NOT NULL,
    supervisorPid INT,
    FOREIGN KEY (pid) REFERENCES Person(pid) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (supervisorPid) REFERENCES Employee(pid) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Academic (
    pid INT PRIMARY KEY,
    FOREIGN KEY (pid) REFERENCES Employee(pid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Faculty (
    pid INT PRIMARY KEY,
    FOREIGN KEY (pid) REFERENCES Academic(pid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Administrative (
    pid INT PRIMARY KEY,
    FOREIGN KEY (pid) REFERENCES Employee(pid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Technical (
    pid INT PRIMARY KEY,
    FOREIGN KEY (pid) REFERENCES Employee(pid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Advises (
    academicPid INT NOT NULL,
    studentPid INT NOT NULL,
    PRIMARY KEY (academicPid, studentPid),
    FOREIGN KEY (academicPid) REFERENCES Academic(pid) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (studentPid) REFERENCES Student(pid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Laboratory (
    labId INT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    building VARCHAR(100) NOT NULL,
    roomNumber VARCHAR(50) NOT NULL,
    discipline VARCHAR(150) NOT NULL,
    supervisorPid INT NOT NULL,
    FOREIGN KEY (supervisorPid) REFERENCES Faculty(pid) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Attached (
    pid INT NOT NULL,
    labId INT NOT NULL,
    PRIMARY KEY (pid, labId),
    FOREIGN KEY (pid) REFERENCES Person(pid) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (labId) REFERENCES Laboratory(labId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ResearchProject (
    code VARCHAR(50) PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active'
);

CREATE TABLE Participates (
    pid INT NOT NULL,
    projectCode VARCHAR(50) NOT NULL,
    role VARCHAR(30)  NOT NULL,
    PRIMARY KEY (pid, projectCode),
    FOREIGN KEY (pid) REFERENCES Person(pid) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (projectCode) REFERENCES ResearchProject(code) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Budget (
    budgetLine VARCHAR(50) PRIMARY KEY,
    amountGranted DECIMAL(12,2) NOT NULL,
    amountDisbursed DECIMAL(12,2) NOT NULL DEFAULT 0,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    managerPid INT NOT NULL,
    FOREIGN KEY (managerPid) REFERENCES Academic(pid) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE FundsPrj (
    budgetLine VARCHAR(50) NOT NULL,
    projectCode VARCHAR(50) NOT NULL,
    PRIMARY KEY (budgetLine, projectCode),
    FOREIGN KEY (budgetLine) REFERENCES Budget(budgetLine) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (projectCode) REFERENCES ResearchProject(code) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE FundsLab (
    budgetLine VARCHAR(50) NOT NULL,
    labId INT NOT NULL,
    PRIMARY KEY (budgetLine, labId),
    FOREIGN KEY (budgetLine) REFERENCES Budget(budgetLine) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (labId) REFERENCES Laboratory(labId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE EquipmentModel (
    modelId INT PRIMARY KEY,
    commercialName VARCHAR(150) NOT NULL,
    manufacturer VARCHAR(150) NOT NULL,
    category VARCHAR(100) NOT NULL,
    requiredEnvironment VARCHAR(200) NOT NULL,
    trainingMandatory BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE EquipmentUnit (
    serialNo VARCHAR(100) PRIMARY KEY,
    acquisitionDate DATE NOT NULL,
    purchaseCost DECIMAL(12,2) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'available',
    portable BOOLEAN NOT NULL,
    modelId INT NOT NULL,
    labId INT NOT NULL,
    FOREIGN KEY (modelId) REFERENCES EquipmentModel(modelId) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (labId) REFERENCES Laboratory(labId) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Certification (
    code VARCHAR(50) PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    issuingAuthority VARCHAR(150) NOT NULL,
    validityPeriod INT NOT NULL,
    safetyLevel VARCHAR(100) NOT NULL
);

CREATE TABLE Requires (
    modelId INT NOT NULL,
    certCode VARCHAR(50) NOT NULL,
    PRIMARY KEY (modelId, certCode),
    FOREIGN KEY (modelId) REFERENCES EquipmentModel(modelId) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (certCode) REFERENCES Certification(code) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Holds (
    pid INT NOT NULL,
    certCode VARCHAR(50) NOT NULL,
    issueDate DATE NOT NULL,
    expirationDate DATE NOT NULL,
    grade VARCHAR(50),
    PRIMARY KEY (pid, certCode),
    FOREIGN KEY (pid) REFERENCES Person(pid) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (certCode) REFERENCES Certification(code) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Reservation (
    resId INT PRIMARY KEY,
    submissionTS TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    plannedStart TIMESTAMP NOT NULL,
    plannedEnd TIMESTAMP NOT NULL,
    purpose VARCHAR(255) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    madeByPid INT NOT NULL,
    projectCode VARCHAR(50) NOT NULL,
    approverPid INT,
    FOREIGN KEY (madeByPid) REFERENCES Person(pid) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (projectCode) REFERENCES ResearchProject(code) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (approverPid) REFERENCES Person(pid) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Reserves (
    resId INT NOT NULL,
    serialNo VARCHAR(100) NOT NULL,
    PRIMARY KEY (resId, serialNo),
    FOREIGN KEY (resId) REFERENCES Reservation(resId) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (serialNo) REFERENCES EquipmentUnit(serialNo) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Maintenance (
    serialNo VARCHAR(100) NOT NULL,
    startTS TIMESTAMP NOT NULL,
    endTS TIMESTAMP NOT NULL,
    type VARCHAR(20) NOT NULL,
    description VARCHAR(255) NOT NULL,
    cost DECIMAL(12,2) NOT NULL,
    outcome VARCHAR(30) NOT NULL,
    technicalPid INT NOT NULL,
    PRIMARY KEY (serialNo, startTS),
    FOREIGN KEY (serialNo) REFERENCES EquipmentUnit(serialNo) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (technicalPid) REFERENCES Technical(pid) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE CalibrationRecord (
    serialNo VARCHAR(100) NOT NULL,
    calibDate DATE NOT NULL,
    calibrationType VARCHAR(100) NOT NULL,
    result VARCHAR(20) NOT NULL,
    nextDueDate DATE NOT NULL,
    remarks VARCHAR(255) NOT NULL,
    PRIMARY KEY (serialNo, calibDate),
    FOREIGN KEY (serialNo) REFERENCES EquipmentUnit(serialNo) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Consumable (
    consId INT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    unitOfMeasure VARCHAR(50) NOT NULL,
    hazardLevel VARCHAR(100) NOT NULL,
    reorderThreshold DECIMAL(12,2) NOT NULL
);

CREATE TABLE Supplier (
    suppId INT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    contactEmail VARCHAR(150) NOT NULL,
    phone VARCHAR(30) NOT NULL
);

CREATE TABLE Supplies (
    suppId INT NOT NULL,
    consId INT NOT NULL,
    labId INT NOT NULL,
    unitPrice DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (suppId, consId, labId),
    FOREIGN KEY (suppId) REFERENCES Supplier(suppId) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (consId) REFERENCES Consumable(consId) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (labId) REFERENCES Laboratory(labId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Stocks (
    labId INT NOT NULL,
    consId INT NOT NULL,
    quantityOnHand DECIMAL(12,2) NOT NULL DEFAULT 0,
    lastRestockDate DATE NOT NULL,
    storageCondition VARCHAR(150),
    technicalPid INT NOT NULL,
    monitoringSince DATE NOT NULL,
    PRIMARY KEY (labId, consId),
    FOREIGN KEY (labId) REFERENCES Laboratory(labId) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (consId) REFERENCES Consumable(consId) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (technicalPid) REFERENCES Technical(pid) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Consumes (
    resId INT NOT NULL,
    labId INT NOT NULL,
    consId INT NOT NULL,
    quantityUsed DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (resId, labId, consId),
    FOREIGN KEY (resId) REFERENCES Reservation(resId) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (labId, consId) REFERENCES Stocks(labId, consId) ON DELETE RESTRICT ON UPDATE CASCADE
);