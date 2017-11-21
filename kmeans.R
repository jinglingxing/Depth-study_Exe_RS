#import libraries
library(RCurl)
library(readr)
library(dplyr)
library(tidyr)
library(Matrix)
library(text2vec)
library(cluster)
library(HSAUR) #HSAUR( A Handbook of Statistical Analyses Using R)

#############import data from TP1###############
u.data <- read.csv(text = getURL('http://www.groupes.polymtl.ca/log6308/Tp/20173/u.data.csv', userpwd = '20113:20113'), sep='|', header=T)
m <- sparseMatrix(u.data[,1],u.data[,2],x=u.data[,3])
rownames(m) <- paste('u', 1:nrow(m), sep='')
colnames(m) <- paste('i', 1:ncol(m), sep='')
u.item <- read.csv(text=getURL('http://www.groupes.polymtl.ca/log6308/Tp/20173/u.item.csv', userpwd = '20113:20113'), sep='|', header=T)
u.user <- read.csv(text=getURL('http://www.groupes.polymtl.ca/log6308/Tp/20173/u.user.csv', userpwd = '20113:20113'), sep='|', header=T)
uitem<- u.item[,c('movie.title', 'Action', 'Adventure', 'Animation', 'Children.s', 'Comedy','Crime', 'Documentary','Drama','Fantasy', 'Film.Noir','Horror','Musical','Mystery','Romance','Sci.Fi','Thriller','War','Western','movie.id','video.release.date','IMDb.URL','unknown','release.date')]
ukdata<-uitem[,1:20]  #the data we used to implement kmeans, the data does not include the non-numberic data
#because the kmeans can only handle the numeric data


##################################################################
#########################Kmeans algorithm#########################
##################################################################

# the importance thing to understand kmeans is to choose the reasonable k-value
#the first step:  we chose k=10
MidValue= rep(0, 20) # I construct a empty vector to store the mid value


#calculate the distance between items(movies), the result is a 1682*1682 matrix
 
d<- dist(ukdata[,-1], method = 'euclidean')  

#the for loop is used for calculate the mid value= the division between withinss and betweenss
for(i in c(2:20)) {
  numClusters <-  i;
  clustMovies <-  kmeans(ukdata[,-1], centers = numClusters);
  MidValue[i] <-  clustMovies$tot.withinss / clustMovies$betweenss  # storing the withing/between ratios
}

numClusters = c(2:20)
withinBetweenRatio = MidValue[2:20] 
plot(numClusters, withinBetweenRatio, xlab = "K", ylab = "Within/Between Ratio for this K")
lines(numClusters, withinBetweenRatio)
k <- 5 

#clustering and analysis
km <- kmeans(ukdata[,-1], centers = 10)
agg<-aggregate(ukdata[,-1],by=list(km$cluster),FUN=mean) #get cluster means
ukdata<- data.frame(ukdata[,-1],km$cluster) #find the movies belonging to which cluster
#plot_clust<- clusplot(ukdata[,-1], KmeansCluster$cluster, color=TRUE, shade=FALSE, 
#         labels=2, lines=0)
#20% of the information about the multivariate data is captured by this plot of components 1 and 2. 
dissE <- daisy(ukdata)  #daisy----Dissimilarity Matrix Calculation
dE2   <- dissE^2        
sk2   <- silhouette(km$cl, dE2)  #Compute or Extract Silhouette Information from Clustering
plot(sk2)



