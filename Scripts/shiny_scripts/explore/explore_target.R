#####################################################################################
###### ----------- Plot individual sparkline for this compound --------------- ######
#####################################################################################


# Function to plot sparkline for compound and phenotypic marker of interest
# param df -- data in tall format for particular phenotypic marker and compound
# param confidence_intervals -- confidence intervals for the negative control of this phenotypic marker
# param phenotypic_marker_name -- name of phenotypic marker (e.g. "Sytox Green")
# param target -- name of target
plot_target_sparklines <- function(df, confidence_intervals, phenotypic_marker_name, target) {
  ggplot() +
    geom_line(data = df, aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound, colour = "blue")) +
    geom_ribbon(data = confidence_intervals, mapping = aes(x = time_elapsed, ymin = phenotype_value.NC.lower, ymax = phenotype_value.NC.upper, 
                                                           fill = "red", colour = NULL), alpha = 0.2) +
    scale_fill_manual(name = "Legend", values = 'red', labels = paste(phenotypic_marker_name,'\nNegative Control\n99.9% C.I.',sep="")) +
    xlab("Time Elapsed (hours)") +
    ylab(phenotypic_marker_name) +
    ggtitle(paste(phenotypic_marker_name," Levels for [Target: ",target,"] Over Time",sep="")) +
    scale_colour_manual(values=c("blue"), guide = FALSE) + 
    theme(panel.grid = element_blank(),
          strip.text=element_blank(),
          legend.key.height = unit(.85, "cm"),
          panel.background = element_rect(fill = "white"),
          panel.margin = unit(.085, "cm"))
}