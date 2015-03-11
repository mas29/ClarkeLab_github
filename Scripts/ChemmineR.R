source("http://bioconductor.org/biocLite.R") # Sources the biocLite.R installation script. 
biocLite("ChemmineR") # Installs the package. 
library("ChemmineR") # Loads the package
library(help="ChemmineR") # Lists all functions and classes 
vignette("ChemmineR") # Opens this PDF manual from R 
data(sdfsample) 
sdfset <- sdfsample
sdfset # Returns summary of SDFset 
sdfset[1:4] # Subsetting of object
sdfset[[1]] # Returns summarized content of one SDF
view(sdfset[1:4]) # Returns summarized content of many SDFs, not printed here 
as(sdfset[1:4], "list") # Returns complete content of many SDFs, not printed here 
sdfset <- read.SDFset("http://faculty.ucr.edu/ tgirke/Documents/R_BioCond/Samples/sdfsample.sdf")
header(sdfset[1:4]) # Not printed here
header(sdfset[[1]])
atomblock(sdfset[1:4]) # Not printed here 
plot(sdfset[1:4], print=FALSE) # Plots structures to R graphics device 


data(smisample)
smiset <- smisample
write.SMI(smiset[1:4], file="sub.smi") 
smiset <- read.SMIset("sub.smi")
data(smisample) # Loads the same SMIset provided by the library 
smiset <- smisample
smiset 
sdf <- smiles2sdf("CC(=O)OC1=CC=CC=C1C(=O)O")
view(sdf) 
data(smisample)
(sdf <- smiles2sdf(smisample[1:4]))


apset <- sdf2ap(sdfset) # Generate atom pair descriptor database for searching 
data(apset) # Load sample apset data provided by library. 
cmp.search(apset, apset[1], type=3, cutoff = 0.3, quiet=TRUE) # Search apset database with single compound. 
cmp.cluster(db=apset, cutoff = c(0.65, 0.5), quiet=TRUE)[1:4,] # Binning clustering using variable similarity cutoffs. 

source("http://bioconductor.org/biocLite.R")
biocLite("ChemmineOB")
library(ChemmineOB)
