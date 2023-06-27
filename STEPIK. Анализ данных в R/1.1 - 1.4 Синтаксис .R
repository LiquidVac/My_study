###### 1.2 Синтаксис R
### хоткеи
# shif t+ ctrl + стрелки влево/вправо для выделения переменных
# shift + alt + стрелка вниз/вверх дублирует строку. 
# alt + дефис = <-
# ctrl + shift + H для смены рабочей директории.
# ctrl + shift + c комментирование

### операторы
# Арифметические операции:
# + сложение
# - вычитание
# * умножение
# / деление 
# ^ или **  возведение в степень 
# x %% y остаток от деления (5 %% 2 = 1)
# x %/% y целая часть от деления (5 %/% 2 = 2)

# Для сравнения:
# равенство ==
# неравенство !=
# больше >  
# меньше < 
# !x не x
# x | y - x или y
# x & y - x и y

# Для присвоения значений:
# "<-"  : a <- 34
# "->"  : 34 -> a
# "="   : a = 34

# TRUE  можно сокращенно обозначать T
# FALSE можно сокращенно обозначать F

### вектор
a <-  1:5 # последовательность чисел 1,2,3,4,5
b <- c(1,3,5,-6,7) # набор чисел 1,3,5
b[2] # обращение к числу внутри вектора (порядок чисел начинается с 1)
b[c(1,3,4)] # обращение к нескольким числам внутри вектора
c <- c(a, b) # сложение векторов

### операции с векторами
c + 10 # прибавление 10 к каждому элементу вектора
c == 0 # сравнение всех элементов с 0
c[c < 0] # вывод всех элементов меньше 0
c[c > 2 & c < 5] # вывод элементов больше 2 и меньше 5

### list
age <- c(16, 18, 22, 27)
is_married <-  c(F, F, T, T)
name <- c("Olga", "Maria", "Nastya", "Polina")

data <- list(age, is_married, name)

data[[1]] # выбор "уровня" (6, 18, 22, 27)
data[[2]][3] # выбор элемента (TRUE)


###### 1.3 Работа с data Frame
### data frame
df <-  data.frame(Name = name, Age = age, Status = is_married)

mydata <-  read.csv("https://stepic.org/media/attachments/lesson/11481/evals.csv") # чтение данных из csv

### data description
head(mydata, 3) # последние 3 записи
tail(mydata) # последние записи (по умолчанию 6)

View(mydata) # вывод данных в отдельное окно
str(mydata) # структура данных
names(mydata) # переменные
summary(mydata) # статистика по переменным

nrow(mydata) # кол-во столбцов
ncol(mydata) # кол-во колонок

# variables
mydata$score # выбор столбца по названию
mydata$ten_point_scale <-  mydata$score * 2 # создание нового столбца
mydata$new_variable <- 0 # создание нового столбца
mydata$number <- 1:nrow(mydata) # создание нового столбца

### subsetting
mydata$score[1:10] # выбор первого столбца с 1 по 10 строку

mydata[1,1] # выбор первое значение первого столбца
mydata[c(2,193,255), 1] # выбор 3 значения из первого столбца
mydata[100:110, 1] # выбор с 100 по 110 значения первого столбца
mydata[5, ]  # 5 строка, все столбцы
mydata[ , 1] # все строки, первый столбец
mydata[ ,2:5] # все строки, со 2 по 5 столбец

### subsetting with condition
mydata[mydata$gender == 'female', 1] # первый столбец, только female
subset(mydata, gender == 'female', select = score) # тоже самое

### rbind, cbind
mydata2 <-  subset(mydata, gender == 'female')
mydata3 <-  subset(mydata, gender == 'male')
mydata4 <- rbind(mydata2, mydata3) # сложение по строкам

mydata5 <-  mydata[, 1:10]
mydata6 <-  mydata[, 11:24]
mydata7 <- cbind(mydata5, mydata6) # сложение по стобцам

### datasets
library(help = "datasets") # список доступных датасетов
data(mtcars) # загрузка датасета
help(mtcars) # описание датасета

