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

# Get Q-Q Plot of the sample data for a particular feature (@param feature_name) against theoretical data with distribution 

# @param df -- data frame of data with features 
# @param feature_name -- name of feature whose distribution is in question
# @param title -- main title for all plots
get_qqplot_sample_theoretical <- function(df, feature_name, title) {
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

# Get histogram for one feature

# @param df -- data frame of data with features 
# @param feature_name -- name of feature to explore
get_single_feature_hist <- function(df, feature_name) {
  # Distributions to compare
  feature_NC <- df[df$empty == "Negative Control", colnames(df) == feature_name]
  feature_Treatment <- df[df$empty == "Treatment", colnames(df) == feature_name]
  
  # Plot
  plot <- ggplot() + 
    # As density
    geom_density(data = data.frame(feature_NC), aes(x = feature_NC, fill = 'Negative Control'), alpha = 0.5) + 
    geom_density(data = data.frame(feature_Treatment), aes(x = feature_Treatment, fill = 'Treatment'), alpha = 0.5) + 
    xlab(feature_name) +
    ggtitle(feature_name) + 
    guides(fill=guide_legend(title="Legend", direction="horizontal")) +
    theme(axis.line = element_line(colour = "black"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          panel.background = element_blank(),
          legend.key.width = unit(0.5, "cm")) 
  
  return(plot)
}

# Get qqplot for one feature

# @param df -- data frame of data with features 
# @param feature_name -- name of feature to explore
get_single_feature_qqplot <- function(df, feature_name) {
  # Distributions to compare
  feature_NC <- df[df$empty == "Negative Control", colnames(df) == feature_name]
  feature_Treatment <- df[df$empty == "Treatment", colnames(df) == feature_name]
  
  # Calculated quantiles
  q1 <- quantile(scale(feature_NC),0:100/100)
  q2 <- quantile(scale(feature_Treatment),0:100/100)
  
  # Plot
  plot <- ggplot(data=data.frame(a=q1,b=q2)) + 
    geom_point(aes(x=a,y=b)) +
    geom_abline(intercept=0,slope=1) +
    theme_bw() +
    ggtitle(feature_name) +
    xlab("Negative Control") +
    ylab("Treatment") +
    theme(axis.line = element_line(colour = "black"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          panel.background = element_blank()) 
  
  return(plot)
}

# Get Q-Q Plot of the negative control sample quantiles for all features against non-negative control sample quantiles 

# @param df -- data frame of data with features 
get_qqplot_sample_sample <- function(df) {
  
  delta_min_max_qq <- get_single_feature_qqplot(df, "delta_min_max")
  delta_min_max_hist <- get_single_feature_hist(df, "delta_min_max")
  time_to_max_qq <- get_single_feature_qqplot(df, "time_to_max")
  time_to_max_hist <- get_single_feature_hist(df, "time_to_max")
  time_x_distance.upper_qq <- get_single_feature_qqplot(df, "time_x_distance.upper")
  time_x_distance.upper_hist <- get_single_feature_hist(df, "time_x_distance.upper")
  time_to_most_positive_slope_qq <- get_single_feature_qqplot(df, "time_to_most_positive_slope")
  time_to_most_positive_slope_hist <- get_single_feature_hist(df, "time_to_most_positive_slope")
  mean_qq <- get_single_feature_qqplot(df, "mean")
  mean_hist <- get_single_feature_hist(df, "mean")
  min_qq <- get_single_feature_qqplot(df, "min")
  min_hist <- get_single_feature_hist(df, "min")
  AUC_trapezoidal_integration_qq <- get_single_feature_qqplot(df, "AUC_trapezoidal_integration")
  AUC_trapezoidal_integration_hist <- get_single_feature_hist(df, "AUC_trapezoidal_integration")
  
  mylegend<-g_legend(delta_min_max_hist)
  
    grid.arrange(delta_min_max_qq, delta_min_max_hist + theme(legend.position="none"), 
                 time_to_max_qq, time_to_max_hist + theme(legend.position="none"), 
                 time_x_distance.upper_qq, time_x_distance.upper_hist + theme(legend.position="none"), 
                 time_to_most_positive_slope_qq, time_to_most_positive_slope_hist + theme(legend.position="none"), 
                 mean_qq, mean_hist + theme(legend.position="none"), 
                 min_qq, min_hist + theme(legend.position="none"), 
                 AUC_trapezoidal_integration_qq, AUC_trapezoidal_integration_hist + theme(legend.position="none"), 
                 ncol = 2, 
                 widths=c(4, 7), 
                 heights=c(rep(10,7),1),
                 main = "Sytox Green Metrics - Q-Q Plot & Histogram", 
                 mylegend)

  
}
### TRY THIS?  to label each row


# Plot Q-Q Plots and Densityplots for various metrics - SAMPLE VS THEORETICAL
get_qqplot_sample_sample(sytoxG_data_features)



# Plot Q-Q Plots for various metrics - SAMPLE VS THEORETICAL

get_qqplot_sample_theoretical(sytoxG_data_features, "delta_min_max", "Q-Q Plots for Sytox Green: Delta (max-min)")
get_qqplot_sample_theoretical(confluency_data_features, "delta_min_max", "Q-Q Plots for Confluency: Delta (max-min)")

get_qqplot_sample_theoretical(sytoxG_data_features, "time_to_max", "Q-Q Plots for Sytox Green: Time to Max")
get_qqplot_sample_theoretical(confluency_data_features, "time_to_max", "Q-Q Plots for Confluency: Time to Max")

# SG uses time x distance UPPER, Con uses time x distance LOWER
get_qqplot_sample_theoretical(sytoxG_data_features, "time_x_distance.upper", "Q-Q Plots for Sytox Green: Time*Distance")
get_qqplot_sample_theoretical(confluency_data_features, "time_x_distance.lower", "Q-Q Plots for Confluency: Time*Distance")

get_qqplot_sample_theoretical(sytoxG_data_features, "M.w.", "Q-Q Plots for Sytox Green: Molecular Weight")
get_qqplot_sample_theoretical(confluency_data_features, "M.w.", "Q-Q Plots for Confluency: Molecular Weight")

get_qqplot_sample_theoretical(sytoxG_data_features, "Max.Solubility.in.DMSO", "Q-Q Plots for Sytox Green: Molecular Weight")
get_qqplot_sample_theoretical(sytoxG_data_features, "Max.Solubility.in.DMSO", "Q-Q Plots for Confluency: Molecular Weight")










