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
-- Table tbl_parameter_code
--
-- +---------------+-------------+------+-----+-----------+-------+
-- | Field         | Type        | Null | Key | Default   | Extra |
-- +---------------+-------------+------+-----+-----------+-------+
-- | PARAMETER_ID  | int(10)     | NO   | PRI |           |       |
-- | LONG_NAME     | varchar(50) | NO   |     | UNDEFINED |       |
-- | SHORT_NAME    | varchar(50) | NO   |     | UNDEFINED |       |
-- | MADRIGAL_NAME | varchar(50) | NO   |     | UNDEFINED |       |
-- | UNITS         | varchar(50) | NO   |     | UNDEFINED |       |
-- | SCALE         | varchar(50) | NO   |     | UNDEFINED |       |
-- | NOTE_ID       | int(10)     | NO   |     | 0         |       |
-- +---------------+-------------+------+-----+-----------+-------+

CREATE TABLE `tbl_parameter_code` (
  `PARAMETER_ID` int(10) NOT NULL,
  `LONG_NAME` varchar(50) NOT NULL default 'UNDEFINED',
  `SHORT_NAME` varchar(50) NOT NULL default 'UNDEFINED',
  `MADRIGAL_NAME` varchar(50) NOT NULL default 'UNDEFINED',
  `UNITS` varchar(50) NOT NULL default 'UNDEFINED',
  `SCALE` varchar(50) NOT NULL default 'UNDEFINED',
  `NOTE_ID` int(10) NOT NULL default '0',
  PRIMARY KEY  (`PARAMETER_ID`)
);

-- -----------------------------------------------------------------------------
--
-- Table tbl_instrument
--
-- +-----------------+--------------+------+-----+-----------+-------+
-- | Field           | Type         | Null | Key | Default   | Extra |
-- +-----------------+--------------+------+-----+-----------+-------+
-- | KINST           | int(10)      | NO   | PRI | 0         |       |
-- | INST_NAME       | varchar(40)  | NO   |     | UNDEFINED |       |
-- | PREFIX          | varchar(3)   | NO   |     | UND       |       |
-- | DESCRIPTION     | text         | YES  |     |           |       |
-- | HAS_CLASS_TYPE  | tinyint(1)   | NO   |     | 0         |       |
-- | CLASS_TYPE_ID   | int(10)      | YES  |     |           |       |
-- | HAS_OBSERVATORY | tinyint(1)   | NO   |     | 0         |       |
-- | OBSERVATORY     | int(10)      | YES  |     |           |       |
-- | HAS_OP_MODE     | tinyint(1)   | NO   |     | 0         |       |
-- | OP_MODE         | varchar(200) | YES  |     |           |       |
-- | NOTE_ID         | int(10)      | NO   |     | 0         |       |
-- +-----------------+--------------+------+-----+-----------+-------+

CREATE TABLE `tbl_instrument` (
  `KINST` int(10) NOT NULL default '0',
  `INST_NAME` varchar(40) NOT NULL default 'UNDEFINED',
  `PREFIX` char(3) NOT NULL default 'UND',
  `DESCRIPTION` text,
  `HAS_CLASS_TYPE` tinyint(1) NOT NULL default '0',
  `CLASS_TYPE_ID` int(30) default NULL,
  `HAS_OBSERVATORY` tinyint(1) NOT NULL default '0',
  `OBSERVATORY` int(10) default NULL,
  `HAS_OP_MODE` tinyint(1) NOT NULL default '0',
  `OP_MODE` varchar(200) default NULL,
  `NOTE_ID` int(10) NOT NULL default '0',
  PRIMARY KEY  (`KINST`)
);

-- -----------------------------------------------------------------------------
--
-- Table tbl_observatory
--
-- +-------------------+--------------+------+-----+---------------+-------+
-- | Field             | Type         | Null | Key | Default       | Extra |
-- +-------------------+--------------+------+-----+---------------+-------+
-- | ID                | int(10)      | NO   | PRI |               |       |
-- | ALPHA_CODE        | varchar(50)  | NO   |     | UNDEFINED     |       |
-- | LONG_NAME         | varchar(40)  | NO   |     | UNDEFINED     |       |
-- | DUTY_CYCLE        | varchar(40)  | NO   |     | UNDEFINED     |       |
-- | OPERATIONAL_HOURS | varchar(40)  | NO   |     | UNDEFINED     |       |
-- | REF_URL           | varchar(120) | NO   |     | UNDEFINED     |       |
-- | DESCRIPTION       | text         | YES  |     |               |       |
-- | NOTE_ID           | int(10)      | NO   |     | 0             |       |
-- +-------------------+--------------+------+-----+---------------+-------+

