-- CREATE DATABASE stepik;
-- use stepik;

/* 1.1 Отношение (таблица) */

/* Задание 1
Сформулируйте SQL запрос для создания таблицы book */
CREATE TABLE book(
	   book_id INT PRIMARY KEY AUTO_INCREMENT, 
       title VARCHAR(50),
       author VARCHAR(30),
       price DECIMAL(8, 2),
       amount INT
);

/* Задание 2
Занесите новую строку в таблицу book */
INSERT INTO book (title, author, price, amount) 
VALUES ('Мастер и Маргарита', 'Булгаков М.А.', 670.99, 3);

/* Задание 3
Занесите остальные записи в таблицу book, 
первая запись уже добавлена на предыдущем шаге: */
INSERT INTO book (title, author, price, amount) 
VALUES ('Белая гвардия', 'Булгаков М.А.', 540.50, 5);
INSERT INTO book (title, author, price, amount) 
VALUES ('Идиот', 'Достоевский Ф.М.', 460.00, 10);
INSERT INTO book (title, author, price, amount) 
VALUES ('Братья Карамазовы', 'Достоевский Ф.М.', 799.01, 2);
INSERT INTO book (title, author, price, amount) 
VALUES ('Стихотворения и поэмы', 'Есенин С.А.', 650.00, 15);
INSERT INTO book (title, author, price, amount) 
VALUES ('Игрок', 'Достоевский Ф.М.', 480.50, 10);


/* 1.2 Выборка данных */

/* Задание 1
Вывести информацию о всех книгах, хранящихся на складе*/
SELECT * FROM book;

/* Задание 2
Выбрать авторов, название книг и их цену из таблицы book */
SELECT author, title, price FROM book;

/* Задание 3
Выбрать названия книг и авторов из таблицы book, 
для поля title задать имя(псевдоним) Название, для поля author –  Автор. */
SELECT title AS Название, author AS Автор
  FROM book;

/* Задание 4
Для упаковки каждой книги требуется один лист бумаги, цена которого 1 рубль 65 копеек. 
Посчитать стоимость упаковки для каждой книги (сколько денег потребуется, чтобы упаковать все экземпляры книги).
В запросе вывести название книги, ее количество и стоимость упаковки, последний столбец назвать pack. */
SELECT title, amount, 1.65 * amount AS pack
  FROM book;

/* Задание 5
В конце года цену всех книг на складе пересчитывают – снижают ее на 30%.
Написать SQL запрос, который из таблицы book выбирает названия, авторов, количества и вычисляет новые цены книг.
Столбец с новой ценой назвать new_price, цену округлить до 2-х знаков после запятой. */
SELECT title, author, amount, ROUND(price / 100 * 70, 2) AS new_price
  FROM book;
  
/* Задание 6 
При анализе продаж книг выяснилось, что наибольшей популярностью пользуются книги Михаила Булгакова, 
на втором месте книги Сергея Есенина. Исходя из этого решили поднять цену книг Булгакова на 10%, а цену книг Есенина - на 5%. 
Написать запрос, куда включить автора, название книги и новую цену, последний столбец назвать new_price. Значение округлить до двух знаков после запятой. */
SELECT author, title,
       ROUND(IF(author = "Булгаков М.А.", price * 1.1,
       IF(author = "Есенин С.А.", price * 1.05, price)),2) AS new_price
  FROM book;
  
/* Задание 7
Вывести автора, название и цены тех книг, количество которых меньше 10. */
SELECT author, title, price
  FROM book
 WHERE amount < 10;

/* Задание 8
Вывести название, автора, цену и количество всех книг, цена которых меньше 500 или больше 600, а стоимость всех экземпляров этих книг больше или равна 5000. */
SELECT title, author, price, amount
  FROM book
 WHERE (price < 500 OR price > 600) AND price * amount > 4999;
 
