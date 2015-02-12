library(dplyr)
# load data
load("/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/DataObjects/sytoxG_data_features.R")

data_for_pca <- sytoxG_data_features %>%
  filter(empty="Treatment") %>%
  select(M.w., Max.Solubility.in.DMSO, mean, min, max, AUC_trapezoidal_integration, time_to_max, 
         time_to_min, delta_min_max, delta_start_finish, most_positive_slope, time_to_most_positive_slope,
         most_negative_slope, time_to_most_negative_slope) 

targets <- sytoxG_data_features %>%
  select(Targets)

pathways <- sytoxG_data_features %>%
  select(Pathway)

# # log transform 
# log.ir <- log(data_for_pca)
# ir.species <- data_for_pca[, 5]

# apply PCA - scale. = TRUE is highly 
# advisable, but default is FALSE. 
pca <- prcomp(data_for_pca, center = TRUE, scale. = TRUE) 
