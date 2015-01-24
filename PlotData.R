install.packages("ggplot2")
library(ggplot2)
library("grid")
######################

p1 <- 
  ggplot(confluency_all_plates_for_data_vis, aes(x=as.numeric(time_elapsed), y=as.numeric(confluency_value), group=compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Confluency") +
  ggtitle("Confluency - Muscle Cells Over Time")
p1


p1 <- 
  ggplot(sytoxG_all_plates_for_data_vis, aes(x=as.numeric(time_elapsed), y=as.numeric(sytoxG_value), group=compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time")
p1

p1 <- 
  ggplot(sytoxG_all_plates_for_data_vis, 
         aes(x=as.numeric(time_elapsed), y=as.numeric(sytoxG_value), group=compound, colour = as.numeric(max))) +
  geom_line() +
  scale_color_gradient(low="darkkhaki", high="darkgreen") +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p1

small_dataset <- sytoxG_all_plates_for_data_vis[1:480,]
p1 <- 
  ggplot(sytoxG_all_plates_for_data_vis, 
         aes(x=as.numeric(time_elapsed), y=as.numeric(sytoxG_value), 
             group=compound, colour = as.numeric(delta_min_max))) +
  geom_line() +
  scale_color_gradient(low="darkkhaki", high="darkgreen") +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time") +
  facet_grid(compound~., scales = "free") +
  facet_wrap(~ compound, ncol = 44, scales = "free") + 
  theme(panel.grid = element_blank(),
        strip.text.x = element_text(size=3, angle=75),
        strip.text.y = element_text(size=12, face="bold"),
        axis.text = element_text(size=3),
        axis.ticks.length = unit(.0085, "cm"),
        panel.background = element_rect(fill = "white"))
p1


legend.title=element_text("horizontal"),
#get rid of text
+ theme(text = element_blank())