-- --------------------------------------------------------
-- Poslužitelj:                  127.0.0.1
-- Server version:               10.1.22-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Verzija:             9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for pyss
DROP DATABASE IF EXISTS `pyss`;
CREATE DATABASE IF NOT EXISTS `pyss` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `pyss`;

-- Dumping structure for table pyss.child_events
DROP TABLE IF EXISTS `child_events`;
CREATE TABLE IF NOT EXISTS `child_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT 'UNDEFINED',
  `description` varchar(200) NOT NULL DEFAULT 'UNDEFINED',
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `parent_event_id` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  KEY `FK_child_events_events` (`parent_event_id`),
  CONSTRAINT `FK_child_events_events` FOREIGN KEY (`parent_event_id`) REFERENCES `events` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table pyss.child_events: ~0 rows (approximately)
/*!40000 ALTER TABLE `child_events` DISABLE KEYS */;
INSERT INTO `child_events` (`id`, `name`, `description`, `date_begin`, `date_end`, `parent_event_id`) VALUES
	(1, 'Probni dijete doagađaj', 'Probni opis', '2017-06-04 10:00:00', '2017-06-04 19:40:21', 1);
/*!40000 ALTER TABLE `child_events` ENABLE KEYS */;

-- Dumping structure for table pyss.cities
DROP TABLE IF EXISTS `cities`;
CREATE TABLE IF NOT EXISTS `cities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT 'UNDEFINED',
  `postal_code` varchar(15) NOT NULL DEFAULT 'UNDEFINED',
  `country_id` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  KEY `FK_cities_countries` (`country_id`),
  CONSTRAINT `FK_cities_countries` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table pyss.cities: ~1 rows (approximately)
/*!40000 ALTER TABLE `cities` DISABLE KEYS */;
INSERT INTO `cities` (`id`, `name`, `postal_code`, `country_id`) VALUES
	(1, 'Zagreb', '10000', 1);
/*!40000 ALTER TABLE `cities` ENABLE KEYS */;

