USE lesson05_shop;

SHOW TABLES;

-- lesson05_1_task01
/* Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем*/

SELECT * FROM users;

SET sql_safe_updates = 0;

UPDATE users 
SET created_at = '0000-0-0', updated_at = '0000-0-0';

UPDATE users
set created_at = now(), updated_at = now();

-- lesson05_1_task02
/*Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR 
и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу 
DATETIME, сохранив введённые ранее значения.*/

ALTER TABLE users MODIFY COLUMN created_at VARCHAR(50);
ALTER TABLE users MODIFY COLUMN updated_at VARCHAR(50);

SHOW CREATE TABLE users;

UPDATE users 
SET created_at = '20.10.2017 8:10', updated_at = '20.10.2017 8:10';
  
ALTER TABLE users ADD COLUMN created_at_new DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users ADD COLUMN updated_at_new DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
UPDATE users 
SET created_at_new = STR_TO_DATE(created_at, '%d.%m.%Y %h:%i'), updated_at_new = STR_TO_DATE(updated_at, '%d.%m.%Y %h:%i');

ALTER TABLE users DROP COLUMN created_at;
ALTER TABLE users RENAME COLUMN created_at_new TO created_at;
ALTER TABLE users DROP COLUMN updated_at;
ALTER TABLE users RENAME COLUMN updated_at_new TO updated_at;

-- lesson05_1_task03
/*В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
0, если товар закончился, и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи 
таким образом, чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны 
выводиться в конце, после всех записей.*/

SELECT * FROM storehouses_products;
SELECT * FROM storehouses;

INSERT INTO storehouses (name) VALUE ('main');
INSERT INTO storehouses (name) VALUE ('reserve');

SELECT * FROM products;

INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES (1, 1, 100);
INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES (2, 1 , 0);
INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES (1, 2, 0);
INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES (2, 2, 0);
INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES (1, 3, 40);
INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES (2, 3, 5);
INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES (1, 4, 500);
INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES (2, 4, 1);
INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES (1, 5, 0);
INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES (2, 5, 30);
INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES (1, 6, 0);
INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES (2, 6, 0);
INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES (1, 7, 2500);
INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES (2, 7, 0);

SELECT pr.name, pr.description, bal.value_total 
FROM
	(SELECT product_id, value_total from (SELECT product_id, SUM(value) as value_total FROM storehouses_products
	GROUP BY product_id ORDER BY value_total) as balances where value_total >0
	UNION
	SELECT product_id, value_total from (SELECT product_id, SUM(value) as value_total FROM storehouses_products
	GROUP BY product_id ORDER BY value_total, product_id) as balances where value_total = 0) as bal 
LEFT JOIN
	products as pr
on pr.id = bal.product_id; 

-- lesson05_1_task04
/*(по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка 
английских названий (may, august)*/

SELECT 
	name, 
    birthday_at
FROM users 
WHERE 
	monthname(birthday_at) IN ('may', 'august');

-- lesson05_1_task05
/*(по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
Отсортируйте записи в порядке, заданном в списке IN.*/

SELECT * FROM catalogs 
WHERE id IN (5, 1, 2)
ORDER BY field(id, 5, 1, 2);

-- lesson05_2_task01
/*Подсчитайте средний возраст пользователей в таблице users.*/
SELECT 
	name, 
    birthday_at, 
    (
		(YEAR(CURRENT_DATE) - YEAR(birthday_at)) -                            
		(DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday_at, '%m%d')) 
	) AS age 
  FROM users as users_with_age;
 
 WITH user_with_age as (
	SELECT 
		name, 
		birthday_at, 
		(
			(YEAR(CURRENT_DATE) - YEAR(birthday_at)) -                            
			(DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday_at, '%m%d')) 
		) AS age 
	FROM users) 
SELECT 
	AVG(age) AS avg_age 
FROM user_with_age;

-- lesson05_2_task02
/*Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
Следует учесть, что необходимы дни недели текущего года, а не года рождения.*/
 
 WITH user_with_weekday AS
	(SELECT name, 
			birthday_at, 
			DAY(birthday_at) as day,
			MONTH(birthday_at) as month,
			YEAR(current_date()) as year,
			DAYOFWEEK(DATE_ADD(DATE_ADD(MAKEDATE(year(current_date()), 1), INTERVAL month(birthday_at) -1 MONTH), INTERVAL day(birthday_at) - 1 DAY)) as week_day 
	FROM users) 
SELECT 
	week_day, 
	COUNT(week_day) AS weekday_count 
FROM user_with_weekday 
GROUP BY week_day;

-- lesson05_2_task03
/*(по желанию) Подсчитайте произведение чисел в столбце таблицы.*/

SELECT exp(SUM(log(value))) AS product FROM storehouses_products WHERE value <> 0;
