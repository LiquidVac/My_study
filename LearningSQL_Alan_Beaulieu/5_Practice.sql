-- 5.1 
-- Заполните в следующем запросе пробелы, чтобы получить следующие результаты...
-- SELECT e.emp_id, e.fname, e.lname, b.name
-- FROM employee e INNER JOIN <1> b
-- 	 ON e.assigned_branch_id = b.<2>;

SELECT e.emp_id, e.fname, e.lname, b.name
FROM employee e INNER JOIN branch b
	ON e.assigned_branch_id = b.branch_id;

-- 5.2
-- Напишите запрос, по которому для каждого клиента-физического лица (customer.cut_type_cd = 'I')
-- возвращаются ID счета, федеральный ID (customer.fed_id) и тип созданного счета (product.name)

SELECT a.account_id, c.fed_id, p.name
FROM account a INNER JOIN customer c
	ON a.cust_id = c.cust_id
    INNER JOIN product p
    ON a.product_cd = p.product_cd
WHERE c.cust_type_cd = 'I';

-- 5.3 
-- Создайте запрос для выбора всех сотрудников, начальник которых приписан к другому отделу. Извлеките ID, имя и фамилию сотрудника

SELECT e1.emp_id, e1.fname, e1.lname
FROM employee e1 INNER JOIN employee e2
	ON e1.superior_emp_id = e2.emp_id
WHERE e1.dept_id != e2.dept_id;