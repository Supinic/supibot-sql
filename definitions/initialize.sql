-- --------------------------------------------------------
-- Host:                         192.168.0.101
-- Server version:               10.3.17-MariaDB-0+deb10u1 - Raspbian 10
-- Server OS:                    debian-linux-gnueabihf
-- HeidiSQL Version:             10.3.0.5771
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for bot_data
CREATE DATABASE IF NOT EXISTS `bot_data` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `bot_data`;

-- Dumping structure for table bot_data.Badge
CREATE TABLE IF NOT EXISTS `Badge` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Description` varchar(200) DEFAULT NULL,
  `Emoji` varchar(16) DEFAULT NULL,
  `Required` int(10) unsigned DEFAULT NULL,
  `Image_URL` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name` (`Name`),
  KEY `FK_Badge_Badge` (`Required`),
  CONSTRAINT `FK_Badge_Badge` FOREIGN KEY (`Required`) REFERENCES `Badge` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table bot_data.Bot
CREATE TABLE IF NOT EXISTS `Bot` (
  `Bot_Alias` int(11) NOT NULL,
  `Channel` int(10) unsigned NOT NULL,
  `Prefix` char(20) DEFAULT NULL,
  `Prefix_Space` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `Language` enum('Node.js','Java','C#','Python','Ruby','Typescript') DEFAULT NULL,
  `Author` int(11) DEFAULT NULL,
  `Active` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `Description` text DEFAULT NULL,
  `Last_Verified` timestamp NULL DEFAULT NULL,
  `Level` int(10) unsigned NOT NULL DEFAULT 0,
  `Notes` text DEFAULT NULL,
  PRIMARY KEY (`Bot_Alias`,`Channel`),
  KEY `FK_Chat_Bot_Channel` (`Channel`),
  KEY `FK_Chat_Bot_User_Alias_2` (`Author`),
  KEY `FK_Channel_Bot_Channel_Bot_Level` (`Level`),
  CONSTRAINT `FK_Bot_Author` FOREIGN KEY (`Author`) REFERENCES `chat_data`.`User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Bot_Bot_Alias` FOREIGN KEY (`Bot_Alias`) REFERENCES `chat_data`.`User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Bot_Channel` FOREIGN KEY (`Channel`) REFERENCES `chat_data`.`Channel` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Bot_Level` FOREIGN KEY (`Level`) REFERENCES `Level` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table bot_data.Bot_Badge
CREATE TABLE IF NOT EXISTS `Bot_Badge` (
  `Bot` int(10) NOT NULL,
  `Badge` int(10) unsigned NOT NULL,
  `Notes` text DEFAULT NULL,
  `Added` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  PRIMARY KEY (`Bot`,`Badge`),
  KEY `FK_Bot_Badge_Badge` (`Badge`),
  CONSTRAINT `FK_Bot_Badge_Badge` FOREIGN KEY (`Badge`) REFERENCES `Badge` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Bot_Badge_Bot` FOREIGN KEY (`Bot`) REFERENCES `Bot` (`Bot_Alias`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table bot_data.Level
CREATE TABLE IF NOT EXISTS `Level` (
  `ID` int(10) unsigned NOT NULL,
  `Description` text NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.


-- Dumping database structure for chat_data
CREATE DATABASE IF NOT EXISTS `chat_data` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `chat_data`;

-- Dumping structure for table chat_data.AFK
CREATE TABLE IF NOT EXISTS `AFK` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `User_Alias` int(11) NOT NULL,
  `Started` timestamp(3) NOT NULL DEFAULT current_timestamp(3),
  `Ended` timestamp(3) NULL DEFAULT NULL ON UPDATE current_timestamp(3),
  `Text` varchar(2000) DEFAULT NULL,
  `Status` enum('afk','poop','gn','brb','shower','lurk','food','work','ppPoof','study') DEFAULT NULL,
  `Active` tinyint(1) NOT NULL DEFAULT 1,
  `Silent` tinyint(1) NOT NULL DEFAULT 0,
  `Interrupted_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `AFK_ibfk_1` (`User_Alias`),
  KEY `FK_AFK_AFK` (`Interrupted_ID`),
  KEY `Active_Lookup` (`Active`),
  CONSTRAINT `AFK_ibfk_1` FOREIGN KEY (`User_Alias`) REFERENCES `User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_AFK_AFK` FOREIGN KEY (`Interrupted_ID`) REFERENCES `AFK` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=166346 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Banphrase
CREATE TABLE IF NOT EXISTS `Banphrase` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Code` text NOT NULL,
  `Type` enum('Denial','API response','Custom response','Replacement','Inactive') NOT NULL DEFAULT 'Custom response',
  `Platform` int(10) unsigned DEFAULT 1 COMMENT 'If NULL, the banphrase is considered as global.',
  `Channel` int(10) unsigned DEFAULT NULL,
  `Priority` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Determines the priority of a banphrase. Higher number = higher priority',
  `Description` text DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_Banphrase_Emote_chat_data.Channel` (`Channel`),
  KEY `FK_Banphrase_Platform` (`Platform`),
  CONSTRAINT `FK_Banphrase_Emote_chat_data.Channel` FOREIGN KEY (`Channel`) REFERENCES `Channel` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Banphrase_Platform` FOREIGN KEY (`Platform`) REFERENCES `Platform` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Bot_Badge
CREATE TABLE IF NOT EXISTS `Bot_Badge` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Description` varchar(200) DEFAULT NULL,
  `Emoji` varchar(16) DEFAULT NULL,
  `Image_URL` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Channel
CREATE TABLE IF NOT EXISTS `Channel` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Platform` int(10) unsigned NOT NULL DEFAULT 1,
  `Specific_ID` varchar(16) DEFAULT NULL,
  `Mode` enum('Inactive','Read','Write','VIP','Moderator') DEFAULT 'Write',
  `Ping` tinyint(1) NOT NULL DEFAULT 1,
  `Links_Allowed` tinyint(1) NOT NULL DEFAULT 1,
  `NSFW` tinyint(1) unsigned DEFAULT NULL,
  `Banphrase_API_Type` enum('Pajbot') DEFAULT NULL,
  `Banphrase_API_URL` varchar(100) DEFAULT NULL,
  `Banphrase_API_Downtime` enum('Ignore','Notify','Refuse') DEFAULT NULL,
  `Message_Limit` smallint(5) unsigned DEFAULT NULL,
  `Custom_Code` text DEFAULT NULL,
  `Mirror` int(10) unsigned DEFAULT NULL,
  `Description` text DEFAULT NULL,
  `Data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name_Platform` (`Name`,`Platform`),
  KEY `Mirror` (`Mirror`),
  KEY `FK_Channel_Platform` (`Platform`),
  CONSTRAINT `FK_Channel_Platform` FOREIGN KEY (`Platform`) REFERENCES `Platform` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Mirror` FOREIGN KEY (`Mirror`) REFERENCES `Channel` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=672 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Command
CREATE TABLE IF NOT EXISTS `Command` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Aliases` text DEFAULT NULL,
  `Description` varchar(300) DEFAULT NULL,
  `Cooldown` int(11) unsigned NOT NULL DEFAULT 0 COMMENT 'Command cooldown given in milliseconds',
  `Rollbackable` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `System` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `Skip_Banphrases` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `Whitelisted` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `Whitelist_Response` varchar(300) DEFAULT NULL,
  `Read_Only` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `Opt_Outable` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `Blockable` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `Ping` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `Pipeable` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `Archived` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `Code` text NOT NULL,
  `Examples` text DEFAULT NULL,
  `Dynamic_Description` text DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=202 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Command_Execution
CREATE TABLE IF NOT EXISTS `Command_Execution` (
  `Executed` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `User_Alias` int(11) NOT NULL,
  `Command` int(10) unsigned NOT NULL,
  `Platform` int(11) unsigned NOT NULL,
  `Channel` int(11) unsigned DEFAULT NULL,
  `Execution_Time` decimal(10,3) unsigned DEFAULT NULL,
  `Success` tinyint(1) unsigned NOT NULL,
  `Invocation` varchar(50) NOT NULL,
  `Arguments` text DEFAULT NULL,
  `Result` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`User_Alias`,`Command`,`Executed`,`Platform`),
  KEY `FK_Command_Execution_Command` (`Command`),
  KEY `FK_Command_Execution_Channel` (`Channel`),
  KEY `Executed` (`Executed`),
  KEY `FK_Command_Execution_Platform` (`Platform`),
  CONSTRAINT `FK_Command_Execution_Channel` FOREIGN KEY (`Channel`) REFERENCES `Channel` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Command_Execution_Command` FOREIGN KEY (`Command`) REFERENCES `Command` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Command_Execution_Platform` FOREIGN KEY (`Platform`) REFERENCES `Platform` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Command_Execution_User_Alias` FOREIGN KEY (`User_Alias`) REFERENCES `User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Cron
CREATE TABLE IF NOT EXISTS `Cron` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Expression` varchar(50) NOT NULL,
  `Description` text DEFAULT NULL,
  `Code` text NOT NULL,
  `Type` enum('All','Website','Bot') NOT NULL,
  `Active` tinyint(1) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Error
CREATE TABLE IF NOT EXISTS `Error` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Type` enum('Backend','Command','Database','Other') NOT NULL,
  `Message` mediumtext DEFAULT NULL,
  `Stack` text NOT NULL DEFAULT '',
  `Arguments` text DEFAULT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=741 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Extra_User_Data
CREATE TABLE IF NOT EXISTS `Extra_User_Data` (
  `User_Alias` int(11) NOT NULL,
  `Cookie_Today` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `Cookie_Is_Gifted` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `Cookies_Total` int(10) unsigned NOT NULL DEFAULT 0,
  `Cookie_Gifts_Sent` int(11) NOT NULL DEFAULT 0,
  `Cookie_Gifts_Received` int(11) NOT NULL DEFAULT 0,
  `Points` bigint(20) unsigned NOT NULL DEFAULT 0,
  `Notes` text DEFAULT NULL,
  `Data` text DEFAULT NULL,
  `Following` tinyint(1) DEFAULT NULL,
  `Follow_Date` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`User_Alias`),
  CONSTRAINT `FK_Extra_User_Data_User_Alias` FOREIGN KEY (`User_Alias`) REFERENCES `User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Filter
CREATE TABLE IF NOT EXISTS `Filter` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `User_Alias` int(10) DEFAULT NULL,
  `Channel` int(10) unsigned DEFAULT NULL,
  `Command` int(10) unsigned DEFAULT NULL,
  `Platform` int(10) unsigned DEFAULT NULL,
  `Type` enum('Blacklist','Whitelist','Opt-out','Block','Unping') NOT NULL DEFAULT 'Blacklist',
  `Blocked_User` int(11) DEFAULT NULL,
  `Active` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `Response` enum('None','Auto','Reason') NOT NULL DEFAULT 'None',
  `Reason` varchar(500) DEFAULT NULL,
  `Issued_By` int(11) NOT NULL DEFAULT 1,
  `Created` timestamp NOT NULL DEFAULT current_timestamp(),
  `Changed` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `Notes` text DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `User_Alias_Channel_Command` (`User_Alias`,`Channel`,`Command`,`Type`),
  KEY `FK_Ban_Channel` (`Channel`),
  KEY `FK_Ban_Command` (`Command`),
  KEY `FK_Ban_User_Alias_2` (`Issued_By`),
  KEY `FK_Filter_Platform` (`Platform`),
  KEY `FK_Filter_User_Alias` (`Blocked_User`),
  KEY `Active_Lookup` (`Active`),
  CONSTRAINT `FK_Filter_Platform` FOREIGN KEY (`Platform`) REFERENCES `Platform` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Filter_User_Alias` FOREIGN KEY (`Blocked_User`) REFERENCES `User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Filter_ibfk_1` FOREIGN KEY (`Channel`) REFERENCES `Channel` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Filter_ibfk_2` FOREIGN KEY (`Command`) REFERENCES `Command` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Filter_ibfk_3` FOREIGN KEY (`User_Alias`) REFERENCES `User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Filter_ibfk_4` FOREIGN KEY (`Issued_By`) REFERENCES `User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=637 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Log
CREATE TABLE IF NOT EXISTS `Log` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Tag` enum('Command','Message','Twitch','Discord','Cytube','Module','System') NOT NULL DEFAULT 'System',
  `Subtag` enum('Request','Fail','Warning','Success','Shadowban','Ban','Clearchat','Sub','Giftsub','Host','Error','Timeout','Restart','Other','Ritual') DEFAULT NULL,
  `Description` text DEFAULT NULL,
  `Channel` int(10) unsigned DEFAULT NULL,
  `User_Alias` int(10) DEFAULT NULL,
  `Timestamp` timestamp(3) NOT NULL DEFAULT current_timestamp(3),
  PRIMARY KEY (`ID`),
  KEY `FK_Log_Channel` (`Channel`),
  KEY `FK_Log_User_Alias` (`User_Alias`),
  CONSTRAINT `FK_Log_Channel` FOREIGN KEY (`Channel`) REFERENCES `Channel` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Log_User_Alias` FOREIGN KEY (`User_Alias`) REFERENCES `User_Alias` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3165501 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Message_Meta_Channel
CREATE TABLE IF NOT EXISTS `Message_Meta_Channel` (
  `Timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `Channel` int(10) unsigned NOT NULL,
  `Amount` int(11) DEFAULT NULL,
  `Length` int(11) DEFAULT NULL,
  PRIMARY KEY (`Timestamp`,`Channel`),
  KEY `Channel_Amount` (`Channel`,`Amount`),
  KEY `Channel_Length` (`Channel`,`Length`),
  CONSTRAINT `FK_Message_Data_Channel` FOREIGN KEY (`Channel`) REFERENCES `Channel` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Message_Meta_Count
CREATE TABLE IF NOT EXISTS `Message_Meta_Count` (
  `User_Alias` int(11) NOT NULL,
  `Channel` int(10) unsigned NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `Amount` int(10) unsigned NOT NULL,
  `Length` int(10) unsigned NOT NULL,
  PRIMARY KEY (`User_Alias`,`Channel`,`Timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Message_Meta_Record
CREATE TABLE IF NOT EXISTS `Message_Meta_Record` (
  `Channel` int(10) unsigned NOT NULL,
  `Type` enum('Amount','Length') NOT NULL,
  `Record` int(10) unsigned NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`Channel`,`Type`),
  CONSTRAINT `FK__Channel` FOREIGN KEY (`Channel`) REFERENCES `Channel` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Message_Meta_User_Alias
CREATE TABLE IF NOT EXISTS `Message_Meta_User_Alias` (
  `User_Alias` int(11) NOT NULL,
  `Channel` int(11) unsigned NOT NULL,
  `Message_Count` int(11) unsigned NOT NULL DEFAULT 1,
  `Last_Message_Text` varchar(2000) DEFAULT NULL,
  `Last_Message_Posted` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`User_Alias`,`Channel`),
  KEY `Last_Seen_Lookup` (`User_Alias`,`Last_Message_Posted`),
  KEY `Top_Chatters_in_Channel_Lookup` (`Channel`,`Message_Count`),
  CONSTRAINT `FK_User_Message_Meta_Channel` FOREIGN KEY (`Channel`) REFERENCES `Channel` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_User_Message_Meta_User_Alias` FOREIGN KEY (`User_Alias`) REFERENCES `User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Platform
CREATE TABLE IF NOT EXISTS `Platform` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Poll
CREATE TABLE IF NOT EXISTS `Poll` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Text` text NOT NULL,
  `Status` enum('Inactive','Active','Passed','Failed','Cancelled') NOT NULL DEFAULT 'Inactive',
  `Created` datetime NOT NULL DEFAULT current_timestamp(),
  `Start` datetime DEFAULT NULL,
  `End` datetime NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Poll_Vote
CREATE TABLE IF NOT EXISTS `Poll_Vote` (
  `User_Alias` int(11) NOT NULL,
  `Poll` int(11) unsigned NOT NULL,
  `Vote` enum('Yes','No') NOT NULL,
  `Created` datetime NOT NULL DEFAULT current_timestamp(),
  `Last_Edit` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`User_Alias`,`Poll`),
  KEY `FK_Poll_Vote_Poll` (`Poll`),
  CONSTRAINT `FK_Poll_Vote_Poll` FOREIGN KEY (`Poll`) REFERENCES `Poll` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Poll_Vote_User_Alias` FOREIGN KEY (`User_Alias`) REFERENCES `User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Reminder
CREATE TABLE IF NOT EXISTS `Reminder` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `User_From` int(11) NOT NULL,
  `User_To` int(11) NOT NULL,
  `Channel` int(11) unsigned DEFAULT NULL,
  `Platform` int(11) unsigned DEFAULT NULL,
  `Text` varchar(2000) DEFAULT NULL,
  `Created` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `Schedule` datetime(3) DEFAULT NULL,
  `Active` tinyint(1) NOT NULL DEFAULT 1,
  `Private_Message` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`),
  KEY `Reminder_User_Alias_From` (`User_From`),
  KEY `FK_Reminder_Channel` (`Channel`),
  KEY `FK_Reminder_User_Alias` (`User_To`),
  KEY `FK_Reminder_Platform` (`Platform`),
  KEY `Active_Lookup` (`Active`),
  CONSTRAINT `FK_Reminder_Channel` FOREIGN KEY (`Channel`) REFERENCES `Channel` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Reminder_Platform` FOREIGN KEY (`Platform`) REFERENCES `Platform` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Reminder_User_Alias` FOREIGN KEY (`User_To`) REFERENCES `User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Reminder_User_Alias_From` FOREIGN KEY (`User_From`) REFERENCES `User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=111093 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Song_Request
CREATE TABLE IF NOT EXISTS `Song_Request` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Link` varchar(50) NOT NULL,
  `Video_Type` int(10) unsigned NOT NULL,
  `User_Alias` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Table_Update_Notification
CREATE TABLE IF NOT EXISTS `Table_Update_Notification` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `User_Alias` int(11) NOT NULL,
  `Channel` int(10) unsigned NOT NULL,
  `Event` enum('Gachi','Suggestion') NOT NULL,
  `Active` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `Created` timestamp NOT NULL DEFAULT current_timestamp(),
  `Changed` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID`),
  UNIQUE KEY `User_Alias_Event` (`User_Alias`,`Event`),
  KEY `FK_Event_Subscription_Channel` (`Channel`),
  CONSTRAINT `FK_Event_Subscription_Channel` FOREIGN KEY (`Channel`) REFERENCES `Channel` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Event_Subscription_User_Alias` FOREIGN KEY (`User_Alias`) REFERENCES `User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.Twitch_Ban
CREATE TABLE IF NOT EXISTS `Twitch_Ban` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `User_Alias` int(11) NOT NULL,
  `Channel` int(11) unsigned NOT NULL,
  `Length` int(11) DEFAULT NULL,
  `Issued` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `Notes` text DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_Twitch_Ban_User_Alias` (`User_Alias`),
  KEY `FK_Twitch_Ban_Channel` (`Channel`),
  KEY `Issued` (`Issued`),
  CONSTRAINT `FK_Twitch_Ban_Channel` FOREIGN KEY (`Channel`) REFERENCES `Channel` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Twitch_Ban_User_Alias` FOREIGN KEY (`User_Alias`) REFERENCES `User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3620688 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.User
CREATE TABLE IF NOT EXISTS `User` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Community_Nick` varchar(32) NOT NULL,
  `Current_Alias` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `User_ibfk_1` (`Current_Alias`),
  CONSTRAINT `User_ibfk_1` FOREIGN KEY (`Current_Alias`) REFERENCES `User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.User_Alias
CREATE TABLE IF NOT EXISTS `User_Alias` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `User` int(11) DEFAULT NULL,
  `Name` varchar(32) NOT NULL,
  `Discord_ID` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `Mixer_ID` varchar(16) DEFAULT NULL,
  `Twitch_ID` varchar(16) CHARACTER SET utf8 DEFAULT NULL,
  `Started_Using` datetime NOT NULL DEFAULT current_timestamp(),
  `Well_Known` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Determines if the user should be loaded on bot startup. Turns to 1 (true) when that user executes a command.',
  `Data` text DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name_2` (`Name`),
  KEY `User` (`User`),
  KEY `Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=4358461 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.User_Alias_Connection
CREATE TABLE IF NOT EXISTS `User_Alias_Connection` (
  `User_From` int(11) NOT NULL,
  `User_To` int(11) NOT NULL,
  `Notes` text DEFAULT NULL,
  PRIMARY KEY (`User_From`,`User_To`),
  KEY `FK_User_Alias_Connection_User_Alias_2` (`User_To`),
  CONSTRAINT `FK_User_Alias_Connection_User_Alias` FOREIGN KEY (`User_From`) REFERENCES `User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_User_Alias_Connection_User_Alias_2` FOREIGN KEY (`User_To`) REFERENCES `User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.User_Alias_No_Holes
CREATE TABLE IF NOT EXISTS `User_Alias_No_Holes` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `User` int(11) DEFAULT NULL,
  `Name` varchar(32) NOT NULL,
  `Started_Using` datetime NOT NULL,
  `Stopped_Using` datetime DEFAULT NULL,
  `Discord` tinyint(1) NOT NULL DEFAULT 0,
  `Cytube` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name_2` (`Name`),
  KEY `User` (`User`),
  KEY `Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=262144 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.

-- Dumping structure for table chat_data.User_Connection_Challenge
CREATE TABLE IF NOT EXISTS `User_Connection_Challenge` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `User_From` int(11) NOT NULL,
  `User_To` int(11) DEFAULT NULL,
  `Challenge` varchar(200) NOT NULL,
  `Initiated` datetime NOT NULL DEFAULT current_timestamp(),
  `Last_Edit` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `Status` enum('Active','Pending','Inactive','Cancelled') NOT NULL DEFAULT 'Pending',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `User_From_User_To` (`User_From`,`User_To`),
  KEY `FK_User_Connection_Challenge_User_Alias_2` (`User_To`),
  CONSTRAINT `FK_User_Connection_Challenge_User_Alias` FOREIGN KEY (`User_From`) REFERENCES `User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_User_Connection_Challenge_User_Alias_2` FOREIGN KEY (`User_To`) REFERENCES `User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for event chat_data.Cookies_Daily_Reset
DELIMITER //
CREATE EVENT `Cookies_Daily_Reset` ON SCHEDULE EVERY 1 DAY STARTS '2019-02-26 01:00:00' ENDS '2021-02-26 00:00:00' ON COMPLETION PRESERVE ENABLE COMMENT 'Resets all daily fortune cookies' DO BEGIN
	UPDATE chat_data.Extra_User_Data
	SET 
		Cookie_Today = 0,
		Cookies_Total = Cookies_Total + 1,
		Cookie_Is_Gifted = 0
	WHERE Cookie_Today = 1;
	
	UPDATE chat_data.Extra_User_Data
	SET Cookie_Is_Gifted = 0
	WHERE Cookie_Is_Gifted = 1;
END//
DELIMITER ;


-- Dumping database structure for cytube
CREATE DATABASE IF NOT EXISTS `cytube` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `cytube`;

-- Dumping structure for table cytube.Video_Request
CREATE TABLE IF NOT EXISTS `Video_Request` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `User_Alias` int(11) NOT NULL,
  `Posted` datetime NOT NULL,
  `Channel` int(10) unsigned NOT NULL DEFAULT 49,
  `Link` varchar(200) NOT NULL,
  `Type` int(11) NOT NULL DEFAULT 1,
  `Length` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `Type` (`Type`),
  KEY `Video_Request_ibfk_2` (`User_Alias`),
  KEY `FK_Video_Request_chat_data.Channel` (`Channel`),
  CONSTRAINT `FK_Video_Request_chat_data.Channel` FOREIGN KEY (`Channel`) REFERENCES `chat_data`.`Channel` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Video_Request_ibfk_1` FOREIGN KEY (`Type`) REFERENCES `Video_Type` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Video_Request_ibfk_2` FOREIGN KEY (`User_Alias`) REFERENCES `chat_data`.`User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=50454 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table cytube.Video_Type
CREATE TABLE IF NOT EXISTS `Video_Type` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Description` varchar(50) NOT NULL,
  `Type` varchar(10) DEFAULT NULL,
  `Link_Prefix` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.


-- Dumping database structure for data
CREATE DATABASE IF NOT EXISTS `data` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `data`;

-- Dumping structure for table data.Config
CREATE TABLE IF NOT EXISTS `Config` (
  `Name` varchar(50) NOT NULL,
  `Value` text DEFAULT NULL,
  `Type` enum('number','string','array','object','date','regex','boolean','function') NOT NULL DEFAULT 'string',
  `Unit` enum('ms','s') DEFAULT NULL,
  `Secret` tinyint(1) NOT NULL DEFAULT 0,
  `Editable` tinyint(1) NOT NULL DEFAULT 0,
  `Notes` text DEFAULT NULL,
  PRIMARY KEY (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table data.Copypasta
CREATE TABLE IF NOT EXISTS `Copypasta` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Text` text NOT NULL,
  `Notes` text DEFAULT NULL,
  `Approved` tinyint(4) NOT NULL DEFAULT 0,
  `Date` date DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table data.Country
CREATE TABLE IF NOT EXISTS `Country` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Code_Alpha_2` varchar(2) NOT NULL,
  `Code_Alpha_3` varchar(3) NOT NULL,
  `Numeric_Code` varchar(3) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Code_Alpha_2` (`Code_Alpha_2`),
  UNIQUE KEY `Code_Alpha_3` (`Code_Alpha_3`),
  UNIQUE KEY `Numeric_Code` (`Numeric_Code`)
) ENGINE=InnoDB AUTO_INCREMENT=249 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table data.Edit
CREATE TABLE IF NOT EXISTS `Edit` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Changed_Table` enum('Fortune_Cookie','Fun_Fact','Gachi','Origin') NOT NULL,
  `Changed_ID` int(10) unsigned NOT NULL,
  `Changed_Column` varchar(50) NOT NULL,
  `Original_Value` text DEFAULT NULL,
  `New_Value` text DEFAULT NULL,
  `Change_Timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `Credit` int(10) NOT NULL DEFAULT 1,
  PRIMARY KEY (`ID`),
  KEY `FK_Edit_chat_data.User_Alias` (`Credit`),
  CONSTRAINT `FK_Edit_chat_data.User_Alias` FOREIGN KEY (`Credit`) REFERENCES `chat_data`.`User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1940 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table data.Event
CREATE TABLE IF NOT EXISTS `Event` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Description` text DEFAULT NULL,
  `Category` enum('Y','N') DEFAULT NULL,
  `Subcategory` enum('Y','N') DEFAULT NULL,
  `Date` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table data.Extra_News
CREATE TABLE IF NOT EXISTS `Extra_News` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Code` varchar(10) NOT NULL,
  `Language` varchar(50) NOT NULL,
  `URL` varchar(100) NOT NULL,
  `Endpoints` text NOT NULL,
  `Type` enum('RSS') NOT NULL DEFAULT 'RSS',
  `Helpers` text DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Code` (`Code`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table data.Fortune_Cookie
CREATE TABLE IF NOT EXISTS `Fortune_Cookie` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Text` varchar(500) NOT NULL,
  `Submitter` int(11) DEFAULT NULL,
  `Notes` text DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `Submitter_data_User_Alias` (`Submitter`),
  CONSTRAINT `Submitter_data_User_Alias` FOREIGN KEY (`Submitter`) REFERENCES `chat_data`.`User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=953 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table data.Fun_Fact
CREATE TABLE IF NOT EXISTS `Fun_Fact` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Text` varchar(450) NOT NULL,
  `Submitter` int(11) DEFAULT NULL,
  `Tag` enum('Bees') DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `Fun_Fact_User_Alias` (`Submitter`),
  KEY `FK_Fun_Fact_Tag` (`Tag`),
  CONSTRAINT `Fun_Fact_User_Alias` FOREIGN KEY (`Submitter`) REFERENCES `chat_data`.`User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=167 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table data.Gachi
CREATE TABLE IF NOT EXISTS `Gachi` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(300) NOT NULL,
  `Foreign_Name` varchar(300) DEFAULT NULL,
  `Link` varchar(150) NOT NULL,
  `Youtube_Link` varchar(300) DEFAULT NULL,
  `Author` varchar(300) DEFAULT NULL,
  `Video_Type` int(11) unsigned NOT NULL DEFAULT 1,
  `Based_On` varchar(300) DEFAULT NULL,
  `Based_On_Link` varchar(300) DEFAULT NULL,
  `Published` date NOT NULL,
  `Length` int(10) unsigned DEFAULT NULL,
  `Notes` text DEFAULT NULL,
  `Audio_Backup` varchar(300) DEFAULT NULL,
  `Added_By` int(11) DEFAULT NULL,
  `Added_On` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Link` (`Link`),
  KEY `fk_added_by_user_alias` (`Added_By`),
  KEY `FK_Gachi_Video_Type` (`Video_Type`),
  CONSTRAINT `FK_Gachi_Video_Type` FOREIGN KEY (`Video_Type`) REFERENCES `Video_Type` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_added_by_user_alias` FOREIGN KEY (`Added_By`) REFERENCES `chat_data`.`User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2192 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table data.Gachi_Todo_List
CREATE TABLE IF NOT EXISTS `Gachi_Todo_List` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Link` varchar(150) NOT NULL,
  `Video_Type` int(10) unsigned NOT NULL DEFAULT 1,
  `Added_By` int(11) DEFAULT NULL,
  `Added_On` timestamp NOT NULL DEFAULT current_timestamp(),
  `Notes` text DEFAULT NULL,
  `Rejected` tinyint(1) NOT NULL DEFAULT 0,
  `Result` int(11) unsigned DEFAULT NULL,
  `Data` text DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Link` (`Link`),
  KEY `Added_By` (`Added_By`),
  KEY `FK_Gachi_Todo_List_Video_Type` (`Video_Type`),
  CONSTRAINT `Added_By` FOREIGN KEY (`Added_By`) REFERENCES `chat_data`.`User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Gachi_Todo_List_Video_Type` FOREIGN KEY (`Video_Type`) REFERENCES `Video_Type` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1757 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table data.Markov_Chain
CREATE TABLE IF NOT EXISTS `Markov_Chain` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Definition` longtext NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table data.Origin
CREATE TABLE IF NOT EXISTS `Origin` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Text` varchar(500) NOT NULL,
  `Tier` enum('1','2','3') DEFAULT NULL,
  `Raffle` date DEFAULT NULL,
  `Raffle_Winner` int(11) DEFAULT NULL,
  `User_Alias` int(11) NOT NULL DEFAULT 1,
  `Todo` tinyint(1) NOT NULL DEFAULT 0,
  `Approved` tinyint(1) NOT NULL DEFAULT 1,
  `Platform` enum('Twitch - Global','Twitch - Sub','Twitch - Bits','BTTV','FFZ','Discord','Other') DEFAULT 'Twitch - Sub',
  `Emote_Added` date DEFAULT NULL,
  `Record_Added` datetime DEFAULT current_timestamp(),
  `Notes` text DEFAULT NULL,
  `Emote` blob DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_user_alias_origin` (`User_Alias`),
  KEY `FK_Origin_chat_data.User_Alias` (`Raffle_Winner`),
  CONSTRAINT `FK_Origin_chat_data.User_Alias` FOREIGN KEY (`Raffle_Winner`) REFERENCES `chat_data`.`User_Alias` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_user_alias_origin` FOREIGN KEY (`User_Alias`) REFERENCES `chat_data`.`User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=307 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table data.Patch_Notes
CREATE TABLE IF NOT EXISTS `Patch_Notes` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Version` int(10) unsigned NOT NULL DEFAULT 2,
  `Subversion` int(10) unsigned NOT NULL DEFAULT 0,
  `Build` int(10) unsigned NOT NULL DEFAULT 0,
  `Summary` tinytext NOT NULL,
  `Description` text DEFAULT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Version_Subversion_Build` (`Version`,`Subversion`,`Build`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table data.Playsound
CREATE TABLE IF NOT EXISTS `Playsound` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Filename` varchar(100) NOT NULL,
  `Access` enum('Everyone','System','Inactive') NOT NULL DEFAULT 'Inactive',
  `Cooldown` int(11) NOT NULL DEFAULT 5000 COMMENT 'Playsound-specific cooldown, in milliseconds.',
  `Notes` text DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Filename` (`Filename`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table data.Reset
CREATE TABLE IF NOT EXISTS `Reset` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `User_Alias` int(11) NOT NULL,
  `Timestamp` datetime NOT NULL DEFAULT current_timestamp(),
  `Reason` text DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK__chat_data.User_Alias` (`User_Alias`),
  CONSTRAINT `FK__chat_data.User_Alias` FOREIGN KEY (`User_Alias`) REFERENCES `chat_data`.`User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=157 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table data.Slots_Pattern
CREATE TABLE IF NOT EXISTS `Slots_Pattern` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Pattern` text NOT NULL,
  `Type` enum('Array','Function') NOT NULL,
  `Notes` text DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table data.Slots_Winner
CREATE TABLE IF NOT EXISTS `Slots_Winner` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `User_Alias` int(11) NOT NULL,
  `Channel` int(10) unsigned NOT NULL,
  `Odds` float unsigned NOT NULL,
  `Source` text NOT NULL,
  `Result` text NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`ID`),
  KEY `FK_Slots_Winner_chat_data.User_Alias` (`User_Alias`),
  KEY `FK_Slots_Winner_chat_data.Channel` (`Channel`),
  CONSTRAINT `FK_Slots_Winner_chat_data.Channel` FOREIGN KEY (`Channel`) REFERENCES `chat_data`.`Channel` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Slots_Winner_chat_data.User_Alias` FOREIGN KEY (`User_Alias`) REFERENCES `chat_data`.`User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2400 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table data.Suggestion
CREATE TABLE IF NOT EXISTS `Suggestion` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `User_Alias` int(11),
  `Text` text DEFAULT NULL,
  `Date` datetime DEFAULT current_timestamp(),
  `Category` enum('Duplicate','Backend','Command - new','Command - refactor','Command - delete','Cytube general','Cytube emote','Discord general','Discord emote','Gachi','Not a suggestion','Other','Refuge general','Refuge emote','Website','Stream','Uncategorized','Origin','Song requests','Bot addition','Verify animal') NOT NULL DEFAULT 'Uncategorized',
  `Status` enum('Approved','Denied','Completed','Dismissed','Dismissed by author','Duplicate','Needs more info','New','Possible','Postponed','Redirected','Rejected','Unlikely','Outsourced','Quarantined','Polled') NOT NULL DEFAULT 'New',
  `Notes` text DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_suggestion_user_alias` (`User_Alias`),
  CONSTRAINT `fk_suggestion_user_alias` FOREIGN KEY (`User_Alias`) REFERENCES `chat_data`.`User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2763 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table data.Timezone
CREATE TABLE IF NOT EXISTS `Timezone` (
  `Abbreviation` varchar(10) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Offset` float NOT NULL DEFAULT 0,
  `Description` text DEFAULT NULL,
  PRIMARY KEY (`Abbreviation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table data.Video_Type
CREATE TABLE IF NOT EXISTS `Video_Type` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Description` varchar(50) NOT NULL,
  `Type` varchar(10) DEFAULT NULL,
  `Link_Prefix` varchar(100) NOT NULL DEFAULT '',
  `Parser_Name` varchar(20) DEFAULT NULL,
  `Author_Prefix` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table data.Word
CREATE TABLE IF NOT EXISTS `Word` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Word` varchar(50) NOT NULL,
  `Language` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=466552 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for trigger data.Gachi_After_Insert_Check_Todo
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `Gachi_After_Insert_Check_Todo` AFTER INSERT ON `Gachi` FOR EACH ROW BEGIN
	IF ((SELECT COUNT(*) FROM Gachi_Todo_List AS Todo WHERE NEW.Link = Todo.Link OR NEW.Youtube_Link = Todo.Link) <> 0) THEN
		UPDATE Gachi_Todo_List AS Todo
			SET Todo.Result = NEW.ID
			WHERE Todo.Result IS NULL AND (NEW.Link = Todo.Link OR NEW.Youtube_Link = Todo.Link);
	END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger data.Gachi_Edit_ON_UPDATE
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `Gachi_Edit_ON_UPDATE` BEFORE UPDATE ON `Gachi` FOR EACH ROW BEGIN
	IF (!(OLD.Name <=> NEW.Name)) THEN
		INSERT INTO Edit (Changed_Table, Changed_Column, Changed_ID, Original_Value, New_Value) VALUES ("Gachi", "Name", OLD.ID, OLD.Name, NEW.Name);
	END IF;
	IF (!(OLD.Foreign_Name <=> NEW.Foreign_Name)) THEN
		INSERT INTO Edit (Changed_Table, Changed_Column, Changed_ID, Original_Value, New_Value) VALUES ("Gachi", "Foreign_Name", OLD.ID, OLD.Foreign_Name, NEW.Foreign_Name);
	END IF;
	IF (!(OLD.Link <=> NEW.Link)) THEN
		INSERT INTO Edit (Changed_Table, Changed_Column, Changed_ID, Original_Value, New_Value) VALUES ("Gachi", "Link", OLD.ID, OLD.Link, NEW.Link);
	END IF;
	IF (!(OLD.Youtube_Link <=> NEW.Youtube_Link)) THEN
		INSERT INTO Edit (Changed_Table, Changed_Column, Changed_ID, Original_Value, New_Value) VALUES ("Gachi", "Youtube_Link", OLD.ID, OLD.Youtube_Link, NEW.Youtube_Link);
	END IF;
	IF (!(OLD.Author <=> NEW.Author)) THEN
		INSERT INTO Edit (Changed_Table, Changed_Column, Changed_ID, Original_Value, New_Value) VALUES ("Gachi", "Author", OLD.ID, OLD.Author, NEW.Author);
	END IF;
	IF (!(OLD.Video_Type <=> NEW.Video_Type)) THEN
		INSERT INTO Edit (Changed_Table, Changed_Column, Changed_ID, Original_Value, New_Value) VALUES ("Gachi", "Video_Type", OLD.ID, OLD.Video_Type, NEW.Video_Type);
	END IF;
	IF (!(OLD.Based_On <=> NEW.Based_On)) THEN
		INSERT INTO Edit (Changed_Table, Changed_Column, Changed_ID, Original_Value, New_Value) VALUES ("Gachi", "Based_On", OLD.ID, OLD.Based_On, NEW.Based_On);
	END IF;
	IF (!(OLD.Based_On_Link <=> NEW.Based_On_Link)) THEN
		INSERT INTO Edit (Changed_Table, Changed_Column, Changed_ID, Original_Value, New_Value) VALUES ("Gachi", "Based_On_Link", OLD.ID, OLD.Based_On_Link, NEW.Based_On_Link);
	END IF;
	IF (!(OLD.Published <=> NEW.Published)) THEN
		INSERT INTO Edit (Changed_Table, Changed_Column, Changed_ID, Original_Value, New_Value) VALUES ("Gachi", "Published", OLD.ID, OLD.Published, NEW.Published);
	END IF;
	IF (!(OLD.Length <=> NEW.Length)) THEN
		INSERT INTO Edit (Changed_Table, Changed_Column, Changed_ID, Original_Value, New_Value) VALUES ("Gachi", "Length", OLD.ID, OLD.Length, NEW.Length);
	END IF;
	IF (!(OLD.Notes <=> NEW.Notes)) THEN
		INSERT INTO Edit (Changed_Table, Changed_Column, Changed_ID, Original_Value, New_Value) VALUES ("Gachi", "Notes", OLD.ID, OLD.Notes, NEW.Notes);
	END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Dumping database structure for music
CREATE DATABASE IF NOT EXISTS `music` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `music`;

-- Dumping structure for table music.Alias
CREATE TABLE IF NOT EXISTS `Alias` (
  `Target_Table` enum('Track','Author') NOT NULL,
  `Target_ID` int(10) unsigned NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Notes` text DEFAULT NULL,
  `Added_By` int(11) DEFAULT 1,
  `Added_On` datetime(3) DEFAULT current_timestamp(3),
  `Last_Edit` datetime(3) DEFAULT NULL ON UPDATE current_timestamp(3),
  PRIMARY KEY (`Target_Table`,`Target_ID`,`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table music.Author
CREATE TABLE IF NOT EXISTS `Author` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Normalized_Name` varchar(100) NOT NULL,
  `Country` int(10) unsigned DEFAULT NULL,
  `Bilibili_ID` varchar(16) DEFAULT NULL,
  `Nicovideo_ID` varchar(16) DEFAULT NULL,
  `Discord_ID` varchar(50) DEFAULT NULL,
  `Soundcloud_ID` varchar(50) DEFAULT NULL,
  `Twitch_ID` varchar(50) DEFAULT NULL,
  `Twitter_ID` varchar(50) DEFAULT NULL,
  `Vimeo_ID` varchar(16) DEFAULT NULL,
  `Youtube_Channel_ID` varchar(50) DEFAULT NULL,
  `Youtube_User_ID` varchar(50) DEFAULT NULL,
  `Youtube_Name` varchar(50) DEFAULT NULL,
  `User_Alias` int(11) DEFAULT NULL,
  `Notes` text DEFAULT NULL,
  `Added_By` int(11) NOT NULL DEFAULT 1,
  `Added_On` datetime(3) DEFAULT current_timestamp(3),
  `Last_Edit` datetime(3) DEFAULT NULL ON UPDATE current_timestamp(3),
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Normalized_Name` (`Normalized_Name`),
  KEY `FK__data.Country` (`Country`),
  KEY `FK_Author_chat_data.User_Alias` (`User_Alias`),
  CONSTRAINT `FK_Author_chat_data.User_Alias` FOREIGN KEY (`User_Alias`) REFERENCES `chat_data`.`User_Alias` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK__data.Country` FOREIGN KEY (`Country`) REFERENCES `data`.`Country` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1299 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table music.Playlist
CREATE TABLE IF NOT EXISTS `Playlist` (
  `ID` int(10) unsigned NOT NULL,
  `User_Alias` int(11) NOT NULL,
  `Privacy` enum('Public','Unlisted','Private') NOT NULL DEFAULT 'Public',
  `Name` varchar(50) NOT NULL,
  `Added_On` datetime NOT NULL DEFAULT current_timestamp(),
  `Last_Edit` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID`),
  KEY `FK_Playlist_chat_data.User_Alias` (`User_Alias`),
  CONSTRAINT `FK_Playlist_chat_data.User_Alias` FOREIGN KEY (`User_Alias`) REFERENCES `chat_data`.`User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table music.Tag
CREATE TABLE IF NOT EXISTS `Tag` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Category` enum('Anime','Game','Genre','Origin','Quality','Source','Top-level','Issues','Technical') NOT NULL,
  `Notes` text DEFAULT NULL,
  `Added_By` int(11) NOT NULL DEFAULT 1,
  `Added_On` datetime(3) DEFAULT current_timestamp(3),
  `Last_Edit` datetime(3) DEFAULT NULL ON UPDATE current_timestamp(3),
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table music.Track
CREATE TABLE IF NOT EXISTS `Track` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Link` varchar(150) DEFAULT NULL,
  `Name` varchar(200) DEFAULT NULL,
  `Video_Type` int(10) unsigned DEFAULT NULL,
  `Track_Type` enum('Single','Collaboration','Reupload','Audio archive','Video archive') DEFAULT 'Single',
  `Duration` float unsigned DEFAULT NULL,
  `Available` tinyint(3) unsigned DEFAULT NULL,
  `Published` datetime DEFAULT NULL,
  `Notes` text DEFAULT NULL,
  `Added_By` int(11) DEFAULT NULL,
  `Added_On` datetime(3) DEFAULT current_timestamp(3),
  `Last_Edit` datetime(3) DEFAULT NULL ON UPDATE current_timestamp(3),
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Link` (`Link`),
  KEY `FK__chat_data.User_Alias` (`Added_By`),
  KEY `FK__data.Video_Type` (`Video_Type`),
  CONSTRAINT `FK__chat_data.User_Alias` FOREIGN KEY (`Added_By`) REFERENCES `chat_data`.`User_Alias` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK__data.Video_Type` FOREIGN KEY (`Video_Type`) REFERENCES `data`.`Video_Type` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9538 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table music.Track_Author
CREATE TABLE IF NOT EXISTS `Track_Author` (
  `Author` int(10) unsigned NOT NULL,
  `Role` enum('Author','Featured','Audio','Video','Vocals','Producer','Lyrics','Arrangment','Reuploader','Archiver','Uploader') NOT NULL,
  `Track` int(10) unsigned NOT NULL,
  `Notes` text DEFAULT NULL,
  `Added_By` int(11) DEFAULT 1,
  `Added_On` datetime(3) DEFAULT current_timestamp(3),
  `Last_Edit` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`Author`,`Role`,`Track`),
  KEY `FK_Track_Author_Track` (`Track`),
  KEY `FK_Track_Author_chat_data.User_Alias` (`Added_By`),
  CONSTRAINT `FK_Track_Author_Author` FOREIGN KEY (`Author`) REFERENCES `Author` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Track_Author_Track` FOREIGN KEY (`Track`) REFERENCES `Track` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Track_Author_chat_data.User_Alias` FOREIGN KEY (`Added_By`) REFERENCES `chat_data`.`User_Alias` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table music.Track_Rating
CREATE TABLE IF NOT EXISTS `Track_Rating` (
  `Track` int(10) unsigned NOT NULL,
  `User_Alias` int(10) NOT NULL,
  `Rating` enum('1','2','3','4','5','6','7','8','9','10') NOT NULL,
  `Notes` text DEFAULT NULL,
  `Added_On` datetime(3) DEFAULT current_timestamp(3),
  `Last_Edit` datetime(3) DEFAULT NULL ON UPDATE current_timestamp(3),
  PRIMARY KEY (`Track`,`User_Alias`),
  KEY `FK_Track_Rating_User_Alias` (`User_Alias`),
  CONSTRAINT `FK_Track_Rating_Track` FOREIGN KEY (`Track`) REFERENCES `Track` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Track_Rating_User_Alias` FOREIGN KEY (`User_Alias`) REFERENCES `chat_data`.`User_Alias` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table music.Track_Relationship
CREATE TABLE IF NOT EXISTS `Track_Relationship` (
  `Track_From` int(10) unsigned NOT NULL,
  `Relationship` enum('Based on','Reuploaded as','Archive of','Inspired by','Part of','Reupload of','Remake of') NOT NULL,
  `Track_To` int(10) unsigned NOT NULL,
  `Notes` text DEFAULT NULL,
  `Time_Start` int(10) unsigned DEFAULT NULL,
  `Time_End` int(10) unsigned DEFAULT NULL,
  `Added_By` int(11) DEFAULT 1,
  `Added_On` datetime(3) DEFAULT current_timestamp(3),
  `Last_Edit` datetime(3) DEFAULT NULL ON UPDATE current_timestamp(3),
  PRIMARY KEY (`Track_From`,`Relationship`,`Track_To`),
  KEY `FK__Track_2` (`Track_To`),
  KEY `FK_Track_Relationship_chat_data.User_Alias` (`Added_By`),
  CONSTRAINT `FK_Track_Relationship_chat_data.User_Alias` FOREIGN KEY (`Added_By`) REFERENCES `chat_data`.`User_Alias` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK__Track` FOREIGN KEY (`Track_From`) REFERENCES `Track` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK__Track_2` FOREIGN KEY (`Track_To`) REFERENCES `Track` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table music.Track_Tag
CREATE TABLE IF NOT EXISTS `Track_Tag` (
  `Track` int(10) unsigned NOT NULL,
  `Tag` int(10) unsigned NOT NULL,
  `Notes` text DEFAULT NULL,
  `Added_By` int(10) DEFAULT 1,
  `Added_On` datetime(3) DEFAULT current_timestamp(3),
  `Last_Edit` datetime(3) DEFAULT NULL ON UPDATE current_timestamp(3),
  PRIMARY KEY (`Track`,`Tag`),
  KEY `FK_Track_Tag_Tag` (`Tag`),
  KEY `FK_Track_Tag_chat_data.User_Alias` (`Added_By`),
  CONSTRAINT `FK_Track_Tag_Tag` FOREIGN KEY (`Tag`) REFERENCES `Tag` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Track_Tag_Track` FOREIGN KEY (`Track`) REFERENCES `Track` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Track_Tag_chat_data.User_Alias` FOREIGN KEY (`Added_By`) REFERENCES `chat_data`.`User_Alias` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table music.User_Alias_Playlist
CREATE TABLE IF NOT EXISTS `User_Alias_Playlist` (
  `Playlist` int(10) unsigned NOT NULL,
  `Track` int(10) unsigned NOT NULL,
  `Notes` text DEFAULT NULL,
  PRIMARY KEY (`Playlist`,`Track`),
  KEY `FK_User_Alias_Playlist_Track` (`Track`),
  CONSTRAINT `FK_User_Alias_Playlist_Playlist` FOREIGN KEY (`Playlist`) REFERENCES `Playlist` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_User_Alias_Playlist_Track` FOREIGN KEY (`Track`) REFERENCES `Track` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
