#Creates a heatmap from a formatted excel file.  Each heat map will be for an individual compound,
#with a specific phenotypic marker over time and dose concentration


#Libraries contain functions that are used in the scipt, and must be installed and included at the top of the file
library(MASS)
library(gplots)
library(drc)
library(XLConnect)
library(gdata)
library(RColorBrewer)

#!!!!!!!!!!!!!!!!!!!!!!!!
#I will use this line of code to specify where the code may have to be changed to run on specific excel files.

#Needed in order to correctly read the excel files.
options(stringsAsFactors = FALSE)

#These variables store whether or not the user has decided to trim the data (if sytox G was selected) and if so
#by what percent.  Initially set to zero but may change based on user input.
trimData<-0
trimPercent<-0

#These lines of code declare the "trim" function that is called later in the script.  This function takes in a 
#numeric vector, and finds the maximum value and the index at which the maximum value occurs.  For each value 
#in the vector that is after that index, this function checks whether or not it is less than 
#maximumValue - (maximumValue * trimPercent), if so, all subsequent values in the vector are removed.
trim<-function(vec){
	maximumValue = max(vec)
	cutoff = maximumValue - ((trimPercent)*maximumValue)
	maxIndex = which.max(vec)
	for(y in 1:(length(vec)-maxIndex)){
#		print(vec[maxIndex+y])
		if(!is.na(vec[maxIndex+y])){
			if((vec[maxIndex+y]) < cutoff){
				#truncate all of the remaining vector
				length(vec)<-(maxIndex+y)
				break
			}
		}
	}
	return(vec)
}


trim2<-function(sytoxVec, mkateVec){
	initialMkate <- as.numeric(mkateVec[1])
	mkateThreshold <- initialMkate * 3
	#for loop through vector, find first occurence overthreshold, trim
	
	for(i in 1:length(mkateVec)){
#		print(mkateVec[i])
		if(mkateVec[i] > mkateThreshold){
			for(j in i:length(sytoxVec)){
				sytoxVec[j] <- -1
			}
#			length(sytoxVec) <- i
			break
		}
	}
	
	return(sytoxVec)
}

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# This value will replace all of the blank values that are present in the excel file.  You may change the 
#value here if you want to replace the blank spaces with a different number.
NAVALUE<- 0.2324089

#Asks user how many excel files are going to be used in the analysis.
num<- as.numeric(readline("How many replicates will be used? "))


#This line of code initializes the variable vectorList to be a data structure of type list.
#This will be used to store the different excel files and all of the tabs in each excel file.
vectorList <- list()

for(i in 1:num){
	
	if(i == 1) {
		wb <-loadWorkbook("/Users/awells/Desktop/Dixon Lab/Replicate #2_9Jul14/Exp33_EtOH_OA_Rep#2_1Jul14.xlsx")
	} else if (i == 2){
		wb <- loadWorkbook("/Users/awells/Desktop/Dixon Lab/Replicate #3_9Jul14/Exp33_EtOH_OA_Rep#3_5Jul14.xlsx")
	}

#	wb <- loadWorkbook(file.choose())

	LIST = readWorksheet(wb, sheet = getSheets(wb), startRow = 21)
	vectorList[i] = list(LIST)
}


#!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#This must be changed if you are running the script on your own computer.  Instead of the "/Users/awells/Documents/compoundList.xlsx" in the read.xls function, type in the source of where your specific key is.  The key should be an excel document formatted as follows:
#1) the first column contains the names of each drug present in the excel file, in the order in which they appear.  For example if column C3-C22 are DMSO, D3-D22 are Erastin, and E3-E22 are STS, then the first column would read
#DMSO
#ERASTIN
#STS
#2)The second column specifies the different phenotypic markers (or other variable) that were used in the experiment.  These will specify which tab is accessed. For example if the first tab in each replicate excel file corresponds to confluency, the second to sytox G, and the third to mkate2, the second column should read:
#Confluency
#Sytox G
#mkate2
#3)The third column specifies the cell line (or other variable).  This should be formatted based on order of appearance in the excel file.  For example if C3 corresponds to HT-1080 and C13 corresponds to NLR, then the 3rd column would read:
#Ht-1080
#NLR
#4)The rest of the columns specify the concentration values of each of the drugs in the order that they appear.
#I will upload an example excel file and corresponding Key
key = read.xls("/Users/awells/Documents/compoundList.xlsx",na.strings="")


