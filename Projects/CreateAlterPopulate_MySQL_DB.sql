#the following was performed in MySQL Shell, then brought into MySQL Workbench to display

#first, we'll create a database
CREATE DATABASE rookerydb;

SHOW DATABASES;
#+--------------------+
#| Database           |
#+--------------------+
#| electronicsdb      |
#| flowerdb           |
#| information_schema |
#| landmarksdb        |
#| librarydb          |
#| mysampledb         |
#| mysql              |
#| performance_schema |
#| rookerydb          |
#| sakila             |
#| sys                |
#| univdb             |
#| world              |
#+--------------------+

#We'll populate the database with some tables

USE rookerydb;
#Database changed
CREATE TABLE Bird(bird_id INT AUTO_INCREMENT PRIMARY KEY,
    scientific_name VARCHAR(255) UNIQUE,
    common_name VARCHAR(255),
    family_sci_name VARCHAR(255),
    brief_description TEXT,
    bird_image BLOB);

ALTER TABLE Bird MODIFY COLUMN common_name VARCHAR(50);

DESCRIBE rookerydb.bird;
#+-------------------+--------------+------+-----+---------+----------------+
#| Field             | Type         | Null | Key | Default | Extra          |
#+-------------------+--------------+------+-----+---------+----------------+
#| bird_id           | int          | NO   | PRI | NULL    | auto_increment |
#| scientific_name   | varchar(255) | YES  | UNI | NULL    |                |
#| common_name       | varchar(50)  | YES  |     | NULL    |                |
#| family_sci_name   | varchar(255) | YES  |     | NULL    |                |
#| brief_description | text         | YES  |     | NULL    |                |
#| bird_image        | blob         | YES  |     | NULL    |                |
#+-------------------+--------------+------+-----+---------+----------------+

RENAME TABLE Bird TO bird_catelogue;

INSERT INTO bird_catelogue(common_name, scientific_name)
    VALUES('Purple finch', 'Haemorhous purpureus')
		  ('Dark-eyed junco', 'Junco hyemalis'),
		  ('Killdeer', 'Charadrius vociferus'),
          ('Northern saw-whet owl', 'Aegolius acadicus'),
		  ('Tree swallow', 'Tachycineta bicolor'),
		  ('Eastern bluebird', 'Sialia sialis'),
		  ('Mute swan', 'Cygnus olor');

SELECT * FROM bird_catelogue;
#+---------+----------------------+-----------------------+-----------------+-------------------+------------------------+
#| bird_id | scientific_name      | common_name           | family_sci_name | brief_description | bird_image             |
#+---------+----------------------+-----------------------+-----------------+-------------------+------------------------+
#|       1 | Haemorhous purpureus | Purple finch          | NULL            | NULL              | NULL                   |
#|       2 | Junco hyemalis       | Dark-eyed junco       | NULL            | NULL              | NULL                   |
#|       3 | Charadrius vociferus | Killdeer              | NULL            | NULL              | NULL                   |
#|       4 | Aegolius acadicus    | Northern saw-whet owl | NULL            | NULL              | NULL                   |
#|       5 | Tachycineta bicolor  | Tree swallow          | NULL            | NULL              | NULL                   |
#|       6 | Sialia sialis        | Eastern bluebird      | NULL            | NULL              | NULL                   |
#|       7 | Cygnus olor          | Mute swan             | NULL            | NULL              | NULL                   |
#+---------+----------------------+-----------------------+-----------------+-------------------+------------------------+

DELETE FROM bird_catelogue WHERE common_name LIKE '%-%';

SELECT * FROM bird_catelogue;
#+---------+----------------------+------------------+-----------------+-------------------+------------------------+
#| bird_id | scientific_name      | common_name      | family_sci_name | brief_description | bird_image             |
#+---------+----------------------+------------------+-----------------+-------------------+------------------------+
#|       1 | Haemorhous purpureus | Purple finch     | NULL            | NULL              | NULL                   |
#|       3 | Charadrius vociferus | Killdeer         | NULL            | NULL              | NULL                   |
#|       5 | Tachycineta bicolor  | Tree swallow     | NULL            | NULL              | NULL                   |
#|       6 | Sialia sialis        | Eastern bluebird | NULL            | NULL              | NULL                   |
#|       7 | Cygnus olor          | Mute swan        | NULL            | NULL              | NULL                   |
#+---------+----------------------+------------------+-----------------+-------------------+------------------------+

CREATE TABLE bird_family(family_id INT AUTO_INCREMENT PRIMARY KEY,
    scientific_name VARCHAR(255) UNIQUE,
    brief_description TEXT,
    order_sci_name VARCHAR(255));

