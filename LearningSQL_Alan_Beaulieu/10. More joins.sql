-- 10.1
-- Напишите запрос, возвращающий все типы счетов и открытые счета этих типов
-- (для соединения с таблицей product используйте столбец product_cd таблицы account).
-- Должны быть включены все типы счетов, даже если не был открыт ни один счет определенного типа.

SELECT p.product_cd, a.account_id
FROM product p LEFT OUTER JOIN account a
ON p.product_cd = a.product_cd;

-- 10.2
-- Переформулируйте 10.1 и примените другой тип внешнего соединения,
-- так чтобы результаты были как в упражнении 10.1.

SELECT p.product_cd, a.account_id
FROM account a RIGHT OUTER JOIN product p
ON p.product_cd = a.product_cd;

-- 10.3
-- Проведите внешнее соединение таблицы account с таблицамии individual и business
-- (посредством столбца account.cust_id) таким образом, чтобы результирующий набор
-- содержал по одной строке для каждого счета. Должны быть включены столбцы:
-- account.account_id, account.product_cd, individual.fname, individual.lname, business.name.
SELECT a.account_id, a.product_cd, i.fname, i.lname, b.name
FROM account a LEFT OUTER JOIN individual i
	ON a.cust_id = i.cust_id
    LEFT OUTER JOIN business b
	ON a.cust_id = b.cust_id;
    
-- 10.4
-- Разработайте запрос, который сформирует набор (1,2,3,..., 99,100).
SELECT (ones.num + tens.num + 1) nums
FROM
	(SELECT 0 num UNION ALL
     SELECT 1 num UNION ALL
	 SELECT 2 num UNION ALL
	 SELECT 3 num UNION ALL
	 SELECT 4 num UNION ALL
	 SELECT 5 num UNION ALL
	 SELECT 6 num UNION ALL
	 SELECT 7 num UNION ALL
	 SELECT 8 num UNION ALL
	 SELECT 9 num) ones
CROSS JOIN
	(SELECT 0 num UNION ALL
     SELECT 10 num UNION ALL
     SELECT 20 num UNION ALL
     SELECT 30 num UNION ALL
     SELECT 40 num UNION ALL
     SELECT 50 num UNION ALL
     SELECT 60 num UNION ALL
     SELECT 70 num UNION ALL
     SELECT 80 num UNION ALL
     SELECT 90 num) tens
ORDER BY nums;