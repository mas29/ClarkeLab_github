# PCA on sytoxG data features 
# with guidance from http://www.r-bloggers.com/computing-and-visualizing-pca-in-r/

# install.packages("ggbiplot")
library(dplyr)
library(devtools)
library(ggbiplot)
install_github("ggbiplot", "vqv")

# load data
load("/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/DataObjects/sytoxG_data_features.R")

sytoxG_data_features_treatment_only <- sytoxG_data_features %>%
  filter(empty=="Treatment") 

data_for_pca <- sytoxG_data_features_treatment_only %>%
  select(M.w., Max.Solubility.in.DMSO, mean, min, max, AUC_trapezoidal_integration, time_to_max, 
         time_to_min, delta_min_max, delta_start_finish, most_positive_slope, time_to_most_positive_slope,
         most_negative_slope, time_to_most_negative_slope) 

sytoxG_data_features_treatment_only <- as.data.frame(sytoxG_data_features_treatment_only)

targets <- sytoxG_data_features_treatment_only$Targets
  
pathways <- sytoxG_data_features_treatment_only$Pathway

plates <- as.factor(sytoxG_data_features_treatment_only$Plate)

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


g <- ggbiplot(pca, obs.scale = 1, var.scale = 1, 
              groups = pathways, ellipse = TRUE, 
              circle = TRUE)
g <- g + scale_color_discrete(name = '')
g <- g + theme(legend.direction = 'horizontal', 
               legend.position = 'top')
print(g)
py$ggplotly(g, kwargs=list(world_readable=FALSE))
