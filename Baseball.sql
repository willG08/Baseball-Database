SHOW DATABASES;
DROP DATABASE IF EXISTS baseball;
SET SQL_SAFE_UPDATES = 0;

CREATE DATABASE IF NOT EXISTS Baseball;
USE Baseball;

CREATE TABLE IF NOT EXISTS Team(
TeamID SMALLINT NOT NULL AUTO_INCREMENT,
TeamName VARCHAR(50) NOT NULL,
TeamCity VARCHAR(50),
TeamManager VARCHAR(50) NOT NULL,
PRIMARY KEY (TeamID)
);

CREATE TABLE IF NOT EXISTS	Player(
PlayerID	smallint	NOT NULL	AUTO_INCREMENT,
PlayerName	varchar(30)	NOT NULL,
PlayerDOB	date,
PRIMARY KEY (PlayerID)	
);

CREATE TABLE IF NOT EXISTS	Bat(
BatSerialNumber	smallint	NOT NULL,
BatManufacturer	varchar(50),
TeamID	smallint	NOT NULL,
PRIMARY KEY (BatSerialNumber),
FOREIGN KEY (TeamID) REFERENCES Team (TeamID)
);


CREATE TABLE IF NOT EXISTS	PlayerHistory(
PlayerHistoryID	smallint	NOT NULL	AUTO_INCREMENT,
PlayerBattingAverage	decimal(6,2),
PlayerStartDate	date,
PlayerEndDate	date,
PlayerPosition	varchar(10),
PlayerID	smallint	NOT NULL,
TeamID	smallint	NOT NULL,
PRIMARY KEY(PlayerHistoryID),
FOREIGN KEY (TeamID)
	REFERENCES Team (TeamID)
	ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (PlayerID)
	REFERENCES Player (PlayerID)
	ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS	Coach(
CoachID	smallint	NOT NULL	AUTO_INCREMENT,
CoachName	varchar(30),
CoachPhoneNumber	varchar(20),
CoachSalary	decimal(8,2),
TeamID	smallint	NOT NULL,
PRIMARY KEY (CoachID),
FOREIGN KEY (TeamID)
	REFERENCES Team (TeamID)
	ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS	UnitsOfWork(
UnitsNumber 	smallint	NOT NULL	AUTO_INCREMENT,
NumberOfYears	tinyint,	
ExperienceType	varchar(30),
CoachID	smallint	NOT NULL,
PRIMARY KEY(UnitsNumber),
FOREIGN KEY (CoachID)
	REFERENCES Coach(CoachID)
	ON UPDATE CASCADE ON DELETE CASCADE
);


INSERT INTO Team (TeamID, TeamName, TeamCity, TeamManager) 
Values 
	(1, 'Bulldogs', 'Scarlett', 'Bill'), 
	(2, 'Sliders', 'Harrion', 'Stank'), 
	(3, 'Hawks', 'Rittsburg', 'Robert'),
    (4, 'Bees', 'Trenton', 'Mac');

Select * FROM Team;

INSERT INTO Player (PlayerID,  PlayerName, PlayerDOB) 
VALUES 
	(1, 'James', '1990-01-01'), 
	(2, 'Boston', '1990-01-01'), 
    (3, 'Rick', '1990-01-01'), 
    (4, 'Steven', '1990-01-01'),
    (5, 'Jim', '1990-01-01'),
    (6, 'Hunter', '1990-01-02');

Select * FROM Player;

INSERT INTO Coach (CoachID, CoachName, CoachPhoneNumber, CoachSalary, TeamID) 
VALUES 
	(1, 'Simon', '111-111-1111', 10000, 1),
    (2, 'Allen', '222-222-2222', 12000, 2),
    (3, 'Jack', '333-333-3333', 11000, 3),
    (4, 'Hansen', '444-444-4444', 2000, 3);

Select * FROM Coach;

INSERT INTO UnitsOfWork(UnitsNumber, NumberOfYears, ExperienceType, CoachID)
VALUES 
	(1, 0, 'N/A', 1),
    (2, 1, 'Little League Baseball', 2),
    (3, 5, 'Weber State Head Coach', 3);

SELECT * FROM UnitsOfWork;

INSERT INTO PlayerHistory (PlayerHistoryID, TeamID, PlayerBattingAverage, PlayerStartDate, PlayerID, PlayerPosition)
VALUES
	(1, 1, .30, '2020-01-01', 1, 'FirstBase'),
	(2, 1, .20, '2020-01-01', 2, 'SecondBase'),
    (3, 1, .25, '2020-01-01', 3, 'ThirdBase'),
    (4, 2, .23, '2020-01-01', 4, 'Catcher'),
    (5, 2, .21, '2020-01-01', 5, 'ShortStop'),
    (6, 2, .22, '2020-01-01', 6, 'Pitcher');
    
SELECT * FROM PlayerHistory;

UPDATE PlayerHistory 
SET
	PlayerEndDate = '2020-07-02'
WHERE PlayerID IN (2, 4, 6);

SELECT * FROM PlayerHistory;

UPDATE Team
SET TeamManager = 'Vacant'
WHERE TeamID IN (
    SELECT TeamID FROM PlayerHistory WHERE PlayerHistory.TeamID IS NULL
);


UPDATE Coach
	LEFT JOIN UnitsOfWork
    ON Coach.CoachID = UnitsOfWork.CoachID
SET
	CoachSalary = ROUND((CoachSalary * 1.0255), 0)
WHERE 
	UnitsNumber IS NOT NULL;
    
    
SELECT * FROM UnitsOfWork;

DELETE FROM UnitsOfWork
WHERE CoachID IN (
    SELECT CoachID
    FROM Coach
    JOIN Team ON Team.TeamID = Coach.TeamID
    WHERE LEFT(Team.TeamCity, 1) NOT IN ('R', 'S', 'T')
);


SELECT * FROM PlayerHistory;

DELETE
FROM PlayerHistory 
ORDER BY PlayerBattingAverage
LIMIT 2;

SELECT * FROM PlayerHistory;

SELECT * FROM Team, Coach, Player, PlayerHistory, UnitsOfWork;

SET SQL_SAFE_UPDATES = 1;