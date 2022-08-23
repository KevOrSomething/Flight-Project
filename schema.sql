CREATE DATABASE  IF NOT EXISTS `sys` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `sys`;
-- MySQL dump 10.13  Distrib 8.0.27, for Win64 (x86_64)
--
-- Host: localhost    Database: sys
-- ------------------------------------------------------
-- Server version	8.0.27

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin_logins`
--

DROP TABLE IF EXISTS `admin_logins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_logins` (
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_logins`
--

LOCK TABLES `admin_logins` WRITE;
/*!40000 ALTER TABLE `admin_logins` DISABLE KEYS */;
INSERT INTO `admin_logins` VALUES ('admin','travel','John','Doe');
/*!40000 ALTER TABLE `admin_logins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aircraft`
--

DROP TABLE IF EXISTS `aircraft`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `aircraft` (
  `aircraftID` int NOT NULL,
  `numOfSeats` int DEFAULT NULL,
  PRIMARY KEY (`aircraftID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aircraft`
--

LOCK TABLES `aircraft` WRITE;
/*!40000 ALTER TABLE `aircraft` DISABLE KEYS */;
INSERT INTO `aircraft` VALUES (1,3),(2,4),(3,5),(4,6),(5,7);
/*!40000 ALTER TABLE `aircraft` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `airline_companies`
--

DROP TABLE IF EXISTS `airline_companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `airline_companies` (
  `airlineID` char(2) NOT NULL,
  PRIMARY KEY (`airlineID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `airline_companies`
--

LOCK TABLES `airline_companies` WRITE;
/*!40000 ALTER TABLE `airline_companies` DISABLE KEYS */;
INSERT INTO `airline_companies` VALUES ('AA'),('AF'),('AI'),('AS'),('BA'),('CX'),('DL'),('EI'),('LH'),('OS'),('QF'),('QR'),('SA'),('SQ'),('SW'),('TK'),('UA');
/*!40000 ALTER TABLE `airline_companies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `airports`
--

DROP TABLE IF EXISTS `airports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `airports` (
  `airportID` char(3) NOT NULL,
  PRIMARY KEY (`airportID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `airports`
--

LOCK TABLES `airports` WRITE;
/*!40000 ALTER TABLE `airports` DISABLE KEYS */;
INSERT INTO `airports` VALUES ('ANC'),('ATL'),('BKK'),('BOS'),('CDG'),('CLE'),('CPT'),('DEL'),('DEN'),('DFW'),('DUB'),('DXB'),('EWR'),('FLL'),('FRA'),('HNL'),('IAD'),('IST'),('JFK'),('LAS'),('LAX'),('LHR'),('MAD'),('MCO'),('MEL'),('MEX'),('MIA'),('MSY'),('MUC'),('ORD'),('PDX'),('PEK'),('PHL'),('PHX'),('PRG'),('SEA'),('SFO'),('SHA'),('SIN'),('SLC'),('SYD'),('VIE'),('YVR'),('YYZ');
/*!40000 ALTER TABLE `airports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `answers`
--

DROP TABLE IF EXISTS `answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `answers` (
  `questionID` int NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `answerInfo` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`questionID`),
  KEY `username` (`username`),
  CONSTRAINT `answers_ibfk_1` FOREIGN KEY (`questionID`) REFERENCES `questions` (`questionID`),
  CONSTRAINT `answers_ibfk_2` FOREIGN KEY (`username`) REFERENCES `rep_logins` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `answers`
--

LOCK TABLES `answers` WRITE;
/*!40000 ALTER TABLE `answers` DISABLE KEYS */;
/*!40000 ALTER TABLE `answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `arrives_at`
--

DROP TABLE IF EXISTS `arrives_at`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arrives_at` (
  `flightNum` int NOT NULL,
  `airlineID` char(2) NOT NULL,
  `airportID` char(3) DEFAULT NULL,
  `arrivalTime` time DEFAULT NULL,
  `arrivalDate` date NOT NULL,
  PRIMARY KEY (`airlineID`,`flightNum`),
  KEY `flightNum` (`flightNum`),
  KEY `airportID` (`airportID`),
  CONSTRAINT `arrives_at_ibfk_1` FOREIGN KEY (`flightNum`) REFERENCES `flights` (`flightNum`),
  CONSTRAINT `arrives_at_ibfk_2` FOREIGN KEY (`airlineID`) REFERENCES `airline_companies` (`airlineID`),
  CONSTRAINT `arrives_at_ibfk_3` FOREIGN KEY (`airportID`) REFERENCES `airports` (`airportID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `arrives_at`
--

LOCK TABLES `arrives_at` WRITE;
/*!40000 ALTER TABLE `arrives_at` DISABLE KEYS */;
INSERT INTO `arrives_at` VALUES (264,'AA','LAX','23:00:00','2021-12-16'),(265,'AA','LAX','23:00:00','2021-12-15'),(365,'AA','JFK','14:35:00','2021-12-15'),(366,'AA','JFK','18:55:00','2021-12-14'),(367,'AA','JFK','16:55:00','2021-12-13'),(368,'AA','JFK','16:50:00','2021-12-11'),(369,'AA','JFK','17:00:00','2021-12-09'),(370,'AA','JFK','04:00:00','2021-12-11'),(888,'AA','DUB','17:00:00','2022-01-23'),(897,'AA','JFK','20:00:00','2021-12-15'),(2,'AS','ANC','10:00:00','2021-11-05'),(27,'AS','ATL','02:45:00','2022-02-15'),(3,'BA','LHR','19:00:00','2021-12-05'),(9,'DL','LAX','19:00:00','2022-02-14'),(174,'DL','LAX','00:00:00','2021-12-15'),(383,'DL','JFK','12:15:00','2021-12-14'),(2,'EI','LAX','20:00:00','2021-12-15'),(33,'EI','DUB','12:45:00','2022-02-15'),(34,'EI','DUB','19:00:00','2021-12-05'),(35,'EI','DUB','22:00:00','2021-12-08'),(98,'EI','DUB','21:00:00','2021-12-05'),(429,'EI','JFK','11:25:00','2021-12-14'),(557,'EI','JFK','09:00:00','2021-12-14'),(837,'EI','LAX','22:15:00','2021-12-22'),(978,'EI','DUB','18:15:00','2021-12-05'),(995,'EI','SYD','22:00:00','2021-12-22'),(57,'LH','FRA','16:30:00','2021-12-05'),(6,'QF','SYD','21:00:00','2021-12-17'),(593,'QF','SYD','12:00:00','2021-12-23'),(100,'TK','CLE','16:00:00','2021-11-07'),(102,'TK','DXB','01:00:00','2021-11-02'),(420,'TK','BOS','12:00:00','2021-12-11'),(74,'UA','MAD','12:00:00','2021-12-05'),(107,'UA','MAD','14:00:00','2021-12-05'),(482,'UA','LAX','23:15:00','2021-12-11');
/*!40000 ALTER TABLE `arrives_at` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asks`
--

DROP TABLE IF EXISTS `asks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asks` (
  `questionID` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  PRIMARY KEY (`questionID`),
  KEY `username` (`username`),
  CONSTRAINT `asks_ibfk_1` FOREIGN KEY (`questionID`) REFERENCES `questions` (`questionID`),
  CONSTRAINT `asks_ibfk_2` FOREIGN KEY (`username`) REFERENCES `customer_logins` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asks`
--

LOCK TABLES `asks` WRITE;
/*!40000 ALTER TABLE `asks` DISABLE KEYS */;
/*!40000 ALTER TABLE `asks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `associated_with`
--

DROP TABLE IF EXISTS `associated_with`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `associated_with` (
  `airlineID` char(2) NOT NULL,
  `airportID` char(3) NOT NULL,
  PRIMARY KEY (`airlineID`,`airportID`),
  KEY `airportID` (`airportID`),
  CONSTRAINT `associated_with_ibfk_1` FOREIGN KEY (`airlineID`) REFERENCES `airline_companies` (`airlineID`),
  CONSTRAINT `associated_with_ibfk_2` FOREIGN KEY (`airportID`) REFERENCES `airports` (`airportID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `associated_with`
--

LOCK TABLES `associated_with` WRITE;
/*!40000 ALTER TABLE `associated_with` DISABLE KEYS */;
/*!40000 ALTER TABLE `associated_with` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `buys`
--

DROP TABLE IF EXISTS `buys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `buys` (
  `username` varchar(50) NOT NULL,
  `ticketID` int NOT NULL,
  `purchaseDate` date DEFAULT NULL,
  `purchaseTime` time DEFAULT NULL,
  `bookingFee` float DEFAULT NULL,
  PRIMARY KEY (`ticketID`),
  KEY `username` (`username`),
  CONSTRAINT `buys_ibfk_1` FOREIGN KEY (`username`) REFERENCES `customer_logins` (`username`),
  CONSTRAINT `buys_ibfk_2` FOREIGN KEY (`ticketID`) REFERENCES `tickets` (`ticketID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buys`
--

LOCK TABLES `buys` WRITE;
/*!40000 ALTER TABLE `buys` DISABLE KEYS */;
/*!40000 ALTER TABLE `buys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_logins`
--

DROP TABLE IF EXISTS `customer_logins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_logins` (
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_logins`
--

LOCK TABLES `customer_logins` WRITE;
/*!40000 ALTER TABLE `customer_logins` DISABLE KEYS */;
INSERT INTO `customer_logins` VALUES ('KrustyKrab','patrick','Spongebob','Squarepants'),('mrpresident','michelle','Barack','Obama'),('testing','password','first','last'),('username123','password','firstname','lastname');
/*!40000 ALTER TABLE `customer_logins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departs_from`
--

DROP TABLE IF EXISTS `departs_from`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departs_from` (
  `flightNum` int NOT NULL,
  `airlineID` char(2) NOT NULL,
  `airportID` char(3) DEFAULT NULL,
  `departTime` time DEFAULT NULL,
  `departDate` date NOT NULL,
  PRIMARY KEY (`airlineID`,`flightNum`),
  KEY `flightNum` (`flightNum`),
  KEY `airportID` (`airportID`),
  CONSTRAINT `departs_from_ibfk_1` FOREIGN KEY (`flightNum`) REFERENCES `flights` (`flightNum`),
  CONSTRAINT `departs_from_ibfk_2` FOREIGN KEY (`airlineID`) REFERENCES `airline_companies` (`airlineID`),
  CONSTRAINT `departs_from_ibfk_3` FOREIGN KEY (`airportID`) REFERENCES `airports` (`airportID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departs_from`
--

LOCK TABLES `departs_from` WRITE;
/*!40000 ALTER TABLE `departs_from` DISABLE KEYS */;
INSERT INTO `departs_from` VALUES (264,'AA','JFK','19:00:00','2021-12-16'),(265,'AA','JFK','19:00:00','2021-12-15'),(365,'AA','DUB','09:25:00','2021-12-15'),(366,'AA','DUB','14:15:00','2021-12-14'),(367,'AA','DUB','12:30:00','2021-12-13'),(368,'AA','DUB','11:55:00','2021-12-11'),(369,'AA','DUB','12:00:00','2021-12-09'),(370,'AA','DUB','23:00:00','2021-12-10'),(888,'AA','JFK','12:00:00','2022-01-23'),(897,'AA','DUB','14:00:00','2021-12-15'),(2,'AS','DXB','22:00:00','2021-11-04'),(27,'AS','LAX','21:00:00','2022-02-14'),(3,'BA','JFK','12:00:00','2021-12-05'),(9,'DL','SYD','03:00:00','2022-02-14'),(174,'DL','JFK','18:00:00','2021-12-14'),(383,'DL','DUB','06:15:00','2021-12-14'),(2,'EI','DUB','04:00:00','2021-12-15'),(33,'EI','ATL','04:30:00','2022-02-15'),(34,'EI','JFK','12:00:00','2021-12-05'),(35,'EI','JFK','15:00:00','2021-12-08'),(98,'EI','LHR','20:00:00','2021-12-05'),(429,'EI','DUB','04:00:00','2021-12-14'),(557,'EI','DUB','03:00:00','2021-12-14'),(837,'EI','DUB','09:25:00','2021-12-22'),(978,'EI','FRA','17:00:00','2021-12-05'),(995,'EI','DUB','01:00:00','2021-12-22'),(57,'LH','MAD','15:00:00','2021-12-05'),(6,'QF','LAX','06:00:00','2021-12-17'),(593,'QF','LAX','23:00:00','2021-12-22'),(100,'TK','ANC','10:00:00','2021-11-07'),(102,'TK','EWR','21:00:00','2021-11-01'),(420,'TK','JFK','07:00:00','2021-12-11'),(74,'UA','JFK','05:00:00','2021-12-05'),(107,'UA','JFK','06:00:00','2021-12-05'),(482,'UA','JFK','18:25:00','2021-12-11');
/*!40000 ALTER TABLE `departs_from` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flights`
--

DROP TABLE IF EXISTS `flights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flights` (
  `flightNum` int NOT NULL,
  `airlineID` char(2) NOT NULL,
  `price` float DEFAULT NULL,
  `flightType` char(1) NOT NULL,
  PRIMARY KEY (`flightNum`,`airlineID`),
  KEY `airlineID` (`airlineID`),
  CONSTRAINT `flights_ibfk_1` FOREIGN KEY (`airlineID`) REFERENCES `airline_companies` (`airlineID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flights`
--

LOCK TABLES `flights` WRITE;
/*!40000 ALTER TABLE `flights` DISABLE KEYS */;
INSERT INTO `flights` VALUES (2,'AS',666,'i'),(2,'EI',650,'i'),(3,'BA',350,'i'),(6,'QF',350,'i'),(9,'DL',780,'i'),(27,'AS',150,'d'),(33,'EI',485,'i'),(34,'EI',340,'i'),(35,'EI',400,'i'),(57,'LH',45,'i'),(74,'UA',350,'i'),(98,'EI',50,'i'),(100,'TK',100,'d'),(102,'TK',102,'i'),(107,'UA',300,'i'),(174,'DL',175,'d'),(264,'AA',150,'d'),(265,'AA',150,'d'),(365,'AA',128,'i'),(366,'AA',132,'i'),(367,'AA',146,'i'),(368,'AA',183,'i'),(369,'AA',130,'i'),(370,'AA',140,'i'),(383,'DL',398,'i'),(420,'TK',80,'d'),(429,'EI',452,'i'),(482,'UA',254,'d'),(557,'EI',563,'i'),(593,'QF',450,'i'),(837,'EI',650,'i'),(888,'AA',175,'i'),(897,'AA',300,'i'),(978,'EI',40,'i'),(995,'EI',1250,'i');
/*!40000 ALTER TABLE `flights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `in_waitlist_of`
--

DROP TABLE IF EXISTS `in_waitlist_of`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `in_waitlist_of` (
  `username` varchar(50) NOT NULL,
  `airlineID` char(2) NOT NULL,
  `flightNum` int NOT NULL,
  `alert` varchar(300) DEFAULT NULL,
  `departDate` date NOT NULL,
  `arrivalDate` date NOT NULL,
  PRIMARY KEY (`username`,`airlineID`,`flightNum`,`departDate`),
  KEY `username` (`username`),
  KEY `flightNum` (`flightNum`),
  KEY `in_waitlist_of_ibfk_2` (`airlineID`),
  CONSTRAINT `in_waitlist_of_ibfk_1` FOREIGN KEY (`username`) REFERENCES `customer_logins` (`username`),
  CONSTRAINT `in_waitlist_of_ibfk_2` FOREIGN KEY (`airlineID`) REFERENCES `airline_companies` (`airlineID`),
  CONSTRAINT `in_waitlist_of_ibfk_3` FOREIGN KEY (`flightNum`) REFERENCES `flights` (`flightNum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `in_waitlist_of`
--

LOCK TABLES `in_waitlist_of` WRITE;
/*!40000 ALTER TABLE `in_waitlist_of` DISABLE KEYS */;
/*!40000 ALTER TABLE `in_waitlist_of` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `includes`
--

DROP TABLE IF EXISTS `includes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `includes` (
  `ticketID` int NOT NULL,
  `airlineID` char(2) NOT NULL,
  `flightNum` int NOT NULL,
  `departDate` date NOT NULL,
  `arrivalDate` date NOT NULL,
  `seatNum` int DEFAULT NULL,
  PRIMARY KEY (`ticketID`,`airlineID`,`flightNum`,`departDate`),
  KEY `includes_ibfk_2` (`airlineID`),
  KEY `includes_ibfk_3` (`flightNum`),
  CONSTRAINT `includes_ibfk_1` FOREIGN KEY (`ticketID`) REFERENCES `tickets` (`ticketID`) ON DELETE CASCADE,
  CONSTRAINT `includes_ibfk_2` FOREIGN KEY (`airlineID`) REFERENCES `airline_companies` (`airlineID`),
  CONSTRAINT `includes_ibfk_3` FOREIGN KEY (`flightNum`) REFERENCES `flights` (`flightNum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `includes`
--

LOCK TABLES `includes` WRITE;
/*!40000 ALTER TABLE `includes` DISABLE KEYS */;
/*!40000 ALTER TABLE `includes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `owns`
--

DROP TABLE IF EXISTS `owns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `owns` (
  `aircraftID` int NOT NULL,
  `airlineID` char(2) DEFAULT NULL,
  PRIMARY KEY (`aircraftID`),
  KEY `airlineID` (`airlineID`),
  CONSTRAINT `owns_ibfk_1` FOREIGN KEY (`aircraftID`) REFERENCES `aircraft` (`aircraftID`),
  CONSTRAINT `owns_ibfk_2` FOREIGN KEY (`airlineID`) REFERENCES `airline_companies` (`airlineID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `owns`
--

LOCK TABLES `owns` WRITE;
/*!40000 ALTER TABLE `owns` DISABLE KEYS */;
INSERT INTO `owns` VALUES (1,'AA'),(2,'AF'),(3,'AI'),(4,'AS'),(5,'BA');
/*!40000 ALTER TABLE `owns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions` (
  `questionID` int NOT NULL AUTO_INCREMENT,
  `questionInfo` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`questionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rep_logins`
--

DROP TABLE IF EXISTS `rep_logins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rep_logins` (
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rep_logins`
--

LOCK TABLES `rep_logins` WRITE;
/*!40000 ALTER TABLE `rep_logins` DISABLE KEYS */;
INSERT INTO `rep_logins` VALUES ('george','ilovemyjob','George','Washington'),('john','ihatemyjob','John','Adams');
/*!40000 ALTER TABLE `rep_logins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets`
--

DROP TABLE IF EXISTS `tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tickets` (
  `ticketID` int NOT NULL AUTO_INCREMENT,
  `departDate` date DEFAULT NULL,
  `departTime` time DEFAULT NULL,
  `totalFare` float DEFAULT NULL,
  `ticketClass` char(1) NOT NULL,
  `isCancelled` char(1) NOT NULL,
  `cancelFee` float DEFAULT NULL,
  PRIMARY KEY (`ticketID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets`
--

LOCK TABLES `tickets` WRITE;
/*!40000 ALTER TABLE `tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `uses`
--

DROP TABLE IF EXISTS `uses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uses` (
  `airlineID` char(2) NOT NULL,
  `flightNum` int NOT NULL,
  `aircraftID` int DEFAULT NULL,
  PRIMARY KEY (`airlineID`,`flightNum`),
  KEY `flightNum` (`flightNum`),
  KEY `aircraftID` (`aircraftID`),
  CONSTRAINT `uses_ibfk_1` FOREIGN KEY (`airlineID`) REFERENCES `airline_companies` (`airlineID`),
  CONSTRAINT `uses_ibfk_2` FOREIGN KEY (`flightNum`) REFERENCES `flights` (`flightNum`),
  CONSTRAINT `uses_ibfk_3` FOREIGN KEY (`aircraftID`) REFERENCES `aircraft` (`aircraftID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `uses`
--

LOCK TABLES `uses` WRITE;
/*!40000 ALTER TABLE `uses` DISABLE KEYS */;
INSERT INTO `uses` VALUES ('AA',265,1),('AA',369,1),('AS',2,1),('EI',33,1),('AA',365,2),('AA',370,2),('EI',2,2),('TK',100,2),('AA',366,3),('AA',420,3),('QF',6,3),('TK',102,3),('AA',367,4),('AA',888,4),('DL',9,4),('DL',174,4),('AA',264,5),('AA',368,5),('AA',897,5),('AS',27,5);
/*!40000 ALTER TABLE `uses` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-12-10 20:49:59
