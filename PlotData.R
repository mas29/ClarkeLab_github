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
sm_dataset <- sytoxG_plate1

ggplot(sytoxG_plate1, aes(date)) + 
  geom_line(aes(y = var0, colour = "var0")) + 
  geom_line(aes(y = var1, colour = "var1"))