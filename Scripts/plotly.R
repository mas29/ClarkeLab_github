# install.packages("devtools")
# install_github("plotly", "ropensci")
library(devtools)
library(plotly)
library(ggplot2)
py <- plotly("mas29", "8s6jru0os3")


plot <- ggplot(sytoxG_data_features, aes(Pathway, delta_min_max, text=Compound)) + 
  geom_point(alpha=0.4) +
  ylab("Delta (max-min)") +
  theme(panel.grid = element_blank(),
        panel.background = element_rect(fill = "white"),
        axis.text.x = element_text(size=6, angle=75))
temp <- py$ggplotly(plot, kwargs=list(world_readable=FALSE))

plot <- ggplot(sm_ds, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), 
           group=Compound, text=Compound)) +
  geom_rect(data = sm_ds, aes(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf, fill = delta_min_max), alpha = 0.4) +
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
py$ggplotly(plot, kwargs=list(world_readable=FALSE))