DESCRIBE bird_family;
#+-------------------+--------------+------+-----+---------+----------------+
#| Field             | Type         | Null | Key | Default | Extra          |
#+-------------------+--------------+------+-----+---------+----------------+
#| family_id         | int          | NO   | PRI | NULL    | auto_increment |
#| scientific_name   | varchar(255) | YES  | UNI | NULL    |                |
#| brief_description | text         | YES  |     | NULL    |                |
#| order_sci_name    | varchar(255) | YES  |     | NULL    |                |
#+-------------------+--------------+------+-----+---------+----------------+

CREATE TABLE bird_order(order_id INT AUTO_INCREMENT PRIMARY KEY,
    scientific_name VARCHAR(255) UNIQUE,
    brief_description TEXT)
    DEFAULT CHARSET=UTF8MB4;

DESCRIBE bird_order;
#+-------------------+--------------+------+-----+---------+----------------+
#| Field             | Type         | Null | Key | Default | Extra          |
#+-------------------+--------------+------+-----+---------+----------------+
#| order_id          | int          | NO   | PRI | NULL    | auto_increment |
#| scientific_name   | varchar(255) | YES  | UNI | NULL    |                |
#| brief_description | text         | YES  |     | NULL    |                |
#+-------------------+--------------+------+-----+---------+----------------+

RENAME TABLE bird_catelogue TO bird;

#our database has three tables now, "Bird", "bird_order", and "bird_family"
#we'll alter the tables a bit, and connect them through foreign keys

ALTER TABLE bird ADD COLUMN last_seen_dt DATETIME AFTER brief_description;

ALTER TABLE bird ADD COLUMN body_id CHAR(2) AFTER last_seen_dt,
    ADD COLUMN nail_beak BOOLEAN DEFAULT 0 AFTER body_id,
    ADD COLUMN bird_status ENUM('Accidental','Breeding','Extinct'),
    CHANGE COLUMN common_name common_name VARCHAR(255);

describe bird;
#+-------------------+-----------------------------------------+------+-----+---------+----------------+
#| Field             | Type                                    | Null | Key | Default | Extra          |
#+-------------------+-----------------------------------------+------+-----+---------+----------------+
#| bird_id           | int                                     | NO   | PRI | NULL    | auto_increment |
#| scientific_name   | varchar(255)                            | YES  | UNI | NULL    |                |
#| common_name       | varchar(255)                            | YES  |     | NULL    |                |
#| family_sci_name   | varchar(255)                            | YES  |     | NULL    |                |
#| brief_description | text                                    | YES  |     | NULL    |                |
#| last_seen_dt      | datetime                                | YES  |     | NULL    |                |
#| body_id           | char(2)                                 | YES  |     | NULL    |                |
#| nail_beak         | tinyint(1)                              | YES  |     | 0       |                |
#| bird_image        | blob                                    | YES  |     | NULL    |                |
#| bird_status       | enum('Accidental','Breeding','Extinct') | YES  |     | NULL    |                |
#+-------------------+-----------------------------------------+------+-----+---------+----------------+

SELECT * FROM bird;
#+---------+----------------------+------------------+-----------------+-------------------+--------------+---------+-----------+------------------------+-------------+
#| bird_id | scientific_name      | common_name      | family_sci_name | brief_description | last_seen_dt | body_id | nail_beak | bird_image             | bird_status |
#+---------+----------------------+------------------+-----------------+-------------------+--------------+---------+-----------+------------------------+-------------+
#|       1 | Haemorhous purpureus | Purple finch     | NULL            | NULL              | NULL         | NULL    |         0 | NULL                   | NULL        |
#|       3 | Charadrius vociferus | Killdeer         | NULL            | NULL              | NULL         | NULL    |         0 | NULL                   | NULL        |
#|       5 | Tachycineta bicolor  | Tree swallow     | NULL            | NULL              | NULL         | NULL    |         0 | NULL                   | NULL        |
#|       6 | Sialia sialis        | Eastern bluebird | NULL            | NULL              | NULL         | NULL    |         0 | NULL                   | NULL        |
#|       7 | Cygnus olor          | Mute swan        | NULL            | NULL              | NULL         | NULL    |         0 | NULL                   | NULL        |
#+---------+----------------------+------------------+-----------------+-------------------+--------------+---------+-----------+------------------------+-------------+

UPDATE bird SET bird_status = 'Breeding' WHERE bird_id IN (1,2,4,5);

