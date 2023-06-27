# Преобразование в factor
df <- read.csv("https://stepik.org/media/attachments/lesson/11502/grants.csv"
               , stringsAsFactors = T) # преобразование строки в фактор
str(df)

# преобразование номинативной переменной в фактор
df$status <- as.factor(df$status) 

levels(df$status) # "уровни" фактора
levels(df$status) <- c("Not funded", "Funded") # переименование уровней

# df$status <- factor(df$status, levels = c(0, 1), 
#                    labels = c("Not Funded", "Funded"))

# Таблица с одной переменной
t1 <- table(df$status) # показывает сколько наблюдений в каждом классе
t1

dim(t1) # размерность таблицы

# Таблица сопряженности по 2 переменным
t2 <- table(df$status, df$field)
t2

dim(t2) # 2 строки, 5 столбцов

prop.table(t2) # преобразует кол-во наблюдений в пропорции
prop.table(t2, 1) # сумма строчек = 100%
prop.table(t2, 2) # сумма столбцов = 100%

# Трехмерная таблица
t3 <- table(Years = df$years_in_uni, Field = df$field, Status = df$status)
t3

dim(t3) # 3 строки, 5 столбцов, 2 группы

# Графики
barplot(t1) 
barplot(t2)
# график с легендой
barplot(t2, legend.text = T, args.legend = list(x = "topright"), beside = T)

mosaicplot(t2)

### Биноминаоьный тест
# x - кол-во исходов, n - кол-во наблюдений, p - вероятность успешного исхода
binom.test(x = 5, n = 20, p = 0.5)
# p-value - какова вероятность, что из 20 наблюдений, 
# успешная вероятность исхода случится 5 или менее раз. 

binom.test(t1)
# H0 - не может быть отвергнута.
# Нельзя сказать что Not funded чаще чем funded 

### Хи-квадрат Пирсона
chisq.test(t1)
# H0 - вероятность распределены равномерно (Not founded и founded)
# p-value позволяет отвергнуть H0
# вероятность Not founded чуть выше, чем founded

# обращение к результатам теста
chi <- chisq.test(t1)
chi$exp # ожидаемые значения
chi$obs # наблюдаемые значения


chisq.test(t2)
### Критерий Фишера
fisher.test(t2)

### Задачи
# HairEyeColor - таблица с данными, встроенными в R.
# Ваша задача в переменную red_men сохранить долю рыжеволосых(Red) 
# от общего числа голубоглазых мужчин.
data(HairEyeColor)
red_men <- prop.table(HairEyeColor[,'Blue','Male'])["Red"]
# prop.table(HairEyeColor[ , ,'Male'],2)['Red','Blue']

# Напишите число зеленоглазых женщин в наборе данных HairEyeColor.
sum(HairEyeColor[ , "Green",'Female'])

# Постройте столбчатую диаграмму распределения цвета глаз по цвету волос 
# только у женщин из таблицы HairEyeColor. По оси X должен идти цвет волос, 
# цвет столбиков должен отражать цвет глаз. По оси Y - количество наблюдений.
mydata <- as.data.frame(HairEyeColor) # преобразование в dataframe
library("ggplot2")
female_data = subset(mydata, Sex == "Female")
obj <- ggplot(data = female_data, aes(x = Hair, y = Freq, fill = Eye)) + 
  geom_bar(stat="identity", position = "dodge") + 
  scale_fill_manual(values=c("Brown", "Blue", "Darkgrey", "Darkgreen"))
obj

# На основе таблицы HairEyeColor создайте ещё одну таблицу, в которой хранится 
# информация о распределении цвета глаз у женщин-шатенок (Hair = 'Brown'). 
# Проведите тест равномерности распределения цвета глаз у шатенок 
# и выведите значение хи-квадрата для этого теста.
chisq.test(HairEyeColor["Brown",,"Female"])$stat

# Воспользуемся данными diamonds из библиотеки ggplot2. 
# При помощи критерия Хи - квадрат проверьте гипотезу о взаимосвязи 
# качества огранки бриллианта (сut) и его цвета (color). 
# В переменную main_stat сохраните значение статистики критерия Хи - квадрат. 
# Обратите внимание, main_stat должен быть вектором из одного элемента.
data(diamonds)
diamonds_table <- table(diamonds$cut, diamonds$color)
main_stat <- chisq.test(diamonds_table)$stat

# При помощи критерия Хи - квадрат проверьте гипотезу о взаимосвязи 
# цены (price) и каратов (carat) бриллиантов. Для этого сначала нужно 
# перевести эти количественные переменные в формат пригодный для Хи - квадрат. 
# Создайте две новые переменные в данных diamonds:
# factor_price - где будет 1, если значение цены больше либо равно чем среднее, 
# и 0, если значение цены ниже среднего цены по выборке.
# factor_carat - где будет 1, если число карат больше либо равно чем среднее, 
# и 0, если ниже среднего числа карат по выборке.
# Используя эти шкалы при помощи Хи - квадрат проверьте исходную гипотезу. 
# Сохраните в переменную main_stat значение критерия  Хи - квадрат.
diamonds$factor_price <- ifelse(diamonds$price >= mean(diamonds$price), 1,0)
diamonds$factor_carat <- ifelse(diamonds$carat >= mean(diamonds$carat), 1,0)

main_stat <- chisq.test(table(diamonds$factor_price, 
                              diamonds$factor_carat))$stat

# При помощи точного критерия Фишера проверьте гипотезу о взаимосвязи 
# типа коробки передач (am) и типа двигателя (vs) в данных mtcars. 
# Результат выполнения критерия сохраните в переменную.
# Получившийся p - уровень значимости сохраните в переменную fisher_test.
data(mtcars)
fisher_test <- fisher.test(table(mtcars$am, 
                  mtcars$vs))$p.value

# tbl <- table(mtcars$am, mtcars$vs)    
# fit <- fisher.test(tbl)    
# fisher_test_master = fit$p.value