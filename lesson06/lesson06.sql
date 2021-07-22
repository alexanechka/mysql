/*
 * Урок 6.
*/

-- Модифицируем таблицу friends_requests

CREATE TABLE friend_requests_types
(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(128) UNIQUE NOT NULL
);

ALTER TABLE friend_requests DROP COLUMN accepted;

ALTER TABLE friend_requests ADD COLUMN request_type INT UNSIGNED NOT NULL;

ALTER TABLE friend_requests ADD CONSTRAINT fk_friends_types 
FOREIGN KEY (request_type) REFERENCES friend_requests_types (id);

ALTER TABLE friend_requests ADD COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP;

/*
 * Запрос 1. Выбираем основную информацию пользователя с id=1.
*/
use vk_lesson06;
-- Выбираем данные пользователя с id 1
-- РЕЗУЛЬТАТ
SELECT 
	first_name,
	last_name,
	(SELECT city FROM profiles WHERE user_id = users.id ) AS city,
	(SELECT file_name FROM media WHERE id = (SELECT photo_id FROM profiles WHERE user_id = users.id)) AS profile_photo
FROM users
WHERE id = 5;

-- 1 ) находим город
SELECT city FROM profiles WHERE user_id = 1;

-- 2) находим id фотографии профиля
SELECT photo_id FROM profiles WHERE user_id = 1;

-- 3) находим имя файла с id фотографии профиля
SELECT file_name FROM media WHERE id = 1;

-- 4) получаем имя файла по id пользователя
SELECT file_name FROM media WHERE id = (SELECT photo_id FROM profiles WHERE user_id = 1);

-- 5) Расписываем с идентификаторами (подставили подзапросы) и алиасами
SELECT 
	first_name, 
	last_name, 
	(SELECT city FROM profiles WHERE user_id = 1) AS city,
	(SELECT file_name FROM media WHERE id = 
	    (SELECT photo_id FROM profiles WHERE user_id = 1) 
	) AS profile_photo
FROM users 
WHERE id = 1;

/*
 * Задание 2. Поиск медиафайлов пользователя с id = 1.
*/

-- Ищем все картинки пользователя
SELECT file_name 
FROM media 
WHERE user_id = (SELECT id FROM users WHERE email = 'greenfelder.antwan@example.org') 
	AND media_types_id = (
							SELECT id FROM media_types WHERE name = 'image');

-- Ищем номер типа картинки
SELECT id FROM media_types WHERE name = 'image';

-- если не знаем id пользователя, но знаем email 'greenfelder.antwan@example.org'

SELECT id FROM users WHERE email = 'greenfelder.antwan@example.org';

-- если хотим вывести только *.png

SELECT * FROM media WHERE file_name LIKE '%.png';


SELECT file_name
FROM media
WHERE user_id = 1 AND file_name LIKE '%.png';

-- если хотим вывести только *.png и *.jpg

SELECT file_name
FROM media
WHERE user_id = 1 AND (file_name LIKE '%.png' OR file_name LIKE '%.jpg');


/*
 * Задание 3. Посчитаем количество медиафайлов каждого типа.
*/

-- количество всех файлов в таблице media
SELECT COUNT(*)
FROM media;

-- считаем количество медиафайлов по каждому типу
SELECT COUNT(*), media_types_id 
FROM media
GROUP BY media_types_id;


-- считаем суммарный размер медиафайлов по каждому типу
SELECT SUM(file_size), media_types_id
FROM media
GROUP BY media_types_id;

-- считаем количество медиафайлов по каждому типу с названиями типов
SELECT 
	COUNT(*), 
	(SELECT name FROM media_types WHERE id = media.media_types_id) AS name
FROM media
GROUP BY media_types_id;

/*
 * Задание 4. Посчитаем количество медиафайлов каждого типа для каждого пользователя.
*/

SELECT 
	COUNT(*), 
	(SELECT name FROM media_types WHERE id = media.media_types_id) AS name,
	user_id
FROM media
GROUP BY media_types_id, user_id
ORDER BY user_id;