SELECT * FROM bird;
#+---------+----------------------+------------------+-----------------+-------------------+--------------+---------+-----------+------------------------+-------------+
#| bird_id | scientific_name      | common_name      | family_sci_name | brief_description | last_seen_dt | body_id | nail_beak | bird_image             | bird_status |
#+---------+----------------------+------------------+-----------------+-------------------+--------------+---------+-----------+------------------------+-------------+
#|       1 | Haemorhous purpureus | Purple finch     | NULL            | NULL              | NULL         | NULL    |         0 | NULL                   | Breeding    |
#|       3 | Charadrius vociferus | Killdeer         | NULL            | NULL              | NULL         | NULL    |         0 | NULL                   | NULL        |
#|       5 | Tachycineta bicolor  | Tree swallow     | NULL            | NULL              | NULL         | NULL    |         0 | NULL                   | Breeding    |
#|       6 | Sialia sialis        | Eastern bluebird | NULL            | NULL              | NULL         | NULL    |         0 | NULL                   | NULL        |
#|       7 | Cygnus olor          | Mute swan        | NULL            | NULL              | NULL         | NULL    |         0 | NULL                   | NULL        |
#+---------+----------------------+------------------+-----------------+-------------------+--------------+---------+-----------+------------------------+-------------+

ALTER TABLE bird MODIFY COLUMN bird_status ENUM('Accidental','Breeding','Extinct','Extirpated','Introduced');

SHOW COLUMNS FROM bird LIKE '%status';
#+-------------+-------------------------------------------------------------------+------+-----+---------+-------+
#| Field       | Type                                                              | Null | Key | Default | Extra |
#+-------------+-------------------------------------------------------------------+------+-----+---------+-------+
#| bird_status | enum('Accidental','Breeding','Extinct','Extirpated','Introduced') | YES  |     | NULL    |       |
#+-------------+-------------------------------------------------------------------+------+-----+---------+-------+

DESCRIBE bird;
#+-------------------+-------------------------------------------------------------------+------+-----+---------+----------------+
#| Field             | Type                                                              | Null | Key | Default | Extra          |
#+-------------------+-------------------------------------------------------------------+------+-----+---------+----------------+
#| bird_id           | int                                                               | NO   | PRI | NULL    | auto_increment |
#| scientific_name   | varchar(255)                                                      | YES  | UNI | NULL    |                |
#| common_name       | varchar(255)                                                      | YES  |     | NULL    |                |
#| family_sci_name   | varchar(255)                                                      | YES  |     | NULL    |                |
#| brief_description | text                                                              | YES  |     | NULL    |                |
#| last_seen_dt      | datetime                                                          | YES  |     | NULL    |                |
#| body_id           | char(2)                                                           | YES  |     | NULL    |                |
#| nail_beak         | tinyint(1)                                                        | YES  |     | 0       |                |
#| bird_image        | blob                                                              | YES  |     | NULL    |                |
#| bird_status       | enum('Accidental','Breeding','Extinct','Extirpated','Introduced') | YES  |     | NULL    |                |
#+-------------------+-------------------------------------------------------------------+------+-----+---------+----------------+

ALTER TABLE bird ALTER nail_beak DROP DEFAULT;

DESCRIBE bird;
#+-------------------+-------------------------------------------------------------------+------+-----+---------+----------------+
#| Field             | Type                                                              | Null | Key | Default | Extra          |
#+-------------------+-------------------------------------------------------------------+------+-----+---------+----------------+
#| bird_id           | int                                                               | NO   | PRI | NULL    | auto_increment |
#| scientific_name   | varchar(255)                                                      | YES  | UNI | NULL    |                |
#| common_name       | varchar(255)                                                      | YES  |     | NULL    |                |
#| family_sci_name   | varchar(255)                                                      | YES  |     | NULL    |                |
#| brief_description | text                                                              | YES  |     | NULL    |                |
#| last_seen_dt      | datetime                                                          | YES  |     | NULL    |                |
#| body_id           | char(2)                                                           | YES  |     | NULL    |                |
#| nail_beak         | tinyint(1)                                                        | YES  |     | NULL    |                |
#| bird_image        | blob                                                              | YES  |     | NULL    |                |
#| bird_status       | enum('Accidental','Breeding','Extinct','Extirpated','Introduced') | YES  |     | NULL    |                |
#+-------------------+-------------------------------------------------------------------+------+-----+---------+----------------+

INSERT INTO bird(common_name, bird_status)
    VALUES('Canada goose','Breeding');
    
#+---------+----------------------+------------------+-----------------+-------------------+--------------+---------+-----------+------------------------+-------------+
#| bird_id | scientific_name      | common_name      | family_sci_name | brief_description | last_seen_dt | body_id | nail_beak | bird_image             | bird_status |
#+---------+----------------------+------------------+-----------------+-------------------+--------------+---------+-----------+------------------------+-------------+
#|       1 | Haemorhous purpureus | Purple finch     | NULL            | NULL              | NULL         | NULL    |      NULL | NULL                   | Breeding    |
#|       3 | Charadrius vociferus | Killdeer         | NULL            | NULL              | NULL         | NULL    |      NULL | NULL                   | NULL        |
#|       5 | Tachycineta bicolor  | Tree swallow     | NULL            | NULL              | NULL         | NULL    |      NULL | NULL                   | Breeding    |
#|       6 | Sialia sialis        | Eastern bluebird | NULL            | NULL              | NULL         | NULL    |      NULL | NULL                   | NULL        |
#|       7 | Cygnus olor          | Mute swan        | NULL            | NULL              | NULL         | NULL    |      NULL | NULL                   | NULL        |
#|       8 | NULL                 | Canada goose     | NULL            | NULL              | NULL         | NULL    |      NULL | NULL                   | Breeding    |
#+---------+----------------------+------------------+-----------------+-------------------+--------------+---------+-----------+------------------------+-------------+

