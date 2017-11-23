#import libraries
library(RCurl)
library(readr)
library(dplyr)
library(tidyr)
library(Matrix)
library(text2vec)
library(cluster)
library(HSAUR) #HSAUR( A Handbook of Statistical Analyses Using R)
library(fpc)
#############import data from TP1###############
u.data <- read.csv(text = getURL('http://www.groupes.polymtl.ca/log6308/Tp/20173/u.data.csv', userpwd = '20113:20113'), sep='|', header=T)
m <- sparseMatrix(u.data[,1],u.data[,2],x=u.data[,3])
rownames(m) <- paste('u', 1:nrow(m), sep='')
colnames(m) <- paste('i', 1:ncol(m), sep='')
u.item <- read.csv(text=getURL('http://www.groupes.polymtl.ca/log6308/Tp/20173/u.item.csv', userpwd = '20113:20113'), sep='|', header=T)
u.user <- read.csv(text=getURL('http://www.groupes.polymtl.ca/log6308/Tp/20173/u.user.csv', userpwd = '20113:20113'), sep='|', header=T)
uitem<- u.item[,c('movie.title', 'Action', 'Adventure', 'Animation', 'Children.s', 'Comedy','Crime', 'Documentary','Drama','Fantasy', 'Film.Noir','Horror','Musical','Mystery','Romance','Sci.Fi','Thriller','War','Western','movie.id','video.release.date','IMDb.URL','unknown','release.date')]
ukdata<-uitem[,1:20]  #the data we used to implement


##################################################################
##################hierarchical clustering#########################
##################################################################

# the importance thing to understand kmeans is to choose the reasonable k-value
#the first step:  we chose k=10
wb= rep(0, 20) # I construct a empty vector to store the mid value


#calculate the distance between items(movies), the result is a 1682*1682 matrix
d = dist(ukdata[,-1], method = 'euclidean') 
clustMovies = hclust(d, method = 'average')

#the for loop is used for calculate the mid value= the division between withinss and betweenss
for(i in c(2:20)) {
  numClusters <-  i;
  #Cuts a tree, e.g., as resulting from hclust, into several groups either by specifying the desired number(s) of groups or the cut height(s).
  groups = cutree(clustMovies, k = numClusters);# assignment to a group for every movie
  wb[i] = cluster.stats(d, groups)$wb # storing the withing/between ratios
}

numClusters = c(2:20)
withinBetweenRatio = wb[2:20] 
plot(numClusters, withinBetweenRatio)
lines(numClusters, withinBetweenRatio)
clust.num<- 20

#clustering and analysis
hca <- cutree(clustMovies, clust.num ) 
moviesClustered <- ukdata
moviesClustered$clusterID <- groups  #appended to moviesData the clusterId

# shows many properties of the clustering, such as between distance, within distance, etc.
stats = cluster.stats(d, groups)