-- Dumping structure for table pyss.countries
DROP TABLE IF EXISTS `countries`;
CREATE TABLE IF NOT EXISTS `countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT 'UNDEFINED',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table pyss.countries: ~1 rows (approximately)
/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
INSERT INTO `countries` (`id`, `name`) VALUES
	(1, 'Hrvatska');
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;

-- Dumping structure for table pyss.events
DROP TABLE IF EXISTS `events`;
CREATE TABLE IF NOT EXISTS `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `name` varchar(50) NOT NULL DEFAULT 'UNDEFINED',
  `no_students` int(11) DEFAULT NULL,
  `weekly_classes` int(11) DEFAULT NULL,
  `goal` varchar(300) DEFAULT NULL,
  `purpose` varchar(300) DEFAULT NULL,
  `realization` varchar(500) DEFAULT NULL,
  `evaluation` varchar(300) DEFAULT NULL,
  `results` varchar(300) DEFAULT NULL,
  `costs` varchar(300) DEFAULT NULL,
  `school_id` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  KEY `FK_events_schools` (`school_id`),
  CONSTRAINT `FK_events_schools` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table pyss.events: ~0 rows (approximately)
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` (`id`, `date_begin`, `date_end`, `name`, `no_students`, `weekly_classes`, `goal`, `purpose`, `realization`, `evaluation`, `results`, `costs`, `school_id`) VALUES
	(1, '2017-03-04 10:00:00', '2017-06-04 12:00:00', 'Probni događaj', 5, 5, 'Nema', 'Nema', 'Nema', 'Nema', 'Nema', 'Nema', 1);
/*!40000 ALTER TABLE `events` ENABLE KEYS */;

-- Dumping structure for table pyss.event_holders
DROP TABLE IF EXISTS `event_holders`;
CREATE TABLE IF NOT EXISTS `event_holders` (
  `event_id` int(11) NOT NULL DEFAULT '-1',
  `holder_id` int(11) NOT NULL DEFAULT '-1',
  UNIQUE KEY `event_id_holder_id` (`event_id`,`holder_id`),
  KEY `FK__users` (`holder_id`),
  CONSTRAINT `FK__events` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`),
  CONSTRAINT `FK__users` FOREIGN KEY (`holder_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table pyss.event_holders: ~0 rows (approximately)
/*!40000 ALTER TABLE `event_holders` DISABLE KEYS */;
INSERT INTO `event_holders` (`event_id`, `holder_id`) VALUES
	(1, 15);
/*!40000 ALTER TABLE `event_holders` ENABLE KEYS */;

-- Dumping structure for table pyss.event_users
DROP TABLE IF EXISTS `event_users`;
CREATE TABLE IF NOT EXISTS `event_users` (
  `event_id` int(11) NOT NULL DEFAULT '-1',
  `user_id` int(11) NOT NULL DEFAULT '-1',
  UNIQUE KEY `event_id_user_id` (`event_id`,`user_id`),
  KEY `FK_users_events_users` (`user_id`),
  CONSTRAINT `FK_users_events_child_events` FOREIGN KEY (`event_id`) REFERENCES `child_events` (`id`),
  CONSTRAINT `FK_users_events_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table pyss.event_users: ~0 rows (approximately)
/*!40000 ALTER TABLE `event_users` DISABLE KEYS */;
INSERT INTO `event_users` (`event_id`, `user_id`) VALUES
	(1, 15);
/*!40000 ALTER TABLE `event_users` ENABLE KEYS */;

-- Dumping structure for table pyss.pending_user_evaluations
DROP TABLE IF EXISTS `pending_user_evaluations`;
CREATE TABLE IF NOT EXISTS `pending_user_evaluations` (
  `user_id` int(11) NOT NULL DEFAULT '-1',
  `school_id` int(11) NOT NULL DEFAULT '-1',
  `role_id` int(11) NOT NULL DEFAULT '-1',
  KEY `FK_pending_user_evaluations_users` (`user_id`),
  KEY `FK_pending_user_evaluations_schools` (`school_id`),
  KEY `FK_pending_user_evaluations_roles` (`role_id`),
  CONSTRAINT `FK_pending_user_evaluations_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `FK_pending_user_evaluations_schools` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`),
  CONSTRAINT `FK_pending_user_evaluations_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table pyss.pending_user_evaluations: ~0 rows (approximately)
/*!40000 ALTER TABLE `pending_user_evaluations` DISABLE KEYS */;
/*!40000 ALTER TABLE `pending_user_evaluations` ENABLE KEYS */;

-- Dumping structure for table pyss.roles
DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT 'UNDEFINED',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Dumping data for table pyss.roles: ~4 rows (approximately)
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` (`id`, `name`) VALUES
	(1, 'Administrator'),
	(2, 'Ravnatelj'),
	(3, 'Psiholog'),
	(4, 'Tajnik');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;

-- Dumping structure for table pyss.schools
DROP TABLE IF EXISTS `schools`;
CREATE TABLE IF NOT EXISTS `schools` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oib` varchar(20) DEFAULT NULL,
  `name` varchar(50) NOT NULL DEFAULT 'UNDEFINED',
  `short_name` varchar(20) DEFAULT NULL,
  `phone_number` varchar(15) DEFAULT NULL,
  `street_name` varchar(50) DEFAULT NULL,
  `street_number` varchar(5) DEFAULT NULL,
  `city_id` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `oib` (`oib`),
  KEY `FK_schools_cities` (`city_id`),
  CONSTRAINT `FK_schools_cities` FOREIGN KEY (`city_id`) REFERENCES `cities` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table pyss.schools: ~1 rows (approximately)
/*!40000 ALTER TABLE `schools` DISABLE KEYS */;
INSERT INTO `schools` (`id`, `oib`, `name`, `short_name`, `phone_number`, `street_name`, `street_number`, `city_id`) VALUES
	(1, '12345', 'Osnova škola za debugging', 'OŠ DBG', '011234567', 'Ulična', 'bb', 1);
/*!40000 ALTER TABLE `schools` ENABLE KEYS */;

-- Dumping structure for table pyss.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL DEFAULT 'UNDEFINED',
  `last_name` varchar(50) NOT NULL DEFAULT 'UNDEFINED',
  `phone_number` varchar(20) DEFAULT NULL,
  `email` varchar(50) NOT NULL DEFAULT 'UNDEFINED',
  `date_joined` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `locked` smallint(6) NOT NULL DEFAULT '1',
  `password` varchar(200) NOT NULL DEFAULT 'UNDEFINED',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

-- Dumping data for table pyss.users: ~16 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`, `first_name`, `last_name`, `phone_number`, `email`, `date_joined`, `locked`, `password`) VALUES
	(1, 'aaa', 'aaa', NULL, 'aaa', '2017-05-04 21:07:36', 0, 'f368a29b71bd201a7ef78b5df88b1361fbe83f959756d33793837a5d7b2eaf660f2f6c7e2fbace01965683c4cfafded3ff28aab34e329aa79bc81e7703f68b86'),
	(2, 'bbb', 'bbb', NULL, 'bbb', '2017-05-04 21:09:32', 0, 'a6ac25518d1fe9984d8d0893919d16b5c3367ab2511d121b5afed88400dcf6ec5f0eadd2b2c73581615ca64500b062a7a552bb71b58ff9ba90c004a9d1295284'),
	(3, 'ccc', 'ccc', NULL, 'aaaccc', '2017-05-04 21:09:57', 0, 'bdb9521087ffa742f856df20bb39ba73ee49a3096553089e5bc7c09414d6932e0066a63f958b159a41540413a00c604925175be912167694b03ba374cc5ce8e7'),
	(4, 'ddd', 'ddd', NULL, 'aaaddd', '2017-05-04 21:10:12', 0, '2bccb4383ba98880071596b9a9ea610486e117333cbb7731ee70906c9d021cab3168d703e5b81fc359af384a1261139dd25d3983823defb8b8f3309e29645a53'),
	(5, 'eee', 'eee', NULL, 'aaaeee', '2017-05-04 21:10:39', 0, '4d61f8d43fc60a08c60dd0bd8da3c66cee009182504d33b072afedcbfb503c72094cfc6a5ce123895aebffaec5cdaed509b57ff525865cbfe1356b07241f7345'),
	(6, '', '', NULL, 'aaawfwef', '2017-05-04 21:14:04', 0, 'b5e069c45e488db5929ca3d07c368b5ccef91547ffd13df28e5d02ee8b06cb50176ce726e3d0c628df6f6af87885cbbf7315daeef3ca972e28c4a1c207509100'),
	(7, 'aa', 'aa', NULL, 'aaabb', '2017-05-04 21:18:49', 0, 'f368a29b71bd201a7ef78b5df88b1361fbe83f959756d33793837a5d7b2eaf660f2f6c7e2fbace01965683c4cfafded3ff28aab34e329aa79bc81e7703f68b86'),
	(8, '', '', NULL, 'aaaww', '2017-05-04 21:21:37', 0, 'f368a29b71bd201a7ef78b5df88b1361fbe83f959756d33793837a5d7b2eaf660f2f6c7e2fbace01965683c4cfafded3ff28aab34e329aa79bc81e7703f68b86'),
	(9, '', '', NULL, 'aaawfef', '2017-05-04 21:22:37', 0, 'f368a29b71bd201a7ef78b5df88b1361fbe83f959756d33793837a5d7b2eaf660f2f6c7e2fbace01965683c4cfafded3ff28aab34e329aa79bc81e7703f68b86'),
	(10, '', '', NULL, 'aaawefwe', '2017-05-04 21:23:23', 0, 'f368a29b71bd201a7ef78b5df88b1361fbe83f959756d33793837a5d7b2eaf660f2f6c7e2fbace01965683c4cfafded3ff28aab34e329aa79bc81e7703f68b86'),
	(11, '', '', NULL, 'aaaerfwregfrg', '2017-05-04 21:25:23', 0, 'f368a29b71bd201a7ef78b5df88b1361fbe83f959756d33793837a5d7b2eaf660f2f6c7e2fbace01965683c4cfafded3ff28aab34e329aa79bc81e7703f68b86'),
	(12, 'mateo', 'stanić', NULL, 'mateo', '2017-05-09 22:40:04', 0, '20b350d635a433545231949fc273c18499fbbadfc37fad4648c2df22edb2ffdb1a0054b467025e42828777703d5fa5d4fbb64caecaf5f9e3ffb12cc4834c36bd'),
	(14, 'Kim', 'Knežić', NULL, 'kim@hr', '2017-06-01 20:22:52', 0, 'bf2f77e69b7fc12e9f3dfd125888e24bf44e029f537417b96539a824b6b9b6ab987624d1adba442ab51f8e5f7d0cef9f885f5eb2e87c9fd6b92b601e7a650522'),
	(15, 'Martin', 'Tomašević', NULL, 'martin@hr', '2017-06-01 20:26:28', 0, '6b9935ee426f42a888548ff81935bac34a378b7496e987eef08ca1c57f0db7bb6cc2199a47d255ba36aa0563e6deb02274bccd290d9c56d7dc893ac3b85d218d'),
	(16, 'Martin2', 'Tomašević', NULL, 'martin2@hr', '2017-06-02 13:00:54', 0, '6b9935ee426f42a888548ff81935bac34a378b7496e987eef08ca1c57f0db7bb6cc2199a47d255ba36aa0563e6deb02274bccd290d9c56d7dc893ac3b85d218d'),
	(17, 'Vedran', 'Đorić', NULL, 'vedran', '2017-06-04 18:58:35', 0, 'c17819d8ccd8bd8c1d02be916860eea41dc74dbbcf26b7ada77fef856015ff84962fab17766cffa012024228baa72b6fffc8683e33a1052e8e999d47ffe315f0');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

-- Dumping structure for table pyss.users_roles
DROP TABLE IF EXISTS `users_roles`;
CREATE TABLE IF NOT EXISTS `users_roles` (
  `user_id` int(11) NOT NULL DEFAULT '-1',
  `role_id` int(11) NOT NULL DEFAULT '-1',
  `school_id` int(11) NOT NULL DEFAULT '-1',
  KEY `FK_users_roles_users` (`user_id`),
  KEY `FK_users_roles_roles` (`role_id`),
  KEY `FK_users_roles_schools` (`school_id`),
  CONSTRAINT `FK_users_roles_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `FK_users_roles_schools` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`),
  CONSTRAINT `FK_users_roles_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table pyss.users_roles: ~1 rows (approximately)
/*!40000 ALTER TABLE `users_roles` DISABLE KEYS */;
INSERT INTO `users_roles` (`user_id`, `role_id`, `school_id`) VALUES
	(15, 1, 1);
/*!40000 ALTER TABLE `users_roles` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
