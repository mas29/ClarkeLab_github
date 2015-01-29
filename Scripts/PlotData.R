# install.packages("ggplot2")
library(ggplot2)
library("grid")

#set paths
dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
#dir = "/Users/mas29/Documents/ClarkeLab_github/"

#load dataset
load(paste(dir,"DataObjects/confluency_sytoxG_data.R",sep=""))

sytoxG_data <- subset(confluency_sytoxG_data, phenotypic_Marker == "Sytox Green")
confluency_data <- subset(confluency_sytoxG_data, phenotypic_Marker == "Confluency")

sm_ds <- sytoxG_data[1:2408,]


#sytoxG sparklines - fixed scale - lines coloured by delta max-min
ggplot(sytoxG_data, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), 
           group=Compound, colour = as.numeric(delta_min_max))) +
  geom_line() +
  scale_color_gradient(low="black", high="red") +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time") +
  facet_grid(Compound~., scales = "fixed") +
  facet_wrap(~ Compound, ncol = 44, scales = "fixed") +
  labs(color = "Delta (max-min)") +
  theme(panel.grid = element_blank(),
        strip.text=element_blank(),
        axis.text = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        legend.key.height = unit(.85, "cm"),
        panel.background = element_rect(fill = "white"),
        panel.margin = unit(.085, "cm"),
        strip.background = element_rect(fill = "white"))

#sytoxG sparklines - free scale - lines coloured by delta max-min
ggplot(sytoxG_data, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), 
           group=Compound, colour = as.numeric(delta_min_max))) +
  geom_line() +
  scale_color_gradient(low="black", high="red") +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time") +
  facet_grid(Compound~., scales = "free") +
  facet_wrap(~ Compound, ncol = 44, scales = "free") +
  labs(color = "Delta (max-min)") +
  theme(panel.grid = element_blank(),
        strip.text=element_blank(),
        axis.text = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        legend.key.height = unit(.85, "cm"),
        panel.background = element_rect(fill = "white"),
        panel.margin = unit(.085, "cm"),
        strip.background = element_rect(fill = "white"))

sm_ds$time_to_most_negative_slope <- factor(sm_ds$time_to_most_negative_slope, levels = seq(1,45,2))
sm_ds$time_to_max <- factor(sm_ds$time_to_max, levels = seq(0,46,2))


#curves by time to sleepest slope, time to max
ggplot(sytoxG_data, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time") +
  facet_grid(time_to_most_negative_slope ~ time_to_max, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"))

ggplot(transform(sytoxG_data, max_cut = cut(max, seq(min(max),max(max),length.out=4))), 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), 
           group=Compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time - facets are time to max, max") +
  facet_grid(max_cut~time_to_max, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"), 
        axis.text = element_blank())

ggplot(transform(sytoxG_data, max_cut = cut(max, seq(min(max),max(max),length.out=4)), 
                 most_negative_slope_cut = cut(most_negative_slope, seq(min(most_negative_slope), max(most_negative_slope), 3))), 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), 
           group=Compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time - facets are most negative slope, max") +
  facet_grid(max_cut~most_negative_slope_cut, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"), 
        axis.text = element_blank())

# compare plates
ggplot(sytoxG_data, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time") +
  facet_grid(~ Plate, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"))
