# Plot heatmap of scaled metrics for each compound, for SG data only.
library(gplots)
library(RColorBrewer)

# Load data.
# dir = "/Users/mas29/Documents/ClarkeLab_github/"
dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
load(file=paste(dir,"DataObjects/sytoxG_data_features.R",sep=""))

# Select metrics of interest, for all compounds (no negative controls)
data_for_heatmap <- sytoxG_data_features[sytoxG_data_features$Pathway != "NegControl", 
                                         names(sytoxG_data_features) %in% c("time_x_distance.upper", "phenotype_value_exceeds_NC_upperbound.timepoint", "time_to_max")]
rownames(data_for_heatmap) <- sytoxG_data_features[sytoxG_data_features$Pathway != "NegControl", 
                                                   names(sytoxG_data_features) == "Compound"]
data_for_heatmap$phenotype_value_exceeds_NC_upperbound.timepoint[which(is.na(data_for_heatmap$phenotype_value_exceeds_NC_upperbound.timepoint))] <- -1

# Scale metrics.
data_for_heatmap <- scale(data_for_heatmap)
data_matrix <- as.matrix(data_for_heatmap)

# Get row and column dendrograms
hr <- hclust(as.dist(1-cor(t(data_matrix), method="pearson")), method="complete"); 
hc <- hclust(as.dist(1-cor(data_matrix, method="spearman")), method="complete")  

# Cut the tree and create color vector for clusters.
num_clusters <- 20
mycl <- cutree(hr, k = num_clusters) # Clusters assigned to each compound.
mycolhc <- rainbow(length(unique(mycl)), start=0.1, end=0.9)
mycolhc <- mycolhc[as.vector(mycl)] 

# Creates heatmap for entire data set -- obtained clusters are indicated in the color bar.
my_palette <- colorRampPalette(c("red", "white", "green"))(n = 299)
heatmap.2(data_matrix, 
          Rowv=as.dendrogram(hr), 
          Colv=as.dendrogram(hc), 
          density.info="none", 
          trace="none", 
          col=my_palette, 
          RowSideColors=mycolhc,
          cexRow = 0.8, 
          cexCol = 0.8, 
          srtCol = 45,
          labCol=c("Time to\nMaximum", "Timepoint When\nSG Exceeds\nNeg.Contr.\nUpperbound", "Time X Distance to\nNeg.Contr.\nUpperbound"))

# Print color key for cluster assignments. (Numbers beside color boxes correspond to the cluster numbers in 'mycl').
names(mycolhc) <- names(mycl); 
barplot(rep(10, max(mycl)), col=unique(mycolhc[hr$labels[hr$order]]), horiz=T, names=unique(mycl[hr$order])) 

# Select sub-cluster number(s) and generate corresponding dendrogram.
zoom <- function(cluster_num) {
  clid <- cluster_num
  data_matrix.sub <- data_matrix[names(mycl[mycl%in%clid]),]
  hrsub <- hclust(as.dist(1-cor(t(data_matrix.sub), method="pearson")), method="complete") 
  
  # Create heatmap for chosen sub-cluster(s).
  heatmap.2(data_matrix.sub, 
            Rowv=as.dendrogram(hrsub), 
            Colv=as.dendrogram(hc), 
            density.info="none", 
            trace="none", 
            col=my_palette, 
            RowSideColors=mycolhc[mycl%in%clid],
            cexRow = 0.7, 
            cexCol = 0.8, 
            srtCol = 45,
            labCol=c("Time to\nMaximum", "Timepoint When\nSG Exceeds\nNeg.Contr.\nUpperbound", "Time X Distance to\nNeg.Contr.\nUpperbound")) 
}

# Print all the clusters
for(i in 1:num_clusters) {
  zoom(i)
}


# Print out row labels in same order as shown in the heatmap.
data.frame(Labels=rev(hrsub$labels[hrsub$order])) 





