-- use stepik;
DELETE FROM book
WHERE book_id > 4;

INSERT INTO book (book_id, title, author, price, amount) 
VALUES (5, 'Стихотворения и поэмы', 'Есенин С.А.', 650.00, 15);

UPDATE book SET amount = 2 WHERE title = "Братья Карамазовы";


/* Задание 1 
Создать таблицу поставка (supply), которая имеет ту же структуру, что и таблица book. */
CREATE TABLE supply(
	   supply_id INT PRIMARY KEY AUTO_INCREMENT, 
       title VARCHAR(50),
       author VARCHAR(30),
       price DECIMAL(8, 2),
       amount INT
);

/* Задание 2
Занесите в таблицу supply четыре записи, чтобы получилась следующая таблица: */
INSERT INTO supply (title, author, price, amount) 
VALUES 
       ("Лирика","Пастернак Б.Л.", 518.99, 2),
       ("Черный человек","Есенин С.А.", 570.20, 6),
       ("Белая гвардия","Булгаков М.А.", 540.50, 7),
       ("Идиот","Достоевский Ф.М.", 360.80, 3);
       
SELECT * FROM supply;

/* Задание 3
Добавить из таблицы supply в таблицу book, все книги, кроме книг, написанных Булгаковым М.А. и Достоевским Ф.М. */
INSERT INTO book (title, author, price, amount) 
SELECT title, author, price, amount 
  FROM supply
 WHERE author NOT IN ("Булгаков М.А.", "Достоевский Ф.М.");    
 
SELECT * FROM book;

-- Возвращение таблицы к исходному состоянию
DELETE FROM book
WHERE book_id > 5;

/* Задание 4
Занести из таблицы supply в таблицу book только те книги, авторов которых нет в  book. */
INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount
  FROM supply
 WHERE author NOT IN (
       SELECT author
         FROM book);
         
SELECT * FROM book;

-- Возвращение таблицы к исходному состоянию
DELETE FROM book
WHERE book_id > 5;

/* Задание 5
Уменьшить на 10% цену тех книг в таблице book, количество которых принадлежит интервалу от 5 до 10, включая границы. */
UPDATE book
   SET price = price * 0.9
 WHERE amount BETWEEN 5 AND 10;
 
SELECT * FROM book;

-- Возвращение таблицы к исходному состоянию
UPDATE book SET price = 540.50 WHERE book_id = 2;
UPDATE book SET price = 460.00 WHERE book_id = 3;

/* Задание 6 */
-- Важно! Для этого шага в таблицу добавлена новая колонка. 
ALTER TABLE book ADD buy INT;
UPDATE book SET buy = 0 WHERE book_id IN(1,4);
UPDATE book SET buy = 3 WHERE book_id = 2;
UPDATE book SET buy = 8 WHERE book_id = 3;
UPDATE book SET buy = 18 WHERE book_id = 5;

/* В таблице book необходимо скорректировать значение для покупателя в столбце buy таким образом, чтобы оно не 
превышало количество экземпляров книг, указанных в столбце amount. А цену тех книг, которые покупатель не заказывал, 
снизить на 10%. */
UPDATE book
   SET buy = IF(buy > amount, amount, buy),
       price = IF(buy = 0, price * 0.9, price);
       
SELECT * FROM book;       

-- Возвращение таблицы к исходному состоянию
ALTER TABLE book
DROP COLUMN buy;
UPDATE book SET price = 670.99 WHERE book_id = 1;
UPDATE book SET price = 460.00 WHERE book_id = 3;
UPDATE book SET price = 799.01 WHERE book_id = 4;

/* Задание 7
Для тех книг в таблице book , которые есть в таблице supply, не только увеличить их количество в таблице book 
(увеличить их количество на значение столбца amount таблицы supply), но и пересчитать их цену 
(для каждой книги найти сумму цен из таблиц book и supply и разделить на 2). */
UPDATE book, supply 
   SET book.amount = book.amount + supply.amount,
       book.price = (book.price + supply.price) / 2
 WHERE book.title = supply.title AND book.author = supply.author;
 
SELECT * FROM book;

-- Возвращение таблицы к исходному состоянию 
UPDATE book SET amount = 5 WHERE book_id = 2;
UPDATE book SET amount = 10 WHERE book_id = 3;
UPDATE book SET price = 460.00 WHERE book_id = 3;

/* Задание 8
Удалить из таблицы supply книги тех авторов, общее количество экземпляров книг которых в таблице book превышает 10. */
DELETE FROM supply 
 WHERE author IN (
       SELECT author 
         FROM book
        GROUP BY author
       HAVING SUM(amount) > 10
       );
       
SELECT * FROM supply;

 -- Возвращение таблицы к исходному состоянию
INSERT INTO supply (supply_id, title, author, price, amount) 
VALUES 
       (2, "Черный человек","Есенин С.А.", 570.20, 6),
       (4, "Идиот","Достоевский Ф.М.", 360.80, 3);

/* Задание 9
Создать таблицу заказ (ordering), куда включить авторов и названия тех книг, количество экземпляров которых в 
таблице book меньше среднего количества экземпляров книг в таблице book. В таблицу включить столбец   amount, 
в котором для всех книг указать одинаковое значение - среднее количество экземпляров книг в таблице book. */
CREATE TABLE ordering AS
SELECT author, title, (
       SELECT ROUND(AVG(amount)) 
       FROM book
       ) AS amount
FROM book
WHERE amount < (
       SELECT AVG(amount)
         FROM book);

SELECT * FROM ordering;
