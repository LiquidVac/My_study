data(swiss)
str(swiss)

### Связь между переменными
pairs(swiss)

ggplot(swiss, aes(x = Examination, y = Education)) +
  geom_point()+
  theme(axis.text=element_text(size=25),
        axis.title=element_text(size=25, face="bold"))

### Выбросы
ggplot(swiss, aes(x = Examination, y = Education)) +
  geom_point()+
  theme(axis.text=element_text(size=25),
        axis.title=element_text(size=25, face="bold")) +
  geom_smooth(method = 'lm')

### Нормальность распределения
ggplot(swiss, aes(x = Examination))+
  geom_histogram()

# распределение не нормальное
ggplot(swiss, aes(x = Education))+
  geom_histogram()

# преобразование графика
ggplot(swiss, aes(x = log(Education)))+
  geom_histogram()

### Линейность взаимосвязи между зависимой и независимой переменными
# диаграмма рассеивания связи между переменными + линия тренда
ggplot(data = swiss, aes(Examination, Education)) +
  geom_point() +
  geom_smooth()
# из графика видно что связь  нелинейна
lm1 <- lm(Education ~ Examination, swiss)
summary(lm1)
#  R-squared:  0.4878

swiss$Examination_squared <- (swiss$Examination)^2
lm2 <- lm(Education ~ Examination + Examination_squared, swiss)
summary(lm2)
# R-squared:  0.5898

anova(lm2, lm1)
# p = 0.001877, разница между моделями значима

# добавление предсказанных моделями значений
swiss$lm1_fitted <- lm1$fitted
swiss$lm2_fitted <- lm2$fitted
# добавление остатков
swiss$lm1_resid <- lm1$resid
swiss$lm2_resid <- lm2$resid
# номер строчки
swiss$obs_number <- 1:nrow(swiss)

# сравнение предсказаний моделей
ggplot(swiss, aes(x = Examination, y = Education)) +
  geom_point(size = 3) +
  geom_line(aes(x = Examination, y = lm1_fitted), col = 'red', lwd = 1) +
  geom_line(aes(x = Examination, y = lm2_fitted), col = 'blue', lwd = 1)

# ось x - предсказанные значения, ось y - остатки
ggplot(swiss, aes(x = lm1_fitted, y = lm1_resid)) +
  geom_point(size = 3) + 
  geom_hline(yintercept = 0, col = "red", lwd = 1)
# из графика видно, что взаимосвязь нелинейна

# остатки распределены примерно поровну снизу и сверху линии
ggplot(swiss, aes(x = lm2_fitted, y = lm2_resid)) +
  geom_point(size = 3) + 
  geom_hline(yintercept = 0, col = "blue", lwd = 1)

### Независимость остатков
# остатки не сгруппированы по каким либо категориям
# по оси х - номера наблюдений, по оси у остатки модели
ggplot(swiss, aes(x = obs_number, y = lm1_resid)) +
  geom_point(size = 3) + 
  geom_smooth()
# нет группировок но есть некоторый скос (в идеале - ровная линия)

ggplot(swiss, aes(x = obs_number, y = lm2_resid)) +
  geom_point(size = 3) + 
  geom_smooth()
# та же проблема

### Гомоскедастичность
# разброс ошибок должен быть одинаковым
ggplot(swiss, aes(x = lm1_fitted, y = lm1_resid)) +
  geom_point(size = 3)
# разброс изменяется на протяжении вектора модели

ggplot(swiss, aes(x = lm2_fitted, y = lm2_resid)) +
  geom_point(size = 3)
# разброс более одинаков, но все наблюдения скошены к началу вектора

### Нормальность распределения остатков
ggplot(swiss, aes(x = lm1_resid)) +
  geom_histogram(bindwidth = 4, fill = "white", col = "black")
# распределение скошено влево

# qq-plot
qqnorm(lm1$residuals)
qqline(lm1$residuals)

shapiro.test(lm1$residuals)
# p < 0.05 - распределение отличается от нормального

ggplot(swiss, aes(x = lm2_resid)) +
  geom_histogram(bindwidth = 4, fill = "white", col = "black")

# qq-plot
qqnorm(lm2$residuals)
qqline(lm2$residuals)

shapiro.test(lm2$residuals)
# p < 0.05 - распределение отличается от нормального

### Задачи
# В переменной my_vector хранится вектор значений.
# Какое преобразование позволяет сделать 
# его распределение нормальным (согласно shapiro.test)?
my_vector <- c(0.027, 0.079, 0.307, 0.098, 0.021, 
               0.091, 0.322, 0.211, 0.069, 0.261, 
               0.241, 0.166, 0.283, 0.041, 0.369, 
               0.167, 0.001, 0.053, 0.262, 0.033, 
               0.457, 0.166, 0.344, 0.139, 0.162, 
               0.152, 0.107, 0.255, 0.037, 0.005, 
               0.042, 0.220, 0.283, 0.050, 0.194, 
               0.018, 0.291, 0.037, 0.085, 0.004, 
               0.265, 0.218, 0.071, 0.213, 0.232, 
               0.024, 0.049, 0.431, 0.061, 0.523)

