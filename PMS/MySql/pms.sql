-- MySQL dump 10.13  Distrib 5.5.16, for Win32 (x86)
--
-- Host: localhost    Database: pms
-- ------------------------------------------------------
-- Server version	5.5.16-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `backlog`
--

DROP TABLE IF EXISTS `backlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `backlog` (
  `log_Id` int(11) NOT NULL AUTO_INCREMENT,
  `chanID` int(11) DEFAULT NULL,
  `userID` int(11) DEFAULT NULL,
  `msgDate` date DEFAULT NULL,
  `message` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`log_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backlog`
--

LOCK TABLES `backlog` WRITE;
/*!40000 ALTER TABLE `backlog` DISABLE KEYS */;
INSERT INTO `backlog` VALUES (1,NULL,NULL,NULL,'Zum Geburtstag im Juni\n'),(2,NULL,NULL,NULL,'\n'),(3,NULL,NULL,NULL,'Den Jahreszeiten allen\n'),(4,NULL,NULL,NULL,'Selbviert sei Preis und Ehr!\n'),(5,NULL,NULL,NULL,'Nun sag ich: Mir gefallen\n'),(6,NULL,NULL,NULL,'Sie minder oder mehr.\n'),(7,NULL,NULL,NULL,'\n'),(8,NULL,NULL,NULL,'Der Frühling wird ja immer\n'),(9,NULL,NULL,NULL,'Gerühmt, wie sich\'s gebührt,\n'),(10,NULL,NULL,NULL,'Weil er mit grünem Schimmer\n'),(11,NULL,NULL,NULL,'Die graue Welt verziert.\n'),(12,NULL,NULL,NULL,'\n'),(13,NULL,NULL,NULL,'Doch hat in unsrer Zone\n'),(14,NULL,NULL,NULL,'Er durch den Reif der Nacht\n'),(15,NULL,NULL,NULL,'Schon manche grüne Bohne\n'),(16,NULL,NULL,NULL,'Und Gurke umgebracht.\n'),(17,NULL,NULL,NULL,'\n'),(18,NULL,NULL,NULL,'Stets wird auch Ruhm erwerben\n'),(19,NULL,NULL,NULL,'Der Herbst, vorausgesetzt,\n'),(20,NULL,NULL,NULL,'Daß er mit vollen Körben\n'),(21,NULL,NULL,NULL,'Uns Aug und Mund ergörzt.\n'),(22,NULL,NULL,NULL,'\n'),(23,NULL,NULL,NULL,'Indes durch leises Tupfen\n'),(24,NULL,NULL,NULL,'Gemahnt er uns bereits:\n'),(25,NULL,NULL,NULL,'Bald, Kinder, kommt der Schnupfen\n'),(26,NULL,NULL,NULL,'Und\'s Gripperl seinerseits.\n'),(27,NULL,NULL,NULL,'\n'),(28,NULL,NULL,NULL,'Der Winter Kommt. Es blasen\n'),(29,NULL,NULL,NULL,'Die Winde scharf und kühl;\n'),(30,NULL,NULL,NULL,'Rot werden alle Nasen,\n'),(31,NULL,NULL,NULL,'Und Kohlen braucht man viel.\n'),(32,NULL,NULL,NULL,'\n'),(33,NULL,NULL,NULL,'Nein, mir gefällt am besten\n'),(34,NULL,NULL,NULL,'Das, was der Sommer bringt,\n'),(35,NULL,NULL,NULL,'Wenn auf belaubten Ästen\n'),(36,NULL,NULL,NULL,'Die Schar der Vöglein singt.\n'),(37,NULL,NULL,NULL,'\n'),(38,NULL,NULL,NULL,'Wenn Rosen, zahm und wilde,\n'),(39,NULL,NULL,NULL,'In vollster Blüte stehn,\n'),(40,NULL,NULL,NULL,'Wenn über Lustgebilde\n'),(41,NULL,NULL,NULL,'Zephire kosend wehn.\n'),(42,NULL,NULL,NULL,'\n'),(43,NULL,NULL,NULL,'Und wollt\' mich Einer fragen,\n'),(44,NULL,NULL,NULL,'Wann\'s mir im Sommer dann\n'),(45,NULL,NULL,NULL,'Besonders tät behagen,\n'),(46,NULL,NULL,NULL,'Den Juni gäb ich an.\n'),(47,NULL,NULL,NULL,'\n'),(48,NULL,NULL,NULL,'Und wieder dann darunter\n'),(49,NULL,NULL,NULL,'Den selben Tag gerad,\n'),(50,NULL,NULL,NULL,'Wo einst ein Kindlein munter\n'),(51,NULL,NULL,NULL,'Zuerst zu Tage trat.\n'),(52,NULL,NULL,NULL,'\n'),(53,NULL,NULL,NULL,'Drum flattert dies Gedichtchen\n'),(54,NULL,NULL,NULL,'Jetzt über Berg und Tal\n'),(55,NULL,NULL,NULL,'Und grüßt das liebe Nichtchen\n'),(56,NULL,NULL,NULL,'Vom Onkel tausendmal.');
/*!40000 ALTER TABLE `backlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channels`
--

DROP TABLE IF EXISTS `channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `channels` (
  `Chan_Id` int(11) NOT NULL AUTO_INCREMENT,
  `Chan_name` varchar(20) DEFAULT NULL,
  `Chan_Topic` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`Chan_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channels`
--

LOCK TABLES `channels` WRITE;
/*!40000 ALTER TABLE `channels` DISABLE KEYS */;
/*!40000 ALTER TABLE `channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `group_Id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`group_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups_to_roles`
--

DROP TABLE IF EXISTS `groups_to_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups_to_roles` (
  `GroupID` int(11) DEFAULT NULL,
  `RoleID` int(11) DEFAULT NULL,
  KEY `GroupID` (`GroupID`),
  KEY `RoleID` (`RoleID`),
  CONSTRAINT `groups_to_roles_ibfk_1` FOREIGN KEY (`GroupID`) REFERENCES `groups` (`group_Id`) ON DELETE CASCADE,
  CONSTRAINT `groups_to_roles_ibfk_2` FOREIGN KEY (`RoleID`) REFERENCES `roles` (`role_Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups_to_roles`
--

LOCK TABLES `groups_to_roles` WRITE;
/*!40000 ALTER TABLE `groups_to_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `groups_to_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `role_Id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`role_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings` (
  `set_Id` int(11) NOT NULL AUTO_INCREMENT,
  `Set_key` varchar(40) DEFAULT NULL,
  `value` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`set_Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `user_Id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  `passwort` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`user_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'ilu','test'),(2,'Benni','bla'),(3,'Luggi','blabla'),(4,'AMY','test'),(5,'Hans','test'),(12,'keule','bla'),(24,'Cheffe','pass'),(28,'Thorsten','test'),(32,'ABC','dddsfer'),(50,'Josef','test'),(51,'Josef','test'),(52,'Heike','test'),(53,'Heike','test'),(54,'Heike','test'),(55,'Heike','test'),(56,'Zoe','test'),(57,'Amy','test');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_to_groups`
--

DROP TABLE IF EXISTS `user_to_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_to_groups` (
  `UserID` int(11) DEFAULT NULL,
  `GroupID` int(11) DEFAULT NULL,
  KEY `UserID` (`UserID`),
  KEY `GroupID` (`GroupID`),
  CONSTRAINT `user_to_groups_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `user` (`user_Id`) ON DELETE CASCADE,
  CONSTRAINT `user_to_groups_ibfk_2` FOREIGN KEY (`GroupID`) REFERENCES `groups` (`group_Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_to_groups`
--

LOCK TABLES `user_to_groups` WRITE;
/*!40000 ALTER TABLE `user_to_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_to_groups` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-04-15 13:18:55
