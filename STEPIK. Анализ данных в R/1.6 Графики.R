df <-  mtcars
df$vs <-  factor(df$vs , labels = c("V", "S"))
df$am <-  factor(df$am , labels = c("Auto", "Manual"))

### основные графики
# гистограмма
hist(df$mpg, breaks = 20, xlab = "MPG")
# боксплот
boxplot(mpg ~ am, df, ylab = "MPG")
# скаттерплот
plot(df$mpg, df$hp)

### графики с помощью ggplot2
library(ggplot2)

# гистограмма
ggplot(df, aes(x = mpg))+
  geom_histogram(fill = "white", col = "black", binwidth = 2)
# точечная гистограмма
ggplot(df, aes(x = mpg))+
  geom_dotplot()
# функция плотности
ggplot(df, aes(x = mpg))+
  geom_density(fill = "blue")
# взаимосвязь 2 переменных
ggplot(df, aes(x = mpg, y = hp))+
  geom_point(size = 5)
# boxplot
ggplot(df, aes(x = am, y = hp))+
  geom_boxplot()

# примеры с разделением переменной по цветам
ggplot(df, aes(x = mpg, fill = am))+
  geom_dotplot()

ggplot(df, aes(x = mpg, fill = am))+
  geom_density(alpha = 0.2)

ggplot(df, aes(x = am, y = hp, col = vs))+
  geom_boxplot()

# взаимосвязь mpg&hp с разделением по цветам от типа двигателя
# размер точек зависит от qsec
ggplot(df, aes(x = mpg, y = hp, col = vs, size = qsec))+
  geom_point()

# сохранение графика в переменную
my_plot <- ggplot(df, aes(x = mpg, y = hp, col = vs, size = qsec))
my_plot + geom_point()

### Задачи
# При помощи функции ggplot() или boxplot() постройте график boxplot, 
# используя встроенные в R данные airquality. По оси x отложите номер месяца, 
# по оси y — значения переменной Ozone.
# На графике boxplot отдельными точками отображаются наблюдения, 
# отклоняющиеся от 1 или 3 квартиля больше чем на полтора межквартильных 
# размаха. Сколько таких наблюдений присутствует в сентябре (месяц №9)?
data(airquality)
ggplot(airquality, aes(x = as.factor(Month), y = Ozone))+
  geom_boxplot()
print("Ответ: 4")

# Используем знакомые нам данные mtcars. 
# Нужно построить scatterplot с помощью ggplot из ggplot2, 
# по оси x которого будет mpg, по оси y - disp, 
# а цветом отобразить переменную (hp).
# Полученный график нужно сохранить в переменную plot1.
data(mtcars)
plot1 <- ggplot(mtcars, aes(x = mpg, y = disp, col = hp))+
  geom_point()
plot1

# Укажите, при помощи какого варианта кода мы можем 
# построить следующий график по данным iris:
# Гистограмма распределения переменной Sepal.Length, в которой 
# цвет заполнения столбцов гистограммы зависит от значения переменной Species.
ggplot(iris, aes(Sepal.Length)) + geom_histogram(aes(fill = Species))
ggplot(iris, aes(Sepal.Length, fill = Species)) + geom_histogram()