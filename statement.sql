-- 创建数据库
create database ten_million_test;

-- 指定长度，创建随机字符串
DELIMITER ;
DROP FUNCTION IF EXISTS ten_million_test.rand_string;
DELIMITER $$
CREATE FUNCTION ten_million_test.rand_string(n INT)
RETURNS VARCHAR(255)
BEGIN
DECLARE chars_str VARCHAR(100) DEFAULT 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
DECLARE return_str VARCHAR(255) DEFAULT '';
DECLARE i INT DEFAULT 0;
WHILE i < n DO
      SET return_str = concat(return_str, substring(chars_str, FLOOR(1 + RAND() * 80), 1));
      SET i = i + 1;
END WHILE;
RETURN return_str;
END $$

-- 创建随机日期
DELIMITER ;
DROP FUNCTION IF EXISTS ten_million_test.rand_date;
DELIMITER $$
CREATE FUNCTION ten_million_test.rand_date()
  RETURNS VARCHAR(255)
  BEGIN
    DECLARE nDate CHAR(10) DEFAULT '';
    SET nDate = CONCAT(2010 + FLOOR((RAND() * 8)), '-', LPAD(FLOOR(1 + (RAND() * 12)), 2, 0), '-',
                       LPAD(FLOOR(3 + (RAND() * 8)), 2, 0));
    RETURN nDate;
  END $$

-- 创建随机日期时间
DELIMITER ;
DROP FUNCTION IF EXISTS ten_million_test.rand_datetime;
DELIMITER $$
CREATE FUNCTION ten_million_test.rand_datetime()
  RETURNS VARCHAR(255)
  BEGIN
    DECLARE nDateTime CHAR(19) DEFAULT '';
    SET nDateTime = CONCAT(CONCAT(2010 + FLOOR((RAND() * 8)), '-', LPAD(FLOOR(1 + (RAND() * 12)), 2, 0), '-',
                                  LPAD(FLOOR(3 + (RAND() * 8)), 2, 0)),
                           ' ',
                           CONCAT(LPAD(FLOOR(0 + (RAND() * 23)), 2, 0), ':', LPAD(FLOOR(0 + (RAND() * 60)), 2, 0), ':',
                                  LPAD(FLOOR(0 + (RAND() * 60)), 2, 0))
    );
    RETURN nDateTime;
  END $$

-- 创建随机性别
DELIMITER ;
DROP FUNCTION IF EXISTS ten_million_test.rand_gender;
DELIMITER $$
CREATE FUNCTION ten_million_test.rand_gender()
RETURNS VARCHAR(255)
BEGIN
DECLARE chars_str VARCHAR(100) DEFAULT '男女它';
RETURN substring(chars_str, FLOOR(1 + RAND() * 3), 1);
END $$

-- 创建用户表
DELIMITER ;
CREATE TABLE IF NOT EXISTS ten_million_test.users(
`user_id` INT PRIMARY KEY auto_increment,
`username` VARCHAR(20) not null,
`email` VARCHAR(100) not null,
`gender` CHAR(1) not null,
`created_at` TIMESTAMP not null,
`age` TINYINT not null
);

-- 创建插入用户表的存储过程，可执行插入的条数
-- 执行存储过程插入；插入1000条： call ten_million_test.insert_large_user(1000);
DROP PROCEDURE ten_million_test.insert_large_user;
DELIMITER $$
CREATE PROCEDURE ten_million_test.insert_large_user(num INT)
  BEGIN
    DECLARE sNum INT;
    SET sNum = 1;
    WHILE sNum <= num DO
      INSERT INTO ten_million_test.users(username, email, gender, created_at, age)
      VALUES (ten_million_test.rand_string(10), concat(ten_million_test.rand_string(7), '@qq.com'), ten_million_test.rand_gender(),
              ten_million_test.rand_datetime(), ROUND(RAND() * 100));
      SET sNum = sNum + 1;
    END WHILE;
END $$
