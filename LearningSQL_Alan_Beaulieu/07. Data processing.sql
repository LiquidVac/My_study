-- 7.1
-- Напишите запрос, возвращающий с 17-го по 25-й символы строки 
-- 'Please find the substring in this string'.

SELECT SUBSTRING('Please find the substring in this string', 17, 9);

-- 7.2
-- Напишите запрос, возвращающий абсолютную величину и знак (-1, 0 или 1)
-- числа -25.76823. Также возвратите число, округленное до сотых.

SELECT ABS(-25.76823), SIGN(-25.76823), ROUND(-25.76823, 2);

-- 7.3
-- Напишите запрос, возвращающий толко значение месяца текущей даты.

SELECT EXTRACT(MONTH FROM CURRENT_DATE());