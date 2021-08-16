-- Электронный документооборот

-- База предназначена для создания и подписания кадровых документов
-- предусмотрена интеграция с 1С ЗУП, для этого добавлены идентификаторы для таблиц id_1C
-- в базе реализована работа с отпусками: можно узнать количество дней отпуска сотрудника на дату
-- и добавить новое заявление на отпуск 

DROP DATABASE IF EXISTS hr_base;
CREATE DATABASE hr_base;
USE hr_base;

-- Организации
DROP TABLE IF EXISTS organizations;
CREATE TABLE organizations(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(145) NOT NULL,
	official_name VARCHAR(145) NOT NULL,
    prefix CHAR(2),
    id_1C VARCHAR(4) UNIQUE,
    parent_id INT UNSIGNED, 
	FOREIGN KEY (parent_id) REFERENCES organizations(id) ON DELETE RESTRICT
    );
    
INSERT INTO organizations VALUES (1, 'Головная организация','ООО "Головная организация"', 'GO', '0001', NULL);    
INSERT INTO organizations VALUES (2, 'Филиал 1','ООО "Филиал 1"', 'FO', '0002', 1);   
INSERT INTO organizations VALUES (3, 'Филиал 2','ООО "Филиал 2"', 'FT','0003', 1);   
INSERT INTO organizations VALUES (4, 'Филиал 3','ООО "Филиал 3"', 'FR','0004', 1);   
INSERT INTO organizations VALUES (5, 'Филиал 4','ООО "Филиал 4"', 'FF','0005', 1);    
    
SELECT * FROM organizations;

-- Должности
DROP TABLE IF EXISTS positions;
CREATE TABLE positions(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(145) NOT NULL,
    id_1C VARCHAR(11) UNIQUE
	);

INSERT INTO positions VALUES (1, 'Генеральный директор', '00000000001');
INSERT INTO positions VALUES (2, 'IT директор', '00000000002');
INSERT INTO positions VALUES (3, 'Главный бухгалтер', '00000000003');
INSERT INTO positions VALUES (4, 'Бухгалтер', '00000000004');
INSERT INTO positions VALUES (5, 'Системный администратор', '00000000005');
INSERT INTO positions VALUES (6, 'Программист', '00000000006');
INSERT INTO positions VALUES (7, 'Операционист', '00000000007');
INSERT INTO positions VALUES (8, 'Рукодитель HR', '00000000008');
INSERT INTO positions VALUES (9, 'Специалист', '00000000009');
INSERT INTO positions VALUES (10, 'Менеджер по продажам', '00000000010');
INSERT INTO positions VALUES (11, 'Секретарь', '00000000011');
INSERT INTO positions VALUES (12, 'Экономист', '00000000012');
INSERT INTO positions VALUES (13, 'Коммерческий директор', '00000000013');
INSERT INTO positions VALUES (14, 'Заместитель Генерального директора', '00000000014');

SELECT * FROM positions;

-- Подразделения
DROP TABLE IF EXISTS departments;
CREATE TABLE departments(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(145) NOT NULL,
    id_1C VARCHAR(11) UNIQUE,
    parent_id INT UNSIGNED,
    organization_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (parent_id) REFERENCES departments(id), -- ON DELETE RESTRICT,
    FOREIGN KEY (organization_id) REFERENCES organizations(id)-- ON DELETE RESTRICT,
    );
 
INSERT INTO departments VALUES (1, 'Администрация', '00000000001', NULL, 1);
INSERT INTO departments VALUES (2, 'Бухгалтерия', '00000000002', NULL, 1);
INSERT INTO departments VALUES (3, 'Департамент продаж', '00000000003', NULL, 1);
INSERT INTO departments VALUES (4, 'IT департамент', '00000000004', NULL, 1);
INSERT INTO departments VALUES (5, 'Отдел продаж', '00000000005', 3, 1);
INSERT INTO departments VALUES (6, 'Отдел кадров', '00000000006', 1, 1);
INSERT INTO departments VALUES (7, 'Отдел продаж', '00000000007', NULL, 2);
INSERT INTO departments VALUES (8, 'Отдел продаж', '00000000008', NULL, 3);
INSERT INTO departments VALUES (9, 'Отдел продаж', '00000000009', NULL, 4);
INSERT INTO departments VALUES (10, 'Отдел продаж', '00000000010', NULL, 5);
INSERT INTO departments VALUES (11, 'Экономический отдел', '00000000011', NULL, 1);

SELECT * FROM departments;

-- Физические лица
DROP TABLE IF EXISTS persons;
CREATE TABLE persons(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(145) NOT NULL,
	last_name VARCHAR(145) NOT NULL,
    birthday DATE NOT NULL,
    id_1C VARCHAR(11) UNIQUE,
	email VARCHAR(145) NOT NULL UNIQUE,
	phone CHAR(11) NOT NULL UNIQUE,
    INDEX(id)
);

