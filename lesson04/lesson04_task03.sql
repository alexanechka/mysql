USE vk_lesson04;

UPDATE media_types
SET name = 'image' 
WHERE id = 1;

UPDATE media_types
SET name = 'audio' 
WHERE id = 2;

UPDATE media_types
SET name = 'video' 
WHERE id = 3;

UPDATE media_types
SET name = 'document' 
WHERE id = 4;

SELECT * FROM media_types;

INSERT friend_requests VALUES (16, 16, 0);
INSERT friend_requests VALUES (15, 15, 0);
INSERT friend_requests VALUES (25, 25, 0);

SELECT * FROM friend_requests WHERE from_user_id = to_user_id;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM friend_requests WHERE from_user_id = to_user_id;

SELECT * FROM friend_requests WHERE from_user_id = to_user_id;


