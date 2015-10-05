-- phpMyAdmin SQL Dump
-- version 3.3.3
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Generation Time: Aug 04, 2010 at 08:13 PM
-- Server version: 5.1.46
-- PHP Version: 5.3.1

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `CEDARCATALOG`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_role`
--

CREATE TABLE IF NOT EXISTS `tbl_role` (
  `role_id` int(32) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(64) NOT NULL,
  `parent_id` int(32) DEFAULT NULL,
  `role_context` varchar(64) NOT NULL,
  `context_column` varchar(64) NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;
