-- 6.1
-- Имеются множество А = {L M N O P} и множество B = {P Q R S T}. 
-- Какие множества будут получены в результате следующих операций:
-- 1) A union B
-- 2) A union all B
-- 3) A intersect B
-- 4) A except B

-- Ответ:
-- 1) {L M N O P Q R S T}
-- 2) {L M N O P P Q R S T}
-- 3) {P}
-- 4) {L M N O}

-- 6.2
-- Напишите составной запрос для выбора имен и фамилий всех клиентов-физических лиц,
-- а также имен и фамилий всех сотрудников.

SELECT fname, lname
FROM individual
UNION ALL
SELECT fname, lname
FROM employee;

-- 6.3
-- Отсортируйте результаты упражнения 6.2 по столбцу  lname.

SELECT fname, lname
FROM individual
UNION ALL
SELECT fname, lname
FROM employee
ORDER BY lname;