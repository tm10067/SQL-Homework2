/* 
Базы данных и SQL, семинар 2, практическое задание:
Создать при помощи SQL несколько таблиц
Например, таблица “Фильмы” и таблица “Киностудии”
Заполнить таблицы с данными в соответствии с выбранными типами
Продемонстрировать работу с
операторами переименования таблиц\полей,
операторами добавления и удаления таблиц\полей;
добавления ключей(внешних);
оператором псевдонима;
оператором CASE;
оператором IF;

Подумать и описать проблемы своего проектирования базы данных;

Оформить работу так, чтобы результатами было пользоваться удобно не только лично вам.
*/

CREATE SCHEMA Homework2;

USE Homework2;

/* Создадим таблицу Фильмы с полями: название, год выпуска, киностудия, режиссер,
первичным ключом будет комбинация названия фильма и года выпуска */

CREATE TABLE movie (
	PRIMARY KEY 		(movie_name, production_year),
	UNIQUE KEY 		movie_name_UNIQUE (movie_name, production_year),
	movie_name 		VARCHAR(60) 	NOT NULL,
	production_year 	YEAR 		NOT NULL,
	production_studio 	VARCHAR(30) DEFAULT NULL,
	director 		VARCHAR(60) DEFAULT NULL
)	
	ENGINE=InnoDB 
	DEFAULT CHARSET=utf8mb4 
    	COLLATE=utf8mb4_0900_ai_ci;
    
/* Создадим таблицу Киностудии с полями: название, страна, владелец, статус (активна/неактивна),
первичным ключом будет название киностудии */ 
    
CREATE TABLE studio (
	PRIMARY KEY 		(studio_name),
	UNIQUE KEY 		studio_name_UNIQUE (studio_name),
	studio_name 		VARCHAR(30) 	NOT NULL,
	residence_country	VARCHAR(30) DEFAULT NULL,
	ownership 		VARCHAR(30) DEFAULT NULL,
	activity_status 	VARCHAR(30) DEFAULT NULL
) 	
	ENGINE=InnoDB 
	DEFAULT CHARSET=utf8mb4 
    	COLLATE=utf8mb4_0900_ai_ci;
    
 /* Создадим таблицу Жанры с полями: индекс и название жанра,
первичным ключом будет индекс */    
    
CREATE TABLE genre (
	PRIMARY KEY 		(genre_id),
	UNIQUE INDEX 		genre_id_UNIQUE (genre_id ASC),
    	UNIQUE INDEX 		genre_name_UNIQUE (genre_name),
	genre_id		INT 		NOT NULL AUTO_INCREMENT,
	genre_name 		VARCHAR(30) 	NOT NULL
)	
	ENGINE=InnoDB 
	DEFAULT CHARSET=utf8mb4 
    	COLLATE=utf8mb4_0900_ai_ci;
    
/* Заполним данные в таблице Фильмы */     
    
INSERT INTO movie (movie_name, production_year, production_studio, director) 
     VALUES ('Зеленая миля', '1999', 'Castle Rock Entertainment', 'Фрэнк Дарабонт'),
            ('Список Шиндлера', '1993', 'Amblin Entertainment', 'Стивен Спилберг'),
            ('Побег из Шоушенка', '1994', 'Castle Rock Entertainment', 'Фрэнк Дарабонт'),
            ('Властелин колец: Возвращение короля', '2003', 'New Line Cinema', 'Питер Джексон'),
            ('Интерстеллар', '2014', 'Legendary Pictures', 'Кристофер Нолан'),
            ('Назад в будущее', '1985', 'Amblin Entertainment', 'Роберт Земекис'),
            ('Форрест Гамп', '1994', 'The Tisch Company', 'Роберт Земекис'),
            ('Криминальное чтиво', '1994', 'A Band Apart', 'Квентин Тарантино'),
            ('Бойцовский клуб', '1999', 'Fox 2000 Pictures', 'Дэвид Финчер');
       
/* Заполним данные в таблице Киностудии */         
       
INSERT INTO studio (studio_name, residence_country, ownership, activity_status) 
     VALUES ('Castle Rock Entertainment', 'США', 'Warner Bros. Discovery', 'активна'),
 	    ('Amblin Entertainment', 'США', 'Reliance Entertainment', 'активна'),
            ('New Line Cinema', 'США', 'Warner Bros. Discovery', 'активна'),
            ('Legendary Pictures', 'США', 'Wanda Group', 'активна'),
            ('The Tisch Company', 'США', 'неизвестно', 'неактивна'),
            ('A Band Apart', 'США', 'Quentin Tarantino', 'неактивна'),
            ('Fox 2000 Pictures', 'США', 'The Walt Disney Studios', 'неактивна');
       
/* Заполним данные в таблице Жанры */ 

