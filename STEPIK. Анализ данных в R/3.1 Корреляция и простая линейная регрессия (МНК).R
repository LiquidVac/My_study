df <- mtcars

### Рассчет корреляции между 2 переменными
# по умолчанию коэффициент Пирсона
cor.test(x = df$mpg, y = df$hp)
#cor.test(x = df$mpg, y = df$hp, method = "kendall")

fit <- cor.test(x = df$mpg, y = df$hp)
fit$p.value
str(fit)
# запись через формулу
cor.test(~ mpg + hp, df)

### Диаграмма рассеивания
plot(~ mpg + hp, df)
# взаимосвязь нелинейна

library(ggplot2)
ggplot(df, aes(x=mpg, y = hp, col = factor(cyl)))+
  geom_point(size = 5)

### Рассчет корреляции между несколькими переменными
df_numeric <- df[, c(1, 3:7)] # только количественные переменные

# диаграмма рассеивания для каждой пары переменных
pairs(df_numeric)

# рассчет корреляции для каждой пары переменных
cor(df_numeric)

# рассчет корреляции для каждой пары переменных с помощью psych
library(psych)
fit <- corr.test(df_numeric)
fit
# матрица корреляции
fit$r
# матрица p-value
fit$p

### Линейная регрессия
fit <- lm(mpg ~ hp, df)
summary(fit) # Call - формула
             # Residuals - описательные стаистики для остатков
             # Coefficients - результаты для модели

ggplot(df, aes(hp, mpg))+
  geom_point(size = 5)+
  geom_smooth(method = "lm")+  # линейная прямая с доверительным интервалом
  facet_grid(.~cyl)

### Предсказанные значения
fit$fitted.values
fitted_values_mpg <- data.frame(mpg = df$mpg, fitted = fit$fitted.values)
fitted_values_mpg$fitted

ggplot(fitted_values_mpg, aes( mpg, fitted)) +
  geom_point(size=5 )
# график показывает как отличается предсказанное значение от реального.
# Если бы разница в предсказаниях была бы 0 но на графике была бы линия.

### Предсказание значений для новых переменных
fit <- lm(mpg ~ hp, df)
new_hp <- data.frame(hp = c(100, 150, 129, 300))
new_hp$mpg <- predict(fit, new_hp)
new_hp

### Использование ЛР, в качестве предиктора номинативная переменная
my_df <- mtcars

fit <- lm(mpg ~ cyl, my_df)
summary(fit)

ggplot(my_df, aes(cyl, mpg))+
  geom_point()+
  geom_smooth(method = "lm")+  # линейная прямая с доверительным интервалом
  theme(axis.text = element_text(size=25),
        axis.title = element_text(size=25, face="bold"))

# перевод независимой переменной в фактор
my_df$cyl <- factor(my_df$cyl, labels = c("four", "six", "eight"))
fit <- lm(mpg ~ cyl, my_df)
# здесь Estimate - изменение среднего mpg при переходе с "базовой"(four) в иную группу
# если p < 0.05, то среднее значимо изменяется при переходе с "базовой" группы
summary(fit)

aggregate(mpg ~ cyl, my_df, mean)

ggplot(my_df, aes(cyl, mpg))+
  geom_point()+
  theme(axis.text = element_text(size=25),
        axis.title = element_text(size=25, face="bold"))

### Задачи
# Напишите функцию corr.calc, которая на вход получает data.frame с двумя 
# количественными переменными, рассчитывает коэффициент корреляции Пирсона 
# и возвращает вектор из двух значений: 
# коэффициент корреляции и p - уровень значимости.
data(mtcars)
data(iris)
corr.calc <- function(x){
  fit <- cor.test(~., x)
  c <- fit$estimate[[1]]
  p <- fit$p.value
  return(c(c, p))
}
corr.calc(mtcars[, c(1,5)])
corr.calc(iris[,1:2])

# Напишите функцию filtered.cor которая на вход получает data.frame с 
# произвольным количеством переменных (как количественными, так и любых 
# других типов), рассчитывает коэффициенты корреляции Пирсона между 
# всеми парами количественных переменных и возвращает наибольшее 
# по модулю значение коэффициента корреляции.
# Гарантируется наличие в data.frame хотя бы двух количественных переменных.
# Данные для тренировки: https://stepic.org/media/attachments/lesson/11504/step6.csv
filtered.cor <- function(x){
  temp_x <- x[, sapply(x , is.numeric)] # выбраны только количественные переменные
  fit <- cor(temp_x)
  diag(fit) <- 0 # корреляция переменной с собой = 0
  max <- max(fit)
  min <- min(fit)
  return(ifelse(abs(max) > abs(min), max, min))
#  return(fit[which.max(abs(fit))])
}
# test <- read.csv("https://stepic.org/media/attachments/lesson/11504/step6.csv")
# str(test)
# filtered.cor(test)
filtered.cor(iris)

