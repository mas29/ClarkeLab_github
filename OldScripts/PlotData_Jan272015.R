# install.packages("ggplot2")
library(ggplot2)
library("grid")
######################

first_half_dataset <- sytoxG_all_plates_for_data_vis[1:23040,]
second_half_dataset <- sytoxG_all_plates_for_data_vis[23041:46080,]
sm_ds <- sytoxG_all_plates_for_data_vis[1:2304,]


#fixed scale
sytoxG_first_half_not_scaled <- 
  ggplot(first_half_dataset, 
         aes(x=as.numeric(time_elapsed), y=as.numeric(sytoxG_value), 
             group=compound, colour = as.numeric(delta_min_max), size=1.5)) +
  geom_line() +
  scale_color_gradient(low="black", high="red") +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time") +
  facet_grid(compound~., scales = "fixed") +
  facet_wrap(~ compound, ncol = 44, scales = "fixed") +
  labs(color = "Delta (max-min)") +
  theme(panel.grid = element_blank(),
        strip.text=element_blank(),
        axis.text = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        legend.key.height = unit(.85, "cm"),
        panel.background = element_rect(fill = "white"),
        panel.margin = unit(.085, "cm"),
        strip.background = element_rect(fill = "white"))

#free scale
sytoxG_first_half_scaled <- 
  ggplot(first_half_dataset, 
         aes(x=as.numeric(time_elapsed), y=as.numeric(sytoxG_value), 
             group=compound, colour = as.numeric(delta_min_max))) +
  geom_line() +
  scale_color_gradient(low="black", high="red") +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time") +
  facet_grid(compound~., scales = "free") +
  facet_wrap(~ compound, ncol = 44, scales = "free") +
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

#!!!!!!!!! BIN FACETING of max?
#curves by time to sleepest slope, time to max
sytoxG_time_vs_steepest_slope <- 
  ggplot(sm_ds, 
         aes(x=as.numeric(time_elapsed), y=as.numeric(sytoxG_value), group=compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time") +
  facet_grid(time_to_most_negative_slope~time_to_max, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"))
