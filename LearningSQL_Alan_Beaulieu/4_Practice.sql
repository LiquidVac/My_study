-- 4.1
-- Какие ID транзакций возвращают следующие условия фильтрации?
-- txn_date < '2005-02-26' AND (txn_type_cd = 'DBT' OR amount > 100)

CREATE TABLE  txn_practice
(txn_id SMALLINT UNSIGNED auto_increment,
txn_date DATE,
account_id SMALLINT UNSIGNED,
txn_type_cd VARCHAR (20),
amount float(10,2),
CONSTRAINT pk_txn_practice PRIMARY KEY (txn_id));

INSERT INTO txn_practice
(txn_id, txn_date, account_id, txn_type_cd, amount)
VALUES (null, '2005-02-22', '101', 'CDT', '1000.00');
INSERT INTO txn_practice
(txn_id, txn_date, account_id, txn_type_cd, amount)
VALUES (null, '2005-02-23', '102', 'CDT', '525.75');
INSERT INTO txn_practice
(txn_id, txn_date, account_id, txn_type_cd, amount)
VALUES (null, '2005-02-24', '101', 'DBT', '100.00');
INSERT INTO txn_practice
(txn_id, txn_date, account_id, txn_type_cd, amount)
VALUES (null, '2005-02-24', '103', 'CDT', '55');
INSERT INTO txn_practice
(txn_id, txn_date, account_id, txn_type_cd, amount)
VALUES (null, '2005-02-25', '101', 'DBT', '50');
INSERT INTO txn_practice
(txn_id, txn_date, account_id, txn_type_cd, amount)
VALUES (null, '2005-02-25', '103', 'DBT', '25');
INSERT INTO txn_practice
(txn_id, txn_date, account_id, txn_type_cd, amount)
VALUES (null, '2005-02-25', '102', 'CDT', '125.37');
INSERT INTO txn_practice
(txn_id, txn_date, account_id, txn_type_cd, amount)
VALUES (null, '2005-02-26', '103', 'DBT', '10');
INSERT INTO txn_practice
(txn_id, txn_date, account_id, txn_type_cd, amount)
VALUES (null, '2005-02-27', '101', 'CDT', '75');

SELECT txn_id
FROM txn_practice
WHERE txn_date < '2005-02-26' AND (txn_type_cd = 'DBT' OR amount > 100);

# Ответ: 1,2,3,5,6,7

-- 4.2
-- Какие ID транзакций возвращают следующие условия фильтрации?
-- account_id IN (101,103) AND NOT (txn_type_cd = 'DBT' OR amount > 100)

SELECT txn_id
FROM txn_practice
WHERE account_id IN (101,103) AND NOT (txn_type_cd = 'DBT' OR amount > 100);

# Ответ: 4,9

-- 4.3
-- Создайте запрос, выбирающий все счета, открытые в 2002 году.

SELECT * 
FROM account
WHERE open_date BETWEEN '2002-01-01' AND '2002-12-31';


-- 4.4
-- Создайте запрос, выбирающий всех клиентов-физических лиц,
-- второй буквой фамилии которых является буква 'a' и есть 'e' в любой позиции после 'a'.

SELECT * 
FROM individual
WHERE lname LIKE '_a%e%';


DROP TABLE txn_practice;