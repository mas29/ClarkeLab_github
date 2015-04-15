library(shiny)
library(ggplot2)
library(grid)

source("../../GetData.R")
source("../../GetImagesForCompound.R")
source("explore_compound.R")
source("explore_target.R")
source("explore_pathway.R")
source("explore_QC.R")
source("explore_QQ_density_plots.R")
source("explore_early_vs_late_acting.R")
source("lists.R")

# WARNING: The first time the app loads, it takes a minute to load images, plots. Afterwards, it runs smoothly.

#####################################################################################
###### --------------------- Define server logic ----------------------------- ######
#####################################################################################

# Note: The following error occurs when the "select compound" bar is empty 
#           Error in `$<-.data.frame`(`*tmp*`, "is.compound", value = FALSE) : 
#           replacement has 1 row, data has 0

# Define server logic
shinyServer(function(input, output) {
  
  # Generates a sparkline for the selected compound and phenotypic marker. 
  output$compound.sparklines <- renderPlot({
    
    # Get data for specified compound and marker
    data_tall.compound_and_marker <- subset(data_tall_each_marker[[input$marker]], Compound == input$compound)
    
    # Plot data
    plot_sparkline(data_tall.compound_and_marker, confidence_intervals_each_marker[[input$marker]], input$marker, input$compound)
  })
  
  # Generates sparklines for the selected target and phenotypic marker. 
  output$target.sparklines <- renderPlot({
    
    # Get data for specified target and marker
    data_tall.target_and_marker <- subset(data_tall_each_marker[[input$target.marker]], Target.class..11Mar15. == input$target)
    
    # Plot data
    plot_target_sparklines(data_tall.target_and_marker, confidence_intervals_each_marker[[input$target.marker]], input$target.marker, input$target)
  })
  
  # Generates sparklines for the selected pathway and phenotypic marker. 
  output$pathway.sparklines <- renderPlot({
    
    # Get data for specified pathway and marker
    data_tall.target_and_marker <- subset(data_tall_each_marker[[input$target.marker]], Pathway == input$pathway)
    
    # Plot data
    plot_pathway_sparklines(data_tall.target_and_marker, confidence_intervals_each_marker[[input$target.marker]], input$pathway.marker, input$pathway)
  })
  
  # Generates sparklines for target of the selected compound. 
  output$compound.target <- renderPlot({
    
    # Get target for specified compound
    data_tall_compound.target <- subset(data_tall_each_marker[[input$marker]], Compound == input$compound)
    target <- data_tall_compound.target$Target.class..11Mar15.[1]
    
    # Get all data with this target
    data_tall.target <- subset(data_tall_each_marker[[input$marker]], Target.class..11Mar15. == target)
    data_tall.target$is.compound <- FALSE
    data_tall.target[data_tall.target$Compound == input$compound, ]$is.compound <- TRUE
    
    # Plot data
    plot_target(data_tall.target, confidence_intervals_each_marker[[input$marker]], input$marker, input$compound, target)
  })
  
  # Generates sparklines for pathway of the selected compound. 
  output$compound.pathway <- renderPlot({
    
    # Get pathway for specified compound
    data_tall_compound.pathway <- subset(data_tall_each_marker[[input$marker]], Compound == input$compound)
    pathway <- data_tall_compound.pathway$Pathway[1]
    
    # Get all data with this pathway
    data_tall.pathway <- subset(data_tall_each_marker[[input$marker]], Pathway == pathway)
    data_tall.pathway$is.compound <- FALSE
    data_tall.pathway[data_tall.pathway$Compound == input$compound, ]$is.compound <- TRUE
    
    # Plot data
    plot_pathway(data_tall.pathway, confidence_intervals_each_marker[[input$marker]], input$marker, input$compound, pathway)
  })
  
  # Hilights sparklines for target in pathways. 
  output$target.pathway <- renderPlot({
    
    # Get all data with target hilights
    data_tall.pathways <- data_tall_each_marker[[input$target.marker]]
    data_tall.pathways$is.target <- FALSE
    data_tall.pathways[data_tall.pathways$Target.class..11Mar15. == input$target, ]$is.target <- TRUE
    
    plot_pathway_hilight_target(data_tall.pathways, confidence_intervals_each_marker[[input$target.marker]], input$target.marker, input$target)
  })
  
  # Generates clusters, hilighting selected compound. 
  output$compound.cluster <- renderPlot({
    
    # Mark the compound within the data frame
    data_tall.cluster <- get_data_w_clusters(data_wide, data_tall_each_marker[[input$marker]], phenotypic_markers[[input$marker]], input$clusters)
    data_tall.cluster$is.compound <- FALSE
    data_tall.cluster[data_tall.cluster$Compound == input$compound, ]$is.compound <- TRUE
    
    # Plot data
    plot_clusters(data_tall.cluster, input$compound, input$marker)
  })
  
  # Hilights sparklines for target in clusters. 
  output$target.cluster <- renderPlot({
    
    # Get all data with target hilights
    data_tall.clusters <- get_data_w_clusters(data_wide, data_tall_each_marker[[input$target.marker]], phenotypic_markers[[input$target.marker]], input$target.clusters)
    data_tall.clusters$is.target <- FALSE
    data_tall.clusters[data_tall.clusters$Target.class..11Mar15. == input$target, ]$is.target <- TRUE
    
    plot_target_clusters(data_tall.clusters, input$target, input$target.marker)
  })
  
  # Hilights sparklines for pathway in clusters. 
  output$pathway.cluster <- renderPlot({
    
    # Get all data with pathway hilights
    data_tall.clusters <- get_data_w_clusters(data_wide, data_tall_each_marker[[input$pathway.marker]], phenotypic_markers[[input$pathway.marker]], input$pathway.clusters)
    data_tall.clusters$is.pathway <- FALSE
    data_tall.clusters[data_tall.clusters$Pathway == input$pathway, ]$is.pathway <- TRUE
    
    plot_pathway_clusters(data_tall.clusters, input$pathway, input$pathway.marker)
  })
  
  output$display.image <- renderImage({
    
    # Get images for that compound into www folder of shiny app
    suppressWarnings(get_images(input$compound))
    
    image_file <- paste("www/",image_types[[input$image.type]],"_t_",input$time.elapsed,".jpeg",sep="")
    
    return(list(
      src = image_file,
      filetype = "image/jpeg",
      height = 520,
      width = 696
    ))
    
  }, deleteFile = FALSE)
  
  # Plot the negative controls vs treatment for specified phenotypic marker
  output$QC.by.plate <- renderPlot({
    
    plot_QC_by_plate(data_tall_each_marker[[input$QC.marker]], phenotypic_markers[[input$QC.marker]])
    
  })
  
  # Plot all sparklines for specified phenotypic marker
  output$all.sparklines <- renderPlot({
    
    plot_all_sparklines(data_tall_each_marker[[input$overview.marker]], phenotypic_markers[[input$overview.marker]])
    
  })
  
  # QQ plot for specified phenotypic marker and curve metric
  output$qq.plot.one.metric <- renderPlot({
    
    get_single_metric_qqplot(data_tall_each_marker[[input$metric.marker]], metrics[[input$metric]])
    
  })
  
  # QQ plot for specified phenotypic marker and curve metric
  output$density.plot.one.metric <- renderPlot({
    
    get_single_metric_density(data_tall_each_marker[[input$metric.marker]], metrics[[input$metric]])
    
  })
  
  # QQ plot for specified phenotypic marker and curve metric
  output$early.vs.late.acting <- renderPlot({
    
    get_early_vs_late_acting(data_tall_each_marker[[input$early.vs.late.marker]], confidence_intervals_each_marker[[input$early.vs.late.marker]], phenotypic_markers[[input$early.vs.late.marker]], input$above.or.below.NC)
    
  })
  
  
  #   # Generates table of additional information for the compound
  #   output$compound.additional_info <- renderDataTable(
  #     data_tall_each_marker[[input$marker]][data_tall_each_marker[[input$marker]]$Compound == input$compound, ]
  #   )
  
  #!!!!!! would be nice to add an export button to the shiny app for exportin the jpegs of the given compound...
})