INSERT INTO genre (genre_name) 
     VALUES ('мелодрама'),
            ('боевик'),
            ('фантастика'),
            ('фэнтези'),
            ('документальный'),
            ('комедия'),
            ('хоррор'),
            ('триллер');
       
/* Добавим в таблицу Фильмы внешний ключ из таблицы Киностудия по полю название киностудии */ 
 
    ALTER TABLE movie
ADD FOREIGN KEY (production_studio) 
     REFERENCES studio(studio_name);
     
/* Переименуем таблицу Фильмы из movie в film */

RENAME TABLE movie
          TO film;
 
/* Переименуем поле таблицы Фильмы из movie_name в film_name */

  ALTER TABLE film 
RENAME COLUMN movie_name 
           TO film_name;
           
/* Удалим столбец владелец из таблицы Киностудии */ 
     
ALTER TABLE studio
DROP COLUMN ownership;          
           
/* Добавим поле ид жанра в таблицу Фильмы */

ALTER TABLE film 
 ADD COLUMN genre_id INT NULL;
 
 /* Добавим в таблицу Фильмы внешний ключ из таблицы Жанры по полю ид жанра */ 
 
    ALTER TABLE film
ADD FOREIGN KEY (genre_id) 
     REFERENCES genre(genre_id);
     
/* Заполним поле ид жанра в таблице Фильмы для существующих записей */ 
       
UPDATE film SET genre_id = CASE
	WHEN film_name = 'Бойцовский клуб' AND production_year = 1999 THEN 8
        WHEN film_name = 'Властелин колец: Возвращение короля' AND production_year = 2003 THEN 4
        WHEN film_name = 'Зеленая миля' AND production_year = 1999 THEN 1
        WHEN film_name = 'Интерстеллар' AND production_year = 2014 THEN 3
        WHEN film_name = 'Криминальное чтиво' AND production_year = 1994 THEN 8
        WHEN film_name = 'Назад в будущее' AND production_year = 1985 THEN 3
        WHEN film_name = 'Побег из Шоушенка' AND production_year = 1994 THEN 1
        WHEN film_name = 'Список Шиндлера' AND production_year = 1993 THEN 8
        WHEN film_name = 'Форрест Гамп' AND production_year = 1994 THEN 1
        END;
     
/* Сделаем выборку фильмов, выпущенных в 90е годы */    
     
SELECT film_name 
    AS 'фильмы девяностых'
  FROM film
 WHERE production_year BETWEEN 1990 AND 1999;
 
 /* Сделаем выборку фильмов по жанру триллеры */ 
 
 SELECT film_name 
     AS 'триллеры'
   FROM film INNER JOIN genre ON (film.genre_id = genre.genre_id)
  WHERE genre_name = 'триллер';
 
 /* Сделаем выборку фильмов по году выпуска поделив на старые и новые фильмы */ 
 
 SELECT film_name 
     AS 'фильм', 
     IF (production_year < 2000, 'старый', 'новый') 
     AS 'год выпуска'
   FROM film
       
/* Подумать и описать проблемы своего проектирования базы данны */

/* Проблемы в проектировании:

1) Для таблицы Фильмы для простоты использован составной ключ из полей 'название фильма' + 'год выпуска', 
на мой взгляд в серьезном решении было бы удобнее использовать одно поле с кодом из какого-либо общепринятого классификатора кинопродукции,
например IMDb или AFI Catalog, но там могут быть свои сложности, например, со страновой совместимостью.

2) В базе данных реализована связь один к одному между таблицами Жанры и Фильмы, что не совсем репрезентативно, 
т.к. один фильм может подпадать под несколько жанров. 
Для этого следовало бы реализовать связь таблиц Фильмы и Жанры через промежуточную таблицу с ключами, 
где можно было бы продублировать записи фильмов, присвоив им различные жанры.
Аналогично и для связи таблиц Фильмы и Киностудии.

3) Не для всех фильмов однозначно известен год выпуска, что может привести к неправильному внесению записей в ключевых полях таблицы Фильмы.
Также могут быть разночтения и в переводе названий иностранных фильмов.
Лучше использовать классификаторы фильмов или генерируемое поле id для первичного ключа таблицы. 

4) Названия фильмов могут иметь произвольную длину, что затрудняет подбор достаточного размера для типа данных в поле название фильмов.

5) Определение жанров через индексы не совсем удобно для заполнения значений в других таблицах, нужно все время держать перед глазами таблицу жанров.

6) Киностудии на протяжении своего существования часто меняют названия, владельцев, сливаются и разделяются, 
нередко создаются временные или совместные предприятия под кинопроект или режиссера, кроме того для выпуска фильма 
имеет значение не только киностудия но и распространитель, все эти изменения и отношения может быть трудно представить в рамках одной таблицы.

7) В таблице Киностидии первичный ключ определен по названию студии, что исключает возможность внесения студий с одинаковыми названиями.
Возможно было бы целесообразно использовать генерируемое поле id*/













       
    
    
