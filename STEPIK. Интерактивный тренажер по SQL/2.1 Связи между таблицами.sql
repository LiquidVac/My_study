-- CREATE DATABASE stepik_book;
-- use stepik_book;

/* Задание 1
Создать таблицу author */
CREATE TABLE author (
       author_id   INT PRIMARY KEY AUTO_INCREMENT,
       name_author VARCHAR(50));

/* Задание 2
Заполнить таблицу author. В нее включить следующих авторов:
Булгаков М.А., Достоевский Ф.М., Есенин С.А., Пастернак Б.Л. */
INSERT INTO author(name_author)
VALUES ('Булгаков М.А.'),
       ('Достоевский Ф.М.'),
       ('Есенин С.А.'),
       ('Пастернак Б.Л.');

SELECT * FROM author;

/* Задание 3
Перепишите запрос на создание таблицы book , чтобы ее структура соответствовала структуре, показанной на логической схеме 
(таблица genre уже создана, порядок следования столбцов - как на логической схеме в таблице book, genre_id  - внешний ключ). 
Для genre_id ограничение о недопустимости пустых значений не задавать. 
В качестве главной таблицы для описания поля  genre_id использовать таблицу genre следующей структуры: */
CREATE TABLE genre (
       genre_id   INT PRIMARY KEY AUTO_INCREMENT,
       name_genre VARCHAR(30));
       
CREATE TABLE book (
    book_id   INT PRIMARY KEY AUTO_INCREMENT, 
    title     VARCHAR(50), 
    author_id INT NOT NULL, 
    genre_id  INT, 
    price     DECIMAL(8,2), 
    amount    INT, 
    FOREIGN KEY (author_id)  REFERENCES author (author_id), 
    FOREIGN KEY (genre_id)  REFERENCES genre (genre_id) 
);

/* Задание 4
Создать таблицу book той же структуры, что и на предыдущем шаге. Будем считать, 
что при удалении автора из таблицы author, должны удаляться все записи о книгах из таблицы book, написанные этим автором. 
А при удалении жанра из таблицы genre для соответствующей записи book установить значение Null в столбце genre_id. */
DROP TABLE book;

CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8 , 2 ),
    amount INT,
    FOREIGN KEY (author_id)
        REFERENCES author (author_id)
        ON DELETE CASCADE,
    FOREIGN KEY (genre_id)
        REFERENCES genre (genre_id)
        ON DELETE SET NULL
);

DESCRIBE book;


/* На предыдущих шагах были созданы и заполнены таблицы book, author и genre. */
INSERT INTO genre(name_genre) 
VALUES ('Роман'),
       ('Поэзия');

SELECT * FROM genre;
       
INSERT INTO book(title, author_id, genre_id, price, amount) 
VALUES ('Мастер и Маргарита', 1, 1, 670.99, 3),
	   ('Белая гвардия', 1, 1, 540.50, 5),
       ('Идиот', 2, 1, 460.00, 10),
       ('Братья Карамазовы', 2, 1, 799.01, 3),
       ('Игрок', 2, 1, 480.50, 10),
       ('Стихотворения и поэмы', 3, 2, 650, 15);

SELECT * FROM book;

/* Задание 5
Добавьте две последние записи (с ключевыми значениями 7, 8) в таблицу book, первые 5 записей уже добавлены: */
INSERT INTO book(title, author_id, genre_id, price, amount) 
VALUES ('Черный человек', 3, 2, 570.20, 6),
       ('Лирика', 4, 2, 518.99, 2);

SELECT * FROM book;
