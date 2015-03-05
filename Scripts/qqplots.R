library(car)
library(ggplot2)
library(grid)
library(gridExtra)



# Function to extract legend
# From: https://github.com/hadley/ggplot2/wiki/Share-a-legend-between-two-ggplot2-graphs
g_legend<-function(a.gplot){
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)}

# Get Q-Q Plot of the sample data for a particular feature (@param feature_name) against theoretical data with distribution (@param distribution)

# @param df -- data frame of data with features 
# @param feature_name -- name of feature whose distribution is in question
# @param title -- main title for all plots
get_qqplot <- function(df, feature_name, title) {
  df$feature <- df[, colnames(df) == feature_name]
  normal <- ggplot(df, aes(sample = scale(feature))) + stat_qq(distribution = qnorm, aes(colour = empty)) + geom_abline(intercept=0, slope=1) + ggtitle("Normal Distribution") + theme(legend.position="bottom") 
  lognormal <- ggplot(df, aes(sample = scale(feature))) + stat_qq(distribution = qlnorm, aes(colour = empty)) + geom_abline(intercept=0, slope=1) + ggtitle("Lognormal Distribution") 
  logistic <- ggplot(df, aes(sample = scale(feature))) + stat_qq(distribution = qlogis, aes(colour = empty)) + geom_abline(intercept=0, slope=1) + ggtitle("Logistic Distribution") 
  cauchy <- ggplot(df, aes(sample = scale(feature))) + stat_qq(distribution = qcauchy, aes(colour = empty)) + geom_abline(intercept=0, slope=1) + ggtitle("Cauchy Distribution") 
  unif <- ggplot(df, aes(sample = scale(feature))) + stat_qq(distribution = qunif, aes(colour = empty)) + geom_abline(intercept=0, slope=1) + ggtitle("Uniform Distribution") 
  mylegend<-g_legend(normal)
  grid.arrange(arrangeGrob(
    normal + theme(legend.position="none"), 
    lognormal + theme(legend.position="none"), 
    logistic + theme(legend.position="none"), 
    cauchy + theme(legend.position="none"), 
    unif + theme(legend.position="none"), 
    ncol = 3), nrow = 2, heights=c(10, 1), main = title, mylegend)
}

#   chisquared <- ggplot(df, aes(sample = scale(feature))) + stat_qq(distribution = qchisq) + geom_abline(intercept=0, slope=1) + ggtitle("Chi-Squared Distribution") 
#   gamma <- ggplot(df, aes(sample = scale(feature))) + stat_qq(distribution = qgamma) + geom_abline(intercept=0, slope=1) + ggtitle("Gamma Distribution") 
#   beta <- ggplot(df, aes(sample = scale(feature))) + stat_qq(distribution = qbeta) + geom_abline(intercept=0, slope=1) + ggtitle("Beta Distribution") 
#   f <- ggplot(df, aes(sample = scale(feature))) + stat_qq(distribution = qf) + geom_abline(intercept=0, slope=1) + ggtitle("F Distribution") 

#qlogis qlnorm qt qcauchy qgamma qchisq qnorm qbeta qf qunif loaded

get_qqplot(sytoxG_data_features, "delta_min_max", "Q-Q Plots for Sytox Green: Delta (max-min)")
get_qqplot(confluency_data_features, "delta_min_max", "Q-Q Plots for Confluency: Delta (max-min)")

get_qqplot(sytoxG_data_features, "time_to_max", "Q-Q Plots for Sytox Green: Time to Max")
get_qqplot(confluency_data_features, "time_to_max", "Q-Q Plots for Confluency: Time to Max")

# SG uses time x distance UPPER, Con uses time x distance LOWER
get_qqplot(sytoxG_data_features, "time_x_distance.upper", "Q-Q Plots for Sytox Green: Time*Distance")
get_qqplot(confluency_data_features, "time_x_distance.lower", "Q-Q Plots for Confluency: Time*Distance")

get_qqplot(sytoxG_data_features, "M.w.", "Q-Q Plots for Sytox Green: Molecular Weight")
get_qqplot(confluency_data_features, "M.w.", "Q-Q Plots for Confluency: Molecular Weight")

get_qqplot(sytoxG_data_features, "Max.Solubility.in.DMSO", "Q-Q Plots for Sytox Green: Molecular Weight")
get_qqplot(sytoxG_data_features, "Max.Solubility.in.DMSO", "Q-Q Plots for Confluency: Molecular Weight")




####### WORKING OUT KINKS #######

df_scaled$theoretical <- quantile(rnorm(df_scaled), seq(0, 100, length.out = nrow(df_scaled))/100)





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

qqPlot(delta_min_max, distribution="normal")
qqPlot(time_x_distance, col=empty)
qqPlot(delta_max_min, col=empty)

x = rweibull(20, 8, 2)
qqPlot(x, "log-normal")

residuals(qqnorm(delta_max_min))
qqPlot(delta_max_min, col=)

#find the elements off the line
#### REDO?
max_unscaled <- sytoxG_data_features$max
mean_plus_1_sd <- mean(sytoxG_data_features$max) + sd(sytoxG_data_features$max)
less_than <- max_unscaled[max_unscaled < mean_plus_1_sd]
qqPlot(less_than)

###

ggplot(df_scaled, aes(sample = delta_min_max_scaled, label=Compound)) + stat_qq() + 
  geom_abline(linetype = "dotted") + theme_bw() +
  geom_text(aes(x = delta_min_max_scaled, y = 0.5, label=df_scaled$empty, size=1, colour=df_scaled$empty))


get_qqplot <- function(df, feature_name, title, distribution) {
  df_scaled <- df
  df_scaled$feature_scaled <- scale(df[, colnames(df) == feature_name])
  df_scaled <- df_scaled[with(df_scaled, order(feature_scaled)), ]
  switch(distribution, 
         normal={
           df_scaled$theoretical <- quantile(rnorm(100000, mean = 0, sd = 1))
         },
         bar={
           # case 'bar' here...
           print('bar')    
         })
  df_scaled$theoretical <- quantile(rnorm(df_scaled), seq(0, 100, length.out = nrow(df_scaled))/100)
  ggplot(data = df_scaled, aes(x=theoretical, y=feature_scaled)) + geom_point() + 
    geom_abline(intercept=0, slope=1, alpha=0.5) +
    #       geom_text(aes(x=theoretical-0.05, y=feature_scaled-0.15, label=Compound, size=1)) + 
    facet_wrap(~empty) +
    ggtitle(title)
}

get_qqplot <- function(df, feature_name, title, distribution) {
  df$feature_scaled <- df[, colnames(df) == feature_name]
  title_edited <- paste(title, ": ", distribution, " Distribution", sep="")
  switch(distribution, 
         Normal={
           ggplot(df, aes(sample = scale(feature_scaled))) + stat_qq(distribution = qnorm) + ggtitle(title_edited) 
         },
         Lognormal={
           ggplot(df, aes(sample = scale(feature_scaled))) + stat_qq(distribution = qlnorm) + ggtitle(title_edited) 
         },
         Uniform)
  multiplot(p1, p2, p3, p4, cols=2)
}