# Script that will fully visualize and analyze your data 
# (although you must make sure the paramteres in Configure.R are set according to your filesystem and needs)

# -------------------------------------------------

setwd("Scripts")

# Run configure file 
source("Configure.R")

# Get the data
source("GetData.R")

# -------------------------------------------------

# Libraries for RMardowns
library(ggplot2)
library(grid)
library(gridExtra)
library(plyr)
library(knitr)
library(devtools)
library(car)
library(plotly)
library(reshape2)
library(gplots)
library(RColorBrewer)
library(shiny)

# Get the analyses and open them in a browser
setwd("../RMarkdowns")

# Quality Control
knitr::knit2html("QC.Rmd")
browseURL("QC.html")

# "Bricks" plot of all sparklines 
knitr::knit2html("AllSparklines.Rmd")
browseURL("AllSparklines.html")

# Pathway Analysis
knitr::knit2html("PathwayAnalysis.Rmd")
browseURL("PathwayAnalysis.html")

# Explore individual compounds
setwd("../Scripts")
runApp("shiny_scripts/temp_sparklines", launch.browser = TRUE)

