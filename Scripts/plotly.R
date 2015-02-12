# install.packages("devtools")
# install_github("plotly", "ropensci")
library(devtools)
library(plotly)
library(ggplot2)
library(grid)
library(plyr)
py <- plotly("mas29", "8s6jru0os3")

# Delta(max-min) by pathway
plot <- ggplot(sytoxG_data_features, aes(Pathway, delta_min_max, text=Compound)) + 
  geom_point(alpha=0.4) +
  ylab("Delta (max-min)") +
  theme(panel.grid = element_blank(),
        panel.background = element_rect(fill = "white"),
        axis.text.x = element_text(size=6, angle=75))
py$ggplotly(plot, kwargs=list(world_readable=FALSE, layout=list(hovermode="closest")))


# Control vs Treatment, by plate as well
plot <- ggplot(sytoxG_data, 
               aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), text=Compound,
                   group=Compound, Plate)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green Over Time - Control vs Treatment") +
  facet_grid(~empty, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"), 
        axis.text = element_blank())
py$ggplotly(plot, kwargs=list(world_readable=FALSE))

#sparklines by pathway
plot <- ggplot(sytoxG_data, 
               aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound,
                   text=Compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Facets: Pathway") +
  facet_wrap(~Pathway, ncol=6, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"),
        strip.text.x = element_text(size=4),
        axis.text.x = element_blank())
py$ggplotly(plot, kwargs=list(world_readable=FALSE))



######## WORKING OUT KINKS ############


plot <- ggplot(sytoxG_data, 
               aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), 
                   group=Compound, text=Compound)) +
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
py$ggplotly(plot, kwargs=list(world_readable=FALSE, layout=list(hovermode="closest")))

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

sm_ds_features <- sytoxG_data_features[1:100,]
sm_ds <- sytoxG_data[1:2400,]
t(matrix(sm_ds_features$delta_min_max, nrow=44))

trace1 <- list(
  list(
    z = t(matrix(sm_ds_features$delta_min_max, nrow=44)), 
    type = "heatmap"
  )
)
trace3 <- list(
  list(
    x = c("2013-10-04 22:23:00", "2013-11-04 22:23:00", "2013-12-04 22:23:00"), 
    y = c(1, 3, 6), 
    type = "scatter"
  )
)
trace2 <- ggplot(sm_ds, 
                 aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), 
                     group=Compound, text=Compound)) +
  geom_tile(aes(fill=delta_min_max))  +
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

data <- list(trace1, trace3)
response <- py$plotly(data, kwargs=list(filename="basic-heatmap", fileopt="overwrite"))
url <- response$url

