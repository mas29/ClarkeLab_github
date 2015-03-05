# Plotting sparklines, faceted by certain features
library(ggplot2)
library(grid)
library(plyr)

#### Pathway sparklines compared with negative controls
# Number of time intervals
num_time_intervals <- length(unique(sytoxG_data$time_elapsed))

# Confidence interval bounds
confidence_intervals_SG <- sytoxG_data[1:num_time_intervals,c("time_elapsed", "phenotype_value.NC.upper", "phenotype_value.NC.mean", "phenotype_value.NC.lower")]
confidence_intervals_Con <- confluency_data[1:num_time_intervals,c("time_elapsed", "phenotype_value.NC.upper", "phenotype_value.NC.mean", "phenotype_value.NC.lower")]

# Get rid of negative control sparklines
sytoxG_data_no_NC <- sytoxG_data[which(sytoxG_data$empty == "Treatment"),]
confluency_data_no_NC <- confluency_data[which(confluency_data$empty == "Treatment"),]

# SG
ggplot(sytoxG_data_no_NC) +
  geom_line(aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound, text=Compound)) +
  geom_ribbon(data = confidence_intervals_SG, mapping = aes(x = time_elapsed, ymin = phenotype_value.NC.lower, ymax = phenotype_value.NC.upper,
                                                            fill = "red", colour = NULL), alpha = 0.6) +
  scale_fill_manual(name = "Legend",
                    values = c('red'),
                    labels = c('Negative Control')) +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Facets: Pathway") +
  facet_wrap(~Pathway, ncol=6, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"),
        strip.text.x = element_text(size=4),
        axis.text = element_blank())

# Confluency
ggplot(confluency_data_no_NC) +
  geom_line(aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound, text=Compound)) +
  geom_ribbon(data = confidence_intervals_Con, mapping = aes(x = time_elapsed, ymin = phenotype_value.NC.lower, ymax = phenotype_value.NC.upper,
                                                             fill = "red", colour = NULL), alpha = 0.6) +
  scale_fill_manual(name = "Legend",
                    values = c('red'),
                    labels = c('Negative Control')) +
  xlab("Time Elapsed") +
  ylab("Confluency") +
  ggtitle("Confluency - Facets: Pathway") +
  facet_wrap(~Pathway, ncol=6, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"),
        strip.text.x = element_text(size=4),
        axis.text = element_blank())

###


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
ggplot(transform(sytoxG_data, max_cut = cut(max, seq(floor(min(max)),ceiling(max(max)),length.out=4))), 
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
ggplot(transform(sytoxG_data, max_cut = cut(max, seq(floor(min(max)),ceiling(max(max)),length.out=4)), 
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

# better slope analysis? (max-min)/(time_to_max-time_to_min) -- so the slope is calculated as max to min, rather than between subsequent 
# time points
sytoxG_data_max_min_slope <- sytoxG_data %>%
  mutate(max_min_slope = (max-min)/(time_to_max-time_to_min))

ggplot(transform(sytoxG_data_max_min_slope, max_min_slope_cut = cut(max_min_slope, 
                                                                    seq(floor(min(max_min_slope)),
                                                                        ceiling(max(max_min_slope)),length.out=10))), 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), 
           group=Compound, Plate)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time") +
  facet_grid(~max_min_slope_cut, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"), 
        axis.text = element_blank())



#sytoxG - most positive slope vs max value
ggplot(transform(sytoxG_data, max_cut = cut(max, seq(floor(min(max)),ceiling(max(max)),length.out=4)), 
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

#sytoxG sparklines, faceted by pathway
ggplot(sytoxG_data, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound,
           text=Compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Facets: Pathway") +
  facet_grid(~Pathway, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"),
        strip.text.x = element_text(size=4, angle=75),
        axis.text.x = element_blank())

#sytoxG coloured by target

#in order to filter down some of the data, I remove those compounds with maxima smaller than 
#or equal to the largest of the maxima for the negative controls
max_of_negative_controls_max <- max(sytoxG_data[sytoxG_data$empty=="Negative Control",]$max)
sytoxG_data_max_greater_than_neg_controls <- sytoxG_data %>%
  filter(max > max_of_negative_controls_max) %>%
  droplevels()
  
ggplot(sytoxG_data, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound,
           text=Compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green") +
  facet_wrap(~Targets, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"),
        strip.text.x = element_text(size=4),
        axis.text.x = element_blank())


#sytoxG sparklines, faceted by targets THAT ARE SIGNIFICANTLY DIFFERENT FROM ZERO
source("/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Scripts/limma.R")
sytoxG_data_significant_targets_only <- sytoxG_data[which(sytoxG_data$Targets %in% sig_targets_SG) , ]
ggplot(sytoxG_data_significant_targets_only, aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle(paste("Sytox Green - Significant Targets (p < ", sig_level, ")",sep="")) +
  facet_wrap(~Targets, ncol=6, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"),
        strip.text.x = element_text(size=4),
        axis.text = element_blank())

confluency_data_significant_targets_only <- confluency_data[which(confluency_data$Targets %in% sig_targets_Con) , ]
ggplot(confluency_data_significant_targets_only, aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Confluency") +
  ggtitle(paste("Confluency - Significant Targets (p < ", sig_level, ")",sep="")) +
  facet_wrap(~Targets, ncol=6, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"),
        strip.text.x = element_text(size=4),
        axis.text = element_blank())