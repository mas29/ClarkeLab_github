install.packages("devtools")
library(devtools)
install_github("plotly", "ropensci")
library(plotly)
library(ggplot2)
py <- plotly("mas29", "8s6jru0os3")
a <- ggplot(sytoxG_data_features, aes(delta_min_max, Pathway, text=Compound)) + 
  geom_point()

py$ggplotly(a, kwargs=list(world_readable=FALSE))


a <- ggplot(sm_ds, 
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
        panel.margin = unit(.085, "cm"),
        strip.background = element_rect(fill = "white"))


response <- py$plotly(a, kwargs=list(filename="privacy-true", world_readable=TRUE, fileopt="overwrite"))
url <- response$url

data <- list(
  list(
    x = c(0, 1, 2), 
    y = c(1, 3, 2), 
    mode = "markers", 
    text = c("Text A", "Text B", "Text C"), 
    type = "scatter"
  )
)
layout <- list(title = "Hover over the points to see the text")
py$plotly(data, kwargs=list(layout=layout, filename="hover-chart-basic", fileopt="overwrite"))