INSERT INTO persons VALUES (1, 'Иван', 'Иванов', '2000-10-12', '00000000001', 'ivan.ivanov@organization.ru', '79215424455');
INSERT INTO persons VALUES (2, 'Петр', 'Петров', '1982-10-22', '00000000002', 'petr.petrov@organization.ru', '79095621555');
INSERT INTO persons VALUES (3, 'Иван', 'Васильев', '1999-05-13', '00000000003', 'ivan.vasiliev@organization.ru', '79185624562');
INSERT INTO persons VALUES (4, 'Анна', 'Петрова', '1977-01-31', '00000000004', 'anna.petrova@organization.ru', '79164524565');
INSERT INTO persons VALUES (5, 'Анна', 'Сидорова', '1981-03-16', '00000000005', 'anna.sidorova@organization.ru', '79456238989');
INSERT INTO persons VALUES (6, 'Елена', 'Викторова', '1986-05-12', '00000000006', 'elena.viktorova@organization.ru', '79295634555');
INSERT INTO persons VALUES (7, 'Сергей', 'Толстой', '1987-09-11', '00000000007', 'sergey.tolstoy@organization.ru', '79315697845');
INSERT INTO persons VALUES (8, 'Лев', 'Кузнецов', '1988-06-29', '00000000008', 'lev.kuznetsov@organization.ru', '79456721595');
INSERT INTO persons VALUES (9, 'Виктор', 'Максимов', '1989-02-28', '00000000009', 'viktor.maximov@organization.ru', '79232951545');
INSERT INTO persons VALUES (10, 'Олеся', 'Овчаренко', '1999-10-31', '00000000010', 'olesya.ovacharenko@organization.ru', '79912541645');
INSERT INTO persons VALUES (11, 'Елена', 'Кузнецова', '1997-06-06', '00000000011', 'elena.kuznetsova@organization.ru', '79285786759');
INSERT INTO persons VALUES (12, 'Алина', 'Бархударян', '1996-01-13', '00000000012', 'alina.barhudaryan@organization.ru', '79164589797');
INSERT INTO persons VALUES (13, 'Алан', 'Алиев', '1988-12-11', '00000000013', 'alan.aliev@organization.ru', '79542445521');
INSERT INTO persons VALUES (14, 'Марина', 'Овчаренко', '1965-07-07', '00000000014', 'marina.ovcharenko@organization.ru', '79564562323');
INSERT INTO persons VALUES (15, 'Лариса', 'Трубина', '1986-11-01', '00000000015', 'larisa.trubina@organization.ru', '79364567898');
INSERT INTO persons VALUES (16, 'Павел', 'Коваленко', '1984-10-15', '00000000016', 'pavel.kovalenko@organization.ru', '79845627878');
INSERT INTO persons VALUES (17, 'Сергей', 'Ласточкин', '1986-04-03', '00000000017', 'sergey.lastochkin@organization.ru', '79251244575');
INSERT INTO persons VALUES (18, 'Кирилл', 'Васечкин', '1965-06-05', '00000000018', 'kirill.vasechkin@organization.ru', '7954659895');
INSERT INTO persons VALUES (19, 'Никита', 'Сергеев', '1988-05-10', '00000000019', 'nikita.sergeev@organization.ru', '79442251545');
INSERT INTO persons VALUES (20, 'Антон', 'Александров', '2001-05-12', '00000000020', 'anton.alexandrov@organization.ru', '79015956255');
INSERT INTO persons VALUES (21, 'Ирина', 'Васильева', '1992-01-22', '00000000021', 'irina.vasilieva@organization.ru', '79543342995');
INSERT INTO persons VALUES (22, 'Владимир', 'Антонов', '1977-04-16', '00000000022', 'vladimir.antonov@organization.ru', '79395721535');
INSERT INTO persons VALUES (23, 'Александр', 'Евгеньев', '1987-03-15', '00000000023', 'alexander.evgeniev@organization.ru', '79335424775');
INSERT INTO persons VALUES (24, 'Григорий', 'Зайцев', '1980-04-30', '00000000024', 'grigory.zaitsev@organization.ru', '79335621875');
INSERT INTO persons VALUES (25, 'Екатерина', 'Власова', '1995-05-11', '00000000025', 'ekaterina.vlasova@organization.ru', '79515422433');
INSERT INTO persons VALUES (26, 'Елизавета', 'Александрова', '1993-08-19', '00000000026', 'elizaveta.alexandrova@organization.ru', '79956021550');
INSERT INTO persons VALUES (27, 'Нина', 'Иванова', '1999-07-31', '00000000027', 'nina.ivanova@organization.ru', '79298724325');
INSERT INTO persons VALUES (28, 'Татьяна', 'Петрова', '1986-02-03', '00000000028', 'tatyana.petrova@organization.ru', '79985661212');
INSERT INTO persons VALUES (29, 'Милана', 'Викторова', '1982-07-03', '00000000029', 'milana.viktorova@organization.ru', '79421455425');
INSERT INTO persons VALUES (30, 'Алексей', 'Оводов', '1986-02-28', '00000000030', 'alexey.ovodov@organization.ru', '79658987878');
INSERT INTO persons VALUES (31, 'Владимир', 'Семенов', '1984-01-14', '00000000031', 'vladimir.semenov@organization.ru', '79986789325');