#Prints out all of the drugs that are listed in the key, asks for user input.
count = 1
while(!is.na(key[count,1])){
	print(sprintf("(%d) %s",count,key[count,1]))
	count = count +1
}

cmp<-as.numeric(readline("Enter the number corresponding with the desired compound: "))



#Prints out all of the phenotypic markers, asks for user input
count2 = 1
while(!is.na(key[count2,2])){
	print(sprintf("(%d) %s",count2,key[count2,2]))
	count2 = count2 +1
}


phe<-as.numeric(readline("Enter the number corresponding with the desired phenotypic marker: "))

#!!!!!!!!!!!!!!!!!!!!!!!!!!!
#if sytox G isn't the second tab, then change phe==2 to phe==x where x is the tab corresponding to sytox G
#Asks the user if he/she wants to trim the data, and if so by what percent.
if(phe==2){
	trimData<-as.numeric(readline("You have selected Sytox G, do you want to trim the data? (1)YES (2)NO "))
	if(trimData==1){
		trimData <- 1
		trimPercent <- as.numeric(readline("By what percent of the max value do you want to trim the data? "))
		trimPercent <- (trimPercent/100)
	}
	
}

#Will store the desired excel tabs from each of the files.
desiredList<-NULL
mkateList <- NULL

#Takes the desired tabs from the vectorList used above
for(l in 1:num){
	desiredList[l]=vectorList[[l]][phe]
	mkateList[l] = vectorList[[l]][3]
}


#Prints out the different cell lines (or other variable), asks for user input
count3 = 1
while(!is.na(key[count3,3])){
	print(sprintf("(%d) %s",count3,key[count3,3]))
	count3 = count3 + 1
}

cell<-as.numeric(readline("Enter the number corresponding with the desired cell line: "))



#From the user input, this line of code calculates where the first column is that needs to be stored in a 
#new data frame
startCol = 3+ (20*(cmp-1)) + (10*(cell-1))

#gets the length of the Elapsed time column in the excel file.
getElapsed<-data.frame(desiredList[1])
ElapsedTime<-getElapsed$Elapsed


#gets the concentrations associated with the correct compound
concentrationValues<-as.numeric(key[,3+cmp])


#Initializes a list that will eventually store the normalized data frames
normalizedFrames <- list()
newFrame <- NULL
tempNormalizedFrame <- data.frame(desiredList[1])

#The normalization will only occur if phe==2 (or if the user selects sytox G).  The first for-loop gets the mkate data.frame that was stored earlier in the code, and converts all blank cells to the designated value.  Then does the same for the data frame stored in the original sytox G data frame.  The inner frame goes through each column in the mkate frame, gets the max value, and divides the corresponding column in the sytox G data frame by that number, thereby normalizing the data frame.
if(phe ==2){
	for(i in 1:num){
		mkateFrame = data.frame(mkateList[i])
		mf <- as.matrix(mkateFrame)
		mf[mf==" "]<-NAVALUE
		mf[mf==NA]<-NAVALUE
		mkateFrame = data.frame(mf)

		
		currFrame = data.frame(desiredList[i])
		cf <- as.matrix(currFrame)
		cf[cf==" "]<-NAVALUE
		cf[cf==NA]<-NAVALUE
		currFrame <- data.frame(cf)
	
		newFrame<-NULL
		for(j in 3:length(tempNormalizedFrame[1,])){
			mkateMax <- max(as.numeric(mkateFrame[,j]))
			currVec <- as.numeric(currFrame[,j])
						
			currVec <- currVec/mkateMax
			newFrame <- cbind(newFrame,currVec)
			
		}
		normalizedFrames[[i]] <- newFrame
	}
} else {
	normalizedFrames <- desiredList
	
}


#Used to help calculate the maximum value of the appropriate excel columns
maxCell<-0
if(cell == 1){
	maxCell <- 1
} else {
	maxCell <- 2
}

#Trims the excel data to eliminate the first 2 unwanted columns
getMaxTempFrame <- data.frame(normalizedFrames[1])
getMaxTempFrame <- getMaxTempFrame[,3:length(getMaxTempFrame[1,])]

#Replaces all of the blank values in the excel file with the NAVALUE constant specified above
m <- as.matrix(getMaxTempFrame)
m[m==" "]<-NAVALUE
getMaxTempFrame<-data.frame(m)

