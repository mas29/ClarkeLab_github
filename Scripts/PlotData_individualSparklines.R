# Plotting data as individual sparklines (one per compound)

#sytoxG sparklines - lines coloured by delta max-min
ggplot(sytoxG_data, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), 
           group=Compound, colour = as.numeric(delta_min_max))) +
  geom_line() +
  scale_color_gradient(low="black", high="red") +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time") +
  facet_wrap(~ Compound, ncol = 44, scales = "fixed") +
  labs(color = "Delta (max-min)") +
  theme(panel.grid = element_blank(),
        strip.text=element_blank(),
        axis.text = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        legend.key.height = unit(.85, "cm"),
        panel.background = element_rect(fill = "white"),
        panel.margin = unit(.085, "cm"))

#sytoxG sparklines - fill coloured by delta max-min
ggplot(sytoxG_data, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), 
           group=Compound)) +
  geom_rect(data = sytoxG_data, aes(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf, fill = delta_min_max), alpha = 0.4) +
  geom_line() +
  scale_fill_gradient2(low = "red", mid = "white", high = "red",
                       midpoint = 0, space = "rgb", na.value = "grey50", guide = "colourbar") + 
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time") +
  facet_wrap(~ Compound, ncol = 44, scales = "fixed") +
  labs(fill = "Delta (max-min)") +
  theme(panel.grid = element_blank(),
        strip.text=element_blank(),
        axis.text = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        legend.key.height = unit(.85, "cm"),
        panel.background = element_rect(fill = "white"),
        panel.margin = unit(.085, "cm"))

#sytoxG sparklines - fill coloured by AUC trapezoidal integration
ggplot(sytoxG_data, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), 
           group=Compound)) +
  geom_rect(data = sytoxG_data, aes(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf, fill = AUC_trapezoidal_integration), alpha = 0.4) +
  geom_line() +
  scale_fill_gradient2(low = "red", mid = "white", high = "red",
                       midpoint = 0, space = "rgb", na.value = "grey50", guide = "colourbar") + 
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time") +
  facet_wrap(~ Compound, ncol = 44, scales = "fixed") +
  labs(fill = "AUC trapezoidal integration") +
  theme(panel.grid = element_blank(),
        strip.text=element_blank(),
        axis.text = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        legend.key.height = unit(.85, "cm"),
        panel.background = element_rect(fill = "white"),
        panel.margin = unit(.085, "cm"))