# Напишите функцию smart_cor, которая получает на вход dataframe 
# с двумя количественными переменными. Проверьте с помощью теста Шапиро-Уилка, 
# что данные в обеих переменных принадлежат нормальному распределению.
# Если хотя бы в одном векторе распределение переменной 
# отличается от нормального (p - value меньше 0.05), то функция должна 
# возвращать коэффициент корреляции Спирмена.(Числовой вектор из одного элемента).
# Если в обоих векторах распределение переменных от нормального значимо 
# не отличается, то функция должна возвращать коэффициент корреляции Пирсона.
smart_cor <- function(x){
  if ((shapiro.test(x[[1]])$p.value < 0.05) | 
      (shapiro.test(x[[2]])$p.value < 0.05)){
    cor <- cor.test(~., x, method = "spearman")$estimate[[1]]
  }
  else{
    cor <- cor.test(~., x)$estimate[[1]]
  }
  return(cor)
}
test_data <- read.csv("https://stepik.org/media/attachments/course/129/test_data.csv")
smart_cor(test_data)

# Скачайте набор данных - dataframe с двумя количественными переменными,
# постройте линейную регрессию, где - 
# первая переменная - зависимая, вторая - независимая. 
#В ответ укажите значения регрессионных коэффициентов сначала intercept затем  slope.
data <- read.csv('data_dataset_11508_12.txt', sep = "", head = F, dec = '.')
fit <- lm(V1 ~ V2, data)
intercept <- fit$coef[[1]]
slope <- fit$coef[[2]]
print(c(intercept, slope))

# Воспользуемся данными diamonds из библиотеки ggplot2. 
# Только для бриллиантов класса Ideal (переменная cut) 
# c числом карат равным 0.46 (переменная carat) постройте линейную регрессию, 
# где в качестве зависимой переменной выступает price, 
# в качестве предиктора - переменная  depth. 
# Сохраните коэффициенты регрессии в переменную fit_coef.
data(diamonds)
diamonds_df <- subset(diamonds, (carat == 0.46 & cut == "Ideal"))
fit_coef <- lm(price ~ depth, diamonds_df)$coefficients
fit_coef

# Напишите функцию regr.calc, которая на вход 
# получает dataframe c двумя переменными.
# Если две переменные значимо коррелируют, то функция строит 
# регрессионную модель, где первая переменная - зависимая, вторая - независимая. 
# Затем создает в dataframe новую переменную с назанием fit, 
# где сохраняет предсказанные моделью значения зависимой переменной. 
# В результате функция должна возвращать исходный dataframe 
# с добавленной новой переменной fit.
# Если две переменные значимо не коррелируют, то функция возвращает строчку 
# "There is no sense in prediction"
regr.calc <- function(x){
  cor_p <- cor.test(~., x)$p.value
  if (cor_p > 0.05){
    return(print("There is no sense in prediction"))
  }
  else{
    fit <- lm(x[[1]] ~ x[[2]])
    x$fit <- predict(fit, x[2])
  #  x$fit  <- fit$fitted.values
    return(x)
  }
}
my_df = iris[,1:2] 
regr.calc(iris[,1:2]) # переменные значимо не коррелируют 

my_df = iris[,c(1,4)] 
regr.calc(my_df) # переменные значимо коррелируют 


# Постройте scatterplot по данным iris, сохранив его в переменную my_plot : 
# Ось X - переменная Sepal.Width
# Ось Y -  переменная Petal.Width
# Цвет точек - переменная Species
# Также добавьте линейное сглаживание для каждой группы 
# наблюдений по переменной Species.
my_plot <- ggplot(iris, aes(Sepal.Width, Petal.Width, col = Species))+
  geom_point()+
  geom_smooth(method = "lm")
my_plot


### Памятка
cor.test(mtcars$mpg, mtcars$disp) # Расчет корреляции Пирсона 
cor.test(~ mpg + disp, mtcars) # запись через формулу
cor.test(mtcars$mpg, mtcars$disp, method = "spearman") # Расчет корреляции Спирмена 
cor.test(mtcars$mpg, mtcars$disp, method = "kendall") # Расчет корреляции Кендала 
cor(iris[, -5]) # построение корреляционной матрицы
fit <- lm(mpg ~ disp, mtcars) # построение линейной регрессии 
fit$coefficients # коэффициенты регрессии 
fit$fitted.values # предсказанные значения зависимой переменной 

# Если в ваших данных есть одинаковые наблюдения, но вы хотите рассчитать 
# непараметрическую корреляцию, используйте функцию spearman_test  из пакета coin
library(coin)
spearman_test(~ mpg + disp, mtcars)

# Обратите внимание на различия в графиках. 
# То что в первом aes() будет распространяться на все слои. 
# А то, что в aes() конкретного geom - только на него.
ggplot(mtcars, aes(mpg, disp, col = factor(am)))+
  geom_point()+
  geom_smooth()

ggplot(mtcars, aes(mpg, disp))+
  geom_point(aes(col = factor(am)))+
  geom_smooth()

ggplot(mtcars, aes(mpg, disp))+
  geom_point()+
  geom_smooth(aes(col = factor(am)))
