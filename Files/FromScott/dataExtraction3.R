#The overall goal of this R script is to take data from formatted excel files, create a dose-response
#curve model, and print information such as the EC50 value, AUC, and slope of the various curves.


#A line of !!!!!!!!!!!!!!!!!!!!!!!!! denotes a place in the code that needs to be changed.

#In order to use certain prewritten functions in an R script, certain libraries must be
#downloaded and included at the top of the R script.  Each of these libraries contains functions
#that are used below
library(MASS)
library(drc)   #used to perform dose-response curve analysis
library(gdata) 
library(XLConnect)  #Used to read and write excel files
library(MESS)  		#Contains the "auc" function used in the script
library(stats)		#contains the coef function
library(gplots)		#Used to plot data if desired

#stringsAsFactors must be set to false in order to ensure the proper reading of excel files.  Normally 
#show.error.messages and warn should not be set to off, but in this case since the drc package displays 
#warnings and errors in the event of a bad fit, it should be used here. 
options(stringsAsFactors =FALSE, warn = -1,show.error.messages = FALSE)



#This value will be used to replace blank cells in the excel file.
NAVALUE <- 0.2320489

#!!!!!!!!!!!!!!!!!
#specifies the number of tabs present in each replicate
numTabs <- 3

#Gets user info, tells the code how many different excel files will be read
num <- as.numeric(readline("How many replicates will be used? "))

#intializing dataList variable to be a list, which is a data structure that will contain multiple data frames.
dataList <- list()

#!!!!!!!!!!!!!!!!!!!!!!!!!
#Reads in the specified excel files.  As shown below, if you are consistently using the same replicates, you can
#comment out the wb<- loadWorkbook(file.choose()) line and add in the correct path as shown below.
for (i in 1:num) {
	#	wb<-loadWorkbook(file.choose())
	
	if (i == 1) {
		wb <- loadWorkbook("/Users/awells/Desktop/Dixon Lab/Replicate #2_9Jul14/Exp33_EtOH_OA_Rep#2_1Jul14.xlsx")
	} else if (i == 2) {
		wb <- loadWorkbook("/Users/awells/Desktop/Dixon Lab/Replicate #3_9Jul14/Exp33_EtOH_OA_Rep#3_5Jul14.xlsx")
	}

	LIST = readWorksheet(wb, sheet = getSheets(wb), startRow = 21)
	dataList[i] = list(LIST)
}

#!!!!!!!!!!!!!!!!!!!!!!!!!
#The key must be specifically formatted, a sample key will be posted.
key = read.xls("/Users/awells/Documents/LethalCompoundsKey.xlsx")

#Gets the elapsed Time vector from the data frame
timeFrame <- data.frame(dataList[[1]][1])
timeVector <- timeFrame[,2]

averagedList <- NULL

#For each tab (defaults to 3, can be changed), the data frames from each replicate are averaged
#to create one data frame per phenotypic marker
for(j in 1:numTabs){
	combinedFrame<- data.frame(dataList[[1]][j])
	combinedFrame <- combinedFrame[,3:length(combinedFrame[1,])]
	n1 <- as.matrix(combinedFrame)
	n1[n1 == " "]<- NAVALUE
	combinedFrame <- data.frame(n1)
		
	for(k in 2:num){
		tempFrame <- data.frame(dataList[[k]][j])
		tempFrame <- tempFrame[,3:length(tempFrame[1,])]
		m1 <- as.matrix(tempFrame)
		m1[m1==" "]<- NAVALUE
		tempFrame <- data.frame(m1)

		combinedFrame <- data.matrix(combinedFrame) + data.matrix(tempFrame)
		
	}
	averagedList[[j]]<-combinedFrame
}

#Completes the averaging by dividing each data frame by the number of replicates
for(i in 1:numTabs){
	frame <- data.frame(averagedList[i])
	frame <- frame/num
	averagedList[[i]] <- frame	
}

#For each tab (defaults to 3, can be changed), a data frame is created from the averaged replicates.  
#Then a while loop is used to run for a number of times equal to the length of a row in the key minus 1, which 
#is equal to the number of compounds/cell line combinations.  In the while loop, a Dose Vector is created using
#the key, and the values at each of the ten drug concentrations are put into a vector.  These two vectors are
#then combined in a data frame that is analyzed using the drc and MESS packages in order to extract values.
for(i in 1:numTabs){
	
	mydata <- data.frame(averagedList[i])
	
	compoundVector <- NULL
	EC50Table <- NULL
	
	CVC = 1
	count = 0	
	
	SlopeTable <- NULL
	AUCTable <- NULL
	
	while(count < (length(key[1,]))-1){
		
		Dvector = as.numeric(key[2:length(key[,1]),count + 1])
		
		if(Dvector[1]!=0){
			
			compoundVector[CVC] = key[1,count +1]
			CVC = CVC +1
			
			EC50Vector <- NULL
			AUCVector <- NULL
			SlopeVector <- NULL
			
			for(j in 1:length(mydata[,1])){
					
				TPvector = as.numeric(mydata[j,(1+ (10*count)):(10*(count+1))])
				tempDataFrame <- data.frame(Dvector,TPvector)
				
				try(drc.m1 <- drm(TPvector ~ Dvector, data = mydata, fct = LL.4()))
				
				SlopeVector[j] = -1 * (coef(drc.m1)[1])
				
				ED50 = ED(drc.m1, 50, interval = "delta", display = FALSE)
				EC50 = ED50[1, 1]
				EC50Vector[j] = EC50
				
				areaUC <- auc(Dvector, TPvector, type = "spline")
				AUCVector[j] = areaUC
						
			}
			
			SlopeTable = cbind(SlopeTable, SlopeVector)
			AUCTable = cbind(AUCTable, AUCVector)
			EC50Table = cbind(EC50Table, EC50Vector)
		
		}
		
		count = count + 1	
	}
	rownames(EC50Table) <- timeVector
	colnames(EC50Table) <- compoundVector
	colnames(AUCTable) <- compoundVector
	rownames(AUCTable) <- timeVector
	colnames(SlopeTable) <- compoundVector
	rownames(SlopeTable) <- timeVector
	print(j)
	print("EC50")
	print(EC50Table)
	print("AUC")
	print(AUCTable)
	print("Slopes")
	print(SlopeTable)	
}





















