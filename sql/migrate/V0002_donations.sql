/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


CREATE DATABASE IF NOT EXISTS `donations` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `donations`;

--
-- Table structure for table `discord_users`
--

CREATE TABLE IF NOT EXISTS `discord_users` (
  `id` varchar(50) NOT NULL,
  `nickname` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `patron_types`
--

CREATE TABLE IF NOT EXISTS `patron_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- Default init
INSERT IGNORE INTO `patron_types` (`type`) VALUES ('None');

--
-- Table structure for table `players`
--

CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(50) NOT NULL,
  `discord` varchar(50) DEFAULT NULL,
  `points` float DEFAULT 0,
  `patron_type` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Index 4` (`ckey`),
  KEY `FK_players_discord_users` (`discord`),
  KEY `FK_players_patron_types` (`patron_type`),
  CONSTRAINT `FK_players_discord_users` FOREIGN KEY (`discord`) REFERENCES `discord_users` (`id`),
  CONSTRAINT `FK_players_patron_types` FOREIGN KEY (`patron_type`) REFERENCES `patron_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=805150 DEFAULT CHARSET=utf8;

--
-- Table structure for table `points_transactions_types`
--

CREATE TABLE IF NOT EXISTS `points_transactions_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- Table structure for table `points_transactions`
--

CREATE TABLE IF NOT EXISTS `points_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `datetime` datetime NOT NULL,
  `change` float NOT NULL,
  `comment` text DEFAULT NULL,
  KEY `Primary Key` (`id`),
  KEY `FK_points_transactions_players` (`player`),
  KEY `FK_points_transactions_points_transactions_types` (`type`),
  CONSTRAINT `FK_points_transactions_players` FOREIGN KEY (`player`) REFERENCES `players` (`id`),
  CONSTRAINT `FK_points_transactions_points_transactions_types` FOREIGN KEY (`type`) REFERENCES `points_transactions_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1778 DEFAULT CHARSET=utf8;

--
-- Table structure for table `store_players_items`
--

CREATE TABLE IF NOT EXISTS `store_players_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL,
  `transaction` int(11) DEFAULT NULL,
  `obtaining_date` datetime DEFAULT NULL,
  `item_data` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_store_players_items_players` (`player`),
  KEY `FK_store_players_items_points_transactions` (`transaction`),
  CONSTRAINT `FK_store_players_items_players` FOREIGN KEY (`player`) REFERENCES `players` (`id`),
  CONSTRAINT `FK_store_players_items_points_transactions` FOREIGN KEY (`transaction`) REFERENCES `points_transactions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=772 DEFAULT CHARSET=utf8mb4;


--
-- Table structure for table `tokens`
--

CREATE TABLE IF NOT EXISTS `tokens` (
  `token` varchar(50) NOT NULL,
  `discord` varchar(50) NOT NULL,
  PRIMARY KEY (`token`),
  KEY `FK_tokens_discord_users` (`discord`),
  CONSTRAINT `FK_tokens_discord_users` FOREIGN KEY (`discord`) REFERENCES `discord_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `discord_users`
--

CREATE TABLE IF NOT EXISTS `discord_users` (
  `id` varchar(50) NOT NULL,
  `nickname` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `points_transactions_types`
--

CREATE TABLE IF NOT EXISTS `points_transactions_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(32) DEFAULT NULL,
  KEY `Primary Key` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- Table structure for table `points_transactions`
--

CREATE TABLE IF NOT EXISTS `points_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `datetime` datetime NOT NULL,
  `change` float NOT NULL,
  `comment` text DEFAULT NULL,
  KEY `Primary Key` (`id`),
  KEY `FK_points_transactions_players` (`player`),
  KEY `FK_points_transactions_points_transactions_types` (`type`),
  CONSTRAINT `FK_points_transactions_players` FOREIGN KEY (`player`) REFERENCES `players` (`id`),
  CONSTRAINT `FK_points_transactions_points_transactions_types` FOREIGN KEY (`type`) REFERENCES `points_transactions_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1778 DEFAULT CHARSET=utf8;

--
-- Table structure for table `store_players_items`
--

CREATE TABLE IF NOT EXISTS `store_players_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL,
  `transaction` int(11) DEFAULT NULL,
  `obtaining_date` datetime DEFAULT NULL,
  `item_data` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_store_players_items_players` (`player`),
  KEY `FK_store_players_items_points_transactions` (`transaction`),
  CONSTRAINT `FK_store_players_items_players` FOREIGN KEY (`player`) REFERENCES `players` (`id`),
  CONSTRAINT `FK_store_players_items_points_transactions` FOREIGN KEY (`transaction`) REFERENCES `points_transactions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=772 DEFAULT CHARSET=utf8mb4;


--
-- Table structure for table `tokens`
--

CREATE TABLE IF NOT EXISTS `tokens` (
  `token` varchar(50) NOT NULL,
  `discord` varchar(50) NOT NULL,
  PRIMARY KEY (`token`),
  KEY `FK_tokens_discord_users` (`discord`),
  CONSTRAINT `FK_tokens_discord_users` FOREIGN KEY (`discord`) REFERENCES `discord_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `discord_users`
--

CREATE TABLE IF NOT EXISTS `discord_users` (
  `id` varchar(50) NOT NULL,
  `nickname` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `points_transactions_types`
--

CREATE TABLE IF NOT EXISTS `points_transactions_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(32) DEFAULT NULL,
  KEY `Primary Key` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- Table structure for table `points_transactions`
--

CREATE TABLE IF NOT EXISTS `points_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `datetime` datetime NOT NULL,
  `change` float NOT NULL,
  `comment` text DEFAULT NULL,
  KEY `Primary Key` (`id`),
  KEY `FK_points_transactions_players` (`player`),
  KEY `FK_points_transactions_points_transactions_types` (`type`),
  CONSTRAINT `FK_points_transactions_players` FOREIGN KEY (`player`) REFERENCES `players` (`id`),
  CONSTRAINT `FK_points_transactions_points_transactions_types` FOREIGN KEY (`type`) REFERENCES `points_transactions_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1778 DEFAULT CHARSET=utf8;

--
-- Table structure for table `store_players_items`
--

CREATE TABLE IF NOT EXISTS `store_players_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL,
  `transaction` int(11) DEFAULT NULL,
  `obtaining_date` datetime DEFAULT NULL,
  `item_data` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_store_players_items_players` (`player`),
  KEY `FK_store_players_items_points_transactions` (`transaction`),
  CONSTRAINT `FK_store_players_items_players` FOREIGN KEY (`player`) REFERENCES `players` (`id`),
  CONSTRAINT `FK_store_players_items_points_transactions` FOREIGN KEY (`transaction`) REFERENCES `points_transactions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=772 DEFAULT CHARSET=utf8mb4;


--
-- Table structure for table `tokens`
--

CREATE TABLE IF NOT EXISTS `tokens` (
  `token` varchar(50) NOT NULL,
  `discord` varchar(50) NOT NULL,
  PRIMARY KEY (`token`),
  KEY `FK_tokens_discord_users` (`discord`),
  CONSTRAINT `FK_tokens_discord_users` FOREIGN KEY (`discord`) REFERENCES `discord_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `discord_users`
--

CREATE TABLE IF NOT EXISTS `discord_users` (
  `id` varchar(50) NOT NULL,
  `nickname` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `points_transactions_types`
--

CREATE TABLE IF NOT EXISTS `points_transactions_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(32) DEFAULT NULL,
  KEY `Primary Key` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- Table structure for table `points_transactions`
--

CREATE TABLE IF NOT EXISTS `points_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `datetime` datetime NOT NULL,
  `change` float NOT NULL,
  `comment` text DEFAULT NULL,
  KEY `Primary Key` (`id`),
  KEY `FK_points_transactions_players` (`player`),
  KEY `FK_points_transactions_points_transactions_types` (`type`),
  CONSTRAINT `FK_points_transactions_players` FOREIGN KEY (`player`) REFERENCES `players` (`id`),
  CONSTRAINT `FK_points_transactions_points_transactions_types` FOREIGN KEY (`type`) REFERENCES `points_transactions_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1778 DEFAULT CHARSET=utf8;

--
-- Table structure for table `store_players_items`
--

CREATE TABLE IF NOT EXISTS `store_players_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL,
  `transaction` int(11) DEFAULT NULL,
  `obtaining_date` datetime DEFAULT NULL,
  `item_data` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_store_players_items_players` (`player`),
  KEY `FK_store_players_items_points_transactions` (`transaction`),
  CONSTRAINT `FK_store_players_items_players` FOREIGN KEY (`player`) REFERENCES `players` (`id`),
  CONSTRAINT `FK_store_players_items_points_transactions` FOREIGN KEY (`transaction`) REFERENCES `points_transactions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=772 DEFAULT CHARSET=utf8mb4;


--
-- Table structure for table `tokens`
--

CREATE TABLE IF NOT EXISTS `tokens` (
  `token` varchar(50) NOT NULL,
  `discord` varchar(50) NOT NULL,
  PRIMARY KEY (`token`),
  KEY `FK_tokens_discord_users` (`discord`),
  CONSTRAINT `FK_tokens_discord_users` FOREIGN KEY (`discord`) REFERENCES `discord_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `discord_users`
--

CREATE TABLE IF NOT EXISTS `discord_users` (
  `id` varchar(50) NOT NULL,
  `nickname` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `points_transactions_types`
--

CREATE TABLE IF NOT EXISTS `points_transactions_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(32) DEFAULT NULL,
  KEY `Primary Key` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- Table structure for table `points_transactions`
--

CREATE TABLE IF NOT EXISTS `points_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `datetime` datetime NOT NULL,
  `change` float NOT NULL,
  `comment` text DEFAULT NULL,
  KEY `Primary Key` (`id`),
  KEY `FK_points_transactions_players` (`player`),
  KEY `FK_points_transactions_points_transactions_types` (`type`),
  CONSTRAINT `FK_points_transactions_players` FOREIGN KEY (`player`) REFERENCES `players` (`id`),
  CONSTRAINT `FK_points_transactions_points_transactions_types` FOREIGN KEY (`type`) REFERENCES `points_transactions_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1778 DEFAULT CHARSET=utf8;

--
-- Table structure for table `store_players_items`
--

CREATE TABLE IF NOT EXISTS `store_players_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL,
  `transaction` int(11) DEFAULT NULL,
  `obtaining_date` datetime DEFAULT NULL,
  `item_data` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_store_players_items_players` (`player`),
  KEY `FK_store_players_items_points_transactions` (`transaction`),
  CONSTRAINT `FK_store_players_items_players` FOREIGN KEY (`player`) REFERENCES `players` (`id`),
  CONSTRAINT `FK_store_players_items_points_transactions` FOREIGN KEY (`transaction`) REFERENCES `points_transactions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=772 DEFAULT CHARSET=utf8mb4;


--
-- Table structure for table `tokens`
--

CREATE TABLE IF NOT EXISTS `tokens` (
  `token` varchar(50) NOT NULL,
  `discord` varchar(50) NOT NULL,
  PRIMARY KEY (`token`),
  KEY `FK_tokens_discord_users` (`discord`),
  CONSTRAINT `FK_tokens_discord_users` FOREIGN KEY (`discord`) REFERENCES `discord_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `discord_users`
--

CREATE TABLE IF NOT EXISTS `discord_users` (
  `id` varchar(50) NOT NULL,
  `nickname` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `points_transactions_types`
--

CREATE TABLE IF NOT EXISTS `points_transactions_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(32) DEFAULT NULL,
  KEY `Primary Key` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- Table structure for table `points_transactions`
--

CREATE TABLE IF NOT EXISTS `points_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `datetime` datetime NOT NULL,
  `change` float NOT NULL,
  `comment` text DEFAULT NULL,
  KEY `Primary Key` (`id`),
  KEY `FK_points_transactions_players` (`player`),
  KEY `FK_points_transactions_points_transactions_types` (`type`),
  CONSTRAINT `FK_points_transactions_players` FOREIGN KEY (`player`) REFERENCES `players` (`id`),
  CONSTRAINT `FK_points_transactions_points_transactions_types` FOREIGN KEY (`type`) REFERENCES `points_transactions_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1778 DEFAULT CHARSET=utf8;

--
-- Table structure for table `store_players_items`
--

CREATE TABLE IF NOT EXISTS `store_players_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL,
  `transaction` int(11) DEFAULT NULL,
  `obtaining_date` datetime DEFAULT NULL,
  `item_data` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_store_players_items_players` (`player`),
  KEY `FK_store_players_items_points_transactions` (`transaction`),
  CONSTRAINT `FK_store_players_items_players` FOREIGN KEY (`player`) REFERENCES `players` (`id`),
  CONSTRAINT `FK_store_players_items_points_transactions` FOREIGN KEY (`transaction`) REFERENCES `points_transactions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=772 DEFAULT CHARSET=utf8mb4;


--
-- Table structure for table `tokens`
--

CREATE TABLE IF NOT EXISTS `tokens` (
  `token` varchar(50) NOT NULL,
  `discord` varchar(50) NOT NULL,
  PRIMARY KEY (`token`),
  KEY `FK_tokens_discord_users` (`discord`),
  CONSTRAINT `FK_tokens_discord_users` FOREIGN KEY (`discord`) REFERENCES `discord_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `discord_users`
--

CREATE TABLE IF NOT EXISTS `discord_users` (
  `id` varchar(50) NOT NULL,
  `nickname` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `points_transactions_types`
--

CREATE TABLE IF NOT EXISTS `points_transactions_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(32) DEFAULT NULL,
  KEY `Primary Key` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- Table structure for table `points_transactions`
--

CREATE TABLE IF NOT EXISTS `points_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `datetime` datetime NOT NULL,
  `change` float NOT NULL,
  `comment` text DEFAULT NULL,
  KEY `Primary Key` (`id`),
  KEY `FK_points_transactions_players` (`player`),
  KEY `FK_points_transactions_points_transactions_types` (`type`),
  CONSTRAINT `FK_points_transactions_players` FOREIGN KEY (`player`) REFERENCES `players` (`id`),
  CONSTRAINT `FK_points_transactions_points_transactions_types` FOREIGN KEY (`type`) REFERENCES `points_transactions_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1778 DEFAULT CHARSET=utf8;

--
-- Table structure for table `store_players_items`
--

CREATE TABLE IF NOT EXISTS `store_players_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL,
  `transaction` int(11) DEFAULT NULL,
  `obtaining_date` datetime DEFAULT NULL,
  `item_data` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_store_players_items_players` (`player`),
  KEY `FK_store_players_items_points_transactions` (`transaction`),
  CONSTRAINT `FK_store_players_items_players` FOREIGN KEY (`player`) REFERENCES `players` (`id`),
  CONSTRAINT `FK_store_players_items_points_transactions` FOREIGN KEY (`transaction`) REFERENCES `points_transactions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=772 DEFAULT CHARSET=utf8mb4;


--
-- Table structure for table `tokens`
--

CREATE TABLE IF NOT EXISTS `tokens` (
  `token` varchar(50) NOT NULL,
  `discord` varchar(50) NOT NULL,
  PRIMARY KEY (`token`),
  KEY `FK_tokens_discord_users` (`discord`),
  CONSTRAINT `FK_tokens_discord_users` FOREIGN KEY (`discord`) REFERENCES `discord_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `discord_users`
--

CREATE TABLE IF NOT EXISTS `discord_users` (
  `id` varchar(50) NOT NULL,
  `nickname` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `points_transactions_types`
--

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


CREATE DATABASE IF NOT EXISTS `donations` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `donations`;

--
-- Table structure for table `patron_types`
--
CREATE TABLE IF NOT EXISTS `patron_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(32) NOT NULL,
  KEY `Primary Key` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- Default init
INSERT IGNORE INTO `patron_types` (`type`) VALUES ('None');

--
-- Table structure for table `players`
--

CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(50) NOT NULL,
  `discord` varchar(50) DEFAULT NULL,
  `points` float DEFAULT 0,
  `patron_type` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Index 4` (`ckey`),
  KEY `FK_players_discord_users` (`discord`),
  KEY `FK_players_patron_types` (`patron_type`),
  CONSTRAINT `FK_players_discord_users` FOREIGN KEY (`discord`) REFERENCES `discord_users` (`id`),
  CONSTRAINT `FK_players_patron_types` FOREIGN KEY (`patron_type`) REFERENCES `patron_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=805150 DEFAULT CHARSET=utf8;

--
-- Table structure for table `points_transactions`
--

CREATE TABLE IF NOT EXISTS `points_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `datetime` datetime NOT NULL,
  `change` float NOT NULL,
  `comment` text DEFAULT NULL,
  KEY `Primary Key` (`id`),
  KEY `FK_points_transactions_players` (`player`),
  KEY `FK_points_transactions_points_transactions_types` (`type`),
  CONSTRAINT `FK_points_transactions_players` FOREIGN KEY (`player`) REFERENCES `players` (`id`),
  CONSTRAINT `FK_points_transactions_points_transactions_types` FOREIGN KEY (`type`) REFERENCES `points_transactions_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1778 DEFAULT CHARSET=utf8;

--
-- Table structure for table `store_players_items`
--

CREATE TABLE IF NOT EXISTS `store_players_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) NOT NULL,
  `transaction` int(11) DEFAULT NULL,
  `obtaining_date` datetime DEFAULT NULL,
  `item_data` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_store_players_items_players` (`player`),
  KEY `FK_store_players_items_points_transactions` (`transaction`),
  CONSTRAINT `FK_store_players_items_players` FOREIGN KEY (`player`) REFERENCES `players` (`id`),
  CONSTRAINT `FK_store_players_items_points_transactions` FOREIGN KEY (`transaction`) REFERENCES `points_transactions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=772 DEFAULT CHARSET=utf8mb4;


--
-- Table structure for table `points_transactions_types`
--

CREATE TABLE IF NOT EXISTS `tokens` (
  `token` varchar(50) NOT NULL,
  `discord` varchar(50) NOT NULL,
  PRIMARY KEY (`token`),
  KEY `FK_tokens_discord_users` (`discord`),
  CONSTRAINT `FK_tokens_discord_users` FOREIGN KEY (`discord`) REFERENCES `discord_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `discord_users`
--

CREATE TABLE IF NOT EXISTS `discord_users` (
  `id` varchar(50) NOT NULL,
  `nickname` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `points_transactions_types`
--

CREATE TABLE IF NOT EXISTS `points_transactions_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(32) DEFAULT NULL,
  KEY `Primary Key` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
