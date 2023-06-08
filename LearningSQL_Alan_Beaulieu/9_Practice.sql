-- 9.1
-- Создайте запрос к таблице account, использующий условие фильтрации с несвязанным подзапросом
-- к таблице product для поиска всех кредитных счетов (product.product_type_cd = 'LOAN'). 
-- Должны быть выбраны ID счета, код счета, ID клиента и доступный остаток.

SELECT account_id, product_cd, cust_id, avail_balance
FROM account
WHERE product_cd IN (SELECT product_cd
	FROM product
    WHERE product.product_type_cd = 'LOAN');

-- 9.2
-- Переработайте запрос из 9.1 используя связанный подзапрос к таблице product.
SELECT a.account_id, a.product_cd, a.cust_id, a.avail_balance
FROM account a
WHERE EXISTS (SELECT 1
	FROM product p
    WHERE p.product_cd = a.product_cd
    AND p.product_type_cd = 'LOAN');

-- 9.3
-- Соедините следующий запрос с таблицей employee, чтобы показать уровень квалификации каждого сотрудника:
SELECT 'trainee' name, '2004-01-01' start_dt, '2005-12-31' end_dt
UNION ALL
SELECT 'worker' name, '2002-01-01' start_dt, '2003-12-31' end_dt
UNION ALL
SELECT 'mentor' name, '2000-01-01' start_dt, '2001-12-31' end_dt; 
-- дайте подзапросы псевдоним levels и включите ID сотрудника, имя, фамилию и квалификацию (levels.name).

SELECT e.emp_id ID, e.fname name, e.lname last_name, levels.name qualification
FROM employee e INNER JOIN 
	(SELECT 'trainee' name, '2004-01-01' start_dt, '2005-12-31' end_dt
	UNION ALL
	SELECT 'worker' name, '2002-01-01' start_dt, '2003-12-31' end_dt
	UNION ALL
	SELECT 'mentor' name, '2000-01-01' start_dt, '2001-12-31' end_dt) levels
    ON e.start_date BETWEEN levels.start_dt AND levels.end_dt;

-- 9.4
-- Создайте запрос к таблице employee для получения ID, имени и фамилии сотрудника
-- вместе с названиями отдела и отделения, к которым он приписан.
-- Не используйте соединение таблиц.

SELECT e.emp_id, e.fname, e.lname, 
	(SELECT d.name FROM department d
    WHERE d.dept_id = e.dept_id) dept_name,
    (SELECT b.name FROM branch b
    WHERE b.branch_id = e.assigned_branch_id) branch_name
FROM employee e;

