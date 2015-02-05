# Plotting sparklines, faceted by certain features

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