### Сравнение моделей
data(swiss)

# предсказание Fertility от всех предикторов
fit_full <- lm(Fertility ~ ., swiss)
summary(fit_full) 
# все предикторы значимы, кроме Examination (p = 0.31)
# Adjusted R-squared:  0.671 

# все предикторы кроме Agriculture 
# fit_reduced1 <-lm(Fertility ~ . -Agriculture, swiss)
fit_reduced1 <- lm(Fertility ~ Infant.Mortality + Examination + 
                     Catholic + Education, swiss)
summary(fit_reduced1) 
# все предикторы значимы, кроме Examination (p = 0.68)
# Adjusted R-squared:  0.6319

# Дисперсионный анализ
anova(fit_full, fit_reduced1)
# Pr(>F) = 0.018 < 0.05 - доля дисперсии объясняемая fit_full значимо больше чем  fit_reduced1.

# все предикторы кроме Examination 
fit_reduced2 <- lm(Fertility ~ Infant.Mortality + Agriculture + 
                     Catholic + Education, swiss)
summary(fit_reduced2) 
# все предикторы значимы
# Adjusted R-squared:  0.6707 

anova(fit_full, fit_reduced2)
# Pr(>F) = 0.31 < 0.05 - модели примерно одинаково объясняют доли дисперсии

# fit_reduced3 <-lm(Fertility ~ . -Agriculture -Education, swiss)

### step()
# по шагам показывает влияние удаление предикторов на статистики модели
# с каждым шагом удаляет наименее влияющий предиктор до тех пор,
# пока влияние на статистики не станет значимым.
step(fit_full, direction = 'backward')

optimal_fit <- step(fit_full, direction = 'backward')
# показывает предикторы, которые значимо ухудшат модель при их удалении
summary(optimal_fit)

### Задачи
# C помощью функции step найдите оптимальную модель 
# для предсказания rating в датасете attitude. 
# Model_full и model_null уже созданы. 
# Сохраните команду с функцией step в переменную ideal_model.
data(attitude)
model_full <- lm(rating ~ ., data = attitude) 
#  нет ни одного предиктора, а есть только intercept.
model_null <- lm(rating ~ 1, data = attitude)

# пространство моделей с разным числом предикторов, 
# в котором будет происходить поиск оптимального набора предикторов.
scope = list(lower = model_null, upper = model_full)

ideal_model <-  step(model_null, scope = scope, direction = 'forward')
# rating ~ complaints + learning

# Сравните полную модель из предыдущего степа и оптимальную модель 
# с помощью функции anova. Введите получившееся F-значение.
result <- anova(model_full, ideal_model)

# В этой задаче будем работать со встроенным датасетом LifeCycleSavings. 
# Попытаемся предсказать значение sr на основе всех остальных переменных. 
# Вспомните способы сокращения формул и напишите команду, которая 
# создаёт линейную регрессию с главными эффектами и всеми возможными 
# взаимодействиями второго уровня. Сохраните модель в переменную model.
data(LifeCycleSavings)
str(LifeCycleSavings)
model <- lm(sr ~ (.)^2, LifeCycleSavings)
summary(model)
