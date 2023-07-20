# Начнем с простого и вспомним, как применять логистическую регрессию в R. 
# Напишите функцию get_coefficients, которая получает на вход dataframe 
# с двумя переменными x(фактор с произвольным числом градаций) и 
# y( фактор с двумя градациями). 
# Функция строит логистическую модель, где y — зависимая переменная, 
# а x — независимая, и возвращает вектор со значением экспоненты коэффициентов модели. 
get_coefficients <- function(dataset){
  fit <- glm(test_data[[2]] ~ test_data[[1]], family = "binomial")
  return(exp(coef(fit)))
}

test_data <- read.csv("https://stepik.org/media/attachments/course/524/test_data_01.csv")
test_data <- transform(test_data, x = factor(x), y = factor(y))
get_coefficients(test_data)

# Если в нашей модели есть количественные предикторы, то в интерцепте мы будем 
# иметь значение, соответствующее базовому уровню категориальных предикторов 
# и нулевому уровню количественных. Это не всегда осмысленно. Например, 
# нам не интересен прогноз для людей нулевого возраста или роста. 
# В таких ситуациях количественную переменную имеет смысл предварительно 
# центрировать так, чтобы ноль являлся средним значением переменной. 

# Самый простой способ центрировать переменную — отнять от каждого наблюдения 
# среднее значение всех наблюдений.

# Вашей задачей будет написать функцию centered, которая получает на вход 
# датафрейм и имена переменных, которые необходимо центрировать так, как это 
# описано выше. Функция должна возвращать этот же датафрейм, только с 
# центрированными указанными переменными.
centered <- function(test_data, var_names){
  # test_data[var_names] <- sapply(test_data[var_names], function(x) x - mean(x))  
  for (col in var_names) {
    mean_val <- mean(test_data[[col]])
    test_data[[col]] <- test_data[[col]] - mean_val
  }
  return(test_data)
}

test_data <- read.csv("https://stepic.org/media/attachments/course/524/cen_data.csv")
print(test_data)
var_names = c("X4", "X2", "X1")
centered(test_data, var_names)

test_data <- read.csv("https://stepic.org/media/attachments/course/524/cen_data.csv")
centered(test_data, "X4")


# Представьте, что мы работаем в аэропорту в службе безопасности и сканируем 
# багаж пассажиров. В нашем распоряжении есть информация о результатах проверки 
# багажа за предыдущие месяцы. Про каждую вещь мы знаем:
  
# являлся ли багаж запрещенным - is_prohibited(No - разрешенный, Yes - запрещенный) 
# его массу (кг) - weight
# длину (см) - length
# ширину (см) - width
# тип багажа (сумка или чемодан) - type.

# Напишите функцию get_features, которая получает на вход набор данных о багаже. 
# Строит логистическую регрессию, 
# где зависимая переменная - являлся ли багаж запрещенным, 
# а предикторы - остальные переменные, 
# и возвращает вектор с названиями статистически значимых переменных (p < 0.05) 
# (в модели без взаимодействия). 
# Если в данных нет значимых предикторов, функция возвращает 
# строку с сообщением  "Prediction makes no sense".
get_features <- function(dataset){
  fit <- glm(is_prohibited ~ ., dataset, family = "binomial")
  result <- anova(fit, test = "Chisq")
  
  c <- rownames(subset(result,`Pr(>Chi)`<0.05))
  
  if (length(c) != 0){
    return(c)
  } else {
    return("Prediction makes no sense")
  }
}

test_data <- read.csv("https://stepic.org/media/attachments/course/524/test_luggage_1.csv", 
                      stringsAsFactors = T)
str(test_data)
get_features(test_data)

test_data <- read.csv("https://stepic.org/media/attachments/course/524/test_luggage_2.csv",
                      stringsAsFactors = T)
str(test_data)
get_features(test_data)


# Продолжим нашу работу в службе безопасности! 
# Разобравшись с тем, какие предикторы могут помогать нам предсказывать 
# запрещенный багаж, давайте применим наши знания для повышения безопасности в аэропорту. 
# Обучим наш алгоритм различать запрещенный и разрешенный багаж на 
# уже имеющихся данных и применим его для сканирования нового багажа!
  
# Напишите функцию, которая принимает на вход два набора данных. 
# Первый dataframe, как и в предыдущей задаче, содержит информацию об 
# уже осмотренном багаже (запрещенный или нет, вес, длина, ширина, тип сумки). 

# Второй набор данных — это информация о новом багаже, 
# который сканируется прямо сейчас. В данных также есть информация:  
# вес, длина, ширина, тип сумки и имя пассажира. 

# Используя первый набор данных, обучите регрессионную модель различать 
# запрещенный и разрешенный багаж. При помощи полученной модели для каждого наблюдения 
# в новых данных предскажите вероятность того, что багаж является запрещенным. 
# Пассажиров, чей багаж получил максимальное значение вероятности, 
# мы попросим пройти дополнительную проверку. 

# Итого, ваша функция принимает два набора данных и возвращает имя пассажира с 
# наиболее подозрительным багажом. Если несколько пассажиров получили 
# максимальное значение вероятности, то верните вектор с несколькими именами. 

