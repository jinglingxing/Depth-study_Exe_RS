# Depth-study_Exe_RS
This is some exercises including Kmeans, KNN, Hierarchical clustering, Decision tree. The data is same as the RS final project. 
## K-means
### Image1: How to set the K value
![image](https://github.com/jinglingxing/Depth-study_Exe_RS/blob/master/Rplot-Kmeans.png)
### Image2: The silhouette performance 
![image](https://github.com/jinglingxing/Depth-study_Exe_RS/blob/master/Rplot-kmeans-silhouette.png)

The silhouette value is a measure of how similar an object is to its own cluster (cohesion) compared to other clusters (separation). The silhouette ranges from −1 to +1, where a high value indicates that the object is well matched to its own cluster and poorly matched to neighboring clusters. If most objects have a high value, then the clustering configuration is appropriate. 
In this case, the silhouette value is between 0.8 to 1.0, it proved that the K value is good enough.
## Hierarchical
### Image3: How to find the number of clusters
![image](https://github.com/jinglingxing/Depth-study_Exe_RS/blob/master/Rplot-hierarchical.png)
#### There is to show many properties of the clustering
$n
[1] 1682

$cluster.number
[1] 20

$cluster.size
 [1]  68 103  59 118  84  92  56  79 119  83 128  97  39  94  66  99 100  53  92  53
 
$median.distance
 [1] 20.09975 31.00000 18.05547 35.04283 25.05993 27.07397 17.08801 23.15167 35.04283 25.03997
[11] 38.02631 29.01724 12.08305 28.03569 20.02498 29.05168 30.00833 16.06238 27.05550 16.03122

$average.between
[1] 590.8787

$average.within
[1] 32.67737
## decision tree
#### comparison between actual and prediction(for rating)
shows how many ratins with value "dt.pre" have been classified as rating "trueResults"

                         trueResults
                         
     dt.pre          1    2    3    4    5
     
  2.33564686285397  293  214  207  113   61
  
  3.2171165806537   568 1143 2625 2311  927
  
  3.68648356194901  251  686 2052 3036 1825
  
  4.12265815910942   85  177  668 1315 1460
  
## KNN
The performance of this data using KNN is terrible. I guess it is because the genre of movie are different kinds and matrix is a sparse matrix, finding neighbors are not realistic..... 
### To conclude
We need to analyze the data first and then find the suitable methods to handle the data and do recommendation. 
I need to study by heart.....
