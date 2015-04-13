# Have to put video in the www folder of this shiny app

# Get list of compounds
compounds <- as.character(sort(unique(data_wide$Compound[which(data_wide$Pathway != "NegControl")])))
compound_list <- as.list(setNames(compounds, compounds))

# Get list of targets
targets <- as.character(sort(unique(data_wide$Target.class..11Mar15.[which(data_wide$Pathway != "NegControl")])))
target_list <- as.list(setNames(targets, targets))

# Define UI
shinyUI(navbarPage("Perspective:",
                   tabPanel("Compound",
                            
                            # Application title
                            titlePanel("Compound Perspective"),
                            
                            # Layout
                            sidebarLayout(
                              
                              sidebarPanel(
                                selectizeInput(
                                  "compound", 'Compound of Interest (Select or Type)', choices = compound_list,
                                  multiple = FALSE
                                ),
                                radioButtons("marker", "Phenotypic Marker:", phenotypic_marker_names),
                                sliderInput("clusters",
                                            "Number of Clusters:",
                                            min = 1,
                                            max = 25,
                                            value = 10)
                              ),
                              
                              mainPanel(
                                tabsetPanel(
                                  tabPanel("Live Images", 
                                           h6("Live Images:", br(), tags$video(src = "video.mp4", type = "video/mp4", width = "600px", height = "600px", 
                                                                               autoplay = NA, controls = "controls"))),
                                  tabPanel("Sparkline", plotOutput("compound.sparklines")
                                           # ,textOutput("compound.additional_info")
                                  ), 
                                  tabPanel("Target", plotOutput("compound.target")),
                                  tabPanel("Pathway", plotOutput("compound.pathway")),
                                  tabPanel("Cluster", plotOutput("compound.cluster"))
                                )
                              )
                            )
                   )
                   ###### NA ERROR with target list !!!!!!!!
                   ,
                   tabPanel("Target",
                            
                            # Application title
                            titlePanel("Target Perspective"),
                            
                            # Layout
                            sidebarLayout(
                              
                              sidebarPanel(
                                selectizeInput(
                                  "target", 'Target of Interest (Select or Type)', choices = target_list,
                                  multiple = FALSE
                                ),
                                radioButtons("marker", "Phenotypic Marker:", phenotypic_marker_names),
                                sliderInput("clusters",
                                            "Number of Clusters:",
                                            min = 1,
                                            max = 25,
                                            value = 10)
                              ),
                              
                              mainPanel(
                                tabsetPanel(
                                  tabPanel("Sparklines", plotOutput("target.sparklines"))
                                  # , 
#                                   tabPanel("Target", plotOutput("compound.target")),
#                                   tabPanel("Pathway", plotOutput("compound.pathway")),
#                                   tabPanel("Cluster", plotOutput("compound.cluster"))
                                )
                              )
                            )
                            
                   )
))

