-- lesson08 “Транзакции, переменные, представления”

-- task01
/* В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.*/

-- подготовка
SELECT * FROM sample.users;
DELETE FROM sample.users WHERE id = 1;  
-- 

START TRANSACTION;

INSERT INTO sample.users 
SELECT id, name, birthday_at, created_at, updated_at FROM shop.users WHERE id = 1; 
DELETE FROM shop.users WHERE id = 1;

COMMIT;

-- task02
/* Создайте представление, которое выводит название name товарной позиции из таблицы products 
и соответствующее название каталога name из таблицы catalogs.*/

USE shop;
SELECT * FROM catalogs;
SELECT * FROM products;

CREATE VIEW products_info AS SELECT pr.id, pr.name, pr.description, pr.price, ct.name as catalog
FROM products as pr
LEFT JOIN catalogs as ct ON ct.id = catalog_id;
    
SELECT * FROM products_info;

-- task03
/* (по желанию) Пусть имеется таблица с календарным полем created_at. 
В ней размещены разряженые календарные записи за август 2018 года 
'2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
Составьте запрос, который выводит полный список дат за август, 
выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.*/

CREATE TABLE periods (n int not null primary key);

INSERT INTO periods
SELECT a.N + b.N * 10 + c.N * 100 + 1 n
  FROM 
 (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
,(SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
,(SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c
ORDER BY n;

SELECT '2018-08-01' + INTERVAL t.n - 1 DAY day
  FROM periods t
 WHERE t.n <= DATEDIFF(LAST_DAY('2018-08-31'), '2018-08-01') + 1;

CREATE TABLE dates_for_task (d DATETIME not null);
INSERT INTO dates_for_task values ('2018-08-01');
INSERT INTO dates_for_task values ('2016-08-04');
INSERT INTO dates_for_task values ('2018-08-16');
INSERT INTO dates_for_task values ('2018-08-17');

SELECT * FROM dates_for_task;
WITH all_dates AS (
SELECT '2018-08-01' + INTERVAL t.n - 1 DAY day
  FROM periods t  
 WHERE t.n <= DATEDIFF(LAST_DAY('2018-08-31'), '2018-08-01') + 1)
SELECT a.day, ifnull(d.d = a.day, 0) AS in_table
FROM all_dates a left join dates_for_task d
on a.day = d.d ;
 
-- task04
/* (по желанию) Пусть имеется любая таблица с календарным полем created_at. 
Создайте запрос, который удаляет устаревшие записи из таблицы, 
оставляя только 5 самых свежих записей.*/
CREATE TABLE somedata (
id SERIAL PRIMARY KEY,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO somedata VALUE ();

SELECT * FROM somedata;

select * FROM somedata where id not in ( 
SELECT * FROM somedata ORDER BY created_at DESC LIMIT 5);

SET SQL_SAFE_UPDATES = 0;

WITH actual_data AS
(SELECT * FROM somedata ORDER BY created_at DESC LIMIT 5)
DELETE FROM somedata s WHERE s.id NOT IN 
	(SELECT id FROM actual_data);

/*Практическое задание по теме “Администрирование MySQL” (эта тема изучается по вашему желанию)*/
-- task01
/*Создайте двух пользователей которые имеют доступ к базе данных shop. 
первому пользователю shop_read должны быть доступны только запросы на чтение данных, 
второму пользователю shop — любые операции в пределах базы данных shop.*/
CREATE USER 'shop_read'@'localhost' IDENTIFIED WITH sha256_password BY 'shop_read';

CREATE USER 'shop'@'localhost' IDENTIFIED WITH sha256_password BY 'shop';

GRANT SELECT, SHOW VIEW ON shop.* TO 'shop_read'@'localhost';

GRANT ALL ON shop.* TO 'shop'@'localhost';

-- task02
/*(по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password, 
содержащие первичный ключ, имя пользователя и его пароль. Создайте представление username 
таблицы accounts, предоставляющий доступ к столбца id и name. Создайте пользователя user_read, 
который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представления username.*/

/*Практическое задание по теме “Хранимые процедуры и функции, триггеры"*/

-- task01
/*Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать 
фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".*/

DROP FUNCTION IF EXISTS hello;

DELIMITER //
CREATE FUNCTION hello ()
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	SET @now_time = HOUR(NOW());
    
    RETURN
		CASE 
		WHEN @now_time < 6
			THEN 'Доброй ночи'
        WHEN @now_time < 12
			THEN 'Доброе утро'
        WHEN @now_time < 18
			THEN 'Добрый день'
        ELSE 
			'Добрый вечер'
		END;
    
END//
DELIMITER ;

SELECT hour(now());
SELECT hour('2021-10-10 14:00');
 
 SELECT hello();

-- task02
/*В таблице products есть два текстовых поля: name с названием товара и description с 
его описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля 
принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы 
одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение 
необходимо отменить операцию.*/
DROP TRIGGER IF EXISTS check_names;

DELIMITER //
CREATE TRIGGER check_names BEFORE INSERT ON shop.products
FOR EACH ROW
	BEGIN
		IF NEW.name IS NULL AND NEW.description IS NULL THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insert Canceled. Name or Description must be set!';
		END IF;
	END //

DELIMITER ;

INSERT INTO shop.products values ();
SELECT * FROM shop.products;
INSERT INTO shop.products VALUES (12, null, 'sfdsfsdf', 0, 1, now(), now());
INSERT INTO shop.products values (13, NULL, NULL, 0, 1, now(), now());
INSERT INTO shop.products values (14, 'fgdfgdfg', NULL, 0, 1, now(), now());


-- task03
/*(по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи.
Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
Вызов функции FIBONACCI(10) должен возвращать число 55.*/
select concat(group_concat(f separator ', '), ', ...')
from (select @f := @i + @j as f, @i := @j, @j := @f
        from information_schema.tables, (select @i := 1, @j := 0) sel1
       limit 16) t;
  
DROP FUNCTION IF EXISTS count_fib;

DELIMITER //
CREATE FUNCTION count_fib(number BIGINT UNSIGNED)
RETURNS FLOAT READS SQL DATA
BEGIN
	SET @i = 1;
    SET @j = 0;
    SET @k = 1;
	WHILE @i <= number-1 DO
		SET @result := @j + @k;
            SET @j = @k;
            SET @k = @result;		
			
			SET @i = @i + 1;
        END WHILE;
        
	RETURN @result;
END//
DELIMITER ;

SELECT count_fib(10);
SELECT count_fib(11);