/*
 * Задание 5. Выбираем друзей пользователя с id = 1.
*/

-- выбираем кому пользователь отправил заявки
SELECT to_user_id FROM friend_requests where from_user_id = 1;

-- выбираем кому пользователь отправил заявки, заявки приняты
SELECT to_user_id FROM friend_requests WHERE from_user_id = 1 AND request_type = 1;

-- выбираем от кого пользователю пришли заявки, заявки приняты
SELECT from_user_id FROM friend_requests WHERE to_user_id = 1 AND request_type = 1;

-- объединяем две группы, чтобы получить всех друзей

SELECT to_user_id FROM friend_requests WHERE from_user_id = 1 AND request_type = 1
UNION
SELECT from_user_id FROM friend_requests WHERE to_user_id = 1 AND request_type = 1;

-- еще один вариант без использования UNION
SELECT 
	DISTINCT IF(to_user_id = 1, from_user_id, to_user_id) AS friends
FROM friend_requests 
WHERE request_type = 1 AND (to_user_id = 1 OR from_user_id = 1);


/*
 * Задание 6. Выводим имя и фамилию друзей пользователя с id = 1
*/

SELECT CONCAT(first_name, ' ', last_name) AS name
FROM users
WHERE id IN (2,3,5,7,11); -- заглушка

SELECT CONCAT(first_name, ' ', last_name) AS name
FROM users
WHERE id IN (
	SELECT to_user_id FROM friend_requests WHERE from_user_id = 1 AND request_type = 1
		UNION
	SELECT from_user_id FROM friend_requests WHERE to_user_id = 1 AND request_type = 1);
	
-- если не знаем, что accepted тип 1

SELECT id FROM friend_requests_types WHERE name = 'accepted';

SELECT CONCAT(first_name, ' ', last_name) AS name
FROM users 
	WHERE id IN (
		SELECT to_user_id FROM friend_requests WHERE from_user_id = 1 AND request_type = 
				(SELECT id FROM friend_requests_types WHERE name = 'accepted')
			UNION
		SELECT from_user_id FROM friend_requests WHERE to_user_id = 1 AND request_type = 
				(SELECT id FROM friend_requests_types WHERE name = 'accepted')
	);
	
-- введем переменную для сохранения результата поиска айди типа дружбы accepted
SET @request_state_id := (SELECT id FROM friend_requests_types WHERE name = 'accepted');

SELECT @request_state_id;

-- использование переменной

SELECT CONCAT(first_name, ' ', last_name) AS name
FROM users 
	WHERE id IN (
		SELECT to_user_id FROM friend_requests WHERE from_user_id = 1 AND request_type = @request_state_id
			UNION
		SELECT from_user_id FROM friend_requests WHERE to_user_id = 1 AND request_type = @request_state_id
	);
	
/*
 * Задание 7. Выводим красиво информацию о друзьях. Выводим пол, возраст.
*/

-- красиво выводим пол
SELECT user_id, 
	CASE (gender)
		WHEN 'f' THEN 'female'
		WHEN 'm' THEN 'male'
		WHEN 'x' THEN 'not defined'
	END AS gender
FROM profiles;

-- выводим возраст
SELECT user_id, TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age
FROM profiles;

SELECT user_id, 
	CASE (gender)
		WHEN 'f' THEN 'female'
		WHEN 'm' THEN 'male'
		WHEN 'x' THEN 'not defined'
	END AS gender,
	TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age
FROM profiles 
WHERE user_id IN (
		SELECT to_user_id FROM friend_requests WHERE from_user_id = 1 AND request_type = 
				(SELECT id FROM friend_requests_types WHERE name = 'accepted')
			UNION
		SELECT from_user_id FROM friend_requests WHERE to_user_id = 1 AND request_type = 
				(SELECT id FROM friend_requests_types WHERE name = 'accepted')
	);
	
