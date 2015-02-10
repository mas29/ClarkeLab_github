max <- scale(sytoxG_data_features$max)
qqnorm(max)
residuals(qqnorm(max))
qqPlot(max)