CREATE TABLE `tbl_observatory` (
  `ID` int(10) NOT NULL,
  `ALPHA_CODE` varchar(50) NOT NULL default 'UNDEFINED',
  `LONG_NAME` varchar(40) NOT NULL default 'UNDEFINED',
  `DUTY_CYCLE` varchar(40) NOT NULL default 'UNDEFINED',
  `OPERATIONAL_HOURS` varchar(40) NOT NULL default 'UNDEFINED',
  `REF_URL` varchar(120) NOT NULL default 'UNDEFINED',
  `DESCRIPTION` text,
  `NOTE_ID` int(10) NOT NULL default '0',
  PRIMARY KEY  (`ID`)
);

-- -----------------------------------------------------------------------------
--
-- Table tbl_notes
-- +-------------+------------+------+-----+-------------------+--------------+
-- | Field       | Type       | Null | Key | Default           | Extra        |
-- +-------------+------------+------+-----+-------------------+--------------+
-- | ID          | int(10)    | NO   | PRI |                   |auto_increment|
-- | NOTE_USER   | int(5)     | NO   |     |                   |              |
-- | DESCRIPTION | text       | NO   |     |                   |              |
-- | NOTE_DATE   | timestamp  | NO   |     | CURRENT_TIMESTAMP |              |
-- | NEXT_NOTE   | int(10)    | NO   |     |                   |              |
-- | PUBLIC      | tinyint(1) | NO   |     | 0                 |              |
-- +-------------+------------+------+-----+-------------------+--------------+

CREATE TABLE `tbl_notes` (
  `ID` int(10) NOT NULL autoincrement,
  `NOTE_USER` int(5) NOT NULL,
  `DESCRIPTION` text NOT NULL,
  `NOTE_DATE` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `NEXT_NOTE` int(10) NOT NULL,
  `PUBLIC` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`ID`)
);

-- -----------------------------------------------------------------------------
--
-- Table tbl_site
--
-- +--------------+------------------+------+-----+-----------+----------------+
-- | Field        | Type             | Null | Key | Default   | Extra          |
-- +--------------+------------------+------+-----+-----------+----------------+
-- | ID           | int(30)          | NO   | PRI |           | auto_increment |
-- | DESCRIPTION  | text             | NO   |     |           |                |
-- | KINST        | int(10)          | NO   |     |           |                |
-- | SHORT_NAME   | varchar(10)      | NO   |     | UND       |                |
-- | LONG_NAME    | varchar(40)      | NO   |     | UNDEFINED |                |
-- | DESCRIPTION  | text             | NO   |     |           |                |
-- | LAT_DEGREES  | int(30)          | NO   |     | 0         |                |
-- | LAT_MINUTES  | int(30)          | NO   |     | 0         |                |
-- | LAT_SECONDS  | decimal(4,2)     | NO   |     | 00.00     |                |
-- | LONG_DEGREES | int(30)          | NO   |     | 0         |                |
-- | LONG_MINUTES | int(30)          | NO   |     | 0         |                |
-- | LONG_SECONDS | decimal(4,2)     | NO   |     | 00.00     |                |
-- | ALTITUDE     | decimal(10,8)    | NO   |     | 0.0000000 |                |
-- | NOTE_ID      | int(10)          | NO   |     | 0         |                |
-- +--------------+------------------+------+-----+-----------+----------------+

CREATE TABLE `tbl_site` (
  `ID` int(30) NOT NULL auto_increment,
  `KINST` int(10) NOT NULL default '0',
  `SHORT_NAME` varchar(10) NOT NULL default 'UND',
  `LONG_NAME` varchar(40) NOT NULL default 'UNDEFINED',
  `DESCRIPTION` text NOT NULL,
  `LAT_DEGREES` int(30) NOT NULL default '0',
  `LAT_MINUTES` int(30) unsigned NOT NULL default '0',
  `LAT_SECONDS` decimal(4,2) unsigned NOT NULL default '00.00',
  `LON_DEGREES` int(30) NOT NULL default '0',
  `LON_MINUTES` int(30) unsigned NOT NULL default '0',
  `LON_SECONDS` decimal(4,2) unsigned NOT NULL default '00.00',
  `ALT` decimal(10,8) NOT NULL default '0.00000000',
  `NOTE_ID` int(10) NOT NULL default '0',
  PRIMARY KEY  (`ID`)
);

-- -----------------------------------------------------------------------------
--
-- Table tbl_class_type
--
-- +---------+--------------+------+-----+---------+----------------+
-- | Field   | Type         | Null | Key | Default | Extra          |
-- +---------+--------------+------+-----+---------+----------------+
-- | ID      | int(10)      | NO   | PRI |         | auto_increment |
-- | NAME    | varchar(255) | NO   |     |         |                |
-- | PARENT  | int(10)      | NO   |     | 0       |                |
-- | NOTE_ID | int(10)      | NO   |     | 0       |                |
-- +---------+--------------+------+-----+---------+----------------+

