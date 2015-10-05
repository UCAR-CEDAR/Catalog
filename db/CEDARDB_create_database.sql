-- -----------------------------------------------------------------------------
-- MySQL Search and Query Language (SQL)
--
-- National Center for Atmospheric Research. (NCAR)
-- High Altitude Observatory. (HAO)
-- Boulder, Colorado. USA
-- Created by Jose Humberto Garcia. February, 2008.
--
-- This script must be run by the MySQL client (mysql)
-- in order to create the CEDAR database which handles meta data
-- about the information existing in all cbf files per directory.
--
-- This script is modeled after the database schema specified on 
-- CEDARDB_entity_relationship_diagram.txt
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--
-- Table tbl_version
-- Defines the version of CEDARDB	
-- 
-- +---------------+----------+------+-----+-------------------+-------+
-- | Field         | Type     | Null | Key | Default           | Extra |
-- +---------------+----------+------+-----+-------------------+-------+
-- | VERSION       | char(10) | NO   |     |                   |       |
-- | CREATED       | date     | NO   |     | 0000-00-00        |       |
-- | LAST_MODIFIED | char(40) | NO   |     | CURRENT_TIMESTAMP |       |
-- +---------------+----------+------+-----+-------------------+-------+

CREATE TABLE `tbl_version` (
  `VERSION` char(10) NOT NULL,
  `CREATED` date NOT NULL,
  `LAST_MODIFIED` timestamp NOT NULL default CURRENT_TIMESTAMP
);
INSERT INTO tbl_version VALUES ("1.6.2",curdate(),now());

-- -----------------------------------------------------------------------------
--
-- Table tbl_date
-- Contains all the days since January 1 of 1950 and assigns to each day a
-- unique ID.
--
-- +---------+---------+------+-----+---------+----------------+
-- | Field   | Type    | Null | Key | Default | Extra          |
-- +---------+---------+------+-----+---------+----------------+
-- | DATE_ID | int(10) |      | UNI | 0       | auto_increment |
-- | YEAR    | int(5)  |      | PRI | 0       |                |
-- | MONTH   | int(5)  |      | PRI | 0       |                |
-- | DAY     | int(5)  |      | PRI | 0       |                |
-- +---------+---------+------+-----+---------+----------------+

CREATE TABLE `tbl_date` (
  `DATE_ID` int(10) NOT NULL auto_increment,
  `YEAR` int(5) NOT NULL,
  `MONTH` int(5) NOT NULL,
  `DAY` int(5) NOT NULL,
  PRIMARY KEY  (`YEAR`,`MONTH`,`DAY`),
  UNIQUE KEY `DATE_ID_INDEX` (`DATE_ID`)
);


-- -----------------------------------------------------------------------------
--
-- Table tbl_date_in_file
-- Links the tbl_dates table with the tbl_cedar_files table, therefore each
-- duplex which is unique defines in which files data for an specific date
-- can be found.
--
-- +-------------------+---------+------+-----+---------+-------+
-- | Field             | Type    | Null | Key | Default | Extra |
-- +-------------------+---------+------+-----+---------+-------+
-- | DATE_ID           | int(10) |      | PRI | 0       |       |
-- | RECORD_IN_FILE_ID | int(10) |      | PRI | 0       |       |
-- +-------------------+---------+------+-----+---------+-------+

CREATE TABLE `tbl_date_in_file` (
  `DATE_ID` int(10) NOT NULL,
  `RECORD_IN_FILE_ID` int(10) NOT NULL,
  PRIMARY KEY  (`DATE_ID`,`RECORD_IN_FILE_ID`)
);

-- -----------------------------------------------------------------------------
--
-- Table tbl_record_in_file_first_last
--
-- +-------------------+---------+------+-----+---------+-------+
-- | Field             | Type    | Null | Key | Default | Extra |
-- +-------------------+---------+------+-----+---------+-------+
-- | RECORD_IN_FILE_ID | int(10) |      | PRI |         |       |
-- | FIRST_YEAR        | int(5)  |      |     |         |       |
-- | FIRST_MONTH       | int(5)  |      |     |         |       |
-- | FIRST_DAY         | int(5)  |      |     |         |       |
-- | FIRST_HOUR        | int(5)  |      |     |         |       |
-- | FIRST_MINUTE      | int(5)  |      |     |         |       |
-- | FIRST_MILISECOND  | int(5)  |      |     |         |       |
-- | LAST_YEAR         | int(5)  |      |     |         |       |
-- | LAST_MONTH        | int(5)  |      |     |         |       |
-- | LAST_DAY          | int(5)  |      |     |         |       |
-- | LAST_HOUR         | int(5)  |      |     |         |       |
-- | LAST_MINUTE       | int(5)  |      |     |         |       |
-- | LAST_MILISECOND   | int(5)  |      |     |         |       |
-- +-------------------+---------+------+-----+---------+-------+

