# Script that will fully visualize and analyze your data 
# (although you must make sure the paramteres in Configure.R are set according to your filesystem and needs)

# -------------------------------------------------

#!!!!!! SET WORKING DIRECTORY....... :-(
#!!!!! ERROR IN PLOTLY..... :-(

setwd("/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Scripts")

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

# Target Analysis
knitr::knit2html("TargetAnalysis.Rmd")
browseURL("TargetAnalysis.html")

# Early-Acting vs Late-Acting Analysis
knitr::knit2html("EarlyActingVsLateActingCurves.Rmd")
browseURL("EarlyActingVsLateActingCurves.html")

# Cluster Analysis
knitr::knit2html("ClusterAnalysis.Rmd")
browseURL("ClusterAnalysis.html")

# QQ Plots and Density Plots of Negative Controls vs Treatments
knitr::knit2html("QQPlotsAndDensityPlots.Rmd")
browseURL("QQPlotsAndDensityPlots.html")

# Explore individual compounds
setwd("../Scripts")
runApp("shiny_scripts/temp_sparklines", launch.browser = TRUE)

