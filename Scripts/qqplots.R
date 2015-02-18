delta_max_min <- scale(sytoxG_data_features$delta_min_max)
qqnorm(delta_max_min, main="Normal Q-Q Plot for Sytox Green Delta (delta_max_min-min)")
delta_max_min <- scale(confluency_data_features$delta_min_max)
qqnorm(delta_max_min, main="Normal Q-Q Plot for Confluency Delta (delta_max_min-min)")

residuals(qqnorm(delta_max_min))
qqPlot(delta_max_min)



#find the elements off the line
#### REDO?
max_unscaled <- sytoxG_data_features$max
mean_plus_1_sd <- mean(sytoxG_data_features$max) + sd(sytoxG_data_features$max)
less_than <- max_unscaled[max_unscaled < mean_plus_1_sd]
qqPlot(less_than)