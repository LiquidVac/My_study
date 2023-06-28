library(ggplot2)

### Формулы
# dv - dependent variable
# iv - independent variable
# dv ~ iv - на зависимую переменную влияет одна независимая
# dv ~ iv1 + iv2 - на зависимую переменную влияют две независимые
# dv ~ iv1:iv2 - влияние iv1 на dv зависит от iv2

# dv ~ iv1 + iv2 + iv1:iv2 - формула с главным эффектом + взаимодействие
#                            Main effects + interaction
# dv ~ iv1 * iv2 - также: Main effects + interaction

# dv ~ (iv1 + iv2 + iv3)^2 - влияние на dv + все возможные попарные 
#                            взаимодействия (iv1+iv2, iv1+iv3 ...)

# dv ~ iv1 + Error(subject/iv1) - повторные измерения
?formula

### Data
mydata <- read.csv("https://stepic.org/media/attachments/lesson/11505/shops.csv", 
                   stringsAsFactors = T)
str(mydata)

### One-way ANOVA
fit <- aov(price ~ origin, data = mydata) # формула расчета
summary(fit) # результаты ANOVA
# p > 0.05 можно отвергнуть H0(что цены на российские и импортные продукты равны)

### Two-way ANOVA
fit1 <- aov(price ~ origin + store, mydata)
summary(fit1)
# страна производитель "влияет" на цену p > 0.05
# тип магазина не "влияет" p < 0.05

# дополнительная информация по модели
model.tables(fit1, "means") # считает общее среднее и среднее внутри групп

### Анализ взаимодействия
# group = origin - "связь" между видами магазина 
# position_dodge(width=0.2) - смещает разделение по магазину с одной линии
ggplot(mydata, aes(x = store, y = price, color = origin, group = origin))+
  # доверительные интервалы
  stat_summary(fun.data = mean_cl_boot, geom = 'errorbar', width=0.1,
               position = position_dodge(width = 0.2))+
  stat_summary(fun.data = mean_cl_boot, geom = 'line', size = 1,
               position = position_dodge(width = 0.2)) +
  stat_summary(fun.data = mean_cl_boot, geom = 'point', shape = 'square',
               size = 3, position = position_dodge(width = 0.2))+
  theme_bw()
# по графику видно, что разница между импортными продуктами в supermarket
# и minimarket неодинакова.
# для этого в модель вписывается взаимодействие 
fit2 <- aov(price ~ origin + store + origin:store, mydata)
summary(fit2)
# страна производитель "влияет" на цену p > 0.05
# тип магазина не "влияет" p < 0.05
# взаимодействие origin:store значимо влияет на цену Pr = 0.035

# та же модель, с другой записью
fit3 <- aov(price ~ origin * store, mydata)
summary(fit3)

### Попарные сравнения с поправками
# влияние типов еды на цену
ggplot(mydata, aes(x = food, y = price))+
  geom_boxplot()

# различаются ли групы еды между собой
fit4 <- aov(price ~ food, data = mydata)
summary(fit4)
# еда является значимым предиктором для цены p < 0.05

# попарное сравнение с попракой Тьюки
TukeyHSD(fit4)
# H0 может быть отвергнута только для групп cheese-bread 

### Дисперсионный анализ с повторным измерением
# каждый испытуемый(subject) может проходить вплоть до 3 тестов(therapy)
mydata2 <- read.csv("https://stepic.org/media/attachments/lesson/11505/therapy_data.csv", 
                    stringsAsFactors = T)
str(mydata2)

mydata2$subject <- as.factor(mydata2$subject)

fit_therapy <- aov(well_being ~ therapy, data = mydata2)
summary(fit_therapy)
# p-value therapy = 0.521 > 0.05 (нет значимых различий)

# учет того, что  каждый subject проходил 3 вида therapy
# Error(subject/therapy)
# subject - группирующий фактор
# therapy - влияние чего нужно узнать
fit_therapy_b <- aov(well_being ~ therapy + Error(subject/therapy), 
                     data = mydata2)
summary(fit_therapy_b)
# p-value therapy = 0.563 > 0.05 (нет значимых различий)

# построение модели с двумя внутригрупповыми факторами
fit_therapy2 <- aov(well_being ~ therapy*price, mydata2)
summary(fit_therapy2)
# p-value therapy = 0.486 > 0.05 (нет значимых различий)
# p-value price = 0.042 < 0.05 (есть значимые различия)
# p-value price:therapy = 0.905 > 0.05 (нет значимых различий)

ggplot(mydata2, aes(x = price, y = well_being))+
  geom_boxplot()
# чем выше цена, тем большее влияние терапии

fit_therapy2_b <- aov(well_being ~ therapy*price + 
                      Error(subject/(therapy*price)), mydata2)
summary(fit_therapy2_b)
# p-value Error: subject:therapy = 0.563 > 0.05 
# p-value Error: subject:price = 0.061 > 0.05 (нет значимых различий)
# p-value Error: subject:therapy:price = 0.905 > 0.05 

ggplot(mydata2, aes(x = price, y = well_being))+
  geom_boxplot()+
  facet_grid((~subject))
# не у всех испытуемых фактор цены улучшил состояние
# цена однозначно не определяет успех терапии

