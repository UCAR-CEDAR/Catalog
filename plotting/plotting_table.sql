-- -----------------------------------------------------------------------------
-- MySQL Search and Query Language (SQL)
--
-- National Center for Atmospheric Research. (NCAR)
-- High Altitude Observatory. (HAO)
-- Boulder, Colorado. USA
-- Created by Jose Humberto Garcia. February, 2008.
--
-- This script must be run by the MySQL client (mysql)
-- in order to create the CEDAR database table for plotting.
--
-- This script is modeled after the database schema specified on 
-- CEDARDB_entity_relationship_diagram.txt
-- -----------------------------------------------------------------------------

-- --------------------------------------------------------
-- 
-- Table tbl_plotting_params
-- 
-- +---------------+--------------+------+-----+-------------+-------+
-- | Field         | Type         | Null | Key | Default     | Extra |
-- +---------------+--------------+------+-----+-------------+-------+
-- | KINST         | int(11)      | NO   | PRI | 0           |       |
-- | KINDAT        | int(11)      | NO   | PRI | 0           |       |
-- | PARAMTER_ID   | int(11)      | NO   | PRI | 0           |       |
-- | REQUIRES      | varchar(255) | NO   |     |             |       |
-- | PLOT_FUNC     | varchar(255) | NO   |     |             |       |
-- | IND_FUNC      | varchar(255) | NO   |     | time_m21m34 |       |
-- | DEFAULT_LABEL | varchar(255) | NO   |     |             |       |
-- | DEFAULT_MIN   | float        | NO   |     | 0           |       |
-- | DEFAULT_MAX   | float        | NO   |     | 0           |       |
-- +---------------+--------------+------+-----+-------------+-------+