-- Сотрудники
DROP TABLE IF EXISTS employees;
CREATE TABLE employees(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_1C VARCHAR(11) UNIQUE,
    person_id INT UNSIGNED NOT NULL,
    organization_id INT UNSIGNED NOT NULL,
    department_id INT UNSIGNED NOT NULL,
    position_id INT UNSIGNED NOT NULL,
    date_in DATE NOT NULL,
    date_out DATE,
    is_working BOOLEAN NOT NULL,
    INDEX(id),
    INDEX(person_id),
    FOREIGN KEY (department_id) REFERENCES departments(id),
    FOREIGN KEY (organization_id) REFERENCES organizations(id),
    FOREIGN KEY (person_id) REFERENCES persons(id),  -- ON DELETE RESTRICT,
    FOREIGN KEY (position_id) REFERENCES positions(id)
);

INSERT INTO employees VALUES (1, 'GO000000010', 22, 1, 1, 1, '2012-03-01', NULL, 1); -- ген дир
INSERT INTO employees VALUES (2, 'GO000000002', 14, 1, 2, 3, '2010-05-15', NULL, 1); -- глав бух
INSERT INTO employees VALUES (3, 'GO000000012', 30, 1, 4, 6, '2012-03-20', NULL, 1); -- программист
INSERT INTO employees VALUES (4, 'GO000000013', 19, 1, 4, 6, '2012-03-21', NULL, 1); -- программист
INSERT INTO employees VALUES (5, 'GO000000051', 5, 1, 3, 10, '2012-12-01', NULL, 1); -- сейлз
INSERT INTO employees VALUES (6, 'GO000000052', 13, 1, 5, 10, '2012-12-01', NULL, 1); -- сейлз
INSERT INTO employees VALUES (7, 'GO000000053', 8, 1, 5, 10, '2012-12-01', NULL, 1); -- сейлз
INSERT INTO employees VALUES (8, 'GO000000054', 7, 1, 3, 10, '2012-12-03', NULL, 1); -- сейлз
INSERT INTO employees VALUES (9, 'GO000000055', 6, 1, 3, 10, '2012-12-03', NULL, 1); -- сейлз
INSERT INTO employees VALUES (10, 'FO000000003', 28, 2, 7, 10, '2013-02-05', NULL, 1); -- сейлз
INSERT INTO employees VALUES (11, 'FO000000004', 29, 2, 7, 10, '2013-02-05', NULL, 1); -- сейлз
INSERT INTO employees VALUES (12, 'GO000000060', 24, 1, 3, 13, '2014-07-08', NULL, 1); -- ком дир
INSERT INTO employees VALUES (13, 'GO000000101', 2, 1, 4, 2, '2015-04-07', NULL, 1); -- ит дир
INSERT INTO employees VALUES (14, 'GO000000102', 21, 1, 2, 4, '2015-04-07', NULL, 1); -- бух
INSERT INTO employees VALUES (15, 'GO000000103', 25, 1, 2, 4, '2015-04-09', NULL, 1); -- бух
INSERT INTO employees VALUES (16, 'GO000000158', 27, 1, 2, 4, '2018-03-01', NULL, 1); -- бух
INSERT INTO employees VALUES (17, 'GO000000015', 4, 1, 11, 12, '2012-03-31', NULL, 1); -- экономист
INSERT INTO employees VALUES (18, 'GO000000017', 15, 1, 6, 9, '2012-04-10', NULL, 1); -- кадровик
INSERT INTO employees VALUES (19, 'GO000000150', 18, 1, 6, 8, '2017-06-01', NULL, 1); -- рук HR
INSERT INTO employees VALUES (20, 'GO000000152', 12, 1, 1, 11, '2017-07-10', NULL, 1); -- секретарь
INSERT INTO employees VALUES (21, 'GO000000098', 26, 1, 11, 7, '2015-03-01', NULL, 1); -- операционист
INSERT INTO employees VALUES (22, 'FR000000001', 31, 4, 9, 10, '2018-07-03', NULL, 1); -- сейлз
INSERT INTO employees VALUES (23, 'FT000000005', 23, 3, 8, 10, '2020-02-05', NULL, 1); -- сейлз
INSERT INTO employees VALUES (24, 'FT000000006', 17, 3, 8, 10, '2020-03-01', NULL, 1); -- сейлз
INSERT INTO employees VALUES (25, 'GO000000097', 16, 1, 4, 5, '2015-02-28', NULL, 1); -- сис админ
INSERT INTO employees VALUES (26, 'FO000000013', 10, 2, 7, 10, '2019-07-01', NULL, 1); -- сейлз
INSERT INTO employees VALUES (27, 'FT000000002', 11, 3, 8, 10, '2019-07-01', NULL, 1); -- сейлз
INSERT INTO employees VALUES (28, 'FR000000002', 1, 4, 9, 10, '2019-06-20', '2020-06-15', 0);  -- сейлз
INSERT INTO employees VALUES (29, 'FF000000005', 20, 5, 10, 10, '2019-06-05', NULL, 1); -- сейлз
INSERT INTO employees VALUES (30, 'FF000000007', 3, 5, 10, 10, '2019-06-06', NULL, 1); -- сейлз
INSERT INTO employees VALUES (31, 'FF000000008', 9, 5, 10, 10, '2019-06-06', NULL, 1); -- сейлз

