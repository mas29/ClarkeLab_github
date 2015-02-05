# Plotting data for quality control -- looking at plates, negative controls

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
ggplot(sytoxG_data, 
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
sytoxG_mean_sd_empty <- ddply(sytoxG_data, ~ Plate * time_elapsed * empty, summarize,
                              mean = mean(phenotype_value), sd = sd(phenotype_value))



# Error: 'names' attribute [46080] must be the same length as the vector [....] 
# potential fix? :  install.packages("plyr", dependencies = TRUE)  
#                   library(plyr)

#sytoxG - plot mean and sd values for each plate, neg.control vs others - using geom_ribbon()
ggplot(sytoxG_mean_sd_empty, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(mean), colour = as.factor(Plate), group = Plate)) +
  geom_ribbon(aes(ymin=mean-sd, ymax=mean+sd), alpha=0.2) + 
  facet_grid(~ empty, scales = "fixed") +
  xlab("Time Elapsed") +
  ylab("Sytox Green Mean & SD") +
  ggtitle("Sytox Green - Plate Mean & SD (line size) & Negative Control T/F (facets)") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white")) 

