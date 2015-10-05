-- phpMyAdmin SQL Dump
-- version 3.3.3
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Generation Time: Aug 04, 2010 at 08:12 PM
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
-- Table structure for table `tbl_organization`
--

CREATE TABLE IF NOT EXISTS `tbl_organization` (
  `organization_id` int(32) NOT NULL AUTO_INCREMENT,
  `parent_id` int(32) DEFAULT NULL,
  `organization_name` varchar(256) NOT NULL,
  `organization_acronym` varchar(32) NOT NULL,
  `organization_url` varchar(256) DEFAULT NULL,
  `organization_logo` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`organization_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;
