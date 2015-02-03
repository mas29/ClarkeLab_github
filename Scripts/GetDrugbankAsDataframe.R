dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
library(XML)
data <- xmlParse(paste(dir,"Databases/drugbank.xml",sep=""))
drugbank_xml_data <- xmlToList(data)
save(drugbank_xml_data, file=paste(dir,"Databases/drugbank_xml_data.R",sep=""))
as_df <- ldply(drugbank_xml_data, data.frame)
(nodes=getNodeSet(data,"//groups"))

temp1 <- unlist(drugbank_xml_data)


temp2 <- data.frame(as.list(temp1))






library(plyr)
ldply(drugbank_xml_data, data.frame )

df <- data.frame(do.call(rbind, drugbank_xml_data))

z <- getNodeSet(drugbank_xml_data, "polypeptide")


xmltop = xmlRoot(data)

drugbank_xml_data[[1]]

xmlSApply(xmltop[[1]], xmlName)

temp = ldply(drugbank_xml_data[[1]], data.frame)


y <- 
  xmlInternalTreeParse( 
    data)


temp2 <- xmlToDataFrame(getNodeSet(data, '//drugbank-id'))

Parsed.xml <- xmlTreeParse(paste(dir,"Databases/drugbank.xml",sep="")) # ??? 
Parsed.xml.internal.nodes <- xmlTreeParse(paste(dir,"Databases/drugbank.xml",sep=""), useInternalNodes = TRUE) # ???

xpathApply(data, 'drugbank-id')
getNodeSet(data, '//drugbank-id')

temp3 <- ldply(drugbank_xml_data, data.frame)


books <- "http://www.w3schools.com/XQuery/books.xml"
ldply(books, function(x) { data.frame(x[!names(x)=="author"]) } )
ldply(xmlToList(books), data.frame)