# В этой задаче для предсказания будем использовать все предикторы, 
# даже если некоторые из них оказались незначимыми. 
# Для предсказания стройте модель без взаимодействия предикторов.
most_suspicious <- function(test_data, data_for_predict){
  fit <- glm(is_prohibited ~ ., test_data, family = "binomial")
  
  passangers_df <- data.frame(name = data_for_predict$passangers, 
                              pred =  predict(fit, newdata = data_for_predict, 
                                              type = "response"))
  
  suspicious <- passangers_df$name[passangers_df$pred == max(passangers_df$pred)]
  return(suspicious)
}

test_data <- read.csv("https://stepic.org/media/attachments/course/524/test_data_passangers.csv",
                      stringsAsFactors = T)
str(test_data)

data_for_predict <- read.csv("https://stepic.org/media/attachments/course/524/predict_passangers.csv")
data_for_predict$type <- factor(data_for_predict$type)
str(data_for_predict)

most_suspicious(test_data, data_for_predict)


# Напишите функцию normality_test, которая получает на вход dataframe 
# с произвольным количеством переменных разных типов (количественные, строки, факторы) 
# и проверяет нормальность распределения количественных переменных. 
# Функция должна возвращать вектор значений p-уровней значимости теста shapiro.test 
# для каждой количественной переменной.
normality_test <- function(dataset){    
  numeric_var <- sapply(dataset, is.numeric)  
  sapply(dataset[numeric_var], function(x) shapiro.test(x)$p.value)    
}

data(iris)
normality_test(iris)


# Напишите функцию smart_anova, которая получает на вход dataframe с двумя переменными x и y. 
# Переменная x — это количественная переменная, 
# переменная y - фактор, разбивает наблюдения на три группы.

# Если распределения во всех группах значимо не отличаются от нормального, 
# а дисперсии в группах гомогенны, функция должна сравнить три группы при помощи 
# дисперсионного анализа и вернуть именованный вектор со значением p-value, имя элемента — "ANOVA".

# Если хотя бы в одной группе распределение значимо отличается от нормального 
# или дисперсии негомогенны, функция сравнивает группы при помощи критерия 
# Краскела — Уоллиса и возвращает именованный вектор со значением p-value, имя вектора  — "KW".

# Распределение будем считать значимо отклонившимся от нормального, 
# если в тесте shapiro.test() p < 0.05.
#Дисперсии будем считать не гомогенными, если в тесте bartlett.test() p < 0.05.

smart_anova <- function(test_data) {
  # Проверка нормальности распределения в группах
  normality_test <- c()
  for (name in names(table(test_data$y))) {
    normality_test <- c(normality_test, shapiro.test(test_data$x[test_data$y == name])$p)
  }
  # Проверка гомогенности дисперсий
  bartlett_test <- bartlett.test(test_data$x ~ test_data$y)$p.value
  
  # Сравнение значений p_value
  t <- all(c(normality_test, bartlett_test) > 0.05) == T
  
  if (t == T) {
    fit <- aov(test_data$x ~ test_data$y)
    p <- summary(fit)[[1]]$'Pr(>F)'[1]
    names(p) <- "ANOVA"
    
    return(p)
  } else {
    p <- kruskal.test(test_data$x ~ test_data$y)$p.value
    names(p) <- "KW"
    
    return(p)
  }
}


test_data <- read.csv("https://stepic.org/media/attachments/course/524/s_anova_test.csv",
                      stringsAsFactors = T)
str(test_data)
smart_anova(test_data)


# Напишите функцию normality_by, которая принимает на вход dataframe c тремя переменными. 
# Первая переменная количественная, вторая и третья имеют две градации 
# и разбивают наши наблюдения на группы.
# Функция должна проверять распределение на нормальность в каждой 
# получившейся группе и возвращать dataframe с результатами применения теста shapiro.test.

# Функция должна возвращать dataframe размером 4 на 3. 
# Название столбцов: 
# 1 — имя первой группирующей переменной
# 2 — имя второй группирующей переменной
# 3 — p_value

normality_by <- function(test){    
  grouped_data <- aggregate(test[,1], by = list(test[,2], test[,3]),                                  
                            FUN = function(x) {shapiro.test(x)$p.value})                                  
  names(grouped_data) <- c(colnames(test)[2:3],'p_value')                                  
  return(grouped_data)    
}

test_data <- read.csv("https://stepic.org/media/attachments/course/524/test_for_norm.csv")
test_data$y <- factor(test_data$y)
test_data$z <- factor(test_data$z)
str(test_data)

normality_by(test_data)
# Используя dplyr
library(dplyr)
normality_by <- function(test_data){    
  result <- test_data %>% group_by(y, z) %>%     
    summarize(p_value = shapiro.test(x)$p.value)     
  return(result)    
}

# При помощи библиотеки ggplot2 визуализируйте распределение переменной 
# Sepal.Length в трех группах в данных Iris. 
# Сохраните график в переменную obj.
library(ggplot2)
data(iris)
obj <- ggplot(iris, aes(Sepal.Length))+
  geom_density(aes(fill = Species),alpha = 0.2)
obj
