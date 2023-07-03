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
