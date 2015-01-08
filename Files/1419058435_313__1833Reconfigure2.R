#Reorganizes the data from the 1833 compound screen into an excel file.  There are some places in the code
#That need to be changed for each individual user.  These places in the code are denoted by !!!!!!!!!!!!!!!!!!!!!!!.
library(MASS)
library(XLConnect)
library(gdata)
library(dataframes2xls)


#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#if you are using different phenotypic markers than the ones listed below, change these names in the order which they appear
#in the tabs
phenotypicMarkerNames <- NULL
phenotypicMarkerNames[1] <- "Confluency"
phenotypicMarkerNames[2] <- "Sytox Green"
phenotypicMarkerNames[3] <- "mCherry Red"


#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#Change the 3 to however many phenotypic markers you are using
numPhenotypicMarkers <- 3

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#Replace ENTER_SCREEN_NAME with your own screen name
screenName <- "ENTER_SCREEN_NAME"

#Creates a column vector that contains the desired screen name.  To customzie the screen name, 
#change the variable named "screenName" above to whatever name you want, remember to keep the name in quotations.
getScreenName <- function(){
	
	screenNamesVec <- NULL
	count = 1
	
	for(i in 1:5){
		for(j in 1:384){
			screenNamesVec[count] <- screenName
			count = count + 1
		}
	}
	
	screenNamesVec = t(screenNamesVec)
	screenNamesVec = t(screenNamesVec)
	
	colnames(screenNamesVec) <- "Screen"
	
	return(screenNamesVec)
}

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#must change the key name to run on your computer, instead of "/Users/awells/Documents/1833Key.xlsx", use the source/load 
#button in R to get the path of the key on your own computer.  I will post the formatted Key online for you to download.
#Using a key I created that has each of the 5 384-well plates on a different tab in an excel file, this function
#lists all of the names of the compounds in an order that goes from plate 1-5 a1-a24, b1-b24...p1-p24.
reconfigureCompoundNames <- function() {
	cmpNameKey <- loadWorkbook("/Users/awells/Documents/1833Key.xlsx")
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
	
	for(i in 1:5){
		finalPositions <- rbind(finalPositions, platePositions)		
	}

	return(finalPositions)	
}

#Uses a nested for loop to create a column vector that contains the correct plate number (1-5)
getPlateNumbers<-function(){
	
	plateNumberVec <- NULL
	count = 1
	
	for(i in 1:5){
		for(j in 1:384){
			plateNumberVec[count] <- i					
			count = count + 1	
		}
	}
	
	plateNumberVec = t(plateNumberVec)
	plateNumberVec = t(plateNumberVec)
	
	colnames(plateNumberVec) <- "Plate"
		
	return(plateNumberVec)
}

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#Must replace "/Users/awells/Downloads/Selleck__Bioactive-Compound-Library-1833_condensed.xlsx" with the corresponding file
#on your own computer.  I will post the excel file to box for you to download.
#using the excel file specified in the red text below, this function gathers all of the data listed from the 
#second tab of the excel file and reorganizes it to fit the new ordering of the compounds in the combined plates.
getDescriptions<- function(){
	
	descriptionVector <- list()
	
	descriptionKey <- read.xls("/Users/awells/Downloads/Selleck__Bioactive-Compound-Library-1833_condensed.xlsx",sheet=2)
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
	
	length(descriptionVector) = 1920
	
	for(i in 1:length(descriptionVector)){
		
		if(descriptionVector[i] == "NULL"){
			descriptionVector[i] <- "POSITIVE CONTROL"
		}	
	}
		
	combinedDescriptions <- NULL	
	normalColNames <- colnames(data.frame(descriptionVector[1]))
	
	replace <- LETTERS[1:13]
		
	tempRow <- matrix(c(rep.int(NA,13)), nrow = 1, ncol = 13)
	newRow <- data.frame(tempRow)	
	colnames(newRow) <- colnames <- normalColNames
		
	for(i in 1:length(descriptionVector)){

		temporaryVec <- data.frame(descriptionVector[i])
		if(length(temporaryVec) == 1){
			temporaryVec <- newRow
		}
		combinedDescriptions <- rbind(combinedDescriptions, temporaryVec)	
	}			
	
	combinedDescriptions <- data.frame(combinedDescriptions)
	combinedDescriptions <- combinedDescriptions[,c(1,4:13)]
	
	return(combinedDescriptions)
}

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#instead of "/Users/awells/Desktop/140820 IncuCyte Data from Laura.xlsx" enter the name of the excel file you wish
#to reconfigure
#This function extracts the raw data from the specified excel file and reformats it. The final product of this function
#will be a data frame that has 3 sections, one for each phenotypic marker.  Time will go across the x axis within each 
#dataframe.
getRawData <- function(){
	
	dataList <- list()
		
	wb <- loadWorkbook("/Users/awells/Downloads/All Plates.xlsx")
	LIST = readWorksheet(wb, sheet = getSheets(wb), startRow = 8)
	dataList[1] <- list(LIST)
	
	tempFrame <- data.frame(dataList[[1]][1])
	elapsedTime <- tempFrame[,2]
	
	
	rowNames <- 1:1920
	finalList <- NULL
	
	#runs once for each phenotypic marker
	for(h in 1:numPhenotypicMarkers){
		currDataFrame <- NULL
		count = h
		
		#runs once for each plate
		for(i in 1:5){
			
			frame <- data.frame(dataList[[1]][count])
			frame <- frame[,3:length(frame[1,])]
			
			startCol = 1
			#once for each letter
			for(j in 1:16){
#				startCol = j
				
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
		phenotypic_Marker[1:1920] <- phenotypicMarkerNames[i]
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

toXL <- combine()

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#change the name of the file to anything you want.
#print(toXL)
write.csv(toXL,file = "1833OutputNewFormat.csv")








