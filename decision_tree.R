library(readr)
library(dplyr)
library(party)
library(rpart.plot)
library(ROCR)
#############import data from TP1###############
u.data <- read.csv(text = getURL('http://www.groupes.polymtl.ca/log6308/Tp/20173/u.data.csv', userpwd = '20113:20113'), sep='|', header=T)
m <- sparseMatrix(u.data[,1],u.data[,2],x=u.data[,3])
rownames(m) <- paste('u', 1:nrow(m), sep='')
colnames(m) <- paste('i', 1:ncol(m), sep='')
u.item <- read.csv(text=getURL('http://www.groupes.polymtl.ca/log6308/Tp/20173/u.item.csv', userpwd = '20113:20113'), sep='|', header=T)
u.user <- read.csv(text=getURL('http://www.groupes.polymtl.ca/log6308/Tp/20173/u.user.csv', userpwd = '20113:20113'), sep='|', header=T)
#################################################
useritem<- merge(u.user, u.item, by.x="id", by.y="movie.id")
useritem$video.release.date<- NULL
useritem$IMDb.URL<-NULL
useritemrating<- merge(useritem, u.data, by.x="id", by.y = "user.id")
useritemrating$timestamp<-NULL
useritemrating$id<-NULL
useritemrating$item.id<-NULL

###train and test
flag<-sample(1:2, nrow(useritemrating), replace = T, prob = c(0.8, 0.2))
train.data<-useritemrating[flag==1, ]
test.data<- useritemrating[flag==2, ]

#the element except rating used to predict rating
#formula: class_label ~ independent_variable
dt = rpart(rating ~ . , train.data, maxdepth = 10)
trueResults = as.factor(test.data$rating)
# valeus predicted by the decision tree
dt.pre= predict(dt, newdata = test.data) 

#comparison between actual and prediction(for rating)
#shows how many ratins with value "dt.pre" have been classified as rating "trueResults"
Tb = table(dt.pre, trueResults)
