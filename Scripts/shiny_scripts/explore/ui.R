# Have to put video in the www folder of this shiny app

source("lists.R")

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
                                            value = 10),
                                sliderInput("time.elapsed", "Time Elapsed:", 
                                            min = head(time_elapsed, n=1), 
                                            max = tail(time_elapsed, n=1), 
                                            value = head(time_elapsed, n=1), 
                                            step= (head(time_elapsed, n=2)[2]-head(time_elapsed, n=2)[1])),
                                radioButtons("image.type", "Image Type:", image_type_names)
                              ),
                              
                              mainPanel(
                                tabsetPanel(
                                  tabPanel("Live Images", 
                                           imageOutput("display.image")),
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
                   ),
                   tabPanel("QC",
                            
                            # Application title
                            titlePanel("Quality Control"),
                            
                            # Layout
                            sidebarLayout(
                              
                              sidebarPanel(
                                radioButtons("QC.marker", "Phenotypic Marker:", phenotypic_marker_names)
                              ),
                              
                              mainPanel(plotOutput("QC.by.plate"))
                            )
                   ),
                   tabPanel("Curve Metrics",
                            
                            # Application title
                            titlePanel("QQ Plots and Density Plots of Curve Metrics"),
                            
                            # Layout
                            sidebarLayout(
                              
                              sidebarPanel(
                                radioButtons("metric.marker", "Phenotypic Marker:", phenotypic_marker_names),
                                radioButtons("metric", "Metric:", metric_names)
                              )
                              ,
                              
                              mainPanel(
                                tabsetPanel(
                                  tabPanel("QQ Plot", plotOutput("qq.plot.one.metric")),
                                  tabPanel("Density Plot", plotOutput("density.plot.one.metric"))
                                )
                              )
                            )
                   ),
                   #### !!!!!!!! STILL HAVE TO DO UNDER NEGATIVE CONTROL
                   tabPanel("Timing",
                            
                            # Application title
                            titlePanel("Early- vs Late-Acting Compounds"),
                            
                            # Layout
                            sidebarLayout(
                              
                              sidebarPanel(
                                radioButtons("early.vs.late.marker", "Phenotypic Marker:", phenotypic_marker_names),
                                radioButtons("above.or.below.NC", "With respect to negative control confidence interval:", above_or_below_list)
                              )
                              ,
                              
                              mainPanel(plotOutput("early.vs.late.acting"))
                            )
                   )
                   # TAKES SO LONG!!!!!
#                    ,
#                    tabPanel("Overview",
#                             
#                             # Application title
#                             titlePanel("All Sparklines"),
#                             
#                             # Layout
#                             sidebarLayout(
#                               
#                               sidebarPanel(
#                                 radioButtons("overview.marker", "Phenotypic Marker:", phenotypic_marker_names)
#                               ),
#                               
#                               mainPanel(h6("Note: Background to each plot is coloured by the delta (max-min) value."),
#                                         plotOutput("QC.by.plate"))
#                             )
#                    )
))

