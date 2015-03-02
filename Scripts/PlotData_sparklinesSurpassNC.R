library(ggplot2)
library(grid)
dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
load(file=paste(dir,"DataObjects/sytoxG_data.R",sep=""))

# Number of time intervals
num_time_intervals <- length(unique(sytoxG_data$time_elapsed))

# Confidence interval bounds
confidence_intervals_SG <- sytoxG_data[1:num_time_intervals,c("time_elapsed", "phenotype_value.NC.upper", "phenotype_value.NC.mean", "phenotype_value.NC.lower")]
confidence_intervals_Con <- confluency_data[1:num_time_intervals,c("time_elapsed", "phenotype_value.NC.upper", "phenotype_value.NC.mean", "phenotype_value.NC.lower")]

# Get rid of negative control sparklines
sytoxG_data_no_NC <- sytoxG_data[which(sytoxG_data$empty == "Treatment"),]
confluency_data_no_NC <- confluency_data[which(confluency_data$empty == "Treatment"),]

# Plot SG
ggplot(sytoxG_data_no_NC) +
  geom_line(aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group = Compound), alpha = 0.6) +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Time Point at which Compound Surpasses Negative Control Upperbound\n(Phenotypic Marker: Sytox Green)") +
  geom_ribbon(data = confidence_intervals_SG, mapping = aes(x = time_elapsed, ymin = phenotype_value.NC.lower, ymax = phenotype_value.NC.upper,
                             fill = "red", colour = NULL), alpha = 0.6) +
  scale_fill_manual(name = "Legend",
                    values = c('red'),
                    labels = c('Negative Control')) +
  facet_wrap(~phenotype_value_exceeds_NC_upperbound.timepoint, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white")) 

# Plot confluency
ggplot(confluency_data_no_NC) +
  geom_line(aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group = Compound), alpha = 0.6) +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Time Point at which Compound Drops Below Negative Control Lowerbound\n(Phenotypic Marker: Confluency)") +
  geom_ribbon(data = confidence_intervals_Con, mapping = aes(x = time_elapsed, ymin = phenotype_value.NC.lower, ymax = phenotype_value.NC.upper,
                                                         fill = "red", colour = NULL), alpha = 0.6) +
  scale_fill_manual(name = "Legend",
                    values = c('red'),
                    labels = c('Negative Control')) +
  facet_wrap(~phenotype_value_falls_below_NC_lowerbound.timepoint, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"))



