install.packages("devtools")
install_github("plotly", "ropensci")
library(devtools)
library(plotly)
library(ggplot2)
py <- plotly("mas29", "8s6jru0os3")


plot <- ggplot(sytoxG_data_features, aes(delta_min_max, Pathway, text=Compound)) + 
  geom_point()
py$ggplotly(plot, kwargs=list(world_readable=FALSE))

