### Data
?swiss
# Fertility - зависимая переменная
data(swiss)

str(swiss)

hist(swiss$Fertility, col = 'red')

### Множественная линейная регрессия

fit1 <- lm(Fertility ~ Examination + Catholic, data = swiss)
summary(fit1)
# В Intersept - среднее значение Fertility при том, 
# что все непрерывные переменные = 0
# Значимый результат дает Examination - p < 0.05
# Связь обратная Estimate < 0 (Чем выше Examination тем ниже Fertility)

# линейная модель + взаимодействие факторов
fit2 <-  lm(Fertility ~ Examination * Catholic, data = swiss)
summary(fit2)
# взаимодействие Examination:Catholic статистически не значимо

# доверительные интервалы
confint(fit2)

### Линейная регрессия с категориальными предикторами
hist(swiss$Catholic)

# Создание новой категориальной переменной на основе Catholic
swiss$religious <- ifelse(swiss$Catholic > 60, "Lots", "Few")
swiss$religious <- as.factor(swiss$religious)

fit3 <- lm(Fertility ~ Examination + religious, data = swiss)
summary(fit3)
# В Intersept - изменение Fertility для religious = "Few", при том, что
# все непрерывные переменные(Examination) = 0.
# Examination - показывает изменение Fertility (при увеличении Examination на 1)
# только для religious = "Few".
# religiousLots - изменение Fertility при переходе от religious = "Few" к "Lots"
# p < 0.05 - фактор religious является статистически значимым.

### Линейная регрессия с категориальными предикторами + взаимодействие
fit4 <- lm(Fertility ~ Examination * religious, data = swiss)
summary(fit4)
# В Intersept - изменение Fertility для religious = "Few", при том, что
# все непрерывные переменные(Examination) = 0.
# Examination - показывает изменение Fertility (при увеличении Examination на 1)
# только для religious = "Few".
# religiousLots - изменение Fertility при переходе от religious = "Few" к "Lots"
# p > 0.05 - фактор religious не является статистически значимым.
# Examination:religiousLots - насколько Examination влияет на Fertility,
# только для religious = "Lots".

### Диаграмма рассевания
library(ggplot2)
ggplot(swiss, aes(x = Examination, y = Fertility)) + 
  geom_point() 

# + линия тренда
ggplot(swiss, aes(x = Examination, y = Fertility)) + 
  geom_point() + 
  geom_smooth(method = 'lm')

ggplot(swiss, aes(x = Examination, y = Fertility, col = religious)) + 
  geom_point()

ggplot(swiss, aes(x = Examination, y = Fertility, col = religious)) + 
  geom_point() + 
  geom_smooth(method = 'lm')

### Несколько непрерывных переменных + категориальная
fit5 <- lm(Fertility ~ religious*Infant.Mortality*Examination, data = swiss)
summary(fit5)
# 1) Intersept - изменение Fertility для religious = "Few", при том, что
# все непрерывные переменные = 0.
# 2) religiousLots - изменение Fertility при переходе от religious = "Few" к "Lots"
# 3) Насколько Infant.Mortality влияет на Fertility, только для religious = "Few".
# 4) Насколько Examinationвлияет на Fertility, только для religious = "Few".
# 5) Насколько Infant.Mortality влияет на Fertility, только для religious = "Lots".
# 6) Насколько Examination влияет на Fertility, только для religious = "Lots".
# 7) Infant.Mortality:Examination - взаимодействие двух переменных для religious = "Low".
# 7) religiousLots:Infant.Mortality:Examination - взаимодействие двух переменных для religious = "Lots".

### Задачи
# Напишите функцию fill_na, которая принимает на вход данные с тремя переменными:
# x_1 - числовой вектор
# x_2 - числовой вектор
# y - числовой вектор с пропущенными значениями.
# На первом этапе, используя только наблюдения, в которых нет 
# пропущенных значений, мы построим регрессионную модель (без взаимодействий), 
# где  y — зависимая переменная, x_1 и x_2 — независимые переменные. 
# Затем, используя построенную модель, мы заполним 
# пропущенные значения предсказаниями модели.
# Функция должна возвращать dataframe c новой переменной  y_full.
# Сохраните в нее переменную y, в которой пропущенные значения заполнены 
# предсказанными значениями построенной модели.
test_data <- read.csv("https://stepic.org/media/attachments/course/129/fill_na_test.csv")
str(test_data)