/* Задание 9
Вывести название и авторов тех книг, цены которых принадлежат интервалу от 540.50 до 800 (включая границы),  а количество или 2, или 3, или 5, или 7. */
SELECT title, author
  FROM book
 WHERE (price BETWEEN 540.50 AND 800) AND (amount IN (2, 3, 5, 7));
 
/* Задание 10
Вывести  автора и название  книг, количество которых принадлежит интервалу от 2 до 14 (включая границы). 
Информацию отсортировать сначала по авторам (в обратном алфавитном порядке), а затем по названиям книг (по алфавиту). */
SELECT author, title
  FROM book
 WHERE amount BETWEEN 2 AND 14
 ORDER BY author DESC, title;
 
/* Задание 10 */
-- Важно! Для этого шага в таблицу добавлены новые записи. 
INSERT INTO book (title, author, price, amount) 
VALUES ('                     ', 'Иванов С.С.', 50.00, 10);
INSERT INTO book (title, author, price, amount) 
VALUES ('Дети полуночи', 'Рушди Салман', 950.00, 5);
INSERT INTO book (title, author, price, amount) 
VALUES ('Лирика', 'Гумилев Н.С.', 460.00, 10);
INSERT INTO book (title, author, price, amount) 
VALUES ('Поэмы', 'Бехтерев С.С.', 460.00, 10);
INSERT INTO book (title, author, price, amount) 
VALUES ('Капитанская дочка', 'Пушкин А.С.', 520.50, 7);
/* Вывести название и автора тех книг, название которых состоит из двух и более слов, а инициалы автора содержат букву «С». 
Считать, что в названии слова отделяются друг от друга пробелами и не содержат знаков препинания, между фамилией автора и инициалами обязателен пробел, 
инициалы записываются без пробела в формате: буква, точка, буква, точка. Информацию отсортировать по названию книги в алфавитном порядке. */
SELECT title, author
  FROM book
 WHERE author LIKE "%С.%"
       AND TRIM(title) LIKE '% %'
 ORDER BY title;

-- Возвращение таблицы к исходному состоянию
DELETE FROM book
WHERE book_id > 6;


/* 1.3 Запросы, групповые операции */

UPDATE book SET amount = 3 WHERE title = "Братья Карамазовы";

/* Задание 1
Отобрать различные (уникальные) элементы столбца amount таблицы book.*/
SELECT DISTINCT amount
  FROM book;
  
/* Задание 2
Посчитать, количество различных книг и количество экземпляров книг каждого автора , хранящихся на складе. 
Столбцы назвать Автор, Различных_книг и Количество_экземпляров соответственно.*/
SELECT author AS "Автор", 
       COUNT(title) AS "Различных_книг", 
       SUM(amount) AS "Количество_экземпляров"
  FROM book
 GROUP BY author;
 
/* Задание 3
Вывести фамилию и инициалы автора, минимальную, максимальную и среднюю цену книг каждого автора.  
Вычисляемые столбцы назвать Минимальная_цена, Максимальная_цена и Средняя_цена соответственно. */
SELECT author, 
       MIN(price) AS "Минимальная_цена",
       MAX(price) AS "Максимальная_цена", 
       AVG(price) AS "Средняя_цена"
  FROM book
 GROUP BY author;

/* Задание 4
Для каждого автора вычислить суммарную стоимость книг(имя столбца Стоимость), а также вычислить налог на добавленную стоимость для полученных сумм(имя столбца НДС ), 
который включен в стоимость и составляет 18%, а также стоимость книг(Стоимость_без_НДС) без него. Значения округлить до двух знаков после запятой.*/
SELECT author, SUM(price * amount) AS "Стоимость",
       ROUND((SUM(price * amount) * 18 / 100) / (1 + 18 / 100), 2) AS "НДС",
       ROUND(SUM(price * amount) / (1 + 18 / 100), 2) AS "Стоимость_без_НДС"
  FROM book
 GROUP BY author;
 