### Задачи
# В этой задче поработаем со встроенными данными mtcars. 
# В датафрэйме mtcars создайте новую колонку (переменную) под названием 
# even_gear, в которой будут единицы, если значение переменной
# (gear) четное, и нули если количество нечетное.
mtcars$even_gear <-  (mtcars$gear+1) %% 2
#mtcars$even_gear <- ifelse(mtcars$gear %% 2 ==1 , 0,1)

# Продолжим нашу работу с данными mtcars. Теперь ваша задача создать 
# переменную - вектор mpg_4 и сохранить в нее значения расхода топлива (mpg) 
# для машин с четырьмя цилиндрами (cyl).
mpg_4 <- mtcars[mtcars$cyl == 4, 1]

# Ваша задача создать новый dataframe под названием mini_mtcars, 
# в котором будут сохранены только третья, седьмая, десятая, s
# двенадцатая и последняя строчка датафрейма mtcars.
mini_mtcars <- mtcars[c(3, 7, 10, 12), ]
mini_mtcars <- rbind(mini_mtcars, tail(mtcars, 1))

# Команда создаст сабсет данных mtcars, только для тех автомобилей, 
# у которых число цилиндров (cyl) не равняется 3, 
# и время разгона автомобиля (qsec) больше среднего по выборке.
new_data <- subset(mtcars, cyl != 3 & qsec > mean(qsec))


###### Синтаксис if & for
### if
a <- -10

if (a > 0){
  print('True')
} else if(a == 0){
  print('zero')
} else{
  print('False')
  a <- a+1
}

### ifelse
a <- c(1, -1) # с помощью ifelse можно проверять вектора
ifelse(a > 0, 'True', 'False')

### for 
for (i in 1:nrow(mydata)){
  print(mydata$score[i])
}

### for + if VS ifelse
mydata$quality <-  rep(NA, nrow(mydata)) # создание столбца со значением NA

# for + if
for (i in 1:nrow(mydata)){
  if (mydata$score[i] > 4){
    mydata$quality[i] <- 'good'
  } else mydata$quality[i] <- 'bad'
}

# ifelse
mydata$quality <-  ifelse(mydata$score > 4, 'good', 'bad')

### while
i <- 1
while (i < 11){
  print(i)
  print(mydata$score[i])
  i <-  i+1
}

### Задачи
data(mtcars)
# Создайте новую числовую переменную  new_var в данных mtcars, 
# которая содержит единицы в строчках, если в машине не меньше четырёх 
# карбюраторов(переменная "carb") или больше шести цилиндров(переменная "cyl").
# В строчках, в которых условие не выполняется, должны стоять нули.
mtcars$new_var <-  ifelse(((mtcars$carb >= 4) | (mtcars$cyl > 6)), 1, 0)



# Cоздать переменную good_months и сохранить в нее число пассажиров
# только в тех месяцах, в которых это число больше, чем показатель в 
# предыдущем месяце.
data(AirPassengers)
?AirPassengers
str(AirPassengers)
vectorAP <- as.vector(AirPassengers) # перевод Time-Series в вектор

good_months <- vector(mode = "numeric", length = 0)
for (i in 2:length(vectorAP)){
  if (vectorAP[i] > vectorAP[i-1]){
    good_months <- c(good_months, vectorAP[i])
  }
}

# Для встроенных в R данных AirPassengers рассчитайте скользящее среднее 
# с интервалом сглаживания равным 10.
vectorAP <- as.vector(AirPassengers)
moving_average <- vector(mode = "numeric", length = 0)
for (i in 1:(length(vectorAP)-9)){
  average_of_ten <- mean(vectorAP[i:(i+9)])
  moving_average <- c(moving_average, average_of_ten)
  print(average_of_ten)
}

# Можно решить и без цикла при помощи разностей кумулятивных сумм    
n <- 10    
d <- vectorAP 
cx <- c(0, cumsum(d))    
moving_average <- (cx[(n + 1):length(cx)] - cx[1:(length(cx) - n)]) / n
