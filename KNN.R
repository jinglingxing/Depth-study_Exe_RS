#import libraries
library(RCurl)
library(readr)
library(dplyr)
library(tidyr)
library(Matrix)
library(text2vec)
library(ggplot2)
library(FNN)
library(class)
library(gmodels) #i want to use the CrossTable() function
######################import data from TP1###########################


u.data <- read.csv(text = getURL('http://www.groupes.polymtl.ca/log6308/Tp/20173/u.data.csv', userpwd = '20113:20113'), sep='|', header=T)
m <- sparseMatrix(u.data[,1],u.data[,2],x=u.data[,3])
rownames(m) <- paste('u', 1:nrow(m), sep='')
colnames(m) <- paste('i', 1:ncol(m), sep='')
u.item <- read.csv(text=getURL('http://www.groupes.polymtl.ca/log6308/Tp/20173/u.item.csv', userpwd = '20113:20113'), sep='|', header=T)
u.user <- read.csv(text=getURL('http://www.groupes.polymtl.ca/log6308/Tp/20173/u.user.csv', userpwd = '20113:20113'), sep='|', header=T)


########################Preprocess data##############################


uitem<- u.item[,c('movie.id','movie.title', 'release.date', 'Action', 'Adventure', 'Animation', 'Children.s', 'Comedy','Crime', 'Documentary','Drama','Fantasy', 'Film.Noir','Horror','Musical','Mystery','Romance','Sci.Fi','Thriller','War','Western','video.release.date','IMDb.URL','unknown')]
uudata<-uitem[,1:21]  #the data of movies

#separate the year-month-date
moviesData <- uudata %>% separate(col = release.date, 
                                  into = c('Day', 'Month','Year'), 
                                  sep = "-")  
##delete the day and month
moviesData$Day <- NULL  
moviesData$Month <- NULL
moviesData$Year <- as.numeric(moviesData$Year)
md<- moviesData

##################################################################
#########################     KNN     ############################
##################################################################

#Normalizing numeric data
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x))) }  #the normalizing function

md.nor <- as.data.frame(lapply(md[4:21], normalize))

md.train <-  md.nor [1:1000,]
md.test <-  md.nor[1001:1682,] 

#This code takes the diagnosis factor in column 1 of the md.nor
#data frame and on turn creates md_train_labels and md_test_labels data frame.

md.train.labels <- md[1:1000, 1]
md.test.labels <- md[1001:1682, 1]
md.test.pred <- knn(train = md.train, test = md.test,cl = md.train.labels, k=10)

####################Evaluate the model performance#########################

CrossTable(x=md.test.labels, y=md.test.pred, prop.chisq =TRUE)
plot(md.test.pred)





