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

#Creates a column vector that contains the desired screen name.  To customzie the screen name, 
#change the variable named "screen_name" above to whatever name you want, remember to keep the name in quotations.
getScreenName <- function(){
  
  screenNamesVec <- NULL
  count = 1
  
  for(i in 1:num_plates){
    for(j in 1:num_wells_per_plate){
      screenNamesVec[count] <- screen_name
      count = count + 1
    }
  }
  
  screenNamesVec = t(screenNamesVec)
  screenNamesVec = t(screenNamesVec)
  
  colnames(screenNamesVec) <- "Screen"
  
  return(screenNamesVec)
}

#Using a key I created that has each of the 5 384-well plates on a different tab in an excel file, this function
#lists all of the names of the compounds in an order that goes from plate 1-5 a1-a24, b1-b24...p1-p24.
reconfigureCompoundNames <- function() {
  cmpNameKey <- loadWorkbook(key_filename)
  tempList <- list()
  LIST = readWorksheet(cmpNameKey, sheet = getSheets(cmpNameKey))
  tempList[1] = list(LIST)
  
  keyList <- list()
  
  for (i in 1:length(tempList[[1]])) {
    keyList[[i]] <- data.frame(tempList[[1]][i])
  }
  
  combinedFrames <- NULL
  newColNames <- (1:24)
  
  for (i in 1:length(keyList)) {
    colnames(keyList[[i]]) <- newColNames
    combinedFrames <- rbind(combinedFrames, keyList[[i]])
  }
  
  rowLength <- length(combinedFrames[1,])
  colLength <- length(combinedFrames[,1])
  
  newRowNames <- 1:(rowLength*colLength)
  
  cmpNameVector <- NULL
  
  for(i in 1:colLength){
    vec <- combinedFrames[i,]
    vec <- t(vec)
    cmpNameVector <- rbind(cmpNameVector,vec)
  }
  
  row.names(cmpNameVector) <- newRowNames
  colnames(cmpNameVector) <- "Compound"
  
  return(cmpNameVector)
  
}

#Uses a nested for loop to create a column vector that contains all of the plate positions in the correct order.
getPlatePositions<-function(){
  
  lettersVec <- letters[1:16]
  numVec <- 1:24
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
  #	print(descriptionKey)
  
  cmpNames <- descriptionKey[,2]
  
  plateNameVector <- reconfigureCompoundNames()
  
  for(i in 1:length(cmpNames)){
    
    currName = cmpNames[i]
    index = which(plateNameVector == currName)
    vec <- data.frame(descriptionKey[i,])
    descriptionVector[index] <- list(vec)
    
  }
  
  length(descriptionVector) = (num_plates*num_wells_per_plate)
  
  for(i in 1:length(descriptionVector)){
    
    if(descriptionVector[i] == "NULL"){
      descriptionVector[i] <- "POSITIVE CONTROL"
    }	
  }
  
  combinedDescriptions <- NULL	
  normalColNames <- colnames(data.frame(descriptionVector[1]))
  replace <- LETTERS[1:13]
  
  # Changed from 13 columns to 17 columns for new updated selleck information excel doc given March 15, 2015 (Selleck_1833_LibraryAnnotation_Mar15.xlsx)
  tempRow <- matrix(c(rep.int(NA,17)), nrow = 1, ncol = 17)
  newRow <- data.frame(tempRow)	
  colnames(newRow) <- colnames <- normalColNames
  
  for(i in 1:length(descriptionVector)){
    
    temporaryVec <- data.frame(descriptionVector[i])
    if(length(temporaryVec) == 1){
      temporaryVec <- newRow
    }
    combinedDescriptions <- rbind(combinedDescriptions, temporaryVec)	
  }			
  
  # Changed from 13 columns to 17 columns for new updated selleck information excel doc given March 15, 2015 (Selleck_1833_LibraryAnnotation_Mar15.xlsx)
  combinedDescriptions <- data.frame(combinedDescriptions)
  combinedDescriptions <- combinedDescriptions[,c(1,4:17)]
  
  return(combinedDescriptions)
}


#This function extracts the raw data from the specified excel file and reformats it. The final product of this function
#will be a data frame that has 3 sections, one for each phenotypic marker.  Time will go across the x axis within each 
#dataframe.
getRawData <- function(){
  
  dataList <- list()
  
  wb <- loadWorkbook(raw_data_filename)
  LIST = readWorksheet(wb, sheet = getSheets(wb), startRow = 8)
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
      for(j in 1:16){
        
        #get all columns of same letter
        for(k in 1:24){
          tempCol <- data.frame(frame[,startCol + (k-1)])
          tempCol = t(tempCol)
          colnames(tempCol) <- elapsedTime
          currDataFrame <- rbind(currDataFrame, tempCol)
        }
        startCol = startCol + 24		
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

# Create reconfigured data, write to file
data_reconfigured <- combine()
dir.create(file.path(dir, "Output"), showWarnings = FALSE)
write.csv(data_reconfigured,file = paste(dir, "Output/data_reconfigured.csv", sep=""))





