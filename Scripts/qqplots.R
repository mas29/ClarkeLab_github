library(car)

delta_max_min <- scale(sytoxG_data_features$delta_min_max)
qqnorm(delta_max_min, main="Normal Q-Q Plot for Sytox Green Delta (delta_max_min-min)")
qqline(delta_max_min)
delta_max_min <- scale(confluency_data_features$delta_min_max)
qqnorm(delta_max_min, main="Normal Q-Q Plot for Confluency Delta (delta_max_min-min)")
qqline(delta_max_min)

time_x_distance <- scale(sytoxG_data_features$time_x_distance)
qqnorm(time_x_distance, main="Normal Q-Q Plot for Sytox Green Time*Distance")
qqline(time_x_distance)

empty <- sytoxG_data_features$empty

qqPlot(time_x_distance, col=empty)
qqPlot(delta_max_min, col=empty)


residuals(qqnorm(delta_max_min))
qqPlot(delta_max_min, col=)


#using ggplot
get_qqplot <- function(df, feature_name, title) {
  df_scaled <- df
  df_scaled$feature_scaled <- scale(df_scaled[, colnames(df_scaled) == feature_name])
  df_scaled <- df_scaled[with(df_scaled, order(feature_scaled)), ]
  df_scaled$theoretical <- quantile(rnorm(df_scaled), seq(0, 100, length.out = nrow(df_scaled))/100)
  ggplot(data = df_scaled, aes(x=theoretical, y=feature_scaled)) + geom_point() + 
    geom_abline(intercept=0, slope=1, alpha=0.5) +
#       geom_text(aes(x=theoretical-0.05, y=feature_scaled-0.15, label=Compound, size=1)) + 
    facet_wrap(~empty) +
    ggtitle(title)
}

get_qqplot(sytoxG_data_features, "delta_min_max", "Q-Q Plot for Sytox Green Delta (max-min)")
get_qqplot(confluency_data_features, "delta_min_max", "Q-Q Plot for Confluency Delta (max-min)")
get_qqplot(sytoxG_data_features, "time_x_distance", "Q-Q Plot for Sytox Green Time*Distance")
get_qqplot(confluency_data_features, "time_x_distance", "Q-Q Plot for Confluency Time*Distance")


#find the elements off the line
#### REDO?
max_unscaled <- sytoxG_data_features$max
mean_plus_1_sd <- mean(sytoxG_data_features$max) + sd(sytoxG_data_features$max)
less_than <- max_unscaled[max_unscaled < mean_plus_1_sd]
qqPlot(less_than)


####### WORKING OUT KINKS #######


ggplot(df_scaled, aes(sample = delta_min_max_scaled, label=Compound)) + stat_qq() + 
  geom_abline(linetype = "dotted") + theme_bw() +
  geom_text(aes(x = delta_min_max_scaled, y = 0.5, label=df_scaled$empty, size=1, colour=df_scaled$empty))
