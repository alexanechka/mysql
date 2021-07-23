USE lesson05_shop;

-- lesson07_task01
/*Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.*/
SELECT * FROM orders_products;
SELECT * FROM orders;
SELECT * FROM users;

INSERT INTO orders (user_id) VALUES (6);

SELECT DISTINCT us.name AS order_id 
FROM orders AS ord
LEFT JOIN users AS us
ON us.id = ord.user_id;

-- lesson07_task02
/*Выведите список товаров products и разделов catalogs, который соответствует товару.*/
SELECT * FROM products;
SELECT * FROM catalogs;

SELECT cat.name, pr.name, pr.price
FROM products AS pr
LEFT JOIN catalogs AS cat
ON pr.catalog_id = cat.id;

-- lesson07_task03
/*(по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
Поля from, to и label содержат английские названия городов, поле name — русское. 
Выведите список рейсов flights с русскими названиями городов.*/
CREATE DATABASE lesson07_flights;

USE lesson07_flights;

CREATE TABLE cities (
  label VARCHAR(50) NOT NULL,
  name VARCHAR(255) NOT NULL,
  PRIMARY KEY (label),
  UNIQUE KEY label (label)
) ENGINE=InnoDB;

INSERT INTO cities VALUES ('moscow', 'Москва');
INSERT INTO cities VALUES ('irkutsk', 'Иркутск');
INSERT INTO cities VALUES ('kazan', 'Казань');
INSERT INTO cities VALUES ('novgorod', 'Новгород');
INSERT INTO cities VALUES ('omsk', 'Омск');

CREATE TABLE flights (
  id bigint unsigned NOT NULL AUTO_INCREMENT,
  from_city VARCHAR(50) NOT NULL,
  to_city VARCHAR(50) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (from_city) REFERENCES cities(label) ,
  FOREIGN KEY (to_city) REFERENCES cities(label) 
) ENGINE=InnoDB;

INSERT INTO flights (from_city, to_city) VALUES ('moscow', 'irkutsk');
INSERT INTO flights (from_city, to_city) VALUES ('irkutsk', 'moscow');
INSERT INTO flights (from_city, to_city) VALUES ('kazan', 'irkutsk');
INSERT INTO flights (from_city, to_city) VALUES ('novgorod', 'omsk');
INSERT INTO flights (from_city, to_city) VALUES ('omsk', 'novgorod');

SELECT * FROM flights;

SELECT fl.id as flight_id, ci_fr.name as from_city, ci_to.name as to_city
FROM flights as fl 
LEFT JOIN cities as ci_fr ON fl.from_city = ci_fr.label
LEFT JOIN cities as ci_to ON fl.to_city = ci_to.label
