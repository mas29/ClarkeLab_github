# Plot heatmap of time series data for each compound, for SG data only.
library(gplots)
library(ggplot2)
library(RColorBrewer)
library(grid)
library(gridExtra)

# Load data.
# dir = "/Users/mas29/Documents/ClarkeLab_github/"
dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
load(file=paste(dir,"DataObjects/confluency_sytoxG_data_prelim_proc.R",sep=""))

# Parameters
start_index <- which(colnames(confluency_sytoxG_data_prelim_proc) == "0")
end_index <- which(colnames(confluency_sytoxG_data_prelim_proc) == "46")
num_time_intervals <- length(unique(sytoxG_data$time_elapsed)) # Number of time intervals

# Confidence interval bounds
confidence_intervals_SG <- sytoxG_data[1:num_time_intervals,c("time_elapsed", "phenotype_value.NC.upper", "phenotype_value.NC.mean", "phenotype_value.NC.lower")]

# Get Sytox Green raw time series data only, for all compounds (no negative controls)
data_for_heatmap <- confluency_sytoxG_data_prelim_proc[confluency_sytoxG_data_prelim_proc$Pathway != "NegControl" 
                                                       & confluency_sytoxG_data_prelim_proc$phenotypic_Marker == "SG",
                                                       start_index:end_index]
rownames(data_for_heatmap) <- confluency_sytoxG_data_prelim_proc[confluency_sytoxG_data_prelim_proc$Pathway != "NegControl" 
                                                                 & confluency_sytoxG_data_prelim_proc$phenotypic_Marker == "SG",]$Compound
data_matrix <- as.matrix(data_for_heatmap)

# Get distances (Euclidean) and clusters
distMatrix <- dist(data_matrix, method="Euclidean")
hr <- hclust(distMatrix, method="average")

# Cut the tree and create color vector for clusters.
num_clusters <- 20
mycl <- cutree(hr, k = num_clusters) # Clusters assigned to each compound.
mycolhc <- rainbow(length(unique(mycl)), start=0.1, end=0.9)
mycolhc <- mycolhc[as.vector(mycl)] 

# Creates heatmap for entire data set -- obtained clusters are indicated in the color bar.

my_palette <- colorRampPalette(c("red", "white", "green"))(n = 299)
heatmap.2(data_matrix, 
          Rowv=as.dendrogram(hr), 
          Colv=NULL, 
          density.info="none", 
          trace="none", 
          col=my_palette, 
          dendrogram = "row",
          RowSideColors=mycolhc,
          cexRow = 0.8, 
          cexCol = 0.8, 
          srtCol = 45)

# Print color key for cluster assignments. (Numbers beside color boxes correspond to the cluster numbers in 'mycl').
names(mycolhc) <- names(mycl); 
barplot(rep(10, max(mycl)), col=unique(mycolhc[hr$labels[hr$order]]), horiz=T, names=unique(mycl[hr$order])) 

# Select sub-cluster number(s) and generate corresponding dendrogram and sparklines.
zoom_plot_sparklines <- function(cluster_num) {
  data_matrix.sub <- data_matrix[names(mycl[mycl%in%cluster_num]),]
  
  # Sub-cluster hierarchical clustering
  distMatrix.sub <- dist(data_matrix.sub, method="Eucluster_numean")
  hrsub <- hclust(distMatrix.sub, method="average")
    
  # Create heatmap for chosen sub-cluster(s).
  heatmap <- heatmap.2(data_matrix.sub, 
              Rowv=as.dendrogram(hrsub), 
              Colv=NULL, 
              density.info="none", 
              trace="none", 
              col=my_palette, 
              dendrogram = "row",
              RowSideColors=mycolhc[mycl%in%cluster_num],
              cexRow = 0.8, 
              cexCol = 0.8, 
              srtCol = 45)
  
  # Create sparklines for chosen sub-cluster(s) compounds
  compounds <- rownames(data_matrix.sub)
  sytoxG_data.sub <- sytoxG_data[sytoxG_data$Compound %in% compounds,]
  ggplot(sytoxG_data.sub) +
    geom_line(aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound, text=Compound)) +
    geom_ribbon(data = confidence_intervals_SG, mapping = aes(x = time_elapsed, ymin = phenotype_value.NC.lower, ymax = phenotype_value.NC.upper,
                                                              fill = "red", colour = NULL), alpha = 0.6) +
    scale_fill_manual(name = "Legend",
                      values = c('red'),
                      labels = c('Negative Control')) +
    xlab("Time Elapsed") +
    ylab("Sytox Green") +
    ggtitle(paste("Cluster ",cluster_num," Compound Sytox Green Sparklines",sep="")) +
    theme(panel.grid = element_blank(),
          axis.ticks.length = unit(0, "cm"),
          panel.background = element_rect(fill = "white"),
          strip.text.x = element_text(size=4),
          axis.text = element_blank())
}

# Print all the clusters
for(i in 1:num_clusters) {
  zoom_plot_sparklines(i)
}