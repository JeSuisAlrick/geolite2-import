/* ============== INITIAL IMPORT ============== */

DROP TABLE IF EXISTS `gc_city`;
CREATE TABLE `gc_city` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
	`geoname_id` INT(11) NOT NULL,
	`locale_code` CHAR(2) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
	`continent_code` CHAR(2) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
	`continent_name` CHAR(35) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
	`country_iso_code` CHAR(3) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
	`country_name` CHAR(80) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
	`subdivision_1_iso_code` CHAR(10) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
	`subdivision_1_name` VARCHAR(80) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
	`subdivision_2_iso_code` CHAR(10) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
	`subdivision_2_name` VARCHAR(80) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
	`city_name` CHAR(80) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
	`metro_code` CHAR(10) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
	`time_zone` CHAR(35) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
    
	PRIMARY KEY (`id`),
    KEY `gc_city-geoname_id` (`geoname_id`),
	KEY `gc_city-country_iso_code` (`country_iso_code`),
	KEY `gc_city-subdivision_1_iso_code` (`subdivision_1_iso_code`)
)  ENGINE=INNODB AUTO_INCREMENT=4080 DEFAULT CHARSET=UTF8 COLLATE = UTF8_UNICODE_CI;

LOAD DATA INFILE '/tmp/GeoLite2-City-Locations-en.csv' INTO TABLE `gc_city` FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES (
	`geoname_id`,
	`locale_code`,
	`continent_code`,
	`continent_name`,
	`country_iso_code`,
	`country_name`,
	`subdivision_1_iso_code`,
	`subdivision_1_name`,
	`subdivision_2_iso_code`,
	`subdivision_2_name`,
	`city_name`,
	`metro_code`,
	`time_zone`
);

/* ============== CONTINENT ============== */

DROP TABLE IF EXISTS `gc_continent`;
CREATE TABLE `gc_continent` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `continent_code` CHAR(2) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
    `continent_name` CHAR(35) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
    
    PRIMARY KEY (`id`),
    KEY `gc_continent-continent_code` (`continent_code`)
)  ENGINE=INNODB AUTO_INCREMENT=4080 DEFAULT CHARSET=UTF8 COLLATE = UTF8_UNICODE_CI;

INSERT INTO `gc_continent` 
	(
		`continent_code`, 
		`continent_name`
    ) 
SELECT DISTINCT
    `gc_city`.`continent_code`,
    `gc_city`.`continent_name`
FROM `gotham_casting_website`.`gc_city`;


/* ============== COUNTRY ============== */

DROP TABLE IF EXISTS `gc_country`;
CREATE TABLE `gc_country` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `country_iso_code` CHAR(3) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
    `country_name` CHAR(80) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
    `continent_code` CHAR(2) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
    
    PRIMARY KEY (`id`),
    KEY `gc_country-country_iso_code` (`country_iso_code`),
    KEY `gc_country-continent_code` (`continent_code`)
)  ENGINE=INNODB AUTO_INCREMENT=4080 DEFAULT CHARSET=UTF8 COLLATE = UTF8_UNICODE_CI;

INSERT INTO `gc_country` 
	(
		`continent_code`, 
		`country_iso_code`, 
		`country_name`
    ) 
SELECT DISTINCT
    `gc_city`.`continent_code`,
    `gc_city`.`country_iso_code`,
    `gc_city`.`country_name`
FROM `gotham_casting_website`.`gc_city`
WHERE (`gc_city`.`country_iso_code` != '');


/* ============== SUBDIVISIONS 1 ============== */

DROP TABLE IF EXISTS `gc_subdivision1`;
CREATE TABLE `gc_subdivision1` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `subdivision_1_iso_code` CHAR(10) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
    `subdivision_1_name` VARCHAR(80) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
    `country_iso_code` CHAR(3) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
    
    PRIMARY KEY (`id`),
    KEY `gc_subdivision1-subdivision_1_iso_code` (`subdivision_1_iso_code`),
    KEY `gc_subdivision1-country_iso_code` (`country_iso_code`)
)  ENGINE=INNODB AUTO_INCREMENT=4080 DEFAULT CHARSET=UTF8 COLLATE = UTF8_UNICODE_CI;

INSERT INTO `gc_subdivision1` 
	(
		`country_iso_code`,
		`subdivision_1_iso_code`,
		`subdivision_1_name`
    ) 
SELECT DISTINCT
    `gc_city`.`country_iso_code`,
    `gc_city`.`subdivision_1_iso_code`,
    `gc_city`.`subdivision_1_name`
FROM `gotham_casting_website`.`gc_city`
WHERE (`gc_city`.`subdivision_1_iso_code` != '');


/* ============== SUBDIVISIONS 2 ============== */

DROP TABLE IF EXISTS `gc_subdivision2`;
CREATE TABLE `gc_subdivision2` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `subdivision_2_iso_code` CHAR(10) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
    `subdivision_2_name` VARCHAR(80) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
    `subdivision_1_iso_code` CHAR(10) COLLATE UTF8_UNICODE_CI NOT NULL DEFAULT '',
    
    PRIMARY KEY (`id`),
    KEY `gc_subdivision2-subdivision_2_iso_code` (`subdivision_2_iso_code`),
    KEY `gc_subdivision2-subdivision_1_iso_code` (`subdivision_1_iso_code`)
)  ENGINE=INNODB AUTO_INCREMENT=4080 DEFAULT CHARSET=UTF8 COLLATE = UTF8_UNICODE_CI;

INSERT INTO `gc_subdivision2` 
	(
		`subdivision_1_iso_code`,
		`subdivision_2_iso_code`,
		`subdivision_2_name`
    ) 
SELECT DISTINCT
    `gc_city`.`subdivision_1_iso_code`,
    `gc_city`.`subdivision_2_iso_code`,
    `gc_city`.`subdivision_2_name`
FROM `gotham_casting_website`.`gc_city`
WHERE (`gc_city`.`subdivision_2_iso_code` != '');


/* ============== Remove certain columns ============== */

ALTER TABLE `gotham_casting_website`.`gc_city` 
	DROP COLUMN `subdivision_2_name`,
	DROP COLUMN `subdivision_1_name`,
	DROP COLUMN `country_name`,
	DROP COLUMN `continent_name`,
	DROP COLUMN `continent_code`,
	DROP COLUMN `locale_code`;

DELETE FROM `gotham_casting_website`.`gc_city`
WHERE `city_name` = '';