shapiro_test <- function(vector){
  p <- shapiro.test(vector)$p.value
  if (p > 0.05) {
    print(p)
    print("Преобразование подходит")
  } else {
    print(p)
    print("Преобразование не подходит")
  }
}
shapiro_test(my_vector)
shapiro_test(1/my_vector)
shapiro_test(log(my_vector))
shapiro_test(sqrt(my_vector))

# Функция scale() позволяет совершить стандартизацию вектора, 
# то есть делает его среднее значение равным нулю, 
# а стандартное отклонение - единице (Z-преобразование).

# Стандартизованный коэффициент регрессии (β) можно получить, 
# если предикторы и зависимая переменная стандартизованы.

# Напишите функцию, которая на вход получает dataframe с двумя 
# количественными переменными, а возвращает стандартизованные коэффициенты 
# для регрессионной модели, в которой первая переменная датафрейма выступает 
# в качестве зависимой, а вторая в качестве независимой.
?scale
beta.coef <- function(x){    
  x <-scale(x)    
  return(lm(x[,1] ~ x[,2])$coefficients)
}
beta.coef(mtcars[,c(1,3)])
beta.coef(swiss[,c(1,4)])

# QuantPsyc
library(QuantPsyc)
lm.beta(lm(mtcars[[3]] ~ mtcars[[1]]))

# Напишите функцию normality.test, которая получает на вход dataframe 
# с количественными переменными, проверяет распределения каждой переменной 
# на нормальность с помощью функции shapiro.test.
# Функция должна возвращать вектор с значениями p-value, полученного 
# в результате проверки на нормальность каждой переменной. 
# Названия элементов вектора должны совпадать с названиями переменных. 
normality.test  <- function(x){
  result <- vector(length = length(x))
  for(i in 1:length(x)){
    result[i] <- shapiro.test(x[[i]])$p.value
  }
  names(result) <- names(x)
  return(result)
}
normality.test(mtcars[,1:6])
normality.test(iris[,-5])
?apply

normality.test <- function(x) {
  apply(x, 2, function (i) shapiro.test(i)$p.value)
}
normality.test(mtcars[,1:6])
normality.test(iris[,-5])

# Загрузите себе прикреплённый к этому степу датасет и постройте регрессию, 
# предсказывающую DV по IV. Установите библиотеку gvlma и проверьте, 
# удовлетворяется ли в этой модели требование гомоскедастичности. 
# Введите в поле ответа p-значение для теста гетероскедастичности.
library(gvlma)

data <- read.csv("https://stepic.org/media/attachments/lesson/12088/homosc.csv")
str(data)

x <- gvlma(DV ~ IV, data)
summary(x)
#fit <- lm(DV ~ IV, data)
#gvlma(fit)

# Напишите функцию resid.norm, которая тестирует распределение остатков 
# от модели на нормальность при помощи функции shapiro.test и создает 
# гистограмму при помощи функции ggplot() с красной заливкой "red", 
# если распределение остатков значимо отличается от нормального (p < 0.05), 
# и с зелёной заливкой "green" - если распределение остатков значимо 
# не отличается от нормального.
# На вход функция получает регрессионную модель. 
# Функция возвращает переменную, в которой сохранен график ggplot.
resid.norm <- function(model){
  fit.residuals = model$residuals
  p <- shapiro.test(fit.residuals)$p.value
  if (p > 0.05) {
    ggplot(as.data.frame(fit$model), aes(x = fit.residuals)) +
      geom_histogram(fill = "green")
  } else {
    ggplot(as.data.frame(fit$model), aes(x = fit.residuals)) +
      geom_histogram(fill = "red")
  }
}

fit <- lm(mpg ~ disp, mtcars)
my_plot <- resid.norm(fit)
my_plot

fit <- lm(mpg ~ wt, mtcars)
my_plot <- resid.norm(fit)
my_plot

# Напишите функцию high.corr, которая принимает на вход датасет 
# с произвольным числом количественных переменных и возвращает вектор 
# с именами двух переменных с максимальным абсолютным 
# значением коэффициента корреляции.
high.corr <- function(x){
  len <- length(x)
  res <- matrix(nrow = len, ncol = len)
  for(i in 1:(len-1)){
    for(j in (i+1):len){
      k <- cor.test(x[[i]], x[[j]])$estimate
      res[i, j] = k[["cor"]]
    }
  }
  res[is.na(res)] <- 0
  res <- abs(res)
  res_row <- which.max(res) %% len
  res_col <- which.max(res[res_row,])
  
  return(c(names(x[res_row]), names(x[res_col])))
}
high.corr(swiss)
high.corr(iris[,-5])

x1 <- rnorm(30) # создадим случайную выборку
x2 <- rnorm(30) # создадим случайную выборку
x3  <- x1 + 5 # теперь коэффициент корреляции x1 и x3 равен единице
my_df <- data.frame(var1 = x1, var2 = x2, var3 = x3)
high.corr(my_df)