CREATE TABLE `tbl_record_in_file_first_last` (
  `RECORD_IN_FILE_ID` int(10) NOT NULL,
  `FIRST_YEAR` int(5) NOT NULL,
  `FIRST_MONTH` int(5) NOT NULL,
  `FIRST_DAY` int(5) NOT NULL,
  `FIRST_HOUR` int(5) NOT NULL,
  `FIRST_MINUTE` int(5) NOT NULL,
  `FIRST_MILISECOND` int(5) NOT NULL,
  `LAST_YEAR` int(5) NOT NULL,
  `LAST_MONTH` int(5) NOT NULL,
  `LAST_DAY` int(5) NOT NULL,
  `LAST_HOUR` int(5) NOT NULL,
  `LAST_MINUTE` int(5) NOT NULL,
  `LAST_MILISECOND` int(5) NOT NULL,
  PRIMARY KEY  (`RECORD_IN_FILE_ID`)
);

-- -----------------------------------------------------------------------------
--
-- Table tbl_cedar_file
-- Contains information about the current set of files in the CEDAR database.
-- Every file gets a unique FILE_ID to improve query performance and to 
-- associate the information in this table with the rest of the database.
-- 
-- +-----------+--------------+------+-----+---------+----------------+
-- | Field     | Type         | Null | Key | Default | Extra          |
-- +-----------+--------------+------+-----+---------+----------------+
-- | FILE_ID   | int(10)      | NO   | UNI |         | auto_increment |
-- | FILE_NAME | varchar(255) | NO   | PRI |         |                |
-- | FILE_SIZE | int(10)      | NO   |     |         |                |
-- | FILE_MARK | varchar(50)  | NO   |     |         |                |
-- | NRECORDS  | int(10)      | NO   |     |         |                |
-- +-----------+--------------+------+-----+---------+----------------+

CREATE TABLE `tbl_cedar_file` (
  `FILE_ID` int(10) NOT NULL auto_increment,
  `FILE_NAME` varchar(255) NOT NULL,
  `FILE_SIZE` int(10) NOT NULL,
  `FILE_MARK` varchar(50) NOT NULL,
  `NRECORDS` int(10) NOT NULL,
  PRIMARY KEY  (`FILE_NAME`),
  UNIQUE KEY `FILE_ID_INDEX` (`FILE_ID`)
);

-- -----------------------------------------------------------------------------
--
-- Table tbl_file_info
-- Contains the information about what "type of record" (see table
-- tbl_record_types) exist for every file in the CEDAR database, In this table
-- every file is identified with the unique index FILE_ID defined in the table
-- tbl_cedar_files.
--
-- +-------------------+---------+------+-----+---------+----------------+
-- | Field             | Type    | Null | Key | Default | Extra          |
-- +-------------------+---------+------+-----+---------+----------------+
-- | RECORD_IN_FILE_ID | int(10) |      | UNI | 0       | auto_increment |
-- | FILE_ID           | int(10) |      | PRI | 0       |                |
-- | RECORD_TYPE_ID    | int(10) |      | PRI | 0       |                |
-- +-------------------+---------+------+-----+---------+----------------+

CREATE TABLE `tbl_file_info` (
  `RECORD_IN_FILE_ID` int(10) NOT NULL auto_increment,
  `FILE_ID` int(10) NOT NULL,
  `RECORD_TYPE_ID` int(10) NOT NULL,
  PRIMARY KEY  (`RECORD_IN_FILE_ID`,`FILE_ID`,`RECORD_TYPE_ID`)
);


-- -----------------------------------------------------------------------------
--
-- Table tbl_record_info
--
-- +----------------+---------+------+-----+---------+-------+
-- | Field          | Type    | Null | Key | Default | Extra |
-- +----------------+---------+------+-----+---------+-------+
-- | RECORD_TYPE_ID | int(10) |      | PRI |         |       |
-- | PARAMETER_ID   | int(10) |      | PRI |         |       |
-- +----------------+---------+------+-----+---------+-------+

CREATE TABLE `tbl_record_info` (
  `RECORD_TYPE_ID` int(10) NOT NULL,
  `PARAMETER_ID` int(10) NOT NULL,
  PRIMARY KEY  (`RECORD_TYPE_ID`,`PARAMETER_ID`)
);

