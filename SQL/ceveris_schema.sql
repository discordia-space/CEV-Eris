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
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin` (
  `ckey` varchar(32) NOT NULL,
  `rank` varchar(32) NOT NULL,
  `feedback` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ckey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ban`
--

DROP TABLE IF EXISTS `ban`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ban` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `bantime` DATETIME NOT NULL,
  `server_ip` INT(10) UNSIGNED NOT NULL,
  `server_port` SMALLINT(5) UNSIGNED NOT NULL,
  `round_id` INT(11) UNSIGNED NULL,
  `role` VARCHAR(32) NULL DEFAULT NULL,
  `expiration_time` DATETIME NULL DEFAULT NULL,
  `applies_to_admins` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
  `reason` VARCHAR(2048) NOT NULL,
  `ckey` VARCHAR(32) NULL DEFAULT NULL,
  `ip` INT(10) UNSIGNED NULL DEFAULT NULL,
  `computerid` VARCHAR(32) NULL DEFAULT NULL,
  `a_ckey` VARCHAR(32) NOT NULL,
  `a_ip` INT(10) UNSIGNED NOT NULL,
  `a_computerid` VARCHAR(32) NOT NULL,
  `who` VARCHAR(2048) NOT NULL,
  `adminwho` VARCHAR(2048) NOT NULL,
  `edits` TEXT NULL DEFAULT NULL,
  `unbanned_datetime` DATETIME NULL DEFAULT NULL,
  `unbanned_ckey` VARCHAR(32) NULL DEFAULT NULL,
  `unbanned_ip` INT(10) UNSIGNED NULL DEFAULT NULL,
  `unbanned_computerid` VARCHAR(32) NULL DEFAULT NULL,
  `unbanned_round_id` INT(11) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ban_isbanned` (`ckey`,`role`,`unbanned_datetime`,`expiration_time`),
  KEY `idx_ban_isbanned_details` (`ckey`,`ip`,`computerid`,`role`,`unbanned_datetime`,`expiration_time`),
  KEY `idx_ban_count` (`bantime`,`a_ckey`,`applies_to_admins`,`unbanned_datetime`,`expiration_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stickyban`
--
DROP TABLE IF EXISTS `stickyban`;
CREATE TABLE `stickyban` (
	`ckey` VARCHAR(32) NOT NULL,
	`reason` VARCHAR(2048) NOT NULL,
	`banning_admin` VARCHAR(32) NOT NULL,
	`datetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`ckey`)
) ENGINE=InnoDB;

--
-- Table structure for table `stickyban_matched_ckey`
--
DROP TABLE IF EXISTS `stickyban_matched_ckey`;
CREATE TABLE `stickyban_matched_ckey` (
	`stickyban` VARCHAR(32) NOT NULL,
	`matched_ckey` VARCHAR(32) NOT NULL,
	`first_matched` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`last_matched` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`exempt` TINYINT(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`stickyban`, `matched_ckey`)
) ENGINE=InnoDB;

--
-- Table structure for table `stickyban_matched_ip`
--
DROP TABLE IF EXISTS `stickyban_matched_ip`;
CREATE TABLE `stickyban_matched_ip` (
	`stickyban` VARCHAR(32) NOT NULL,
	`matched_ip` INT UNSIGNED NOT NULL,
	`first_matched` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`last_matched` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`stickyban`, `matched_ip`)
) ENGINE=InnoDB;

--
-- Table structure for table `stickyban_matched_cid`
--
DROP TABLE IF EXISTS `stickyban_matched_cid`;
CREATE TABLE `stickyban_matched_cid` (
	`stickyban` VARCHAR(32) NOT NULL,
	`matched_cid` VARCHAR(32) NOT NULL,
	`first_matched` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`last_matched` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`stickyban`, `matched_cid`)
) ENGINE=InnoDB;

--
--
-- Table structure for table `connection_log`
--

DROP TABLE IF EXISTS `connection_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `connection_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime DEFAULT NULL,
  `server_ip` int(10) unsigned NOT NULL,
  `server_port` smallint(5) unsigned NOT NULL,
  `round_id` int(11) unsigned DEFAULT NULL,
  `ckey` varchar(45) DEFAULT NULL,
  `ip` int(10) unsigned NOT NULL,
  `computerid` varchar(45) DEFAULT NULL,
  `byond_version` varchar(8) DEFAULT NULL,
  `byond_build` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `death`
--

DROP TABLE IF EXISTS `death`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `death` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pod` varchar(50) NOT NULL,
  `x_coord` smallint(5) unsigned NOT NULL,
  `y_coord` smallint(5) unsigned NOT NULL,
  `z_coord` smallint(5) unsigned NOT NULL,
  `mapname` varchar(32) NOT NULL,
  `server_ip` int(10) unsigned NOT NULL,
  `server_port` smallint(5) unsigned NOT NULL,
  `round_id` int(11) unsigned NULL,
  `tod` datetime NOT NULL COMMENT 'Time of death',
  `job` varchar(32) NOT NULL,
  `special` varchar(32) DEFAULT NULL,
  `name` varchar(96) NOT NULL,
  `byondkey` varchar(32) NOT NULL,
  `laname` varchar(96) DEFAULT NULL,
  `lakey` varchar(32) DEFAULT NULL,
  `bruteloss` smallint(5) unsigned NOT NULL,
  `brainloss` smallint(5) unsigned NOT NULL,
  `fireloss` smallint(5) unsigned NOT NULL,
  `oxyloss` smallint(5) unsigned NOT NULL,
  `toxloss` smallint(5) unsigned NOT NULL,
  `cloneloss` smallint(5) unsigned NOT NULL,
  `last_words` varchar(255) DEFAULT NULL,
  `suicide` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `player`
--

DROP TABLE IF EXISTS `player`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player` (
  `ckey` varchar(32) NOT NULL,
  `byond_key` varchar(32) DEFAULT NULL,
  `firstseen` datetime NOT NULL,
  `firstseen_round_id` int(11) unsigned NULL,
  `lastseen` datetime NOT NULL,
  `lastseen_round_id` int(11) unsigned NULL,
  `ip` int(10) NOT NULL,
  `computerid` varchar(32) NOT NULL,
  `lastadminrank` varchar(32) NOT NULL DEFAULT 'Player',
  `accountjoindate` DATE DEFAULT NULL,
  `flags` int(11) NOT NULL DEFAULT '0',
  `country` varchar(255),
  `VPN_check_white` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ckey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `library`
--

DROP TABLE IF EXISTS `library`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `library` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `author_id` varchar(32) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `deleted` tinyint(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_library_on_author_id` (`author_id`),
  CONSTRAINT `fk_rails_53d51ce16a` FOREIGN KEY (`author_id`) REFERENCES `player` (`ckey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` enum('memo','message','message sent','note','watchlist entry') NOT NULL,
  `targetckey` varchar(32) NOT NULL,
  `adminckey` varchar(32) NOT NULL,
  `text` varchar(2048) NOT NULL,
  `timestamp` datetime NOT NULL,
  `server` varchar(32) DEFAULT NULL,
  `server_ip` int(10) unsigned NOT NULL,
  `server_port` smallint(5) unsigned NOT NULL,
  `round_id` int(11) unsigned NULL,
  `secret` tinyint(1) unsigned NOT NULL,
  `expire_timestamp` datetime DEFAULT NULL,
  `severity` enum('high','medium','minor','none') DEFAULT NULL,
  `playtime` int(11) unsigned NULL DEFAULT NULL,
  `lasteditor` varchar(32) DEFAULT NULL,
  `edits` text,
  `deleted` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `deleted_ckey` VARCHAR(32) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_msg_ckey_time` (`targetckey`,`timestamp`, `deleted`),
  KEY `idx_msg_type_ckeys_time` (`type`,`targetckey`,`adminckey`,`timestamp`, `deleted`),
  KEY `idx_msg_type_ckey_time_odr` (`type`,`targetckey`,`timestamp`, `deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `polls`
--

DROP TABLE IF EXISTS `polls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `polls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(16) NOT NULL,
  `start` datetime NOT NULL,
  `end` datetime NOT NULL,
  `question` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `poll_question`
--

DROP TABLE IF EXISTS `poll_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `poll_question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `polltype` enum('OPTION','TEXT','NUMVAL','MULTICHOICE','IRV') NOT NULL,
  `created_datetime` datetime NOT NULL,
  `starttime` datetime NOT NULL,
  `endtime` datetime NOT NULL,
  `question` varchar(255) NOT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `adminonly` tinyint(1) unsigned NOT NULL,
  `multiplechoiceoptions` int(2) DEFAULT NULL,
  `createdby_ckey` varchar(32) NOT NULL,
  `createdby_ip` int(10) unsigned NOT NULL,
  `dontshow` tinyint(1) unsigned NOT NULL,
  `allow_revoting` tinyint(1) unsigned NOT NULL,
  `deleted` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_pquest_question_time_ckey` (`question`,`starttime`,`endtime`,`createdby_ckey`,`createdby_ip`),
  KEY `idx_pquest_time_deleted_id` (`starttime`,`endtime`, `deleted`, `id`),
  KEY `idx_pquest_id_time_type_admin` (`id`,`starttime`,`endtime`,`polltype`,`adminonly`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `poll_options`
--

DROP TABLE IF EXISTS `poll_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `poll_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `poll_id` int(11) NOT NULL,
  `text` varchar(255) NOT NULL,
  `min_value` int(11) DEFAULT NULL,
  `max_value` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_poll_options_on_poll_id` (`poll_id`),
  CONSTRAINT `fk_rails_aa85becb42` FOREIGN KEY (`poll_id`) REFERENCES `polls` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `poll_textreply`
--

DROP TABLE IF EXISTS `poll_textreply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `poll_textreply` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `poll_id` int(11) DEFAULT NULL,
  `ckey` varchar(32) DEFAULT NULL,
  `text` text,
  PRIMARY KEY (`id`),
  KEY `index_poll_textreply_on_poll_id` (`poll_id`),
  KEY `index_poll_textreply_on_ckey` (`ckey`),
  CONSTRAINT `fk_rails_0833f4df0b` FOREIGN KEY (`poll_id`) REFERENCES `polls` (`id`),
  CONSTRAINT `fk_rails_ffc8df499f` FOREIGN KEY (`ckey`) REFERENCES `player` (`ckey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `poll_votes`
--

DROP TABLE IF EXISTS `poll_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `poll_votes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` datetime NOT NULL,
  `poll_id` int(11) NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `option_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_poll_votes_on_poll_id` (`poll_id`),
  KEY `index_poll_votes_on_ckey` (`ckey`),
  KEY `index_poll_votes_on_option_id` (`option_id`),
  CONSTRAINT `fk_rails_826ebfbbb3` FOREIGN KEY (`option_id`) REFERENCES `poll_options` (`id`),
  CONSTRAINT `fk_rails_a3e5a3aede` FOREIGN KEY (`ckey`) REFERENCES `player` (`ckey`),
  CONSTRAINT `fk_rails_a6e6974b7e` FOREIGN KEY (`poll_id`) REFERENCES `polls` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `populations`
--

DROP TABLE IF EXISTS `populations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `populations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playercount` int(11) DEFAULT NULL,
  `admincount` int(11) DEFAULT NULL,
  `time` datetime NOT NULL,
  `server_ip` int(10) unsigned NOT NULL,
  `server_port` smallint(5) unsigned NOT NULL,
  `round_id` int(11) unsigned NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `round`
--
DROP TABLE IF EXISTS `round`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `round` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `initialize_datetime` DATETIME NOT NULL,
  `start_datetime` DATETIME NULL,
  `shutdown_datetime` DATETIME NULL,
  `end_datetime` DATETIME NULL,
  `server_ip` INT(10) UNSIGNED NOT NULL,
  `server_port` SMALLINT(5) UNSIGNED NOT NULL,
  `commit_hash` CHAR(40) NULL,
  `game_mode` VARCHAR(32) NULL,
  `game_mode_result` VARCHAR(64) NULL,
  `end_state` VARCHAR(64) NULL,
  `shuttle_name` VARCHAR(64) NULL,
  `map_name` VARCHAR(32) NULL,
  `station_name` VARCHAR(80) NULL,
  `log_directory` VARCHAR(255) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

--
-- Table structure for table `admin_connections`
--
DROP TABLE IF EXISTS `admin_connections`;
CREATE TABLE `admin_connections` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `ckey` VARCHAR(32) NOT NULL,
  `ip` INT(11) UNSIGNED NOT NULL,
  `cid` VARCHAR(32) NOT NULL,
  `verification_time` DATETIME NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `unique_constraints` (`ckey`, `ip`, `cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `known_alts`
--
DROP TABLE IF EXISTS `known_alts`;
CREATE TABLE `known_alts` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `ckey1` VARCHAR(32) NOT NULL,
    `ckey2` VARCHAR(32) NOT NULL,
    `admin_ckey` VARCHAR(32) NOT NULL DEFAULT '*no key*',
    PRIMARY KEY (`id`),
    UNIQUE INDEX `unique_contraints` (`ckey1` , `ckey2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `telemetry_connections`
--
DROP TABLE IF EXISTS `telemetry_connections`;
CREATE TABLE `telemetry_connections` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `ckey` VARCHAR(32) NOT NULL,
    `telemetry_ckey` VARCHAR(32) NOT NULL,
    `address` INT(10) UNSIGNED NOT NULL,
    `computer_id` VARCHAR(32) NOT NULL,
    `first_round_id` INT(11) UNSIGNED NULL,
    `latest_round_id` INT(11) UNSIGNED NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `unique_constraints` (`ckey` , `telemetry_ckey` , `address` , `computer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `schema_revision`
--
DROP TABLE IF EXISTS `schema_revision`;
CREATE TABLE `schema_revision` (
  `major` TINYINT(3) unsigned NOT NULL,
  `minor` TINYINT(3) unsigned NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`major`, `minor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
