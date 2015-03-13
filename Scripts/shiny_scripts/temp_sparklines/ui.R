library(shiny)

# Load files
dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
#dir = "/Users/mas29/Documents/ClarkeLab_github/"
load(file=paste(dir,"DataObjects/sytoxG_data.R",sep=""))

# Get rid of negative control data
sytoxG_data_no_NC <- sytoxG_data[which(sytoxG_data$empty == "Treatment"),]

# Get list of compounds
compounds <- unique(sytoxG_data_no_NC$Compound)
compound_list <- as.list(setNames(compounds, compounds))


# Define UI 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Explore Selected Compound"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      selectizeInput(
        "compound", 'Select or Type Compound of Interest', choices = compound_list,
        multiple = FALSE
      ),
      radioButtons("marker", "Phenotypic Marker:",
                   c("Sytox Green" = "Sytox Green",
                     "Confluency" = "Confluency"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("sparklines")
    )
  )
))



