# Getting features of curves, then performing PCA on them.
# With help from http://davetang.org/muse/2013/05/09/on-curve-fitting/
library(dplyr)

# load source to GetData.R
source("/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Scripts/GetData.R")

# load the data from Giovanni (C2C12_tunicamycin_output.csv), which is all the data from 1833 compounds, 
# created by the _____ script
#!!!!!!!!!!!!!!!!!!!! replace filename of toXL data frame with the correct filename !!!!!!!!!!!!!!!!!!!
df <- read.csv(file=paste(dir,"Files/C2C12_tunicamycin_output.csv",sep=""), header=T, 
               check.names=F, row.names=1)

# preliminary processing on data
df <- preliminary_processing(df)

# work with the first compound
time_elapsed <- seq(0,46,2)
whichCompound <- 1
phenotype_values <- unlist(df[whichCompound,18:41])

#fit first degree polynomial equation:
fit1 <- lm(formula = phenotype_values ~ time_elapsed)
#second degree
fit2 <- lm(formula = phenotype_values ~ poly(time_elapsed,2,raw=TRUE))
#third degree
fit3 <- lm(formula = phenotype_values ~ poly(time_elapsed,3,raw=TRUE))
#fourth degree
fit4 <- lm(formula = phenotype_values ~ poly(time_elapsed,4,raw=TRUE))

#check the significance of the bigger model
anova(fit3,fit4)

#generate 24 numbers over the range [0,46]
xx <- seq(0,46, length=24)
plot(time_elapsed, phenotype_values, pch=19)
lines(xx, predict(fit1, data.frame(x=xx)), col="red")
lines(xx, predict(fit2, data.frame(x=xx)), col="green")
lines(xx, predict(fit3, data.frame(x=xx)), col="blue")
lines(xx, predict(fit4, data.frame(x=xx)), col="purple")

#### GET POLYNOMIAL REGRESSION COEFFICIENTS ####

# function to get the fourth degree polynomial coefficients

fit_fourth_degree_polynomial <- function(df_row) {
  time_elapsed <- seq(0,46,2)
  phenotype_values <- df_row[18:41]
  fit4 <- lm(formula = phenotype_values ~ poly(time_elapsed,4,raw=TRUE))
  return(fit4$coef)
}

# get fourth degree polynomial coefficients 

df$intercept <- apply(df, 1, function(x) {fit_fourth_degree_polynomial(x)[1]})
df$coef1 <- apply(df, 1, function(x) {fit_fourth_degree_polynomial(x)[2]})
df$coef2 <- apply(df, 1, function(x) {fit_fourth_degree_polynomial(x)[3]})
df$coef3 <- apply(df, 1, function(x) {fit_fourth_degree_polynomial(x)[4]})
df$coef4 <- apply(df, 1, function(x) {fit_fourth_degree_polynomial(x)[5]})

#### PCA ####

df <- tbl_df(df)

# SG ONLY!
df_SG <- df %>%
  filter(phenotypic_Marker == "SG") 

data_SG_for_pca <- df_SG %>%
  select(intercept, coef1, coef2, coef3, coef4) 

data_SG_for_pca <- as.data.frame(data_SG_for_pca)

targets <- df_SG$Targets

pathways <- df_SG$Pathway

plates <- as.factor(df_SG$Plate)

# # # log transform  BUT what to do with negatives...
# log_data_SG_for_pca <- log(data_SG_for_pca)

# PCA
pca <- prcomp(data_SG_for_pca, center = TRUE, scale. = TRUE) 

# Standard deviations for each PC
print(pca)

# A plot of the variances associated with each PC. 
plot(pca, type = "l")

# The importance of each PC
# 1st row -- standard deviation associated with each PC. 
# 2nd row -- proportion of the variance explained by each PC 
# 3rd row -- cumulative proportion of explained variance
summary(pca)

### add curve fits values...?


g <- ggbiplot(pca, obs.scale = 1, var.scale = 1, 
              groups = pathways, ellipse = TRUE, 
              circle = TRUE)
g <- g + scale_color_discrete(name = '')
g <- g + theme(legend.direction = 'horizontal', 
               legend.position = 'top')
print(g)

py$ggplotly(g, kwargs=list(world_readable=FALSE))

#### MERGE WITH OTHER FEATURES, PCA AGAIN ####

sytoxG_data_features_w_regression_coefs <- merge(df_SG[,c(1,18:ncol(df_SG))], sytoxG_data_features, by="Compound")

sytoxG_data_features_w_regression_coefs_treatment_only <- sytoxG_data_features_w_regression_coefs %>%
  filter(empty == "Treatment")

data_for_pca <- sytoxG_data_features_w_regression_coefs_treatment_only %>%
  select(intercept, coef1, coef2, coef3, coef4,
         M.w., Max.Solubility.in.DMSO, mean, min, max, AUC_trapezoidal_integration, time_to_max, 
         time_to_min, delta_min_max, delta_start_finish, most_positive_slope, time_to_most_positive_slope,
         most_negative_slope, time_to_most_negative_slope) 

sytoxG_data_features_w_regression_coefs_treatment_only <- as.data.frame(sytoxG_data_features_w_regression_coefs_treatment_only)

targets <- sytoxG_data_features_w_regression_coefs_treatment_only$Targets

pathways <- sytoxG_data_features_w_regression_coefs_treatment_only$Pathway

plates <- as.factor(sytoxG_data_features_w_regression_coefs_treatment_only$Plate)

# # # log transform  BUT what to do with negatives...
# log_data_for_pca <- log(data_for_pca)

# PCA
pca <- prcomp(data_for_pca, center = TRUE, scale. = TRUE) 

# Standard deviations for each PC
print(pca)

# A plot of the variances associated with each PC. 
plot(pca, type = "l")

# The importance of each PC
# 1st row -- standard deviation associated with each PC. 
# 2nd row -- proportion of the variance explained by each PC 
# 3rd row -- cumulative proportion of explained variance
summary(pca)

### add curve fits values...?


g <- ggbiplot(pca, choices = c(2,3), obs.scale = 1, var.scale = 1, 
              groups = pathways, ellipse = TRUE, 
              circle = TRUE)
g <- g + scale_color_discrete(name = '')
g <- g + theme(legend.direction = 'horizontal', 
               legend.position = 'top')
print(g)
py$ggplotly(g, kwargs=list(world_readable=FALSE))



