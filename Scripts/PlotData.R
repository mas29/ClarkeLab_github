# install.packages("ggplot2")
# install.packages("grid")
# install.packages("plyr")
library(ggplot2)
library("grid")
library(ply)

#set paths
# dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
dir = "/Users/mas29/Documents/ClarkeLab_github/"

# COMMENTED OUT because IRMACS fatal error with saving this object
# #load dataset
# load(paste(dir,"DataObjects/confluency_sytoxG_data.R",sep=""))

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


#sytoxG sparklines, faceted by time to most positive slope, time to max
ggplot(sytoxG_data, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Facets: Time to Most Positive Slope vs Time to Max") +
  facet_grid(time_to_most_positive_slope ~ time_to_max, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"))

#sytoxG sparklines, faceted by by time to max vs max
ggplot(transform(sytoxG_data, max_cut = cut(max, seq(min(max),max(max),length.out=4))), 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), 
           group=Compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time - Facets: Time to Max, Max") +
  facet_grid(max_cut~time_to_max, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"), 
        axis.text = element_blank())

#sytoxG - most positive slope vs max value
ggplot(transform(sytoxG_data, max_cut = cut(max, seq(min(max),max(max),length.out=4)), 
                 most_positive_slope_cut = cut(most_positive_slope, seq(min(most_positive_slope), max(most_positive_slope), 3))), 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), 
           group=Compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time - Facets: Most Positive Slope, Max") +
  facet_grid(max_cut~most_positive_slope_cut, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"), 
        axis.text = element_blank(), 
        strip.text.x = element_text(size=4, angle=75),
        strip.text.y = element_text(size=8))

# compare sytoxG sparklines, faceted by plates
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

# plot sparklines for negative controls vs others
ggplot(transform(sytoxG_data,
                 empty = grepl("Empty", sytoxG_data$Compound)), 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), 
           group=Compound, Plate)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time - empty vs not empty") +
  facet_grid(~empty, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"), 
        axis.text = element_blank())

#sytoxG - calculate mean and sd values for each plate, empty vs not empty
sytoxG_data_empty <- transform(sytoxG_data, empty = grepl("Empty", sytoxG_data$Compound))
sytoxG_mean_sd_empty <- ddply(sytoxG_data_empty, ~ Plate * time_elapsed * empty, summarize,
                        mean = mean(phenotype_value), sd = sd(phenotype_value))


# Error: 'names' attribute [46080] must be the same length as the vector [....] 

#sytoxG - plot mean and sd values for each plate, neg. control vs others - using geom_line()
ggplot(sytoxG_mean_sd_empty, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(mean), colour = as.factor(Plate), group = Plate)) +
  geom_line(aes(size=sd)) +
  facet_grid(~ empty, scales = "fixed") +
  xlab("Time Elapsed") +
  ylab("Sytox Green Mean") +
  ggtitle("Sytox Green - Plate Mean & SD (line size) & Negative Control T/F (facets)") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white")) 

#sytoxG - plot mean and sd values for each plate, neg.control vs others - using geom_ribbon()
ggplot(sytoxG_mean_sd_empty, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(mean), colour = as.factor(Plate), group = Plate)) +
  geom_ribbon(aes(ymin=mean-sd, ymax=mean+sd), alpha=0.2) + 
  facet_grid(~ empty, scales = "fixed") +
  xlab("Time Elapsed") +
  ylab("Sytox Green Mean") +
  ggtitle("Sytox Green - Plate Mean & SD (line size) & Negative Control T/F (facets)") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white")) 




## geom_ribbon ??

http://svitsrv25.epfl.ch/R-doc/library/ggplot2/html/geom_ribbon.html


### which has slope zero?

temp <- sytoxG_data %>%
  arrange(max) %>%
  filter(phenotypic_Marker=="Sytox Green") %>%
  filter(Compound == "Bilobalide")

temp <- temp %>%
  arrange(Compound, phenotypic_Marker, time_elapsed)