/* Задание 5
Вывести  цену самой дешевой книги, цену самой дорогой и среднюю цену уникальных книг на складе. Названия столбцов Минимальная_цена, 
Максимальная_цена, Средняя_цена соответственно. Среднюю цену округлить до двух знаков после запятой.*/
SELECT MIN(price) AS "Минимальная_цена", 
       MAX(price) AS "Максимальная_цена",
       ROUND(AVG(price), 2) AS "Средняя_цена"
  FROM book;

/* Задание 6
Вычислить среднюю цену и суммарную стоимость тех книг, количество экземпляров которых принадлежит интервалу от 5 до 14, включительно. 
Столбцы назвать Средняя_цена и Стоимость, значения округлить до 2-х знаков после запятой. */
SELECT ROUND(AVG(price), 2) AS "Средняя_цена",
       SUM(price * amount) AS "Стоимость"
  FROM book
 WHERE amount BETWEEN 5 AND 14;

/* Задание 7
Посчитать стоимость всех экземпляров каждого автора без учета книг «Идиот» и «Белая гвардия». В результат включить только тех авторов, 
у которых суммарная стоимость книг (без учета книг «Идиот» и «Белая гвардия») более 5000 руб. Вычисляемый столбец назвать Стоимость. 
Результат отсортировать по убыванию стоимости. */
SELECT author, SUM(amount * price) AS "Стоимость"
  FROM book
 WHERE title NOT IN ("Идиот","Белая гвардия")
 GROUP BY author
HAVING SUM(amount * price) > 5000
 ORDER BY Стоимость DESC;
 
 
 /* 1.4 Вложенные запросы */
 
/* Задание 1
Вывести информацию (автора, название и цену) о  книгах, цены которых меньше или равны средней цене книг на складе. 
Информацию вывести в отсортированном по убыванию цены виде. Среднее вычислить как среднее по цене книги. */
SELECT author, title, price
  FROM book
 WHERE price <= (
       SELECT AVG(price)
         FROM book)
 ORDER BY price DESC;
 
/* Задание 2
Вывести информацию (автора, название и цену) о тех книгах, цены которых превышают минимальную цену книги на складе не более чем на 150 рублей в отсортированном по возрастанию цены виде. */
SELECT author, title, price
  FROM book
 WHERE (price - (SELECT MIN(price) FROM book)) <= 150
 ORDER BY price;

/* Задание 3
Вывести информацию (автора, книгу и количество) о тех книгах, количество экземпляров которых в таблице book не дублируется. */
SELECT author, title, amount
  FROM book
 WHERE amount NOT IN (
       SELECT amount
         FROM book
        GROUP BY amount
       HAVING COUNT(amount) > 1
       );
       
/* Задание 4
Вывести информацию о книгах(автор, название, цена), цена которых меньше самой большой из минимальных цен, вычисленных для каждого автора. */
SELECT author, title, price
  FROM book
 WHERE price < ANY(
       SELECT MIN(price)
         FROM book
        GROUP BY author
        );
        
/* Задание 5
Посчитать сколько и каких экземпляров книг нужно заказать поставщикам, чтобы на складе стало одинаковое количество 
экземпляров каждой книги, равное значению самого большего количества экземпляров одной книги на складе. Вывести 
название книги, ее автора, текущее количество экземпляров на складе и количество заказываемых экземпляров книг. 
Последнему столбцу присвоить имя Заказ. В результат не включать книги, которые заказывать не нужно. */
SELECT title, author, amount, (
       SELECT MAX(amount)
         FROM book) - amount AS "Заказ"
  FROM book
HAVING Заказ > 0;


/* 1.5 Запросы корректировки данных */

DELETE FROM book WHERE title = 'Игрок';
UPDATE book SET amount = 2 WHERE title = "Братья Карамазовы";

/* Задание 1 
Создать таблицу поставка (supply), которая имеет ту же структуру, что и таблиц book. */
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