-- проверяла всех ли приняла на работу
SELECT * FROM persons pr WHERE pr.id NOT IN (select person_id from employees) ORDER BY birthday DESC;

-- Пользователи
DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    person_id INT UNSIGNED NOT NULL,
    -- password_hash CHAR(65) DEFAULT NULL, -- windows authentication
    AD_id VARCHAR(150) NOT NULL,
    is_active BOOLEAN NOT NULL,
    FOREIGN KEY (person_id) REFERENCES persons(id) -- ON DELETE RESTRICT,
);

INSERT INTO users VALUES (DEFAULT, 1, '\\organization\ivan_ivanov', 0); -- уволен
INSERT INTO users VALUES (DEFAULT, 2, '\\organization\petr_petrov', 1);
INSERT INTO users VALUES (DEFAULT, 3, '\\organization\ivan_vasiliev', 1);
INSERT INTO users VALUES (DEFAULT, 4, '\\organization\anna_petrova', 1);
INSERT INTO users VALUES (DEFAULT, 5, '\\organization\anna_sidorova', 1);
INSERT INTO users VALUES (DEFAULT, 6, '\\organization\elena_viktorova', 1);
INSERT INTO users VALUES (DEFAULT, 7, '\\organization\sergey_tolstoy', 1);
INSERT INTO users VALUES (DEFAULT, 8, '\\organization\lev_kuznetsov', 1);
INSERT INTO users VALUES (DEFAULT, 9, '\\organization\viktor_maximov', 1);
INSERT INTO users VALUES (DEFAULT, 10, '\\organization\olesya_ovacharenko', 1);
INSERT INTO users VALUES (DEFAULT, 11, '\\organization\elena_kuznetsova', 1);
INSERT INTO users VALUES (DEFAULT, 12, '\\organization\alina_barhudaryan', 1);
INSERT INTO users VALUES (DEFAULT, 13, '\\organization\alan_aliev', 1);
INSERT INTO users VALUES (DEFAULT, 14, '\\organization\marina_ovcharenko', 1);
INSERT INTO users VALUES (DEFAULT, 15, '\\organization\larisa_trubina', 1);
INSERT INTO users VALUES (DEFAULT, 16, '\\organization\pavel_kovalenko', 1);
INSERT INTO users VALUES (DEFAULT, 17, '\\organization\sergey_lastochkin', 1);
INSERT INTO users VALUES (DEFAULT, 18, '\\organization\kirill_vasechkin', 1);
INSERT INTO users VALUES (DEFAULT, 19, '\\organization\nikita_sergeev', 1);
INSERT INTO users VALUES (DEFAULT, 20, '\\organization\anton_alexandrov', 1);
INSERT INTO users VALUES (DEFAULT, 21, '\\organization\irina_vasilieva', 1);
INSERT INTO users VALUES (DEFAULT, 22, '\\organization\vladimir_antonov', 1);
INSERT INTO users VALUES (DEFAULT, 23, '\\organization\alexander_evgeniev', 1);
INSERT INTO users VALUES (DEFAULT, 24, '\\organization\grigory_zaitsev', 1);
INSERT INTO users VALUES (DEFAULT, 25, '\\organization\ekaterina_vlasova', 1);
INSERT INTO users VALUES (DEFAULT, 26, '\\organization\elizaveta_alexandrova', 1);
INSERT INTO users VALUES (DEFAULT, 27, '\\organization\nina_ivanova', 1);
INSERT INTO users VALUES (DEFAULT, 28, '\\organization\tatyana_petrova', 1);
INSERT INTO users VALUES (DEFAULT, 29, '\\organization\milana_viktorova', 1);
INSERT INTO users VALUES (DEFAULT, 30, '\\organization\alexey_ovodov', 1);
INSERT INTO users VALUES (DEFAULT, 31, '\\organization\vladimir_semenov', 1);

