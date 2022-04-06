DROP TABLE IF EXISTS `airports`;

CREATE TABLE `airports` (
  `code` varchar(15) NOT NULL,
  `lat` decimal(12,4) DEFAULT NULL,
  `lon` decimal(12,4) DEFAULT NULL,
  `name` varchar(1023) DEFAULT NULL,
  `city` varchar(1023) DEFAULT NULL,
  `state` varchar(1023) DEFAULT NULL,
  `country` varchar(1023) DEFAULT NULL,
  `created` timestamp DEFAULT now(),
  `updated` timestamp DEFAULT now(),
  PRIMARY KEY (`code`)
);

DROP TABLE IF EXISTS `airports_journal`;

CREATE TABLE `airports_journal` (
  `journal_id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(15) DEFAULT NULL,
  `action_type` enum('create','update','delete') DEFAULT NULL,
  `action_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`journal_id`)
);

DELIMITER ;;
CREATE TRIGGER `airports_after_insert` AFTER INSERT ON `airports` FOR EACH ROW INSERT INTO airports.airports_journal
	SET
		action_type = 'create',
		code = NEW.code,
		action_time = now();;
DELIMITER ;

DELIMITER ;;
CREATE TRIGGER `airports_after_update` AFTER UPDATE ON `airports` FOR EACH ROW IF NEW.code = OLD.code THEN
		INSERT INTO airports.airports_journal
		SET action_type = 'update',
			code = OLD.code,
			action_time = now();
	ELSE
		-- Set old one as deleted
		INSERT INTO airports.airports_journal
		SET action_type = 'delete',
			code = OLD.code,
			action_time = now();
		-- AND NEW one created
		INSERT INTO airports.airports_journal
		SET action_type = 'create',
			code = NEW.code,
			action_time = now();
	END IF;;
DELIMITER ;
DELIMITER ;;
CREATE TRIGGER `airports_after_delete` AFTER DELETE ON `airports` FOR EACH ROW INSERT INTO airports.airports_journal
	SET action_type = 'delete',
		code = OLD.code,
		action_time = now();;
DELIMITER ;