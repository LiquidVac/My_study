/* В таблицу  traffic_violation занесены нарушения ПДД и соответствующие штрафы (в рублях). */
CREATE TABLE traffic_violation (
       violation_id INT PRIMARY KEY AUTO_INCREMENT,
       violation    VARCHAR(50),
       sum_fine     DECIMAL(8, 2));
       
INSERT INTO traffic_violation(violation, sum_fine)
VALUES ('Превышение скорости(от 20 до 40)', 500),
       ('Превышение скорости(от 40 до 60)', 1000),
       ('Проезд на запрещающий сигнал', 1000);

SELECT * FROM traffic_violation;

/* Задание 1
Создать таблицу fine следующей структуры:
В таблице fine  представлена информация о начисленных водителям штрафах за нарушения правил дорожного движения (ПДД) 
(фамилия водителя, номер машины, описание нарушения, сумма штрафа, дата совершения нарушения и дата оплаты штрафа). */
CREATE TABLE fine (
       fine_id        INT PRIMARY KEY AUTO_INCREMENT,
       name           VARCHAR(30),
       number_plate   VARCHAR(6),
       violation      VARCHAR(50),
       sum_fine       DECIMAL(8, 2),
       date_violation DATE,
       date_payment   DATE);

/* Задание 2
В таблицу fine первые 5 строк уже занесены. Добавить в таблицу записи с ключевыми значениями 6, 7, 8. */
INSERT INTO fine(name, number_plate, violation, sum_fine, date_violation, date_payment) 
VALUES ('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', 500.00, '2020-01-12', '2020-01-17'),
       ('Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', 1000.00, '2020-01-14', '2020-02-27'),
       ('Яковлев Г.Р.', 'Т330ТТ', 'Превышение скорости(от 20 до 40)', 500.00, '2020-01-23', '2020-02-23'),
       ('Яковлев Г.Р.', 'М701АА', 'Превышение скорости(от 20 до 40)', NULL, '2020-01-12', NULL),
       ('Колесов С.П.', 'К892АХ', 'Превышение скорости(от 20 до 40)', NULL, '2020-02-01', NULL),
	   ('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', NULL, '2020-02-14', NULL),
       ('Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', NULL, '2020-02-23', NULL),
       ('Яковлев Г.Р.', 'Т330ТТ', 'Проезд на запрещающий сигнал', NULL, '2020-03-03', NULL);
       
SELECT * FROM fine;

/* Задание 3
Занести в таблицу fine суммы штрафов, которые должен оплатить водитель, в соответствии с данными из таблицы traffic_violation. 
При этом суммы заносить только в пустые поля столбца  sum_fine. */
UPDATE fine f, traffic_violation tv
   SET f.sum_fine = tv.sum_fine
 WHERE (f.violation = tv.violation) AND
       (f.sum_fine IS NULL);
 
 SELECT * FROM fine;
 
/* Задание 4
Вывести фамилию, номер машины и нарушение только для тех водителей, которые на одной машине нарушили одно и то же 
правило   два и более раз. При этом учитывать все нарушения, независимо от того оплачены они или нет. Информацию 
отсортировать в алфавитном порядке, сначала по фамилии водителя, потом по номеру машины и, наконец, по нарушению. */
SELECT name, number_plate, violation 
  FROM fine
 GROUP BY name, number_plate, violation
HAVING COUNT(*) > 1;

/* Задание 5
В таблице fine увеличить в два раза сумму неоплаченных штрафов для отобранных на предыдущем шаге записей. */
UPDATE fine, 
       (SELECT name, number_plate, violation 
       FROM fine
       GROUP BY name, number_plate, violation
       HAVING COUNT(*) > 1) AS persistent_offenders
   SET fine.sum_fine = fine.sum_fine * 2
 WHERE ((fine.name, fine.number_plate, fine.violation) = 
       (persistent_offenders.name, persistent_offenders.number_plate, 
        persistent_offenders.violation)) AND
       (fine.date_payment IS NULL);

 SELECT * FROM fine;