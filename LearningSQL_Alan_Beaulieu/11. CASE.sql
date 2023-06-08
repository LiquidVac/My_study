-- 11.1
-- Перепишите следующий запрос, использующий простое выражение CASE, таким образом,
-- чтобы получить аналогичные результаты с помощью выражения CASE с перебором вариантов.
-- Попытайтесь свести к минимуму количество блоков WHEN.
SELECT emp_id,
CASE title
	WHEN 'President' THEN 'Managenent'
    WHEN 'Vice President' THEN 'Managenent'
    WHEN 'Treasurer' THEN 'Managenent'
    WHEN 'Loan Manager' THEN 'Managenent'
    WHEN 'Operations Manager' THEN 'Operations'
    WHEN 'Head Teller' THEN 'Operations'
    WHEN 'Teller' THEN 'Operations'
    ELSE 'Unknown'
END title
FROM employee;

-- Ответ:
SELECT emp_id,
CASE 
	WHEN title IN('President', 'Vice President', 'Treasurer', 'Loan Manager')
    THEN 'Managenent'
    WHEN title IN('Operations Manager', 'Head Teller', 'Teller')
    THEN 'Operations'
    ELSE 'Unknown'
END title
FROM employee;

-- 11.2
-- Перепишите следующий запрос так, чтобы результирующий набор
-- содержал всего одну строку и четыре столбца (по одному для каждого отделения).
-- Назовите столбцы branch_1, branch_2 и т.д.
SELECT open_branch_id, COUNT(*)
FROM account
GROUP BY open_branch_id;

-- Ответ:
SELECT 
	SUM(CASE
			WHEN open_branch_id = 1 THEN 1
            ELSE 0
		END) branch_1,
	SUM(CASE
			WHEN open_branch_id = 2 THEN 1
            ELSE 0
		END) branch_2,
	SUM(CASE
			WHEN open_branch_id = 3 THEN 1
            ELSE 0
		END) branch_3,
	SUM(CASE
			WHEN open_branch_id = 4 THEN 1
            ELSE 0
		END) branch_4
FROM account;
            