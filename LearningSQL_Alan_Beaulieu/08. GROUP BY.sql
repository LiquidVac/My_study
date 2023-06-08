-- 8.1
-- Создайте запрос для подсчета числа строк в таблице account.

SELECT COUNT(*)
FROM account;

-- 8.2
-- Измените свой запрос из 8.1 для подсчета чисда счетов, имеющихся у каждого клиента.
-- Для каждого клиента выведите ID клиента и количество счетов.

SELECT cust_id, COUNT(*)
FROM account
GROUP BY cust_id;

-- 8.3
-- Измените свой запрос из 8.2 так, чтобы в результирующий набор были включены клиенты,
-- имеющие не менее двух счетов.

SELECT cust_id, COUNT(*)
FROM account
GROUP BY cust_id
HAVING COUNT(*) > 1;

-- 8.4
-- Найдите общий доступный остаток по типу счетов и отделению, 
-- где на каждый тип и отделение приходится более одного счета. 
-- Результаты должны быть упорядочены по общему остатку (от наибольшего к наименьшему).

SELECT product_cd, open_branch_id,  SUM(avail_balance)
FROM account
GROUP BY product_cd, open_branch_id
HAVING COUNT(*) > 1
ORDER BY SUM(avail_balance) DESC;