# Getting features of curves, then performing PCA on them.
# With help from http://davetang.org/muse/2013/05/09/on-curve-fitting/
library(dplyr)
library(ggbiplot)
### FUNCTIONS ###

# Function to perform PCA. Takes in the data, the groups to identify in PCA, and any other features of the graph.

perform_PCA <- function(data, groups, ...) {
  # PCA
  pca <- prcomp(data, center = TRUE, scale. = TRUE) 
  
  # Standard deviations for each PC
  print(pca)
  
  # A plot of the variances associated with each PC. 
  plot(pca, type = "l")
  
  # The importance of each PC
  # 1st row -- standard deviation associated with each PC. 
  # 2nd row -- proportion of the variance explained by each PC 
  # 3rd row -- cumulative proportion of explained variance
  print(summary(pca))
  
  # Plot.
  g <- ggbiplot(pca, obs.scale = 1, var.scale = 1, 
                groups = pathways, ellipse = TRUE, 
                circle = TRUE, ...)
  g <- g + scale_color_discrete(name = '')
  g <- g + theme(legend.direction = 'horizontal', 
                 legend.position = 'top')
  print(g)
  
  # Send to plotly.
  # py$ggplotly(g, kwargs=list(world_readable=FALSE))
}

# Function to get data for a specific phenotypic marker (input String: marker), and perform PCA.
# Input df is the df created from preliminary processing in the GetData script.

PCA_on_selected_marker <- function(df, marker) {
  
  # Get data for selected marker.
  df_marker <- df %>%
    filter(phenotypic_Marker == marker) 
  
  targets <- df_marker$Targets
  pathways <- df_marker$Pathway
  plates <- as.factor(df_marker$Plate)
  
  data_marker_for_pca <- as.data.frame(df_marker %>%
                                         select(intercept, coef1, coef2, coef3, coef4))
  
  #### MERGE WITH OTHER FEATURES, PCA AGAIN ####
  
  marker_features <- merge(df_marker[,c(1,18:ncol(df_marker))], sytoxG_data_features, by="Compound")
  
  targets <- marker_features$Targets
  pathways <- marker_features$Pathway
  plates <- as.factor(marker_features$Plate)
  
  columns_for_pca <- colnames(marker_features)[c(2:30,47:58)]
  data_marker_for_pca_more_features <- marker_features[,columns_for_pca]
  
  # Perform PCA for marker data (features: regression coefficients)
  
  perform_PCA(data_marker_for_pca, pathways)
  perform_PCA(data_marker_for_pca, plates)
  perform_PCA(data_marker_for_pca, targets)
  
  # Perform PCA for marker data (features: regression + other coefficients)
  perform_PCA(data_marker_for_pca_more_features, choices = c(1,2))
}

### END FUNCTIONS ###

# load the preliminarily processed data 

dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
#dir = "C:/Users/Dave/Documents/SFU job/Lab - muscle signaling/Dixon - myocyte expts/Maia Smith files/ClarkeLab_github/"
# dir = "/Users/mas29/Documents/ClarkeLab_github/"
load(paste(dir,"DataObjects/confluency_sytoxG_data_prelim_proc.R",sep=""))
load(paste(dir,"DataObjects/sytoxG_data_features.R",sep=""))
df <- confluency_sytoxG_data_prelim_proc

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

PCA_on_selected_marker(df, "SG")
PCA_on_selected_marker(df, "Con")



