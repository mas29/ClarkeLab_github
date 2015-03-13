library(shiny)
library(ggplot2)
library(grid)

# Load files
dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
#dir = "/Users/mas29/Documents/ClarkeLab_github/"
load(file=paste(dir,"DataObjects/sytoxG_data.R",sep=""))
load(file=paste(dir,"DataObjects/confluency_data.R",sep=""))

# Number of time intervals
num_time_intervals <- length(unique(sytoxG_data$time_elapsed))

# Confidence interval bounds
confidence_intervals_SG <- sytoxG_data[1:num_time_intervals,c("time_elapsed", "phenotype_value.NC.upper", "phenotype_value.NC.mean", "phenotype_value.NC.lower")]
confidence_intervals_Con <- confluency_data[1:num_time_intervals,c("time_elapsed", "phenotype_value.NC.upper", "phenotype_value.NC.mean", "phenotype_value.NC.lower")]

# Get rid of negative control data
sytoxG_data_no_NC <- sytoxG_data[which(sytoxG_data$empty == "Treatment"),]
confluency_data_no_NC <- confluency_data[which(confluency_data$empty == "Treatment"),]

# Get axis limits
y_limits_SG <- c(min(sytoxG_data$phenotype_value), max(sytoxG_data$phenotype_value))
y_limits_Con <- c(min(confluency_data$phenotype_value), max(confluency_data$phenotype_value))

# Function to plot 
plot <- function(df, confidence_intervals, phenotypic_marker_name, phenotypic_marker_units, y_axis_limits, compound) {
  ggplot() +
    geom_line(data = df, aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound)) +
    geom_ribbon(data = confidence_intervals, mapping = aes(x = time_elapsed, ymin = phenotype_value.NC.lower, ymax = phenotype_value.NC.upper, fill = "red", colour = NULL), alpha = 0.2) +
    scale_fill_manual(name = "Legend", values = 'red', labels = paste(phenotypic_marker_name,'\nNegative Control\n99.9% C.I.',sep="")) +
    xlab("Time Elapsed (hours)") +
    ylab(paste(phenotypic_marker_name," ",phenotypic_marker_units,sep="")) +
    ggtitle(paste(phenotypic_marker_name," Levels for ",compound," Over Time",sep="")) +
    scale_y_continuous(limits = c(y_axis_limits[1], y_axis_limits[2])) +
    theme(panel.grid = element_blank(),
          strip.text=element_blank(),
          legend.key.height = unit(.85, "cm"),
          panel.background = element_rect(fill = "white"),
          panel.margin = unit(.085, "cm"))
}


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Expression that generates a sparkline for the selected compound. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  output$sparklines <- renderPlot({
    
    sytoxG_data_no_NC.sub <- sytoxG_data_no_NC[sytoxG_data_no_NC$Compound == input$compound,] 
    confluency_data_no_NC.sub <- confluency_data_no_NC[confluency_data_no_NC$Compound == input$compound,] 
    
    if (input$marker == "Sytox Green") {
      plot(sytoxG_data_no_NC.sub, confidence_intervals_SG, "Sytox Green", "(green cells / mm^2)", y_limits_SG, input$compound)
    }
    else if (input$marker == "Confluency") {
      plot(confluency_data_no_NC.sub, confidence_intervals_Con, "Confluency", "(% area occupied by cells)", y_limits_Con, input$compound)
    }
  })
})
