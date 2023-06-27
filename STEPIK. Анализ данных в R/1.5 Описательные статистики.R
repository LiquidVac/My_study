?mtcars
df <- mtcars

str(df) # структура df

### переопределение переменных в фактор
df$vs <-  factor(df$vs , labels = c("V", "S")) 
df$am <-  factor(df$am , labels = c("Auto", "Manual"))

### описательные статистики
median(df$mpg) # медиана
mean(df$disp) # среднее
sd(df$hp) # стандартное отклонение
range(df$cyl) # размах

### описательные статистики + условия
mean(df$mpg[df$cyl == 6])
mean(df$mpg[df$cyl == 6 & df$vs == "V"])
sd(df$hp[df$cyl != 3 & df$am == "Auto"])

### aggregate
# группировка переменных hp по vs, функция - среднее
mean_hp_vs <- aggregate(x = df$hp, by = list(df$vs), FUN = mean)
colnames(mean_hp_vs) <- c("VS", "Mean HP") # переименование столбцов

aggregate(hp ~ vs, df, mean) # запись в виде "формулы"

# группировка по 2 переменным
aggregate(x = df$hp, by = list(df$vs, df$am), FUN = mean)
aggregate(hp ~ vs + am, df, mean) # запись в виде "формулы"

# группировка всех столбцов по am
aggregate(x = df[, -c(8,9)], by = list(df$am), FUN = median)

# группировка 2 стобцов по 2 переменным
aggregate(df[, c(1,3)], by = list(df$am, df$vs), FUN = sd)
aggregate(cbind(mpg, disp) ~ am + vs, df, sd) # запись в виде "формулы"

### функции библиотеки psych
library(psych) # для рассчета описательных статистик

# рассчет базовых описательных статистик
describe(x = df) 

# рассчет базовых описательных статистик для групп
descr <-  describeBy(x = df, group = df$vs) # вывод в виде списка
descr$V # обращение к группам списка
descr$S

# вывод в виде датафрейма
descr2 <-  describeBy(x = df, group = df$vs, mat = T, digits = 1)
# fast - T  рассчитывает только основные описательные статистики
descr3 <-  describeBy(x = df, group = df$vs, mat = T, digits = 1, fast = T)

# группировка по 2 переменным
describeBy(df$qsec, group = list(df$vs, df$am), mat = T, digits = 1, fast = T)

### действия с NA
df$mpg[1:10] <-  NA
# проверка на наличие NA
sum(is.na(df))
# удаление NA из расчета
mean(df$mpg, na.rm = T)
describeBy(df, df$vs, na.rm = T)

### Задачи
# Вновь вернемся к данным mtcars. Рассчитайте среднее значение времени разгона 
# (qsec) для автомобилей, число цилиндров (cyl) у которых не равняется 3 
# и показатель количества миль на галлон топлива (mpg) больше 20.
# Получившийся результат (среднее значение) сохраните в переменную result.
data(mtcars)
result <- mean(mtcars$qsec[mtcars$cyl != 3 & mtcars$mpg > 20])

# При помощи функции aggregate рассчитайте стандартное отклонение переменной 
# hp (лошадиные силы) и переменной disp (вместимости двигателя)  у машин 
# с автоматической и ручной коробкой передач. 
# Полученные результаты (результаты выполнения функции aggregate) сохраните 
# в переменную descriptions_stat.
descriptions_stat <-  aggregate(cbind(hp, disp) ~ am, mtcars, sd)

# Воспользуемся встроенными данными airquality. В новую переменную сохраните 
# subset исходных данных, оставив наблюдения только для месяцев 7, 8 и 9.
# При помощи функции aggregate рассчитайте количество непропущенных наблюдений 
# по переменной Ozone в 7, 8 и 9 месяце. Для определения количества наблюдений 
# используйте функцию length().
# Результат выполнения функции aggregate сохраните в переменную result.
data(airquality)
mini_airquality <- subset(airquality, Month %in% c(7, 8, 9))
result <- aggregate(Ozone ~ Month , mini_airquality, length)
# result <- aggregate(Ozone ~ Month, airquality,
#              subset = Month %in% c(7,8,9), length) 
                    
# Примените функцию describeBy к количественным переменным данных airquality, 
# группируя наблюдения по переменной Month. Чему равен коэффициент 
# асимметрии (skew) переменной Wind в восьмом месяце?
desc <- describeBy(airquality$Wind, group = airquality$Month, 
                   mat = T, digits = 1)
desc$skew[4]

# Обратимся к встроенным данным iris. Соотнесите значения 
# стандартного отклонения переменных.
data(iris)
describe(iris)[,c(1,4)]

# В данных iris расположите по убыванию значения медиан количественных 
# переменных в группе virginica.
aggregate(x = iris[, -5], by = list(iris$Species), FUN = median)[3,]
#sort(sapply(iris[iris$Species =='virginica',][-5], FUN=median), dec = T)

# В переменной my_vector сохранен вектор с пропущенными значениями. 
# Вам нужно создать новый вектор fixed_vector, в котором все 
# пропущенные значения вектора my_vector будут заменены на 
# среднее значение по имеющимся наблюдениям.
my_vector <- rnorm(30)
my_vector[sample(1:30, 10)] <- NA # на десять случайных позиций поместим NA

fixed_vector <- replace(my_vector, is.na(my_vector), mean(my_vector, na.rm = T))