DROP TABLE IF EXISTS managers;
CREATE TABLE managers(
	person_id INT UNSIGNED NOT NULL UNIQUE,
    manager_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(person_id, manager_id),
    FOREIGN KEY (person_id) REFERENCES persons(id), -- ON DELETE RESTRICT,
    FOREIGN KEY (manager_id) REFERENCES persons(id), -- ON DELETE RESTRICT,
    CONSTRAINT check_manager CHECK (person_id != manager_id)    
);

INSERT INTO managers VALUES (14, 22);
INSERT INTO managers VALUES (5, 24);
INSERT INTO managers VALUES (13, 24);
INSERT INTO managers VALUES (8, 24);
INSERT INTO managers VALUES (7, 24);
INSERT INTO managers VALUES (6, 24);
INSERT INTO managers VALUES (28, 24);
INSERT INTO managers VALUES (29, 24);
INSERT INTO managers VALUES (24, 22);
INSERT INTO managers VALUES (2, 22);
INSERT INTO managers VALUES (30, 2);
INSERT INTO managers VALUES (19, 2);
INSERT INTO managers VALUES (21, 14);
INSERT INTO managers VALUES (25, 14);
INSERT INTO managers VALUES (27, 14);
INSERT INTO managers VALUES (1, 24);
INSERT INTO managers VALUES (20, 24);
INSERT INTO managers VALUES (3, 24);
INSERT INTO managers VALUES (9, 24);
INSERT INTO managers VALUES (10, 24);
INSERT INTO managers VALUES (31, 24);
INSERT INTO managers VALUES (11, 24);
INSERT INTO managers VALUES (23, 24);
INSERT INTO managers VALUES (17, 24);
INSERT INTO managers VALUES (4, 22);
INSERT INTO managers VALUES (12, 22);
INSERT INTO managers VALUES (18, 22);
INSERT INTO managers VALUES (26, 14);
INSERT INTO managers VALUES (15, 18);
INSERT INTO managers VALUES (16, 2);

-- Типы отпусков
DROP TABLE IF EXISTS types_of_status;
CREATE TABLE types_of_status(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150)
);
  
INSERT INTO types_of_status VALUES (1, 'Основной отпуск');   
INSERT INTO types_of_status VALUES (2, 'Северный отпуск');  
INSERT INTO types_of_status VALUES (3, 'Учебный отпуск');  
INSERT INTO types_of_status VALUES (4, 'Отпуск без оплаты');  
INSERT INTO types_of_status VALUES (5, 'Учебный отпуск без оплаты'); 
INSERT INTO types_of_status VALUES (6, 'Работа');  
INSERT INTO types_of_status VALUES (7, 'Болезнь');  

DROP TABLE IF EXISTS vacations;
CREATE TABLE vacations(
	employee_id INT UNSIGNED NOT NULL,
    date_from DATE NOT NULL,
    date_to DATE NOT NULL,
    type_id INT UNSIGNED,
    is_approved BOOLEAN DEFAULT 0,
    approve_manager INT UNSIGNED NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,  
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX(employee_id),
    PRIMARY KEY(employee_id, date_from),
	FOREIGN KEY (employee_id) REFERENCES employees(id), -- ON DELETE RESTRICT,
    FOREIGN KEY (approve_manager) REFERENCES persons(id) -- ON DELETE RESTRICT,
);

-- Остатки отпусков, заполняется ежедневно
DROP TABLE IF EXISTS days_of_vacation;
CREATE TABLE days_of_vacation(
	employee_id INT UNSIGNED NOT NULL,
    date_of_check DATE NOT NULL,
    days FLOAT,
    FOREIGN KEY (employee_id) REFERENCES employees(id)    
); 