ALTER TABLE bird
    ADD CONSTRAINT fk_family_sci_name FOREIGN KEY(family_sci_name)
    REFERENCES bird_family(scientific_name);

SHOW CREATE TABLE bird;
#+-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
#| Table | Create Table                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
#+-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
#| bird  | CREATE TABLE `bird` (
#  `bird_id` int NOT NULL AUTO_INCREMENT,
#  `scientific_name` varchar(255) DEFAULT NULL,
#  `common_name` varchar(255) DEFAULT NULL,
#  `family_sci_name` varchar(255) DEFAULT NULL,
#  `brief_description` text,
#  `last_seen_dt` datetime DEFAULT NULL,
#  `body_id` char(2) DEFAULT NULL,
#  `nail_beak` tinyint(1) DEFAULT NULL,
#  `bird_image` blob,
#  `bird_status` enum('Accidental','Breeding','Extinct','Extirpated','Introduced') DEFAULT NULL,
#  PRIMARY KEY (`bird_id`),
#  UNIQUE KEY `scientific_name` (`scientific_name`),
#  KEY `fk_family_sci_name` (`family_sci_name`),
#  CONSTRAINT `fk_family_sci_name` FOREIGN KEY (`family_sci_name`) REFERENCES `bird_family` (`scientific_name`)
#) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
#+-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

DESCRIBE bird;
#+-------------------+-------------------------------------------------------------------+------+-----+---------+----------------+
#| Field             | Type                                                              | Null | Key | Default | Extra          |
#+-------------------+-------------------------------------------------------------------+------+-----+---------+----------------+
#| bird_id           | int                                                               | NO   | PRI | NULL    | auto_increment |
#| scientific_name   | varchar(255)                                                      | YES  | UNI | NULL    |                |
#| common_name       | varchar(255)                                                      | YES  |     | NULL    |                |
#| family_sci_name   | varchar(255)                                                      | YES  | MUL | NULL    |                |
#| brief_description | text                                                              | YES  |     | NULL    |                |
#| last_seen_dt      | datetime                                                          | YES  |     | NULL    |                |
#| body_id           | char(2)                                                           | YES  |     | NULL    |                |
#| nail_beak         | tinyint(1)                                                        | YES  |     | NULL    |                |
#| bird_image        | blob                                                              | YES  |     | NULL    |                |
#| bird_status       | enum('Accidental','Breeding','Extinct','Extirpated','Introduced') | YES  |     | NULL    |                |
#+-------------------+-------------------------------------------------------------------+------+-----+---------+----------------+

ALTER TABLE bird_family
    ADD CONSTRAINT fk_order_sci_name FOREIGN KEY (order_sci_name)
    REFERENCES bird_order(scientific_name);

DESCRIBE bird_family;
#+-------------------+--------------+------+-----+---------+----------------+
#| Field             | Type         | Null | Key | Default | Extra          |
#+-------------------+--------------+------+-----+---------+----------------+
#| family_id         | int          | NO   | PRI | NULL    | auto_increment |
#| scientific_name   | varchar(255) | YES  | UNI | NULL    |                |
#| brief_description | text         | YES  |     | NULL    |                |
#| order_sci_name    | varchar(255) | YES  | MUL | NULL    |                |
#+-------------------+--------------+------+-----+---------+----------------+

SHOW CREATE TABLE bird_family;
#+-------------+---------------------------------------------------------------------------------------------------+
#| Table       | Create Table                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
#+-------------+---------------------------------------------------------------------------------------------------+
#| bird_family | CREATE TABLE `bird_family` (
#  `family_id` int NOT NULL AUTO_INCREMENT,
#  `scientific_name` varchar(255) DEFAULT NULL,
#  `brief_description` text,
#  `order_sci_name` varchar(255) DEFAULT NULL,
#  PRIMARY KEY (`family_id`),
#  UNIQUE KEY `scientific_name` (`scientific_name`),
#  KEY `fk_order_sci_name` (`order_sci_name`),
#  CONSTRAINT `fk_order_sci_name` FOREIGN KEY (`order_sci_name`) REFERENCES `bird_order` (`scientific_name`)
#) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
#+-------------+---------------------------------------------------------------------------------------------------+