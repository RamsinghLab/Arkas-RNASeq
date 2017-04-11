# dataVariance
This is a package for measuring data variance amidst a computation S4 object.

For an example of measuring the difference between two kallisto Experiments, please see the package artemis, and artemisData.  From artemisData, we can load two Kallisto Experiments and compare their differences.

>library(artemisVariance)   
>data(kexpNew)    
>data(kexpOriginal)    
>diff<-findPercentDifferenceAssays(kexpNew,kexpOriginal)    
>kde<-findOutliers(diff)    