INSERT INTO days_of_vacation VALUES (1, '2020-01-01', 5.33);
INSERT INTO days_of_vacation VALUES (2, '2020-01-01', 9);
INSERT INTO days_of_vacation VALUES (3, '2020-01-01', 5);
INSERT INTO days_of_vacation VALUES (4, '2020-01-01', 2);
INSERT INTO days_of_vacation VALUES (5, '2020-01-01', 2.33);
INSERT INTO days_of_vacation VALUES (6, '2020-01-01', 0.33);
INSERT INTO days_of_vacation VALUES (7, '2020-01-01', 15.33);
INSERT INTO days_of_vacation VALUES (8, '2020-01-01', 15.67);
INSERT INTO days_of_vacation VALUES (9, '2020-01-01', 6);
INSERT INTO days_of_vacation VALUES (10, '2020-01-01', 2);
INSERT INTO days_of_vacation VALUES (11, '2020-01-01', 2.33);
INSERT INTO days_of_vacation VALUES (12, '2020-01-01', 6.33);
INSERT INTO days_of_vacation VALUES (13, '2020-01-01', 5.33);
INSERT INTO days_of_vacation VALUES (14, '2020-01-01', 30);
INSERT INTO days_of_vacation VALUES (15, '2020-01-01', 25.33);
INSERT INTO days_of_vacation VALUES (16, '2020-01-01', 15.67);
INSERT INTO days_of_vacation VALUES (17, '2020-01-01', 3);
INSERT INTO days_of_vacation VALUES (18, '2020-01-01', 7);
INSERT INTO days_of_vacation VALUES (19, '2020-01-01', 21);
INSERT INTO days_of_vacation VALUES (20, '2020-01-01', 15.67);
INSERT INTO days_of_vacation VALUES (21, '2020-01-01', -5.67);
INSERT INTO days_of_vacation VALUES (22, '2020-01-01', 0.33);
INSERT INTO days_of_vacation VALUES (25, '2020-01-01', 1.33);
INSERT INTO days_of_vacation VALUES (26, '2020-01-01', 11.67);
INSERT INTO days_of_vacation VALUES (27, '2020-01-01', 11.67);
INSERT INTO days_of_vacation VALUES (28, '2020-01-01', 14);
INSERT INTO days_of_vacation VALUES (29, '2020-01-01', 14);
INSERT INTO days_of_vacation VALUES (30, '2020-01-01', 14);
INSERT INTO days_of_vacation VALUES (31, '2020-01-01', 14);
INSERT INTO days_of_vacation VALUES (1, '2020-01-01', 5.33 +2.33);
INSERT INTO days_of_vacation VALUES (2, '2020-02-01', 9+ 2.33);
INSERT INTO days_of_vacation VALUES (3, '2020-02-01', 5+ 2.33);
INSERT INTO days_of_vacation VALUES (4, '2020-02-01', 2+ 2.33);
INSERT INTO days_of_vacation VALUES (5, '2020-02-01', 2.33 + 2.33);
INSERT INTO days_of_vacation VALUES (6, '2020-02-01', 0.33 + 2.33);
INSERT INTO days_of_vacation VALUES (7, '2020-02-01', 15.33 + 2.33);
INSERT INTO days_of_vacation VALUES (8, '2020-02-01', 15.67 + 2.33);
INSERT INTO days_of_vacation VALUES (9, '2020-02-01', 6 + 2.33);
INSERT INTO days_of_vacation VALUES (10, '2020-02-01', 2 + 2.33);
INSERT INTO days_of_vacation VALUES (11, '2020-02-01', 2.33 + 2.33);
INSERT INTO days_of_vacation VALUES (12, '2020-02-01', 6.33 + 2.33);
INSERT INTO days_of_vacation VALUES (13, '2020-02-01', 5.33 + 2.33);
INSERT INTO days_of_vacation VALUES (14, '2020-02-01', 30 + 2.33);
INSERT INTO days_of_vacation VALUES (15, '2020-02-01', 25.33 + 2.33);
INSERT INTO days_of_vacation VALUES (16, '2020-02-01', 15.67 + 2.33);
INSERT INTO days_of_vacation VALUES (17, '2020-02-01', 3 + 2.33);
INSERT INTO days_of_vacation VALUES (18, '2020-02-01', 7 + 2.33);
INSERT INTO days_of_vacation VALUES (19, '2020-02-01', 21 + 2.33);
INSERT INTO days_of_vacation VALUES (20, '2020-02-01', 15.67 + 2.33);
INSERT INTO days_of_vacation VALUES (21, '2020-02-01', -5.67 + 2.33);
INSERT INTO days_of_vacation VALUES (22, '2020-02-01', 0.33 + 2.33);
INSERT INTO days_of_vacation VALUES (25, '2020-02-01', 1.33 + 2.33);
INSERT INTO days_of_vacation VALUES (26, '2020-02-01', 11.67 + 2.33);
INSERT INTO days_of_vacation VALUES (27, '2020-02-01', 11.67 + 2.33);
INSERT INTO days_of_vacation VALUES (28, '2020-02-01', 14 + 2.33);
INSERT INTO days_of_vacation VALUES (29, '2020-02-01', 14 + 2.33);
INSERT INTO days_of_vacation VALUES (30, '2020-02-01', 14 + 2.33);
INSERT INTO days_of_vacation VALUES (31, '2020-02-01', 14 + 2.33);
INSERT INTO days_of_vacation VALUES (1, '2020-01-01', 5.33 + 4.67);
INSERT INTO days_of_vacation VALUES (2, '2020-03-01', 9 + 4.67);
INSERT INTO days_of_vacation VALUES (3, '2020-03-01', 5 + 4.67);
INSERT INTO days_of_vacation VALUES (4, '2020-03-01', 2 + 4.67);
INSERT INTO days_of_vacation VALUES (5, '2020-03-01', 2.33 + 4.67);
INSERT INTO days_of_vacation VALUES (6, '2020-03-01', 0.33 + 4.67);
INSERT INTO days_of_vacation VALUES (7, '2020-03-01', 15.33 + 4.67);
INSERT INTO days_of_vacation VALUES (8, '2020-03-01', 15.67 + 4.67);
INSERT INTO days_of_vacation VALUES (9, '2020-03-01', 6 + 4.67);
INSERT INTO days_of_vacation VALUES (10, '2020-03-01', 2 + 4.67);
INSERT INTO days_of_vacation VALUES (11, '2020-03-01', 2.33 + 4.67);
INSERT INTO days_of_vacation VALUES (12, '2020-03-01', 6.33 + 4.67);
INSERT INTO days_of_vacation VALUES (13, '2020-03-01', 5.33 + 4.67);
INSERT INTO days_of_vacation VALUES (14, '2020-03-01', 30 + 4.67);
INSERT INTO days_of_vacation VALUES (15, '2020-03-01', 25.33 + 4.67);
INSERT INTO days_of_vacation VALUES (16, '2020-03-01', 15.67 + 4.67);
INSERT INTO days_of_vacation VALUES (17, '2020-03-01', 3 + 4.67);
INSERT INTO days_of_vacation VALUES (18, '2020-03-01', 7 + 4.67);
INSERT INTO days_of_vacation VALUES (19, '2020-03-01', 21 + 4.67);
INSERT INTO days_of_vacation VALUES (20, '2020-03-01', 15.67 + 4.67);
INSERT INTO days_of_vacation VALUES (21, '2020-03-01', -5.67 + 4.67);
INSERT INTO days_of_vacation VALUES (22, '2020-03-01', 0.33 + 4.67);
INSERT INTO days_of_vacation VALUES (25, '2020-03-01', 1.33 + 4.67);
INSERT INTO days_of_vacation VALUES (26, '2020-03-01', 11.67 + 4.67);
INSERT INTO days_of_vacation VALUES (27, '2020-03-01', 11.67 + 4.67);
INSERT INTO days_of_vacation VALUES (28, '2020-03-01', 14 + 4.67);
INSERT INTO days_of_vacation VALUES (29, '2020-03-01', 14 + 4.67);
INSERT INTO days_of_vacation VALUES (30, '2020-03-01', 14 + 4.67);
INSERT INTO days_of_vacation VALUES (31, '2020-03-01', 14 + 4.67);

