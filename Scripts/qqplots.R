max <- scale(sytoxG_data_features$max)
qqnorm(max)
residuals(qqnorm(max))
qqPlot(max)



#find the elements off the line
#### REDO?
max_unscaled <- sytoxG_data_features$max
mean_plus_1_sd <- mean(sytoxG_data_features$max) + sd(sytoxG_data_features$max)
less_than <- max_unscaled[max_unscaled < mean_plus_1_sd]
qqPlot(less_than)