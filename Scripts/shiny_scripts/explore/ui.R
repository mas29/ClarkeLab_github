# Have to put video in the www folder of this shiny app

# Get list of compounds
compounds <- as.character(sort(unique(data_wide$Compound)))
compound_list <- as.list(setNames(compounds, compounds))

# Get list of targets
targets <- as.character(sort(unique(data_wide$Target.class..11Mar15.)))
target_list <- as.list(setNames(targets, targets))

# Get list of pathways
pathways <- as.character(sort(unique(data_wide$Pathway)))
pathway_list <- as.list(setNames(pathways, pathways))

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
                                           #  h6("Live Images:", br(), tags$video(src = "video.mp4", type = "video/mp4", width = "600px", height = "600px", 
                                           #   autoplay = NA, controls = "controls"))),
                                           img(src = "Converted.jpeg", width = "696px", height = "520px")),
                                  tabPanel("Sparkline", plotOutput("compound.sparklines")
                                           # ,textOutput("compound.additional_info")
                                  ), 
                                  tabPanel("Target", plotOutput("compound.target")),
                                  tabPanel("Pathway", plotOutput("compound.pathway")),
                                  tabPanel("Clusters", plotOutput("compound.cluster"))
                                )
                              )
                            )
                   ),
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
                                radioButtons("target.marker", "Phenotypic Marker:", phenotypic_marker_names),
                                sliderInput("target.clusters",
                                            "Number of Clusters:",
                                            min = 1,
                                            max = 25,
                                            value = 10)
                              ),
                              
                              mainPanel(
                                tabsetPanel(
                                  tabPanel("Sparklines", plotOutput("target.sparklines")), 
                                  tabPanel("Pathways", plotOutput("target.pathway")),
                                  #                                   tabPanel("Pathway", plotOutput("compound.pathway")),
                                  tabPanel("Clusters", plotOutput("target.cluster"))
                                )
                              )
                            )
                   ),
                   tabPanel("Pathway",
                            
                            # Application title
                            titlePanel("Pathway Perspective"),
                            
                            # Layout
                            sidebarLayout(
                              
                              sidebarPanel(
                                selectizeInput(
                                  "pathway", 'Pathway of Interest (Select or Type)', choices = pathway_list,
                                  multiple = FALSE
                                ),
                                radioButtons("pathway.marker", "Phenotypic Marker:", phenotypic_marker_names),
                                sliderInput("pathway.clusters",
                                            "Number of Clusters:",
                                            min = 1,
                                            max = 25,
                                            value = 10)
                              ),
                              
                              mainPanel(
                                tabsetPanel(
                                  tabPanel("Sparklines", plotOutput("pathway.sparklines")),
                                  tabPanel("Clusters", plotOutput("pathway.cluster"))
                                )
                              )
                            )
                   )
))

