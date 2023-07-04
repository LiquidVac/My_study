library(ggplot2)
# по независимым переменным (пол и оценки по предметам), предсказывается 
# получил ли ученик красный диплом
my_df <- read.csv("https://stepic.org/media/attachments/lesson/10226/train.csv",
                  sep = ";", stringsAsFactors = T)
str(my_df)

ggplot(my_df, aes(read, math, col = gender)) +
  geom_point(size = 5) +
  facet_grid(.~hon) +
  theme(axis.text=element_text(size = 25),
        axis.title=element_text(size = 25, face = "bold"))

# glm - обобщенная линейная модель
fit <- glm(hon ~ read + math + gender, my_df, family = "binomial")
summary(fit)
fit$coefficients
# intercept - показатель для девушек при 0 в read и math
# Если испытуеммый - девушка:
# read - изменение статистик с единичным увеличением read, если math неизменно
# math - изменение статистик с единичным увеличением math, если read неизменно
# gendermale - изменение статистик с изменением gender, если read и math неизменно

# коэффициенты без логарифма
exp(fit$coefficients)

# предсказание для каждого испытуемого
predict(object = fit)
# предсказание для каждого испытуемого в %
predict(object = fit, type = "response")

my_df$prob <- predict(object = fit, type = "response")

### ROC Curve
library(ROCR)

pred_fit <- prediction(my_df$prob, my_df$hon)
# tpr - True Positive Rate
# fpt - False Positive Rate
perf_fit <- performance(pred_fit, "tpr", "fpr")
plot(perf_fit, colorize = T, print.cutoffs.at = seq(0,1, by = 0.1))

# AUC - area under curve
auc <- performance(pred_fit, measure = "auc")
str(auc)
# площадь под кривой = 0.87

# поиск порога отсечения для предсказания
# специфичность классификатора - 
# насколько хорошо удается предсказывать отрицательный исход события
# (испытуемый не получит красный диплом)
perf3 <- performance(pred_fit, x.measure = "cutoff", measure = "spec")
plot(perf3, col ="red", lwd = 2)
# чувствительность классификатора - 
# насколько хорошо удается предсказывать положительный исход события
# (испытуемый получит красный диплом)
perf4 <- performance(pred_fit, x.measure = "cutoff", measure = "sens")
plot(add = T, perf4, col ="green", lwd = 2)
# Точность классификатора
perf5 <- performance(pred_fit, x.measure = "cutoff", measure = "acc")
plot(add = T, perf5, lwd = 2)

legend(x = 0.6, y = 0.3, c("spec", "sens", "accur"),
       lty = 1, col = c("red", "green", "black"), bty = "n", cex = 1, lwd = 2)
# порога отсечения = 0.225
abline(v = 0.225, lwd = 2)
# предсказание
my_df$pred_resp <- factor(ifelse(my_df$prob > 0.225, 1, 0), labels = c("N", "Y"))
# правильность предсказаний
my_df$correct <- ifelse(my_df$pred_resp == my_df$hon, 1, 0)

ggplot(my_df, aes(prob, fill = factor(correct)))+
  geom_dotplot()+
  theme(axis.text=element_text(size = 25),
        axis.title=element_text(size = 25, face = "bold"))

# средняя эффективность предсказания
mean(my_df$correct)

### Предсказание на новых данных
test_df <- read.csv("https://stepic.org/media/attachments/lesson/10226/test.csv", 
                    sep = ";", stringsAsFactors = T)
str(test_df)
test_df$hon <- NA

test_df$hon <- predict(fit, newdata = test_df, type = "response")
View(test_df)

### Задачи
# Используем данные mtcars. Сохраните в переменную логистическую регрессионную 
# модель, где в качестве зависимой переменной выступает тип коробки передач (am), 
# в качестве предикторов переменные disp, vs, mpg.
# Значения коэффициентов регрессии сохраните в переменную log_coef.
data(mtcars)

fit_mtcars <- glm(am ~ disp + vs + mpg, mtcars, family = "binomial")
summary(fit_mtcars)
log_coef <- fit_mtcars$coefficients

# Дополните предложенный в задании код, чтобы построить 
# следующий график по данным ToothGrowth.
# Изобразите различия длины зубов морских свинок в различных условиях 
# дозировки и типа потребляемого продукта.
data(ToothGrowth)

ggplot(data = ToothGrowth, aes(x = supp, y = len , fill = factor(dose)))+
  geom_boxplot()

# По имеющимся данным в переменной admit постройте логистическую регрессионную 
# модель, предсказывающую результат поступления по престижности учебного 
# заведения среднего образования (переменная rank, 1 — наиболее престижное, 
# 4 — наименее престижное) и результатов GPA (переменная gpa) 
# с учётом их взаимодействия. 
# Примените эту модель к той части данных, где результат поступления неизвестен.
# Ответом в задаче будет предсказанное моделью число поступивших из тех, 
# для кого результат поступления был неизвестен. 
# Считаем человека поступившим, когда вероятность его поступления не меньше 0.4.
data2 <- read.csv("https://stepic.org/media/attachments/lesson/11478/data.csv")
str(data2)
data2$admit <- as.factor(data2$admit)
data2$rank <- as.factor(data2$rank)

coef = 0.4
train <- subset(data2, is.na(admit) == F)
test <- subset(data2, is.na(admit))

fit_train <- glm(admit ~ rank*gpa, train, family = "binomial")

test$prob <- predict(object = fit_train, newdata = test, type = "response")
test$pred_resp <- factor(ifelse(test$prob >= coef, 1, 0))

sum(as.numeric(as.character(test$pred_resp)))


### Экспорт результатов анализа
library(xtable)
library(stargazer)

fit1 <- lm(mpg ~ cyl + disp, mtcars)
fit2 <- aov(mpg ~ am * vs, mtcars)

fit_table1 <- xtable(fit1)
fit_table2 <- xtable(fit2)

#print(fit_table1, type="html", file="fit_table1.html")
#print(fit_table2, type="html", file="fit_table2.html")

#stargazer(fit1, type="html",
#          dep.var.labels="mpg",
#          covariate.labels=c("cyl","dysp"), out="models1.html")