DROP TABLE IF EXISTS `tbl_plotting_params`;
CREATE TABLE `tbl_plotting_params` (
  `KINST` int(11) NOT NULL default '0',
  `KINDAT` int(11) NOT NULL default '0',
  `PARAMETER_ID` int(11) NOT NULL default '0',
  `requires` varchar(255) NOT NULL default '',
  `plot_func` varchar(255) NOT NULL default '',
  `ind_func` varchar(255) NOT NULL default 'time_m21m34',
  `default_label` varchar(255) NOT NULL default '',
  `default_min` float NOT NULL default '0',
  `default_max` float NOT NULL default '0',
  PRIMARY KEY  (`KINST`,`KINDAT`,`PARAMETER_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Dumping data for table `tbl_plotting_params`
-- 

INSERT INTO `tbl_plotting_params` (`KINST`, `KINDAT`, `PARAMETER_ID`, `requires`, `plot_func`, `ind_func`, `default_label`, `default_min`, `default_max`)
VALUES
(5340, 7001, 810, '810,21,34,130,140', 'fpi', 'time_m21m34', 'Tn', 0, 2500),
(5340, 7001, 2506, '2506,21,34,130,140', 'fpi', 'time_m21m34', 'Rel Brightness', 0, 10),
(5340, 7001, 800, '800,21,34,130,140', 'fpi', 'time_m21m34', 'V(+Up)', -500, 400),
(5340, 7001, 1410, '1410,21,34,130,140', 'fpi', 'time_m21m34', 'V(EW)', -500, 400),
(5340, 7001, 1420, '1420,21,34,130,140', 'fpi', 'time_m21m34', 'V(NS)', -500, 400),
(5300, 7002, 810, '810,21,34', 'fpi', 'time_m21m34', 'Tn', 0, 2500),
(5300, 7002, 2507, '2507,21,34', 'fpi', 'time_m21m34', 'Rel Brightness', 0, 500),
(5300, 7002, 800, '800,21,34', 'fpi', 'time_m21m34', 'V(+Up)', -500, 400),
(5300, 7002, 1410, '1410,21,34', 'fpi', 'time_m21m34', 'V(EW)', -500, 400),
(5300, 7002, 1420, '1420,21,34', 'fpi', 'time_m21m34', 'V(NS)', -500, 400),
(5300, 7003, 810, '810,21,34', 'fpi', 'time_m21m34', 'Tn', 0, 2500),
(5300, 7003, 2507, '2507,21,34', 'fpi', 'time_m21m34', 'Rel Brightness', 0, 500),
(5300, 7003, 800, '800,21,34', 'fpi', 'time_m21m34', 'V(+Up)', -500, 400),
(5300, 7003, 1410, '1410,21,34', 'fpi', 'time_m21m34', 'V(EW)', -500, 400),
(5300, 7003, 1420, '1420,21,34', 'fpi', 'time_m21m34', 'V(NS)', -500, 400),
(5160, 17001, 2505, '2505,21,34', 'fpi', 'time_m21m34', 'Rel Brightness', 0, 500),
(5160, 17001, 1411, '1411,21,34', 'fpi', 'time_m21m34', 'V(EW)', -500, 400),
(5160, 17001, 1421, '1421,21,34', 'fpi', 'time_m21m34', 'V(NS)', -500, 400),
(5340, 17001, 1410, '1410,21,34', 'fpi', 'time_m21m34', 'V(EW)', -500, 400),
(5340, 17001, 1420, '1420,21,34', 'fpi', 'time_m21m34', 'V(NS)', -500, 400),
(53, 9801, 500, '500,-500,110', 'binhnt', 'time_m21m34', 'NEUC (Te/Ti=1)', 4e+11, 3e+12),
(53, 9801, 550, '550,-550,110', 'binhnt', 'time_m21m34', 'TI', 0, 3000),
(53, 9801, 560, '560,-560,110', 'binhnt', 'time_m21m34', 'TE', 0, 5000),
(53, 9801, 580, '580,-580,110', 'binhnt', 'time_m21m34', 'VO', -500, 500),
(180, 17002, 370, '370,21,34', 'fpi', 'time_m21m34', 'Mag Lat', 50, 70),
(5015, 17011, 810, '21,34,130,140,153,156,440,810', 'fpi', 'time_m21m34', 'Tn', 0, 2500),
(5015, 17011, 1410, '21,34,130,140,153,156,440,1410', 'fpi', 'time_m21m34', 'V(EW)', -500, 400),
(5015, 17011, 1420, '21,34,130,140,153,156,440,1420', 'fpi', 'time_m21m34', 'V(NS)', -500, 400),
(5015, 17011, 1431, '21,34,130,140,153,156,440,1431', 'fpi', 'time_m21m34', 'V(UP)', -500, 400),
(5015, 17011, 2400, '21,34,130,140,153,156,440,2400', 'fpi', 'time_m21m34', 'Lambda', 0, 1000),
(5015, 17011, 2506, '21,34,130,140,153,156,440,2506', 'fpi', 'time_m21m34', 'Rel Brightness', 0, 10),
(5430, 7001, 800, '800,21,34,130,140,440', 'fpi', 'time_m21m34', 'V(+Up)', -500, 400),
(5430, 7001, 810, '810,21,34,130,140,440', 'fpi', 'time_m21m34', 'Tn', 0, 2500),
(5430, 7001, 1410, '1410,21,34,130,140,440', 'fpi', 'time_m21m34', 'V(EW)', -500, 400),
(5430, 7001, 1420, '1420,21,34,130,140,440', 'fpi', 'time_m21m34', 'V(NS)', -500, 400),
(5430, 7001, 2400, '2400,21,34', 'fpi', 'time_m21m34', 'Lambda', 0, 1000),
(5430, 7001, 2507, '2507,21,34,130,140,440', 'fpi', 'time_m21m34', 'Rel Brightness', 0, 500),
(5460, 17001, 810, '810,21,34,130,140', 'fpi', 'time_m21m34', 'Tn', 0, 2500),
(5460, 17001, 1430, '1430,21,34,130,140', 'fpi', 'time_m21m34', 'V(UP)', -500, 400),
(5460, 17001, 1440, '1440,21,34,130,140', 'fpi', 'time_m21m34', 'V(PE)', -500, 400),
(5460, 17001, 1455, '1455,21,34,130,140', 'fpi', 'time_m21m34', 'V(H)', -500, 400),
(5460, 17001, 2400, '2400,21,34', 'fpi', 'time_m21m34', 'Lambda', 0, 1000),
(5460, 17001, 2505, '2505,21,34', 'fpi', 'time_m21m34', 'Rel Brightness', 0, 500);