-- выводим имя, фамилию
SELECT CONCAT(first_name, ' ', last_name) AS name,
	(SELECT 
		CASE (gender)
			WHEN 'f' THEN 'female'
			WHEN 'm' THEN 'male'
			WHEN 'x' THEN 'not defined'
		END 
		FROM profiles WHERE user_id = users.id) AS gender,
		(SELECT TIMESTAMPDIFF(YEAR, birthday, NOW()) FROM profiles WHERE user_id = users.id) AS age
FROM users 
WHERE id IN (
		SELECT to_user_id FROM friend_requests WHERE from_user_id = 1 AND request_type = 
				(SELECT id FROM friend_requests_types WHERE name = 'accepted')
			UNION
		SELECT from_user_id FROM friend_requests WHERE to_user_id = 1 AND request_type = 
				(SELECT id FROM friend_requests_types WHERE name = 'accepted')
	);
	
/*
 * Задание 8. Выводим все непрочитанные сообщения пользователя с id = 1.
*/

-- выводим все сообщения пользователя, сортируем по дате
SELECT from_user_id, to_user_id, txt, is_delivered, created_at
FROM messages
WHERE from_user_id = 1 OR to_user_id = 1
ORDER BY created_at DESC;

-- выводим все непрочитанные сообщения из диалогов
SELECT from_user_id, to_user_id, txt, is_delivered, created_at
FROM messages
WHERE (from_user_id = 1 OR to_user_id = 1) AND is_delivered = FALSE
ORDER BY created_at DESC;

-- выводим сверху непрочитанные сообщения пользователя
SELECT from_user_id, to_user_id, txt, is_delivered, created_at
FROM messages
WHERE (from_user_id = 1 OR to_user_id = 1) AND is_delivered = FALSE
ORDER BY (from_user_id = 1) DESC, created_at DESC;


-- Лазарева 
SELECT * FROM users WHERE id = 5;

-- lesson06, task02
/*Пусть задан некоторый пользователь. 
Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.*/

SELECT 
	friend,
	MAX(messages) AS messages	
FROM
	(SELECT 
		COUNT(*) AS messages, 
		friend  
	FROM
		(SELECT to_user_id as friend, from_user_id as person FROM messages WHERE from_user_id = 5 
		UNION ALL
		SELECT from_user_id, to_user_id FROM messages WHERE to_user_id = 5) as friends
	GROUP BY friend) AS count_messages
;

-- lesson06, task03
/*Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.*/

-- checking
SELECT * FROM users as us
	LEFT JOIN 
    profiles as pr
    on pr.user_id = us.id
    ORDER BY pr.birthday DESC;

SELECT 
	COUNT(*) 
FROM
	(SELECT *,
	(SELECT user_id FROM posts WHERE id = posts_likes.post_id) as user_id_posts 
	FROM posts_likes 
		WHERE like_type = 1 
		AND user_id IN 
			(SELECT
				user_id
			FROM
				(SELECT *
				FROM profiles
				ORDER BY birthday DESC LIMIT 10) AS persons)) as likes;

-- lesson06, task04                              
/* Определить кто больше поставил лайков (всего) - мужчины или женщины? */

SELECT 
	CASE (gender)
		WHEN 'f' THEN 'female'
		WHEN 'm' THEN 'male'
	END as gender,
    MAX(likes) as likes
FROM (
	SELECT count(*) as likes,
		(SELECT gender FROM profiles where user_id = posts_likes.user_id) as gender
	FROM posts_likes
	WHERE like_type = 1
	GROUP BY gender) as likes
WHERE gender != 'x';

-- lesson06, task05 
/* Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.*/
/*INSERT INTO users (first_name, last_name, email, phone) value ('test', 'test', 'test@test.com', 89562356322) ;*/

SELECT 
	id,
	ifnull((SELECT  acts  FROM 
		(SELECT 
			user_id,
			count(*) AS acts
		FROM 
			(SELECT user_id FROM posts
			UNION ALL
			SELECT user_id FROM posts_likes
			UNION ALL
			SELECT from_user_id FROM messages
			UNION ALL
			SELECT from_user_id FROM friend_requests) as activity
		GROUP BY user_id) as activity_1
        WHERE user_id = users.id), 0) as acts
        FROM users
        ORDER BY acts LIMIT 10;   
   