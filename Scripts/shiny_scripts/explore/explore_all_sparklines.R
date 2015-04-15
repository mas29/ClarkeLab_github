# Function to plot all sparklines for phenotypic marker of interest
# param df -- data in tall format for particular phenotypic marker
# param phenotypic_marker_name -- phenotypic marker of interest
plot_all_sparklines <- function(df, phenotypic_marker_name) {
  ggplot(df, 
         aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), 
             group=Compound)) +
    geom_rect(data = df, aes(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf, fill = delta_min_max), alpha = 0.4) +
    geom_line() +
    scale_fill_gradient2(low = "red", mid = "white", high = "red",
                         midpoint = 0, space = "rgb", na.value = "grey50", guide = "colourbar") + 
    xlab("Time Elapsed") +
    ylab(phenotypic_marker_name) +
    ggtitle(paste("All ",phenotypic_marker_name, " Sparklines", sep="")) +
    facet_wrap(~ Compound, ncol = 43, scales = "fixed") +
    labs(fill = "Delta\n(max-min)") +
    theme(panel.grid = element_blank(),
          strip.text=element_blank(),
          axis.text = element_blank(),
          axis.ticks.length = unit(0, "cm"),
          legend.key.height = unit(.85, "cm"),
          panel.background = element_rect(fill = "white"),
          panel.margin = unit(.085, "cm"),
          axis.title.x = element_text(size = 20.5, angle = 00),
          axis.title.y = element_text(size = 20.5, angle = 90),
          title = element_text(size = 35, angle = 00),
          legend.text = element_text(size = 20.5, angle = 00))
}