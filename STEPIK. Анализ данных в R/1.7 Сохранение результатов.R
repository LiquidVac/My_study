library(psych)
df <-  mtcars
str(df)
mean_mpg <- mean(df$mpg)
descr_df <- describe(df[, -c(8,9)])

library(ggplot2)

boxplot <-  ggplot(df, aes(x = factor(am), y = disp))+
  geom_boxplot()+
  xlab("Transmission")+
  ylab("Displacement (cu.in.)")+
  ggtitle("Box - plot")

# проверка и установка директории
# getwd()
# setwd()

# сохранение df
write.csv(df, "df.csv")
# сохранение переменных

my_mean <-  mean(10^6:10^9)
save(my_mean, file = "my_mean.RData")

# сохранение global enviroment
save.image("Global_data.RData")