fill_na <- function(x){
  fit <- lm(x[[3]] ~ x[[1]] + x[[2]], na.action = "na.exclude")
  x$y_full <- ifelse(is.na(x[[3]]), predict(fit, x), x[[3]])
  return(x)
}

fill_na(test_data)

# В переменной df сохранен subset данных mtcars только с переменными 
# "wt", "mpg", "disp", "drat", "hp". 
# Воспользуйтесь множественным регрессионным анализом, чтобы предсказать 
# вес машины (переменная "wt"). Выберите такую комбинацию независимых 
# переменных (из "mpg", "disp", "drat", "hp"), чтобы значение R^2 adjusted 
# было наибольшим. Взаимодействия факторов учитывать не надо.
df <- subset(mtcars, select = c("wt", "mpg", "disp", "drat", "hp"))

fit <- lm(wt ~ mpg + disp + drat + hp, df)
?step
optimal_fit <-  step(fit, direction = 'backward', SCALE=1)
summary(optimal_fit)
attr(as.formula(summary(optimal_fit)), "term.labels")

# Воспользуйтесь встроенным датасетом attitude, чтобы предсказать 
# рейтинг (rating) по переменным complaints и critical. 
# Каково t-значение для взаимодействия двух факторов?
data(attitude)
str(attitude)

summary(lm(rating ~ complaints*critical, attitude))$coefficients["complaints:critical", "t value"]

# Постройте линейную модель, в которой в качестве зависимой переменной 
# выступает расход топлива (mpg), а в качестве независимых - вес машины (wt) 
# и коробка передач (модифицированная am), а также их взаимодействие. 
# Выведите summary этой модели.
data(mtcars)
mtcars$am <- factor(mtcars$am, labels = c('Automatic', 'Manual'))

fit <- lm(mpg ~ am*wt, mtcars)
summary(fit)
# Intercept - Средний расход топлива у машин с автоматической коробкой передач и нулевым весом
ggplot(mtcars, aes(x = wt, y = mpg, col = am)) + 
  geom_point() + 
  geom_smooth(method = 'lm')
# У машин с ручной коробкой передач расход топлива ниже 
# (Intercept = 31.4161) > (amManual = 14.8784)
# В машинах с ручной коробкой передач вес сильнее влияет на расход топлива
# (wt = -3.7859) < (amManual:wt = -5.2984)


### Памятка по интерпретации результатов регрессионного анализа 
### с категориальными и непрерывными переменными
# DV ~ IV_numeric * IV_categorical
# IV_categorical - фактор с двумя уровнями (Level1 и Level2)

# Коэффициенты:
# Intercept — предсказанное значение DV для первого уровня IV_categorical 
# с учётом того, что IV_numeric равна нулю.

# IV_numeric — насколько изменяется предсказанное значение DV при увеличении 
# IV_numeric на одну единицу в группе, соответствующей первому уровню IV_categorical

# IV_categoricalLevel2 — насколько изменяется предсказанное значение DV 
# при переходе от первого уровня IV_categorical ко второму уровню. 
# С учётом того, что IV_numeric равна нулю.

# IV_numeric:IV_categoricalLevel2 — насколько сильнее (или слабее) изменяется 
# предсказанное значение DV при увеличении IV_numeric на одну единицу в группе, 
# соответствующей второму уровню IV_categorical, по сравнению с первым уровнем.

### Как предсказывать значения в новом датасете на основе полученных коэффициентов
# 1) Предположим у нас есть новый объект, про который мы знаем, 
# что он принадлежит к группе, соответствующей IV_categorical (Level1) 
# и измеренный у него IV_numeric составил 10:
# Предсказанное значение DV = Intercept + 10 * IV_numeric

# 2) Предположим у нас есть новый объект, про который мы знаем, 
# что он принадлежит к группе, соответствующей IV_categorical (Level2) 
# и измеренный у него IV_numeric составил 6:
# Предсказанное значение 
# DV = Intercept + IV_categoricalLevel2 + 6 * (IV_numeric + IV_numeric:IV_categoricalLevel2)
