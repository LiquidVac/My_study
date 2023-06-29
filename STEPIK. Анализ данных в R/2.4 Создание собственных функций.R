### Синтаксис объявления функции
my_calc <- function(x, y, z = 10){
  s <- x + y + z
  d <- x - y - z
  return(c(s,d))
}
my_calc(1,2)

### Функция заменяет пропущенные значения в векторе на среднее этого вектора
my_na_rm <- function(x){
  if (is.numeric(x)){
    stat_test <- shapiro.test(x)
    if (stat_test$p.value > 0.05){
      x[is.na(x)] <- mean(x, na.rm = T)
      print("Na values were replaced with mean")
    }
    else{
      x[is.na(x)] <- median(x, na.rm = T)
      print("Na values were replaced with median")
    }
    return(x)
  }
  else{
    print("X is not numeric")
  }
}
distr1 <- rnorm(2000) # генерация нормального распределения (M=0, sd = 1)
distr1[1:10] <- NA # пропущенные значения
distr2 <- runif(2000) # генерация равномерного распределения
distr2[1:10] <- NA # пропущенные значения

distr1 <- my_na_rm(x = distr1)
hist(distr1)
distr2 <- my_na_rm(x = distr2)
hist(distr2)
my_na_rm(x = c("2", "3", NA))

### Применение функций с другого файла
distr3 <- rnorm(1000)
distr3[1:10] <- NA # пропущенные значения

source("function_my_na_rm.R")
my_na_rm2(distr3)

### Функция - из нескольких файлов собирает датафрейм
# setwd(".../STEPIK. Анализ данных в R/data_grants_data") # задание рабочей папки
# dir() # выводит все элементы в рабочей папке
dir(pattern = "*.csv") # выводит только csv файлы

# знак <<- позволяет сохранить переменную вне тела функции
read_data <- function(){
  df <- data.frame()
  number <<- 0                        # <<-
  for (i in dir(pattern = "*.csv")){
    temp_df <- read.csv(i)
    df <- rbind(temp_df, df)
    number <<- number + 1             # <<-
  }
  print(paste(as.character(number), "files were combined"))
  return(df)
}

grants <- read_data()

### Задачи
# Напишите функцию, которая выводит номера позиций 
# пропущенных наблюдений в векторе.
# На вход функция получает числовой вектор с пропущенными значениями. 
# Функция возвращает новый вектор с номерами позиций пропущенных значений.
NA.position <- function(x){
  return(which(is.na(x)))
}
my_vector <- c(1, 2, 3, NA, NA)
NA.position(my_vector)

# Напишите функцию NA.counter для подсчета пропущенных значений в векторе.
# На вход функция  NA.counter должна принимать один аргумент - числовой вектор. 
# Функция должна возвращать количество пропущенных значений.
NA.counter <- function(x){
  return(sum(is.na(x)))
}
my_vector <- c(1, 2, 3, NA, NA)
NA.counter(my_vector)

# Напишите функцию filtered.sum, которая на вход получает вектор 
# с пропущенными, положительными и отрицательными значениями и возвращает 
# сумму положительных элементов вектора.
filtered.sum <- function(x){
  return(sum(x[x > 0], na.rm = T))
}
x <- c(1, -2, 3, NA, NA)
filtered.sum(x)

# Напишите функцию outliers.rm, которая находит и удаляет выбросы. 
# Выбросами будем считать те наблюдения, которые отклоняются от 1 или 
# 3 квартиля больше чем на 1,5 *  IQR, где  IQR  - межквартильный размах.
# На вход функция получает числовой вектор x. 
# Функция должна возвращать модифицированный вектор x с удаленными выбросами. 
outliers.rm <- function(x){
  modified_vector <- vector(mode = "numeric", length = 0)
  q1 <- quantile(x,probs=c(0.25))
  q2 <- quantile(x,probs=c(0.75))
  temp_vector <- (x > q1 - (1.5 * IQR(x))) & (x < q2 + (1.5 * IQR(x)))
  
  for (i in 1:length(temp_vector)){
    if (temp_vector[i] == T){
      modified_vector <- c(modified_vector, x[i])
    }
  }
  return(modified_vector)
}

x1 <- rnorm(100)
x1[1:10] <- x1[1:10] + 3
hist(x1)
boxplot(x1)
outliers.rm(x1)

# outliers.rm <- function(x){    
#   q <- quantile(x, 0.25) + quantile(x, 0.75)    
#   return(x[abs(x - q/2) <= 2*IQR(x)])
# }
