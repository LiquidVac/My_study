# Напишите функцию smart_hclust, которая получает на вход dataframe  
# с произвольным числом количественных переменных и число кластеров, 
# которое необходимо выделить при помощи иерархической кластеризации.

# Функция должна в исходный набор данных добавлять новую переменную 
# фактор - cluster  -- номер кластера, к которому отнесено каждое из наблюдений.
smart_hclust <-  function(test_data, cluster_number){
  dist_matrix <- dist(test_data) # расчет матрицы расстояний
  fit <- hclust(dist_matrix) # иерархическая кластеризация 
  cluster <- cutree(fit, k = cluster_number) # номер кластера для каждого наблюдения
  test_data$cluster <- factor(cluster)
  return(test_data)
}


test_data <- read.csv("https://stepic.org/media/attachments/course/524/test_data_hclust.csv")
str(test_data)
str(smart_hclust(test_data, 3))


# Напишите функцию get_difference, которая получает на вход два аргумента: 
# 1) test_data — набор данных с произвольным числом количественных переменных.
# 2) n_cluster — число кластеров, которое нужно выделить 
#    в данных при помощи иерархической кластеризации.

# Функция должна вернуть названия переменных, по которым были обнаружены 
# значимые различия между выделенными кластерами (p < 0.05). 
# Иными словами, после того, как мы выделили заданное число кластеров, 
# мы добавляем в исходные данные новую группирующую переменную — номер кластера, 
# и сравниваем получившиеся группы между собой по количественным переменным 
# при помощи дисперсионного анализа.

# Для поиска различий используйте ANOVA (функция aov). 
# Давайте договоримся, что для наших целей мы не будем проверять данные 
# на соответствие требованиями к применению этого критерия 
# и не будем думать о поправке на множественные сравнения.
get_difference<-  function(test_data, n_cluster){
  dist_matrix <- dist(test_data) 
  fit <- hclust(dist_matrix) 
  cluster <- factor(cutree(fit, k = n_cluster))
  
  p.values <- sapply(test_data, function(x) anova(aov(x ~ cluster))$P[1])
  
  return(names(which(p.values  < 0.05)))
}

test_data <- read.csv("https://stepic.org/media/attachments/course/524/cluster_1.csv")
str(test_data)
get_difference(test_data, 2)

test_data <- as.data.frame(list(X1 = c(13, 10, 14, 16, 20, 19, 30, 29, 24), 
                                X2 = c(13, 20, 12, 25, 22, 10, 31, 25, 29),
                                X3 = c(14, 12, 15, 16, 17, 26, 30, 30, 31),
                                X4 = c(7, 8, 7, 20, 21, 18, 31, 32, 28)))
get_difference(test_data, 3)


# Напишите функцию get_pc, которая получает на вход dataframe 
# с произвольным числом количественных переменных. 
# Функция должна выполнять анализ главных компонент 
# и добавлять в исходные данные две новые колонки 
# со значениями первой и второй главной компоненты. 
# Новые переменные должны называться "PC1"  и "PC2" соответственно.
get_pc <- function(d){
  data <- prcomp(d)
  d$PC1 <- data$x[,1]
  d$PC2 <- data$x[,2]
  return(d)
}

test_data <- read.csv("https://stepic.org/media/attachments/course/524/pca_test.csv")
str(test_data)
get_pc(test_data)


# Усложним предыдущую задачу! Напишите функцию get_pca2, которая 
# принимает на вход dataframe с произвольным числом количественных переменных. 
# Функция должна рассчитать, какое минимальное число главных компонент 
# объясняет больше 90% изменчивости в исходных данных и добавлять 
# значения этих компонент в исходный dataframe в виде новых переменных.
get_pca2 <- function(data){
  fit <- prcomp(swiss)
  pcs <- summary(fit)$importance[3, ]
  min_pca <- which(pcs > 0.9)[1]
  
  return(cbind(df, fit$x[,1:min_pca]))
}

data(swiss)
result  <- get_pca2(swiss)
str(result)


# Напишите функцию is_multicol, которая получает на вход dataframe 
# произвольного размера с количественными переменными. 
# Функция должна проверять существование строгой мультиколлинеарности, 
# а именно наличие линейной комбинации между предикторами. 
# Линейной комбинацией является ситуация, когда одна переменная может быть 
# выражена через другую переменную при помощи уравнения: V1=k∗V2+b.
# Например V1 = V2 + 4 или V1 = V2 - 5.

# Функция возвращает имена переменных, между которыми есть линейная зависимость 
# или cобщение "There is no collinearity in the data".
is_multicol <- function(d){
  correlation <- cor(d)
  diag(correlation) <- 0
  abs_correlation <- abs(correlation)
  
  strict_correlation <- round(abs_correlation, 2) == 1
  variables <- rownames(which(strict_correlation, arr.ind = T))

  ifelse(length(variables) != 0, result <- variables, 
         result <- "There is no collinearity in the data")
  
  return(result)
}

test_data <- read.csv("https://stepic.org/media/attachments/course/524/Norris_1.csv")
str(test_data)
is_multicol(test_data)

test_data <- read.csv("https://stepic.org/media/attachments/course/524/Norris_2.csv")
str(test_data)
is_multicol(test_data)

test_data <- read.csv("https://stepic.org/media/attachments/course/524/Norris_3.csv")
str(test_data)
is_multicol(test_data)


# В данных swiss, используя все переменные, выделите два кластера 
# при помощи иерархической кластеризации и сохраните значение кластеров 
# как фактор в переменную cluster.

# Затем визуализируйте взаимосвязь переменных  Education и  Catholic 
# в двух выделенных кластерах.

library(ggplot2)
smart_hclust <-  function(test_data, cluster_number){
  dist_matrix <- dist(test_data) 
  fit <- hclust(dist_matrix) 
  cluster <- cutree(fit, k = cluster_number) 
  test_data$cluster <- factor(cluster)
  return(test_data)
}

data(swiss)
swiss <- smart_hclust(swiss,2)
str(swiss)

my_plot <- ggplot(swiss, aes(Education, Catholic, col = cluster))+
  geom_smooth(method = lm, formula = y~x)+
  geom_point()
my_plot