SELECT * FROM days_of_vacation;

-- состояния сотрудников
DROP TABLE IF EXISTS status_of_employees;
CREATE TABLE status_of_employees(
	employee_id INT UNSIGNED NOT NULL,
    date_from DATE NOT NULL,
    date_to DATE DEFAULT '2999-12-31',
    status INT UNSIGNED NOT NULL,
    INDEX(employee_id),
    FOREIGN KEY (employee_id) REFERENCES employees(id),  
    FOREIGN KEY (status) REFERENCES types_of_status(id) 
); 

INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (1, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (2, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (3, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (4, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (5, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (6, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (7, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (8, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (9, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (10, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (11, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (12, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (13, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (14, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (15, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (16, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (17, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (18, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (19, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (20, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (21, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (22, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, date_to, status) VALUES (25, '2020-01-01', '2020-01-25', 7);
INSERT INTO status_of_employees (employee_id, date_from, date_to, status) VALUES (25, '2020-01-26', '2020-02-07', 1);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (25, '2020-02-08', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (25, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (26, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (27, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (28, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (29, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (30, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (31, '2020-01-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (23, '2020-02-05', 7);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (24, '2020-03-01', 7);
INSERT INTO status_of_employees (employee_id, date_from, date_to, status) VALUES (2, '2020-01-01', '2020-02-12', 7);
INSERT INTO status_of_employees (employee_id, date_from, date_to, status) VALUES (2, '2020-02-13', '2020-02-28', 1);
INSERT INTO status_of_employees (employee_id, date_from, status) VALUES (2, '2020-02-29', 7);

SELECT * FROM status_of_employees;

-- информация о сотрудниках
CREATE OR REPLACE VIEW employees_info
AS
SELECT 
	CONCAT(p.first_name, ' ', p.last_name) AS name,
	p.birthday,
	p.email,
	p.phone,
    p.id,
	o.name AS organization,
	d.name AS department,
	pos.name AS position,
	e.id_1C AS tab_num,
    man.name as manager
FROM employees e
LEFT JOIN persons p ON e.person_id = p.id
LEFT JOIN organizations o ON e.organization_id = o.id
LEFT JOIN departments d ON e.department_id = d.id
LEFT JOIN positions pos ON e.position_id = pos.id
LEFT JOIN 
	(SELECT 
		CONCAT(mp.first_name, ' ', mp.last_name) AS name, 
        person_id  
	FROM managers m 
    LEFT JOIN persons mp ON m.manager_id = mp.id) man ON e.person_id = man.person_id
WHERE e.is_working = 1
ORDER BY tab_num
;

--
CREATE OR REPLACE VIEW employees_vacation
AS
SELECT 
	emp.name,
	emp.birthday,
	emp.manager as manager,
	vac.date_from,
    vac.date_to,
    -- vac.approve_manager,
    vac.is_approved    
FROM vacations vac
JOIN (
SELECT 
	CONCAT(p.first_name, ' ', p.last_name) AS name,
	p.birthday,
    p.id,
	man.name as manager
FROM employees e
LEFT JOIN persons p ON e.person_id = p.id
LEFT JOIN 
	(SELECT 
		CONCAT(mp.first_name, ' ', mp.last_name) AS name, 
        person_id  
	FROM managers m 
    LEFT JOIN persons mp ON m.manager_id = mp.id) man ON e.person_id = man.person_id
WHERE e.is_working = 1) emp ON emp.id = vac.employee_id;

SELECT * FROM employees_info;
SELECT COUNT(*) FROM employees_info;

SELECT * FROM employees_vacation;
 
DELIMITER //
 -- Проверка, что организация и подразделение относятся к одной организации
 
USE hr_base//
DROP TRIGGER IF EXISTS check_organization;
CREATE TRIGGER check_organization BEFORE INSERT ON hr_base.employees
FOR EACH ROW
	BEGIN		
		IF NEW.organization_id != (SELECT organization_id 
			FROM hr_base.departments WHERE id = NEW.department_id) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insert Canceled. Department is not in selected organization! Check your data';
		END IF;
	END //

-- хранимая процедура для добавления отпуска в таблицу
DROP PROCEDURE IF EXISTS add_vacation //
CREATE PROCEDURE add_vacation(employee_id INT, 
								date_from DATE, 
                                date_to DATE, 
                                type_of_vacation INT) 
	BEGIN
		-- определяем работает ли сотрудник
		SET @is_working = (SELECT employee_is_working(employee_id));
        SET @can_take_vacation = (SELECT can_take_vacation(employee_id, date_from, date_to));
                
 		IF @is_working = 1 
			AND @can_take_vacation = 1 THEN        
			-- определяем менеджера, который должен согласовать отпуск
			SET @manager = 
				(SELECT man.manager_id 
				FROM managers man
				JOIN employees em ON em.person_id = man.person_id AND em.id = employee_id);
  		
			-- добавляем запись в таблицу		
			INSERT INTO vacations (employee_id, date_from, date_to, type_id, approve_manager) VALUES (employee_id, date_from, date_to, type_of_vacation, @manager);
		ELSE 
			SELECT 'Невозможно предоставить сотруднику в эти даты' AS error;       
		END IF;	    
    END //
    
DROP FUNCTION IF EXISTS rest_days_of_vacation //
CREATE FUNCTION rest_days_of_vacation(employee_id INT,
                                        date_of_check DATE)
	RETURNS FLOAT READS SQL DATA 
    BEGIN
		RETURN 
			(WITH rest_vac AS 
				(SELECT d.days AS days FROM days_of_vacation d 
				WHERE employee_id = d.employee_id AND d.date_of_check <= date_of_check 
				ORDER BY d.date_of_check DESC LIMIT 1)
			SELECT rest_vac.days FROM rest_vac 
            UNION 
            SELECT 0
            LIMIT 1);
    END //
    
DROP FUNCTION IF EXISTS employee_is_working //
CREATE FUNCTION employee_is_working(employee_id INT)
	RETURNS BOOLEAN READS SQL DATA 
    BEGIN
		RETURN 
			(SELECT is_working FROM employees WHERE id = employee_id);
    END //

DROP FUNCTION IF EXISTS can_take_vacation //
CREATE FUNCTION can_take_vacation(employee_id INT,
									date_from DATE, 
                                    date_to DATE)
	RETURNS BOOLEAN READS SQL DATA 
    BEGIN
		RETURN 
			(SELECT 7 = (SELECT s.status FROM status_of_employees s
            WHERE s.employee_id = employee_id 
				AND date_from <= s.date_to
                AND date_to >= s.date_from
			ORDER BY s.status
            LIMIT 1));
    END //
DELIMITER ;  


SELECT rest_days_of_vacation(2, '2020-03-01') AS rest_of_vacation;
SELECT rest_days_of_vacation(23, '2020-03-01') AS rest_of_vacation;
SELECT rest_days_of_vacation(2, '2019-03-01') AS rest_of_vacation;
SELECT rest_days_of_vacation(2, '2020-02-01') AS rest_of_vacation;

SELECT employee_is_working(1);
SELECT employee_is_working(28);
SELECT employee_is_working(2);
SELECT employee_is_working(26);
SELECT employee_is_working(25);

SELECT can_take_vacation(25, '2020-01-26', '2020-01-26');
SELECT can_take_vacation(25, '2020-01-12', '2020-01-20');

CALL add_vacation(25, '2020-01-26', '2020-01-26', 1); 
CALL add_vacation(25, '2020-01-12', '2020-01-20', 1); 

SELECT * FROM vacations;