#Combines the desired portions of the excel files into one data frame
for(i in 2:num){
	tempMaxFrame <- data.frame(normalizedFrames[i])
	tempMaxFrame <- tempMaxFrame[,3:length(tempMaxFrame[1,])]
	m2<-as.matrix(tempMaxFrame)
	m2[m2==" "]<-NAVALUE
	tempMaxFrame <- data.frame(m2)

	getMaxTempFrame <- (data.matrix(getMaxTempFrame) + data.matrix(tempMaxFrame))
}
getMaxTempFrame <- getMaxTempFrame/num



#Finds the maximum value for the appropriate columns in excel so that a standardized key can be used in the
#heatmaps.
maxValue <- 0
maxStartCol <- 1 + (10 *(maxCell -1)) 
for(j in 1:(count-1)){
	for(k in 1:10){
		getMaxTempVec <- as.vector(getMaxTempFrame[,maxStartCol + (k-1)])
		tempMax <- max(getMaxTempVec)
		if(tempMax > maxValue){
			maxValue <- tempMax
		}	

	}
	maxStartCol <- maxStartCol + 20		
}


vectorOfMatrices<-list()

maxLength <- length(ElapsedTime)

offset<-0

#Used to extract the desired columns from the excel spread sheet and combine them into a single data frame
#so that a heatmap can be created using all of the replicates.
for(i in 1:num){
	newDataFrame1 <- NULL
	newDataFrame1<- ElapsedTime

	frame = data.frame(normalizedFrames[i])
	m1 <- as.matrix(frame)
	m1[m1==" "]<-NAVALUE
	m1[m1==NA]<-NAVALUE
	frame <- data.frame(m1)

	mkateTempFrame <- data.frame(mkateList[i])
	mtf <- as.matrix(mkateTempFrame)
	mtf[mtf==" "] <- NAVALUE
	mtf[mtf == NA] <- NAVALUE
	mkateTempFrame <- data.frame(mtf)
	
	
	if(phe==2){
		offset <- -2
	}

	for(j in 1:10){		
		tempCol = as.numeric(frame[,startCol + offset + (j-1)])
		tempMax <- max(tempCol)
		tempMkateCol <- as.numeric(mkateTempFrame[,startCol + (j-1)])
#		print(tempCol)
#		print(tempMkateCol)
		if(trimData==1){
			tempCol <- trim(tempCol)
			tempCol <- trim2(tempCol,tempMkateCol)
#			print(length(tempCol))
			length(tempCol) <- maxLength
			
		}
		s <- sprintf("%f",concentrationValues[j])
		
		newDataFrame1 <- cbind(newDataFrame1, tempCol)
		colnames(newDataFrame1)[colnames(newDataFrame1) == "tempCol"] <- s
	}
	row.names(newDataFrame1) <- ElapsedTime
	newDataFrame1<-newDataFrame1[,2:11]
	m <- data.matrix(newDataFrame1)
	vectorOfMatrices[[i]] <- m
	
}


endMatrix <- vectorOfMatrices[[1]]


for(i in 2:num){
	endMatrix <- (endMatrix + vectorOfMatrices[[i]])
}


endMatrix <- endMatrix/num

print(endMatrix)

	


sequence = seq(from=0, to = maxValue, by=maxValue/16)
if(phe==2){
	sequence = seq(from=-1, to = 1,by=1/24)
}


#!!!!!!!!!!!!!!!!!!!!!!
#Prints the heatmap to an excel file titled "mygraph", you may change the pdf name
pdf("myHeatmapGraph.pdf")

#creation of the heatmap
#heatmap.2(endMatrix, dendrogram = "none",Rowv=FALSE, Colv = FALSE,trace = "none",cexCol = .75,xlab = "Concentration (uM)",ylab = "Time (hours)", na.rm = TRUE,colsep = c(0,10), rowsep= c(0,length(ElapsedTime)),sepcolor = "black", sepwidth = c(.025,.05),col=  colorRampPalette(c("gray0","gray20","gray35","gray50","chartreuse4","chartreuse3","chartreuse2","chartreuse1")),breaks = sequence,density.info="none")	

heatmap.2(endMatrix, dendrogram = "none",Rowv=FALSE, Colv = FALSE,trace = "none",cexCol = .75,xlab = "Concentration (uM)",ylab = "Time (hours)", na.rm = TRUE,colsep = c(0,10), rowsep= c(0,length(ElapsedTime)),sepcolor = "black", sepwidth = c(.025,.05),col=  colorRampPalette(c("gray0","gray0","gray0","purple4", "purple3","purple2","purple1","chartreuse4","chartreuse3","chartreuse2","chartreuse1")),breaks = sequence,density.info="none")	

dev.off()







