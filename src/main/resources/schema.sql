-- -------------------------------------------------------------
-- LexCuria database instantiation schema for court management
-- -------------------------------------------------------------

CREATE TABLE IF NOT EXISTS court_judges (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(64) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) DEFAULT 'Judge',
    chamber VARCHAR(30) NOT NULL,
    courtroom VARCHAR(30) NOT NULL,
    active BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS court_cases (
    id INT AUTO_INCREMENT PRIMARY KEY,
    case_number VARCHAR(50) NOT NULL UNIQUE,
    title VARCHAR(150) NOT NULL,
    type VARCHAR(50) NOT NULL,
    priority VARCHAR(20) DEFAULT 'Medium',
    status VARCHAR(50) DEFAULT 'Pending',
    hearing_date DATE NOT NULL,
    courtroom VARCHAR(30) NOT NULL,
    judge_id INT REFERENCES court_judges(id),
    description CLOB,
    latest_update VARCHAR(500)
);

-- Seed Initial Judicial Accounts (Password for both: judgepassword123)
-- SHA-256: d18b9c7b91d9047cb8dfa38efc695dbfedcb4ff49f2b879a83ebf9c3ff475b63
INSERT INTO court_judges (username, password_hash, full_name, role, chamber, courtroom) 
VALUES ('j_collins', 'd18b9c7b91d9047cb8dfa38efc695dbfedcb4ff49f2b879a83ebf9c3ff475b63', 'Patricia Collins', 'District Presiding Judge', 'Chamber 402B', 'Bench 4A');

INSERT INTO court_judges (username, password_hash, full_name, role, chamber, courtroom) 
VALUES ('j_harrison', 'd18b9c7b91d9047cb8dfa38efc695dbfedcb4ff49f2b879a83ebf9c3ff475b63', 'Richard Harrison', 'Senior Magistrate', 'Chamber 101D', 'Bench 2B');

-- Seed Mock Pending Court Docket Cases
INSERT INTO court_cases (case_number, title, type, priority, status, hearing_date, courtroom, judge_id, description, latest_update)
VALUES ('CR-2026-0421', 'State vs. Derek Vance', 'Criminal', 'High', 'Pending', '2026-06-03', 'Bench 4A', 1, 'First-degree felony charges regarding financial asset fraud and corporate cyber espionage.', 'Indictment accepted into judicial records.');

INSERT INTO court_cases (case_number, title, type, priority, status, hearing_date, courtroom, judge_id, description, latest_update)
VALUES ('CV-2026-1188', 'OmniCorp vs. Zenith Security Systems', 'Civil', 'Medium', 'Under Review', '2026-06-15', 'Bench 4A', 1, 'Contract breach and non-disclosure liability complaint involving proprietary algorithm leaks.', 'Motions to suppress evidence currently under active review in chambers.');

INSERT INTO court_cases (case_number, title, type, priority, status, hearing_date, courtroom, judge_id, description, latest_update)
VALUES ('FM-2026-3392', 'In Re: Guardianship of Miller Minors', 'Family', 'High', 'Hearing Scheduled', '2026-06-02', 'Bench 4A', 1, 'Emergency custody hearing regarding probate trust assets allocation.', 'Summons and notices served to estate representatives; hearing scheduled for 9:00 AM.');

INSERT INTO court_cases (case_number, title, type, priority, status, hearing_date, courtroom, judge_id, description, latest_update)
VALUES ('CR-2026-9051', 'State vs. Marcus Sterling', 'Criminal', 'Low', 'Decided', '2026-05-28', 'Bench 2B', 2, 'Misdemeanor ordinance violation regarding commercial property boundaries.', 'Final adjudication issued; fine assessed at $500.');
