### Подготовка данных
df <- iris

str(df)

# остаются только 2 группы
df1 <- subset(df, Species != "setosa")
table(df1$Species)

### Визуализация распределения и анализ
# распределение общее
hist(df1$Sepal.Length)

library(ggplot2)
# распределение по группам
ggplot(df1, aes(x = df1$Sepal.Length))+
  geom_histogram(fill = "white", col = "black", binwidth = 0.4)+
  facet_grid(Species ~ .)
# функция плотности
ggplot(df1, aes(Sepal.Length, fill = Species))+
  geom_density(alpha = 0.5)
# выбросы
ggplot(df1, aes(Species, Sepal.Length))+
  geom_boxplot()

### Проверка на нормальность распределения и гомогенность дисперсии
# Тест Шапиро-Уилка общий
shapiro.test(x = df1$Sepal.Length)
# p > 0.05 - нельзя отклонить H0(распределение не отличается от нормального)

# Тест Шапиро-Уилка по группам
shapiro.test(x = df1$Sepal.Length[df1$Species == "versicolor"])
shapiro.test(x = df1$Sepal.Length[df1$Species == "virginica"])
# p > 0.05 - нельзя отклонить H0(распределения не отличаются от нормального)

#  проверка Sepal.Length в трех разных группах в соответствии Species
by(iris$Sepal.Length, INDICES = iris$Species, shapiro.test) 


# Критерий Бартлетта - Проверка на гомогенность дисперсии
bartlett.test(Sepal.Length ~ Species, df1)
# p > 0.05 - нельзя отклонить H0(дисперсия гомогенна)

### T- критерий Стьюдента
# для независимых выборок
# Количественная переменная Sepal.Length разбивается на две группы из Species
t.test(Sepal.Length ~ Species, df1)

test1 <- t.test(Sepal.Length ~ Species, df1)
str(test1)
test1$p.value

# сравнение выборочного среднего с теоретическим значением
# (проверяется гипотеза, что среднее в ГС = 8 по данным df1$Sepal.Length)
t.test(df1$Sepal.Length, mu = 8)
# p < 0.05 - гипотеза отклоняется

# для зависимых выборок (paired = T)
# H0 Petal.Length = Petal.Width
t.test(df1$Petal.Length, df1$Petal.Width, paired = T)
# p < 0.05 - гипотеза отклоняется

### Визуализация результатов
# рассчет доверительного интервала
mean_cl_normal(df$Sepal.Length)

# отображение доверительных интервалов и среднего значения
ggplot(df1, aes(Species, Sepal.Length))+
  # доверительный интервал
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar",
               width = 0.1)+
  # среднее значение
  stat_summary(fun.y = mean, geom = "point", size = 2)

# альтернативный вариант отображения
ggplot(df1, aes(Species, Sepal.Length))+
  stat_summary(fun.data = mean_cl_normal, geom = "pointrange",
               size = 1)

### Непараметрический аналог т-теста (Тест Манна-Уитни)
# используется когда не выполняются условия т-теста 
# (мало данных, не норм. распределение)
wilcox.test(Petal.Length ~ Species, df1)
# p < 0.05 - H0 гипотеза отклоняется

ggplot(df1, aes(Species, Petal.Length))+
  geom_boxplot()

# проверка гипотезы для зависимых переменных
wilcox.test(df1$Petal.Length, df1$Petal.Width, paired = T)

### Задачи
# Воспользуемся еще одним встроенным набором данных в R - ToothGrowth. 
# Сравните среднее значение длины зубов свинок, которые потребляли 
# апельсиновый сок (OJ) с дозировкой 0.5 миллиграмм, со средним значением 
# длины зубов свинок, которые потребляли аскорбиновую кислоту (VC) 
# с дозировкой 2 миллиграмма. 
# Подготовка данных
data(ToothGrowth)
group1 <- subset(ToothGrowth, (supp == "OJ" & dose == 0.5))
group2 <- subset(ToothGrowth, (supp == "VC" & dose == 2))
# Проверка на ограничения т-теста
shapiro.test(x = group1$len)
shapiro.test(x = group2$len)
bartlett.test(len ~ supp, rbind(group1, group2))
# т-тест
t_stat <- t.test(group1$len, group2$len)$stat
# correct_data <- subset(ToothGrowth, supp=='OJ' & dose==0.5 | supp=='VC' & dose==2)    
# t_stat <- t.test(len ~ supp, correct_data)$statistic

# Данные, посвященные влиянию различного типа лечения на 
# показатель артериального давления. 
# По всем испытуемым сравните показатель давления до начала лечения 
# (Pressure_before) с показателем давления после лечения (Pressure_after) 
# при помощи t - критерия для зависимых выборок. 
remedy <- read.csv("https://stepik.org/media/attachments/lesson/11504/lekarstva.csv")
print(t.test(remedy$Pressure_before, remedy$Pressure_after, paired = T)$stat)

# В этом задании нужно проверить гипотезу о равенстве средних двух выборок, 
# загрузив набор данных и выполнив все необходимые операции на вашем компьютере.
# В скачанных данных вы найдете две переменные: количественную переменную, 
# и номинативную переменную с двумя градациями.
# Сначала с помощью теста Бартлетта проверьте гомогенность дисперсий 
# двух выборок. В случае, если дисперсии значимо не отличаются (с уровнем 0.05),
# примените тест Стьюдента, иначе - непараметрический тест (Манна-Уитни). 
data <- read.table("data_dataset_11504_15.txt")
bartlett_p <- bartlett.test(V1 ~ V2, data)$p.value
if (bartlett_p > 0.05){
  # если p>0.05, то дисперсия гомогенна и в т-тесте - var.equal = TRUE
  print(t.test(V1 ~ V2, data, var.equal = TRUE)$p.value)
} else {
  print(wilcox.test(V1 ~ V2, data)$p.value)
}

# В данных сохранены две количественные переменные, проверьте гипотезу о 
# равенстве средних этих переменных при помощи t- теста для независимых выборок.
# Если значимые различия не обнаружены, то в поле для ответа введите: 
# "The difference is not significant"
# Если обнаружены значимые различия(p< 0.05), то введите через пробел три числа: 
# среднее значение первой переменной, среднее значение второй переменной,
# p - уровень значимости.
data2 <- read.table("data_dataset_11504_16.txt")
p <- t.test(data2$V1, data2$V2)$p.value
if (p > 0.05){
  print("The difference is not significant")
} else{
  print(c(mean(data2$V1), mean(data2$V2), p))
}