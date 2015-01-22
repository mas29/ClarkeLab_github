#This script will overlay mkate2 and sytox G graphs for the highest concentration of the desired
#drug over time.  

library(MASS)
library(XLConnect) #reads and writes excel data
library(gdata)
library(gplots)	#plots graphs to quartz
library(lattice)

#Will replace any blank values in the excel spreadsheet with this value
NAVALUE <- 0.2324089


#Needed for the correct reading of excel files
options(stringsAsFactors = FALSE)

#Designates the trim percent value.  Can be changed
trimPercent<-5

#Not used in this script, but shows example of how to write a functon.
#A trim function that looks for the max in a given numeric vector.  Once the index of the maximum is found, the 
#remaining indexes are analyzed to see if the mkate value drops below 5 percent of the max, if so, the rest of the
#values are trimmed.
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

#User input for number of replciates
num<- as.numeric(readline("How many replicates will be used? "))

#initializes vectorList to be a list, which is a data structure
vectorList <- list()

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#Loads the desired excel spreadsheets
for(i in 1:num){
	
	if(i == 1) {
		wb <- loadWorkbook("/Users/awells/Desktop/Dixon Lab/Replicate #2_9Jul14/Exp33_EtOH_OA_Rep#2_1Jul14.xlsx")
	} else if (i == 2){
		wb <- loadWorkbook("/Users/awells/Desktop/Dixon Lab/Replicate #3_9Jul14/Exp33_EtOH_OA_Rep#3_5Jul14.xlsx")
	}

	#wb <- loadWorkbook(file.choose())
	LIST = readWorksheet(wb, sheet = getSheets(wb), startRow = 21)
	vectorList[i] = list(LIST)
	
}

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#A formatted key that provides the program with necessary information
key = read.xls("/Users/awells/Documents/compoundList.xlsx",na.strings="")

#prints out the names of all the drugs in the excel files.
count = 1
while(!is.na(key[count,1])){
	print(sprintf("(%d) %s",count,key[count,1]))
	count = count +1
}

cmp<-as.numeric(readline("Enter the number corresponding with the desired compound: "))

#prints out the next variable (in this case cell line)
count3 = 1
while(!is.na(key[count3,3])){
	print(sprintf("(%d) %s",count3,key[count3,3]))
	count3 = count3 + 1
}

cell<-as.numeric(readline("Enter the number corresponding with the desired cell line: "))

ElapsedTime<-NULL

sytoxList <- list()
mkateList <- list()

#for each replicate, both the sytox and mkate data frames are taken, modified so that each blank cell is 
#replaced by NAVALUE, and put into a list that contains vectors.
for(i in 1:num){
	sytoxTempFrame <- data.frame(vectorList[[i]][2])
	ElapsedTime <- sytoxTempFrame[,2]
	sytoxTempFrame <- sytoxTempFrame[,3:length(sytoxTempFrame[1,])]
	s <- as.matrix(sytoxTempFrame)
	s[s==" "] <- NAVALUE
	sytoxTempFrame <- data.frame(s)
	sytoxList[[i]] <- sytoxTempFrame
	
	mkateTempFrame <- data.frame(vectorList[[i]][3])
	mkateTempFrame <- mkateTempFrame[,3:length(mkateTempFrame[1,])]
	m <- as.matrix(mkateTempFrame)
	m[m == " "] <- NAVALUE
	mkateTempFrame <- data.frame(m)
	mkateList[[i]] <- mkateTempFrame
}


#The starCol specifies the point in the excel file where the code begins extracting data.  It 
# is calculated based on the known format of the excel file, and the user input.
startCol <- 1+ (20*(cmp-1)) + (10*(cell-1)) 

#A vector containing the concentration values that are specified in the key.
concentrationValues <- as.numeric(key[,3+cmp])


STemp <- data.frame(sytoxList[1])
sytoxVec <- as.numeric(STemp[,startCol])

MTemp <- data.frame(mkateList[1])
mkateVec <- as.numeric(MTemp[,startCol])


#Averages the data frames
for(i in 2:num){
	SFrame <- data.frame(sytoxList[i])
	sytoxVec <- as.numeric(sytoxVec) + as.numeric(SFrame[,startCol])
	MTemp <- data.frame(mkateList[i])
	mkateVec <- as.numeric(mkateVec) + as.numeric(MTemp[,startCol])
}

sytoxVec <- sytoxVec/num
mkateVec <- mkateVec/num

maximum <- 0

#The overall maxiumum value is needed so that both lines can be fit on the same graph.
if(max(sytoxVec)>max(mkateVec)){
	maximum <- max(sytoxVec)
} else {
	maximum <- max(mkateVec)
}


#make xy plot that contains both lines on one plot

finalFrame = data.frame(mkateVec,sytoxVec)

matplot(ElapsedTime, finalFrame, type = c("l","l"),col=c("blue","red"),xlab = "Time (hours)",ylab = "Count")
legend(0,maximum,c("mkate2","Sytox G"),lty=c(1,1),lwd=c(2.5,2.5),col=c("blue","red"))
















