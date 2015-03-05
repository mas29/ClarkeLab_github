# Brainstorming for plotting

# install.packages("ggplot2")
# install.packages("grid")
# install.packages("plyr")
library(ggplot2)
library(grid)
library(plyr)

#set paths
dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
# dir = "/Users/mas29/Documents/ClarkeLab_github/"

##load datasets
# load(paste(dir,"DataObjects/sytoxG_data.R",sep=""))

sm_ds <- sytoxG_data[1:2408,]




#stripplot for deltas in different pathways & targets

plot <- ggplot(sytoxG_data_features, aes(Pathway, delta_min_max, text=Compound)) + 
  geom_point(alpha=0.4) +
  ylab("Delta (max-min)") +
  theme(panel.grid = element_blank(),
        panel.background = element_rect(fill = "white"),
        axis.text.x = element_text(size=6, angle=75))
ggplot(sytoxG_data_features, aes(max, Pathway)) + 
  geom_point()
ggplot(sytoxG_data_features, aes(min, Pathway)) + 
  geom_point()
ggplot(sytoxG_data_features, aes(min, Form)) + 
  geom_point()
ggplot(sytoxG_data_features, aes(Pathway, time_to_max)) + 
  geom_violin() + 
  theme(axis.text.x = element_text(size=7, angle=75))

ggplot(sytoxG_data_features, aes(Targets, max)) + 
  geom_boxplot() + 
  theme(axis.text.x = element_text(size=7, angle=75)) 

ggplot(sytoxG_data_features, aes(Pathway, max)) + 
  geom_boxplot() + 
  theme(axis.text.x = element_text(size=7, angle=75)) 
ggplot(sytoxG_data_features, aes(Pathway, max)) + 
  geom_violin() + 
  theme(axis.text.x = element_text(size=7, angle=75)) 

ggplot(sytoxG_data_features, aes(delta_min_max, Targets)) + 
  geom_point()
ggplot(sytoxG_data_features, aes(max, Targets)) + 
  geom_point()
ggplot(sytoxG_data_features, aes(min, Targets)) + 
  geom_point()
ggplot(sytoxG_data_features, aes(time_to_max, Targets)) + 
  geom_point()

ggplot(transform(sytoxG_data_features, M.w._cut = cut(max, seq(min(M.w.),max(M.w.),length.out=10))), 
       aes(Pathway, M.w._cut)) + 
  geom_violin() + 
  theme(axis.text.x = element_text(size=7, angle=75)) 

# linear plots
sytoxG_data_features_no_neg_controls <- sytoxG_data_features %>%
  filter(empty == FALSE)
plot(delta_min_max ~ M.w., data=sytoxG_data_features_no_neg_controls)
plot(delta_min_max ~ Max.Solubility.in.DMSO..mM., data=sytoxG_data_features_no_neg_controls)
plot(time_to_max ~ M.w., data=sytoxG_data_features_no_neg_controls)
plot(time_to_max ~ Max.Solubility.in.DMSO..mM., data=sytoxG_data_features_no_neg_controls)
plot(most_positive_slope ~ M.w., data=sytoxG_data_features_no_neg_controls)
plot(most_positive_slope ~ Max.Solubility.in.DMSO..mM., data=sytoxG_data_features_no_neg_controls)
plot(AUC_trapezoidal_integration ~ M.w., data=sytoxG_data_features_no_neg_controls)
plot(AUC_trapezoidal_integration ~ Max.Solubility.in.DMSO..mM., data=sytoxG_data_features_no_neg_controls)

### which has slope zero?

temp <- sytoxG_data %>%
  arrange(max) %>%
  filter(phenotypic_Marker=="Sytox Green") %>%
  filter(Compound == "Bilobalide")

temp <- temp %>%
  arrange(Compound, phenotypic_Marker, time_elapsed)