CREATE TABLE `tbl_class_type` (
  `ID` int(10) NOT NULL auto_increment,
  `NAME` varchar(255) NOT NULL default '',
  `PARENT` int(10) NOT NULL default '0',
  `NOTE_ID` int(10) NOT NULL default '0',
  PRIMARY KEY  (`ID`)
);

-- -----------------------------------------------------------------------------
--
-- Table tbl_record_type
-- This table defines a unique record_type for every KINDAT-KINST combination
-- in the CEDAR database.
--
-- +----------------+-------------+------+-----+-----------+----------------+
-- | Field          | Type        | Null | Key | Default   | Extra          |
-- +----------------+-------------+------+-----+-----------+----------------+
-- | RECORD_TYPE_ID | int(10)     | NO   | UNI |           | auto_increment |
-- | KINDAT         | int(10)     | NO   | PRI |           |                |
-- | KINST          | int(10)     | NO   | PRI |           |                |
-- | DESCRIPTION    | varchar(60) | NO   |     | UNDEFINED |                |
-- +----------------+-------------+------+-----+-----------+----------------+

CREATE TABLE `tbl_record_type` (
  `RECORD_TYPE_ID` int(10) NOT NULL auto_increment,
  `KINDAT` int(10) NOT NULL,
  `KINST` int(10) NOT NULL,
  `DESCRIPTION` varchar(60) NOT NULL default 'UNDEFINED',
  PRIMARY KEY  (`KINDAT`,`KINST`),
  UNIQUE KEY `RECORD_TYPE_ID_INDEX` (`RECORD_TYPE_ID`)
);

-- -----------------------------------------------------------------------------
--
-- Table tbl_report
--
-- +-----------------+--------------+------+-----+-------------------+----------------+
-- | Field           | Type         | Null | Key | Default           | Extra          |
-- +-----------------+--------------+------+-----+-------------------+----------------+
-- | REPORT_ID       | int(10)      | NO   | PRI |                   | auto_increment |
-- | REQUEST_TIME    | timestamp    | NO   |     | current_timestamp |                |
-- | USER            | varchar(64)  | NO   |     | 0                 |                |
-- | REQUESTED       | varchar(255) | NO   |     | 0                 |                |
-- | CONSTRAINT_EXPR | varchar(255) | NO   |     | 0                 |                |
-- | DATA_PRODUCT    | varchar(64)  | NO   |     | 0                 |                |
-- +-----------------+--------------+------+-----+-------------------+----------------+

CREATE TABLE `tbl_report` (
  `request_id` int(10) NOT NULL auto_increment,
  `request_time` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `user` varchar(64) NOT NULL default '',
  `requested` varchar(255) NOT NULL default '',
  `constraint_expr` varchar(255) NOT NULL default '',
  `data_product` varchar(64) NOT NULL default '',
  PRIMARY KEY  (`request_id`)
);

-- --------------------------------------------------------
--
-- Table tbl_organization
--
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `tbl_organization` (
  `organization_id` int(32) NOT NULL AUTO_INCREMENT,
  `parent_id` int(32) DEFAULT NULL,
  `organization_name` varchar(256) NOT NULL,
  `organization_acronym` varchar(32) NOT NULL,
  `organization_url` varchar(256) DEFAULT NULL,
  `organization_logo` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`organization_id`)
) ;


-- --------------------------------------------------------
--
-- Table structure for table `tbl_person`
--
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `tbl_person` (
  `person_id` int(32) NOT NULL AUTO_INCREMENT,
  `user_id` int(32) DEFAULT NULL,
  `user_phone` varchar(64) DEFAULT NULL,
  `user_fax` varchar(64) DEFAULT NULL,
  `user_url` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`person_id`)
) ;


-- --------------------------------------------------------
--
-- Table structure for table `tbl_role`
--
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `tbl_role` (
  `role_id` int(32) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(64) NOT NULL,
  `parent_id` int(32) DEFAULT NULL,
  `role_context` varchar(64) NOT NULL,
  `context_column` varchar(64) NOT NULL,
  PRIMARY KEY (`role_id`)
) ;


-- --------------------------------------------------------
--
-- Table structure for table `tbl_person_role`
--
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `tbl_person_role` (
  `person_role_id` int(32) NOT NULL AUTO_INCREMENT,
  `person_id` int(32) NOT NULL,
  `role_id` int(32) NOT NULL,
  `organization_id` int(32) DEFAULT NULL,
  `context_id` int(32) DEFAULT NULL,
  PRIMARY KEY (`person_role_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=102 ;

