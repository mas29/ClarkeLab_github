install.packages("ggplot2")
library(ggplot2)
set.seed(1410)
dsmall <- diamonds[sample(nrow(diamonds), 100), ]
qplot(carat, price, data = diamonds)
qplot(log(carat), log(price), data = diamonds)
qplot(carat, x*y*z, data = diamonds)
qplot(carat, price, data = dsmall, colour = color)
qplot(carat, price, data = dsmall, colour = color, geom = c("smooth"), method="loess", se=FALSE)
qplot(carat, price, data = dsmall, shape = cut)
qplot(carat, price, data = diamonds, alpha = I(1/10))
qplot(carat, price, data = diamonds, alpha = I(1/100))
qplot(carat, price, data = diamonds, geom = c("point","smooth")) #grey line is confidence interval - to turn off, se=FALSE
qplot(carat, price, data = diamonds, geom = "boxplot")
qplot(carat, price, data = diamonds, geom = "line")

#single plot
myPlot = qplot(as.numeric(rownames(sytoxG_plate1)), as.numeric(Clofarabine), data = sytoxG_plate1, 
      xlab="Time Elapsed", ylab="Clofarabine", geom="line") 
myPlot + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

#smaller dataset
sm_dataset <- sytoxG_plate1[,1:2]

sm_dataset <- confluency_sytoxG_allPlates[1,2:25]
temp <- cbind(t(sm_dataset), as.data.frame(time_elapsed))
sm_dataset2 <- confluency_sytoxG_allPlates[2,2:25]
temp2 <- cbind(t(sm_dataset), as.data.frame(time_elapsed))
temp3 <- rbind(temp,temp2)

sm_ds_conf_syt <- confluency_sytoxG_allPlates[1,]

p = ggplot(data=sm_ds_conf_syt, aes(x=time_elapsed, y=sm_ds_conf_syt, group = 1)) + geom_line()

p0  <- 
  ggplot(temp3, aes(x=time_elapsed, y=1, group=)) +
  geom_line() +
  ggtitle("Temp curve")

p1 <- 
  ggplot(ChickWeight, aes(x=Time, y=weight, colour=Diet, group=Chick)) +
  geom_line() +
  ggtitle("Growth curve for individual chicks")

ggplot(sytoxG_plate1, aes(date)) + 
  geom_line(aes(y = var0, colour = "var0")) + 
  geom_line(aes(y = var1, colour = "var1"))

p1 <- 
  ggplot(ChickWeight, aes(x=Time, y=weight, colour=Diet, group=Chick)) +
  geom_line() +
  ggtitle("Growth curve for individual chicks")

######################

p1 <- 
  ggplot(confluency_all_plates_for_data_vis, aes(x=as.numeric(time_elapsed), y=as.numeric(confluency_value), group=compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Confluency") +
  ggtitle("Confluency - Muscle Cells Over Time")
p1

p1 <- 
  ggplot(sytoxG_all_plates_for_data_vis, aes(x=as.numeric(time_elapsed), y=as.numeric(sytoxG_value), group=compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time")
p1
