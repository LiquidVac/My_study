# Напишите функцию smart_test, которая получает на вход dataframe 
# с двумя номинативными переменными с произвольным числом градаций. 
# Функция должна проверять гипотезу о независимости этих двух переменных 
# при помощи критерия хи - квадрат или точного критерия Фишера.

# Если хотя бы в одной ячейке таблицы сопряженности двух переменных 
# меньше 5 наблюдений, функция должна рассчитывать точный критерий Фишера 
# и возвращать вектор из одного элемента: получившегося p - уровня значимости.

# Если наблюдений достаточно для расчета хи-квадрат 
# (во всех ячейках больше либо равно 5 наблюдений), 
# тогда функция должна применять критерий хи-квадрат 
# и возвращать вектор из трех элементов: 
# значение хи-квадрат, число степеней свободы,  p-уровня значимости.
smart_test <-  function(x){
  data <- table(x)
  if (all(data > 5)) {
    chi <- chisq.test(data)
    print("Достаточно наблюдений в таблице")
    return(c(unname(chi$stat), unname(chi$param), chi$p.value))
  } else {
    print("Недостаточно наблюдений в таблице")
    return(c(fisher.test(data)$p.value))
  }
}
# Достаточно наблюдений в таблице
table(mtcars[,c("am", "vs")])
smart_test(mtcars[,c("am", "vs")])
# Недостаточно наблюдений в таблице
table(mtcars[1:20,c("am", "vs")])
smart_test(mtcars[1:20,c("am", "vs")])


# Вся наследственная информация в живых организмах хранится внутри молекулы ДНК. 
# Эта молекула состоит из последовательности четырех "букв" — A, T, G и C. 

# Напишите функцию most_significant, которая получает на вход dataframe 
# с произвольным количеством переменных, где каждая переменная 
# это нуклеотидная последовательность. 

# Функция должна возвращать вектор с названием переменной (или переменных), 
# в которой был получен минимальный p - уровень значимости при проверке гипотезы 
# о равномерном распределении нуклеотидов при помощи критерия хи - квадрат. 
most_significant <-  function(data){
  p_table <- sapply(data , function(column) chisq.test(table(column))$p.value)
  return(names(p_table[p_table == min(p_table)]))
  
#  chisq_tests <- sapply(data, function(col) chisq.test(table(col))$p.value)    
#  min_p  <- which(chisq_tests == min(chisq_tests))    
#  return(colnames(data)[min_p])
}


test_data <- read.csv("https://stepic.org/media/attachments/course/524/test_data.csv", 
                      stringsAsFactors = F)
str(test_data)

most_significant(test_data)


# Воспользуемся встроенными в R данными Iris. 
# Создайте новую переменную important_cases - фактор с двумя градациями 
# ("No" и "Yes"). Переменная должна принимать значение Yes, если для данного 
# цветка значения хотя бы трех количественных переменных выше среднего. 
# В противном случае переменная important_cases  будет принимать значение No.
data(iris)
ab_mean_check <- sapply(iris[,1:4] , function(column) column > mean(column))
iris$important_cases <- ifelse(rowSums(ab_mean_check ) > 2, "Yes", "No")
iris$important_cases <- factor(iris$important_cases)
table(iris$important_cases)

#importance_calc <- function(v1, v2, threshold=3){    
#  ifelse(sum(v1 > v2) >= threshold, 'Yes', 'No')
#}    
#iris$important_cases <- factor(apply(iris[1:4], 1,
#                                     importance_calc, v2 = colMeans(iris[, 1:4])))


# Обобщим предыдущую задачу! Напишем функцию get_important_cases, 
# которая принимает на вход dataframe с произвольным числом количественных 
# переменных (гарантируется хотя бы две переменные). 
# Функция должна возвращать dataframe с новой переменной - фактором important_cases.

# Переменная important_cases принимает значение Yes, если для данного наблюдения 
# больше половины количественных переменных имеют значения больше среднего. 
# В противном случае переменная important_cases принимает значение No.

# Переменная important_cases - фактор с двумя уровнями 0 - "No", 1  - "Yes".  
# То есть даже если в каком-то из тестов все наблюдения получили значения "No", 
# фактор должен иметь две градации. 
get_important_cases <- function(data){
  num_variables <- ncol(data)
  ab_mean_check <- sapply(data, function(column) column > mean(column))
  data$important_cases <- factor(ifelse(rowSums(ab_mean_check) > num_variables/2, 
                                 "Yes", "No"))
  return(data)
}

test_data <- data.frame(V1 = c(16, 21, 18), 
                        V2 = c(17, 7, 16 ), 
                        V3 = c(25, 23, 27), 
                        V4 = c(20, 22, 18), 
                        V5 = c(16, 17, 19))

test_data <- get_important_cases(test_data)
str(test_data)
test_data

# get_important_cases  <- function(d){    
#  m <-  colMeans(d)    
#  compare_to_means <- apply(d, 1, function(x) as.numeric(x > m))    
#  is_important <- apply(compare_to_means, 2, sum) > ncol(d)/2    
#  is_important <- factor(is_important, levels = c(FALSE, TRUE), labels = c('No', 'Yes'))    
#  d$important_cases <- is_important    
#  return(d)
#}


# Напишите функцию stat_mode, которая получает на вход вектор из чисел 
# произвольной длины и возвращает числовой вектор с наиболее часто встречаемым 
# значением. Если наиболее часто встречаемых значений несколько, 
# функция должна возвращать несколько значений моды  в виде числового вектора.
stat_mode <- function(vec) {
  freq <- table(vec)
  max_freq <- max(freq)
  modes <- as.numeric(names(freq)[freq == max_freq])
  return(modes)
}

v <- c(1, 2, 3, 3, 3, 4, 5)
stat_mode(v)

v <- c(1, 1, 1, 2, 3, 3, 3)
stat_mode(v)

# stat_mode <- function(v){        
#  mode_positions <- which(table(v) == max(table(v)))    
#  as.numeric(names(table(v))[mode_positions])
#}


# Напишите функцию max_resid, которая получает на вход dataframe с двумя 
# переменными: типом лекарства и результатом его применения. 

# Drugs - фактор с тремя градациями: drug_1, drug_2, drug_3.     
# Result - фактор с двумя градациями: positive, negative.

# Функция должна находить ячейку таблицы сопряженности с максимальным значением 
# стандартизированного остатка и возвращать вектор из двух элементов: 
# название строчки и столбца этой ячейки.
test_data <- read.csv("https://stepic.org/media/attachments/course/524/test_drugs.csv",
                      stringsAsFactors = T)
str(test_data)

max_resid <- function(data){
  data <- table(data)
  
  chi_stdres <- chisq.test(data)$stdres
  max_stdres <- which(chi_stdres == max(chi_stdres), arr.ind = TRUE)
  
  col_name <- colnames(data)[max_stdres[2]]
  row_name <- rownames(data)[max_stdres[1]]
  
  return(c(row_name, col_name))
}
max_resid(test_data)

# Используя библиотеку ggplot2 и встроенные данные diamonds, постройте 
# график распределения частот переменной color, на котором за цвет заполнения 
# столбиков отвечает переменная cut. Сохраните код графика в переменную obj. 
library("ggplot2")
data(diamonds)
str(diamonds)

obj <- ggplot(diamonds, aes(x = color, fill = cut)) + 
  geom_bar(position = 'dodge')
obj