# внутригрупповые + межгрупповой фактор
fit_therapy3 <- aov(well_being ~ therapy*price*sex, mydata2)
summary(fit_therapy3)
# только p-value price = 0.042 < 0.05 (есть значимые различия)
# p-value sex 0.722 > 0.05 (нет значимых различий) - влияние пола

# в ошибку добавляются только внутригрупповые факторы
fit_therapy3_b <- aov(well_being ~ therapy*price*sex +
                      Error(subject/(therapy*price)), mydata2)
summary(fit_therapy3_b)
# p-value sex 0.709 > 0.05 - влияние пола
# p-value therapy:price:sex = 0.745 > 0.05 - влияние трех факторов

### Задачи
# Воспользуемся встроенными данными npk, иллюстрирующими влияние 
# применения различных удобрений на урожайность гороха (yield). 
# Нашей задачей будет выяснить, существенно ли одновременное применение 
# азота (фактор N) и фосфата (фактор P). Примените дисперсионный анализ, 
# где будет проверяться влияние фактора применения азота (N), 
# влияние фактора применения фосфата (P) и их взаимодействие.
# В ответе укажите p-value для взаимодействия факторов N и P.
data(npk)

ggplot(npk, aes(x = N, y = yield, color = P, group = P))+
  stat_summary(fun.data = mean_cl_boot, geom = 'errorbar', width=0.1,
               position = position_dodge(width = 0.2))+
  stat_summary(fun.data = mean_cl_boot, geom = 'line', size = 1,
               position = position_dodge(width = 0.2)) +
  stat_summary(fun.data = mean_cl_boot, geom = 'point', shape = 'square',
               size = 3, position = position_dodge(width = 0.2))+
  theme_bw()

fit_npk <- aov(yield ~ N * P, npk)
summary(fit_npk)
# p = 0.4305, H0 отклонить нельзя (влияние N:P несущественно)

# Теперь проведите трехфакторный дисперсионный анализ, где 
# зависимая переменная - это урожайность (yield), 
# а три фактора - типы удобрений (N, P, K). 
# После проведения данного анализа вы получите три значения p-value.
fit_npk2 <- aov(yield ~ N + P + K, npk)
summary(fit_npk2)
cat("N Pr(>F) =", summary(fit_npk2)[[1]]["N", "Pr(>F)"], "\n",
    "P Pr(>F) =", summary(fit_npk2)[[1]]["P", "Pr(>F)"], "\n",
    "K Pr(>F) =", summary(fit_npk2)[[1]]["K", "Pr(>F)"])

# Проведите однофакторный дисперсионный анализ на встроенных данных iris. 
# Зависимая переменная - ширина чашелистика (Sepal.Width), 
# независимая переменная - вид (Species). 
# Затем проведите попарные сравнения видов. 
# Какие виды статистически значимо различаются по ширине чашелистика (p < 0.05)?     
data(iris)

ggplot(iris, aes(x = Species, y = Sepal.Width))+
  geom_boxplot()

fit_iris <- aov(Sepal.Width ~ Species, iris)
TukeyHSD(fit_iris)
# все виды статистически значимо различаются по ширине чашелистика

# В этой задаче вам дан набор данных, в котором представлена информация 
# о температуре нескольких пациентов, которые лечатся 
# разными таблетками и у разных врачей.
# Проведите однофакторный дисперсионный анализ с повторными измерениями: 
# влияние типа таблетки (pill) на температуру (temperature) 
# с учётом испытуемого (patient). 
# Каково p-value для влияния типа таблеток на температуру?
pilulki <- read.csv("https://stepic.org/media/attachments/lesson/11505/Pillulkin.csv",
                    stringsAsFactors = T)
str(pilulki)
pilulki$patient <- as.factor(pilulki$patient)

fit_pilulki <- aov(temperature ~ pill + Error(patient/pill), 
                     data = pilulki)
summary(fit_pilulki)[[2]]

# Теперь вашей задачей будет провести двухфакторный дисперсионный анализ 
# с повторными измерениями: влияние факторов doctor, влияние фактора pill и 
# их взаимодействие на temperature. Учтите обе внутригрупповые переменные: 
# и тот факт, что один и тот же больной принимает разные таблетки, и тот факт, 
# что  один и тот же больной лечится у разных врачей! 
# Каково F-значение для взаимодействия факторов 
# доктора (doctor) и типа таблеток (pill)?
fit_pilulki2 <- aov(temperature ~ pill*doctor + Error(patient/(pill*doctor)), 
                   data = pilulki)
summary(fit_pilulki2)[[4]]

# Вспомните графики из лекций и дополните шаблон графика в поле для ответа так 
# (не добавляя еще один geom) , чтобы объединить линиями точки, принадлежащие 
# разным уровням фактора supp. Пожалуйста, сохраните график в переменную obj.

obj <- ggplot(ToothGrowth, aes(x = as.factor(dose), y = len, 
                               col = supp, group = supp))+
  stat_summary(fun.data = mean_cl_boot, geom = 'errorbar', width = 0.1, 
               position = position_dodge(0.2))+
  stat_summary(fun.data = mean_cl_boot, geom = 'point', size = 3, 
               position = position_dodge(0.2))+
  stat_summary(fun.data = mean_cl_boot, geom = 'line', 
               position = position_dodge(0.2))
obj
