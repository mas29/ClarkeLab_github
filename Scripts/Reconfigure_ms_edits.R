#Reorganizes the data from the 1833 compound screen into an excel file. 

library(MASS)
library(XLConnect)
library(gdata)
library(dataframes2xls)

# Parameters set in Configure.R script
# source("Scripts/Configure.R")

numPhenotypicMarkers <- length(phenotypic_markers) # number of phenotypic markers you're using
num_plates <- 5
num_wells_per_plate <- 384
num_letters <- 16 # Number of "letters" for the screen (ex. A1, B1, C1 ... if goes up to letter P, would be 16 letters)
num_numbers <- 24 # Number of "numbers" for the screen (ex. A1, B1, C1 ... A2, B2, C2 ... if goes up to A24, would be 24 numbers)
# !!!!!!!!!!!!!!!
# order of phenotypic markers


#Creates a column vector that contains the desired screen name.  To customzie the screen name, 
#change the variable named "screen_name" above to whatever name you want, remember to keep the name in quotations.
getScreenName <- function(){
  
  screenNamesVec <- as.factor(rep(screen_name, (num_plates*num_wells_per_plate)))
  
  return(screenNamesVec)
}

#Using a key Giovanni created with each plate and phenotypic marker on a different tab in an excel file, this function
#lists all of the names of the compounds in an order that goes from plate 1-5 a1-a24, b1-b24...p1-p24.
reconfigureCompoundNames <- function() {
  
  cmpNameKey <- loadWorkbook(key_filename)
  LIST = readWorksheet(cmpNameKey, sheet = getSheets(cmpNameKey))
  
  cmpNameVector <- NULL
  for (i in 1:length(LIST)) {
    newCmpNameVector <- as.vector(t(LIST[[i]]))
    cmpNameVector <- c(cmpNameVector, newCmpNameVector )
  }
  cmpNameVector <- as.vector(cmpNameVector)
 
  return(cmpNameVector)
}

#Uses a nested for loop to create a column vector that contains all of the plate positions in the correct order.
getPlatePositions<-function(){
  
  lettersVec <- letters[1:num_letters]
  numVec <- 1:num_numbers
  platePositions <- NULL
  count = 1
  
  for(i in 1:length(lettersVec)){
    for(j in 1:length(numVec)){
      
      position = sprintf("%s%d",lettersVec[i],numVec[j])
      platePositions[count] = position
      count = count + 1	
    }
  }
  
  platePositions = t(platePositions)
  platePositions = t(platePositions)	
  colnames(platePositions) = "Position"
  
  finalPositions <- NULL
  
  for(i in 1:num_plates){
    finalPositions <- rbind(finalPositions, platePositions)		
  }
  
  return(finalPositions)	
}

#Uses a nested for loop to create a column vector that contains the correct plate number (1-5)
getPlateNumbers<-function(){
  
  plateNumberVec <- NULL
  count = 1
  
  for(i in 1:num_plates){
    for(j in 1:num_wells_per_plate){
      plateNumberVec[count] <- i					
      count = count + 1	
    }
  }
  
  plateNumberVec = t(plateNumberVec)
  plateNumberVec = t(plateNumberVec)
  
  colnames(plateNumberVec) <- "Plate"
  
  return(plateNumberVec)
}


#Using the excel file specified, this function gathers all of the data listed from the 
#second tab of the excel file and reorganizes it to fit the new ordering of the compounds in the combined plates.
getDescriptions<- function(){
  
  descriptionVector <- list()
  
  descriptionKey <- read.xls(selleck_info_filename,sheet=1)
  descriptionKey <- data.frame(descriptionKey)
  
  plateNameVector <- reconfigureCompoundNames()
  
  descriptionKey <- descriptionKey[1:1833,] # The rows after 1833 are blank
  rownames(descriptionKey) <- descriptionKey$Product.Name
  descriptionKey <- descriptionKey[plateNameVector, ]
  combinedDescriptions <- descriptionKey[,c(1,4:ncol(descriptionKey))]

  return(combinedDescriptions)
}


#This function extracts the raw data from the specified excel file and reformats it. The final product of this function
#will be a data frame that has 3 sections, one for each phenotypic marker.  Time will go across the x axis within each 
#dataframe.
getRawData <- function(){
  
  dataList <- list()
  
  wb <- loadWorkbook(raw_data_filename)

  # Get the starting row of the data in the worksheets
  temp <- readWorksheet(wb, sheet = 1)
  startRow <- which(temp[1] == "Date Time") + 1
  
  LIST = readWorksheet(wb, sheet = getSheets(wb), startRow = startRow)
  dataList[1] <- list(LIST)
  
  tempFrame <- data.frame(dataList[[1]][1])
  elapsedTime <- tempFrame[,2]
  
  
  rowNames <- 1:(num_plates*num_wells_per_plate)
  finalList <- NULL
  
  #runs once for each phenotypic marker
  for(h in 1:numPhenotypicMarkers){
    currDataFrame <- NULL
    count = h
    
    #runs once for each plate
    for(i in 1:num_plates){
      
      frame <- data.frame(dataList[[1]][count])
      frame <- frame[,3:length(frame[1,])]
      
      startCol = 1
      #once for each letter
      for(j in 1:num_letters){
        
        #get all columns of same letter
        for(k in 1:num_numbers){
          tempCol <- data.frame(frame[,startCol + (k-1)])
          tempCol = t(tempCol)
          colnames(tempCol) <- elapsedTime
          currDataFrame <- rbind(currDataFrame, tempCol)
        }
        startCol = startCol + num_numbers		
      }
      count = count + numPhenotypicMarkers	
    }
    rownames(currDataFrame) <- rowNames
    finalList[h] <- list(currDataFrame)	
  }
  
  for(i in 1:numPhenotypicMarkers){
    
    phenotypic_Marker <- NULL
    phenotypic_Marker[1:(num_plates*num_wells_per_plate)] <- phenotypic_markers[i]
    phenotypic_Marker <- data.frame(phenotypic_Marker)
    
    if(i == 1){
      finalFrame <- data.frame(phenotypic_Marker) 	
      currFrame <- data.frame(finalList[i])
      colnames(currFrame) <- elapsedTime
      finalFrame <- cbind(finalFrame,currFrame)
    } else {
      currFrame <- phenotypic_Marker
      currFrame <- cbind(currFrame,(finalList[i]))
      colnames(currFrame[2:length(currFrame[1,])]) <- elapsedTime
      finalFrame <- cbind(finalFrame,currFrame)
    }	
  }
  
  return(finalFrame)
}


#Calls all of the other functions written in this script, and combines their outputs in the correct order.
combine<-function(){
  
  names <- reconfigureCompoundNames()
  positions<- getPlatePositions()
  plateNumbers <- getPlateNumbers()
  screenID <- getScreenName()
  cmpDescriptions <- getDescriptions()
  dataReformat <- getRawData()
  totalFrame <- cbind(names,cmpDescriptions, plateNumbers, positions,screenID, dataReformat)
  return(totalFrame)	
  
}

###### DELETE AFTER
test_df <- combine()
######


# Create reconfigured data, write to file
data_reconfigured <- combine()
dir.create(file.path(dir, "Output"), showWarnings = FALSE)
write.csv(data_reconfigured,file = paste(dir, "Output/data_reconfigured.csv", sep=""))





