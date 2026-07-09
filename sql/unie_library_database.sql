-- =====================================
-- A3 - UNIE Library Project - Part 1
-- Md Munif Akanda - 3551133
-- =====================================


-- STEP 0: CLEAN START

IF DB_ID('UNIELibrary') IS NOT NULL
BEGIN
    ALTER DATABASE UNIELibrary SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE UNIELibrary;
END;
GO


-- STEP 1: CREATE DATABASE

CREATE DATABASE UNIELibrary;
GO
USE UNIELibrary;
GO


-- STEP 2: CREATE TABLES


CREATE TABLE Item (
    itemNo CHAR(10) PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    publisher VARCHAR(200),
    author VARCHAR(200),
    year CHAR(4),
    description VARCHAR(500),
    notes VARCHAR(300),
    subject VARCHAR(100)
);

CREATE TABLE Book (
    itemNo CHAR(10) PRIMARY KEY,
    ISBN CHAR(13),
    edition VARCHAR(20),
    contents VARCHAR(500),
    summary VARCHAR(500),
    FOREIGN KEY (itemNo) REFERENCES Item(itemNo)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Journal (
    itemNo CHAR(10) PRIMARY KEY,
    frequency VARCHAR(50),
    abbreviatedTitle VARCHAR(100),
    mainSeries VARCHAR(100),
    FOREIGN KEY (itemNo) REFERENCES Item(itemNo)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE OnlineDatabase (
    itemNo CHAR(10) PRIMARY KEY,
    contents VARCHAR(500),
    releaseDate DATE,
    FOREIGN KEY (itemNo) REFERENCES Item(itemNo)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Collection (
    collectionID CHAR(10) PRIMARY KEY,
    collectionName VARCHAR(100),
    campus VARCHAR(50),
    building VARCHAR(50),
    shelf VARCHAR(50)
);

CREATE TABLE CopyOfItem (
    accessionNo CHAR(15) PRIMARY KEY,
    itemNo CHAR(10),
    dateAdded DATE,
    cost DECIMAL(8,2),
    FOREIGN KEY (itemNo) REFERENCES Item(itemNo)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE PhysicalCopy (
    accessionNo CHAR(15) PRIMARY KEY,
    barcode VARCHAR(20),
    status VARCHAR(20) DEFAULT 'Available',
    collectionID CHAR(10),
    FOREIGN KEY (accessionNo) REFERENCES CopyOfItem(accessionNo)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (collectionID) REFERENCES Collection(collectionID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DigitalCopy (
    accessionNo CHAR(15) PRIMARY KEY,
    URL VARCHAR(300),
    format VARCHAR(20),
    accessPeriod VARCHAR(50),
    size DECIMAL(10,2),
    FOREIGN KEY (accessionNo) REFERENCES CopyOfItem(accessionNo)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE MemberType (
    memberTypeID CHAR(10) PRIMARY KEY,
    typeName VARCHAR(50),
    description VARCHAR(200)
);

CREATE TABLE Privilege (
    privilegeID CHAR(10) PRIMARY KEY,
    description VARCHAR(200),
    loanPeriod INT,
    maxRenewals INT,
    maxBorrowLimit INT,
    maxHoldLimit INT,
    memberTypeID CHAR(10),
    FOREIGN KEY (memberTypeID) REFERENCES MemberType(memberTypeID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Member (
    memberID CHAR(10) PRIMARY KEY,
    PIN CHAR(4),
    name VARCHAR(100),
    email VARCHAR(150),
    mobile VARCHAR(20),
    dateJoined DATE,
    membershipStatus VARCHAR(20),
    membershipExpirationDate DATE,
    memberTypeID CHAR(10),
    FOREIGN KEY (memberTypeID) REFERENCES MemberType(memberTypeID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Loan (
    loanID CHAR(12) PRIMARY KEY,
    accessionNo CHAR(15),
    memberID CHAR(10),
    dateLoaned DATE,
    dueDate DATE,
    loanStatus VARCHAR(20),
    renewalCount INT,
    FOREIGN KEY (accessionNo) REFERENCES PhysicalCopy(accessionNo)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (memberID) REFERENCES Member(memberID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE HoldRequest (
    holdRequestID CHAR(12) PRIMARY KEY,
    itemNo CHAR(10),
    memberID CHAR(10),
    holdRequestDateTime DATETIME,
    holdStatus VARCHAR(20),
    comments VARCHAR(300),
    FOREIGN KEY (itemNo) REFERENCES Item(itemNo)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (memberID) REFERENCES Member(memberID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AcquisitionRequest (
    acquisitionRequestID CHAR(12) PRIMARY KEY,
    memberID CHAR(10),
    requestedTitle VARCHAR(200),
    requestedDate DATE,
    requestStatus VARCHAR(20),
    FOREIGN KEY (memberID) REFERENCES Member(memberID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
GO


-- STEP 3: INSERT DATA


INSERT INTO MemberType (memberTypeID, typeName, description) VALUES
('MT001', 'Student', 'Student member'),
('MT002', 'Staff', 'Staff member'),
('MT003', 'Researcher', 'Research member'),
('MT004', 'External', 'External member'),
('MT005', 'Alumni', 'Alumni member'),
('MT006', 'Guest', 'Guest member');

INSERT INTO Privilege (privilegeID, description, loanPeriod, maxRenewals, maxBorrowLimit, maxHoldLimit, memberTypeID) VALUES
('PR001', 'Student borrowing rules', 14, 2, 6, 4, 'MT001'),
('PR002', 'Staff borrowing rules', 28, 3, 10, 5, 'MT002'),
('PR003', 'Researcher borrowing rules', 30, 4, 12, 6, 'MT003'),
('PR004', 'External borrowing rules', 10, 1, 4, 2, 'MT004'),
('PR005', 'Alumni borrowing rules', 14, 1, 5, 3, 'MT005'),
('PR006', 'Guest borrowing rules', 7, 0, 2, 1, 'MT006');

INSERT INTO Collection (collectionID, collectionName, campus, building, shelf) VALUES
('C001', 'Main General', 'Callaghan', 'Library A', 'S1'),
('C002', 'Engineering', 'Callaghan', 'Library B', 'S2'),
('C003', 'Business', 'City', 'Library C', 'S3'),
('C004', 'Health', 'Ourimbah', 'Library D', 'S4'),
('C005', 'Law', 'City', 'Library E', 'S5'),
('C006', 'Research', 'Callaghan', 'Library F', 'S6');

INSERT INTO Member (memberID, PIN, name, email, mobile, dateJoined, membershipStatus, membershipExpirationDate, memberTypeID) VALUES
('M001', '1234', 'zzz', 'zzz@unie.edu', '0400000001', '2025-01-15', 'Active', '2026-12-31', 'MT001'),
('M002', '1235', 'Aisha Khan', 'aisha@unie.edu', '0400000002', '2025-02-10', 'Active', '2026-12-31', 'MT002'),
('M003', '1236', 'Liam Chen', 'liam@unie.edu', '0400000003', '2025-03-12', 'Active', '2026-12-31', 'MT003'),
('M004', '1237', 'Noah Smith', 'noah@unie.edu', '0400000004', '2025-01-20', 'Active', '2026-12-31', 'MT004'),
('M005', '1238', 'Sara Ali', 'sara@unie.edu', '0400000005', '2025-04-05', 'Active', '2026-12-31', 'MT005'),
('M006', '1239', 'Eva Brown', 'eva@unie.edu', '0400000006', '2025-05-08', 'Active', '2026-12-31', 'MT006');

INSERT INTO Item (itemNo, title, publisher, author, year, description, notes, subject) VALUES
('I001', 'Database Systems', 'Pearson', 'Elmasri', '2023', 'Database concepts', 'Core text', 'Database'),
('I002', 'Advanced SQL', 'OReilly', 'Beaulieu', '2022', 'SQL programming', 'Popular title', 'Database'),
('I003', 'Machine Learning Basics', 'Springer', 'Murphy', '2024', 'ML foundations', 'New arrival', 'AI'),
('I004', 'Cyber Security Today', 'Wiley', 'Smith', '2021', 'Security overview', 'High demand', 'Security'),
('I005', 'Cloud Computing Intro', 'McGraw Hill', 'Rosen', '2020', 'Cloud concepts', 'General use', 'Cloud'),
('I006', 'Data Analytics Journal', 'Elsevier', 'Taylor', '2026', 'Analytics research', 'Journal issue', 'Analytics'),
('I007', 'ACM Digital Library', 'ACM', 'ACM', '2026', 'Online research db', 'Subscription', 'Research'),
('I008', 'Operating Systems', 'Pearson', 'Silberschatz', '2023', 'OS concepts', 'Core text', 'Systems');

INSERT INTO Book (itemNo, ISBN, edition, contents, summary) VALUES
('I001', '9780133970777', '7th', 'Ch1-Ch12', 'Comprehensive database book'),
('I002', '9781492057611', '2nd', 'Ch1-Ch10', 'Advanced SQL topics'),
('I003', '9783030000001', '1st', 'Ch1-Ch8', 'Intro to machine learning'),
('I004', '9781111111111', '3rd', 'Ch1-Ch9', 'Cyber security fundamentals'),
('I005', '9782222222222', '2nd', 'Ch1-Ch7', 'Cloud computing basics'),
('I008', '9783333333333', '10th', 'Ch1-Ch11', 'Operating systems overview');

INSERT INTO Journal (itemNo, frequency, abbreviatedTitle, mainSeries) VALUES
('I006', 'Monthly', 'DAJ', 'Data Analytics Series');

INSERT INTO OnlineDatabase (itemNo, contents, releaseDate) VALUES
('I007', 'Digital academic papers and journals', '2026-01-01');

INSERT INTO CopyOfItem (accessionNo, itemNo, dateAdded, cost) VALUES
('A001', 'I001', '2026-01-10', 89.90),
('A002', 'I001', '2026-01-11', 89.90),
('A003', 'I002', '2026-01-12', 75.00),
('A004', 'I003', '2026-01-13', 92.50),
('A005', 'I004', '2026-01-14', 88.20),
('A006', 'I005', '2026-01-15', 79.00),
('A007', 'I006', '2026-01-16', 40.00),
('A008', 'I007', '2026-01-17', 0.00),
('A009', 'I008', '2026-01-18', 95.00),
('A010', 'I002', '2026-01-19', 75.00);

INSERT INTO PhysicalCopy (accessionNo, barcode, status, collectionID) VALUES
('A001', 'BC001', 'On Loan', 'C001'),
('A002', 'BC002', 'Available', 'C001'),
('A003', 'BC003', 'On Hold', 'C002'),
('A004', 'BC004', 'On Loan', 'C003'),
('A005', 'BC005', 'Available', 'C004'),
('A006', 'BC006', 'Available', 'C005'),
('A007', 'BC007', 'Available', 'C006'),
('A009', 'BC009', 'On Loan', 'C001'),
('A010', 'BC010', 'Available', 'C002');

INSERT INTO DigitalCopy (accessionNo, URL, format, accessPeriod, size) VALUES
('A008', 'https://acm.example.edu', 'Web', '12 months', 0.00);

INSERT INTO Loan (loanID, accessionNo, memberID, dateLoaned, dueDate, loanStatus, renewalCount) VALUES
('L001', 'A001', 'M001', '2026-01-20', '2026-02-03', 'Returned', 1),
('L002', 'A004', 'M002', '2026-02-01', '2026-02-15', 'Returned', 0),
('L003', 'A009', 'M003', '2026-03-01', '2026-03-15', 'Returned', 2),
('L004', 'A001', 'M004', '2026-04-01', '2026-04-15', 'Returned', 0),
('L005', 'A003', 'M001', '2026-04-05', '2026-04-19', 'Open', 0),
('L006', 'A004', 'M005', '2026-04-06', '2026-04-20', 'Open', 1);

INSERT INTO HoldRequest (holdRequestID, itemNo, memberID, holdRequestDateTime, holdStatus, comments) VALUES
('H001', 'I002', 'M001', '2026-04-01 09:00:00', 'Pending', 'Need for assignment'),
('H002', 'I002', 'M002', '2026-04-01 10:00:00', 'Pending', 'Urgent'),
('H003', 'I002', 'M003', '2026-04-01 11:00:00', 'Pending', 'Course reading'),
('H004', 'I001', 'M004', '2026-04-02 09:00:00', 'Pending', 'Interested'),
('H005', 'I001', 'M005', '2026-04-02 10:00:00', 'Pending', 'Needed soon'),
('H006', 'I003', 'M001', '2026-04-03 09:00:00', 'Pending', 'Research use');

INSERT INTO AcquisitionRequest (acquisitionRequestID, memberID, requestedTitle, requestedDate, requestStatus) VALUES
('R001', 'M001', 'Python for Data Science', '2026-01-10', 'Submitted'),
('R002', 'M001', 'Deep Learning Illustrated', '2026-02-12', 'Submitted'),
('R003', 'M001', 'Practical Statistics', '2026-03-14', 'Approved'),
('R004', 'M002', 'Network Security Essentials', '2026-01-18', 'Submitted'),
('R005', 'M003', 'Data Mining Concepts', '2026-02-20', 'Rejected'),
('R006', 'M001', 'AI for Business', '2026-04-01', 'Submitted');
GO


-- STEP 4: TRIGGER SETUP


ALTER TABLE Member
ADD currentBorrowLimit INT NULL;
GO

UPDATE m
SET currentBorrowLimit = p.maxBorrowLimit
FROM Member m
JOIN MemberType mt
    ON m.memberTypeID = mt.memberTypeID
JOIN Privilege p
    ON mt.memberTypeID = p.memberTypeID;
GO

CREATE TABLE Notification (
    notificationID INT IDENTITY(1,1) PRIMARY KEY,
    holdRequestID CHAR(12) NOT NULL,
    memberID CHAR(10) NOT NULL,
    itemNo CHAR(10) NOT NULL,
    notificationDateTime DATETIME NOT NULL DEFAULT GETDATE(),
    message VARCHAR(300) NOT NULL,
    notificationStatus VARCHAR(20) NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (holdRequestID) REFERENCES HoldRequest(holdRequestID)
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY (memberID) REFERENCES Member(memberID)
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY (itemNo) REFERENCES Item(itemNo)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
GO


-- STEP 5: TRIGGER 1


CREATE OR ALTER TRIGGER trg_ReduceBorrowLimitOnOverdue
ON Loan
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE l
    SET loanStatus = 'Overdue'
    FROM Loan l
    JOIN inserted i
        ON l.loanID = i.loanID
    WHERE l.dueDate < CAST(GETDATE() AS DATE)
      AND l.loanStatus = 'Open';

    ;WITH AffectedMembers AS (
        SELECT DISTINCT memberID
        FROM inserted
        WHERE memberID IS NOT NULL
    ),
    MemberLoanCount AS (
        SELECT
            l.memberID,
            COUNT(*) AS currentLoans
        FROM Loan l
        WHERE l.loanStatus IN ('Open', 'Overdue')
        GROUP BY l.memberID
    )
    UPDATE m
    SET currentBorrowLimit =
        CASE
            WHEN ISNULL(ml.currentLoans, 0) > CEILING(p.maxBorrowLimit / 2.0)
                THEN ISNULL(ml.currentLoans, 0)
            ELSE CEILING(p.maxBorrowLimit / 2.0)
        END
    FROM Member m
    JOIN AffectedMembers am
        ON m.memberID = am.memberID
    JOIN MemberType mt
        ON m.memberTypeID = mt.memberTypeID
    JOIN Privilege p
        ON mt.memberTypeID = p.memberTypeID
    LEFT JOIN MemberLoanCount ml
        ON m.memberID = ml.memberID
    WHERE EXISTS (
        SELECT 1
        FROM Loan l2
        WHERE l2.memberID = m.memberID
          AND l2.loanStatus = 'Overdue'
    );
END;
GO


-- STEP 6: TRIGGER 2


CREATE OR ALTER TRIGGER trg_NotifyOnAvailableHoldItem
ON PhysicalCopy
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NextHold TABLE (
        accessionNo CHAR(15),
        itemNo CHAR(10),
        holdRequestID CHAR(12),
        memberID CHAR(10)
    );

    INSERT INTO @NextHold (accessionNo, itemNo, holdRequestID, memberID)
    SELECT
        ac.accessionNo,
        ac.itemNo,
        h.holdRequestID,
        h.memberID
    FROM (
        SELECT
            i.accessionNo,
            coi.itemNo
        FROM inserted i
        JOIN deleted d
            ON i.accessionNo = d.accessionNo
        JOIN CopyOfItem coi
            ON i.accessionNo = coi.accessionNo
        WHERE i.status = 'Available'
          AND d.status <> 'Available'
    ) ac
    JOIN HoldRequest h
        ON ac.itemNo = h.itemNo
    WHERE h.holdStatus = 'Pending'
      AND h.holdRequestDateTime = (
            SELECT MIN(h2.holdRequestDateTime)
            FROM HoldRequest h2
            WHERE h2.itemNo = ac.itemNo
              AND h2.holdStatus = 'Pending'
      );

    INSERT INTO Notification (holdRequestID, memberID, itemNo, message, notificationStatus)
    SELECT
        nh.holdRequestID,
        nh.memberID,
        nh.itemNo,
        'A held item is now available for you.',
        'Pending'
    FROM @NextHold nh;

    UPDATE h
    SET holdStatus = 'Notified'
    FROM HoldRequest h
    JOIN @NextHold nh
        ON h.holdRequestID = nh.holdRequestID;

    UPDATE pc
    SET status = 'On Hold'
    FROM PhysicalCopy pc
    JOIN @NextHold nh
        ON pc.accessionNo = nh.accessionNo;
END;
GO


-- STEP 7: REQUIRED QUERIES


-- Query 1
SELECT TOP 3
    m.name,
    m.mobile,
    COUNT(ar.acquisitionRequestID) AS numberOfRequests
FROM Member m
JOIN AcquisitionRequest ar
    ON m.memberID = ar.memberID
WHERE YEAR(ar.requestedDate) = 2026
GROUP BY m.memberID, m.name, m.mobile
ORDER BY COUNT(ar.acquisitionRequestID) DESC, m.name;

-- Query 2
SELECT
    m.name,
    p.maxBorrowLimit,
    COUNT(h.holdRequestID) AS currentHoldRequests
FROM Member m
JOIN MemberType mt
    ON m.memberTypeID = mt.memberTypeID
JOIN Privilege p
    ON mt.memberTypeID = p.memberTypeID
LEFT JOIN HoldRequest h
    ON m.memberID = h.memberID
    AND h.holdStatus = 'Pending'
WHERE m.name = 'zzz'
GROUP BY m.name, p.maxBorrowLimit;

-- Query 3
SELECT TOP 1
    i.title,
    COUNT(DISTINCT h.memberID) AS numberOfDistinctHolds
FROM Item i
JOIN HoldRequest h
    ON i.itemNo = h.itemNo
GROUP BY i.itemNo, i.title
ORDER BY COUNT(DISTINCT h.memberID) DESC, i.title;

-- Query 4
WITH BorrowCounts AS (
    SELECT
        coi.itemNo,
        COUNT(l.loanID) AS borrowCount
    FROM Loan l
    JOIN CopyOfItem coi
        ON l.accessionNo = coi.accessionNo
    WHERE YEAR(l.dateLoaned) = YEAR(GETDATE())
    GROUP BY coi.itemNo
),
HoldCounts AS (
    SELECT
        h.itemNo,
        COUNT(h.holdRequestID) AS holdCount
    FROM HoldRequest h
    WHERE YEAR(h.holdRequestDateTime) = YEAR(GETDATE())
    GROUP BY h.itemNo
)
SELECT TOP 3
    i.title,
    ISNULL(b.borrowCount, 0) + ISNULL(h.holdCount, 0) AS totalUsage,
    ISNULL(b.borrowCount, 0) AS borrowCount,
    ISNULL(h.holdCount, 0) AS holdCount
FROM Book bk
JOIN Item i
    ON bk.itemNo = i.itemNo
LEFT JOIN BorrowCounts b
    ON i.itemNo = b.itemNo
LEFT JOIN HoldCounts h
    ON i.itemNo = h.itemNo
ORDER BY totalUsage DESC, i.title;
GO