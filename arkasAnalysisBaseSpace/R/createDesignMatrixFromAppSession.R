#' create the Design matrix from comparison and control inputs on basespace
#' @param selectNames   vector of input ids from baseSpace input form
#' @return  design      matrix of a one group comparison default
#' @export


createDesignMatrixFromAppSession<-function(appSession){
#message("creating single covariate, two group comparison design matrix ...")
#create vector of compare, control names,  rename.

sampleCompareNames<-appSession$comparisonSamples
sampleControlNames<-appSession$controlSamples



totalNumberPairs<-(length(sampleCompareNames)+length(sampleControlNames))/2
additionalColumns<-totalNumberPairs-1
DF<-data.frame(samples=c(sampleCompareNames,sampleControlNames),Intercept=rep(1,length(c(sampleCompareNames,  sampleControlNames))),CompVsControl=rep(0,length(c(sampleCompareNames,  sampleControlNames))), stringsAsFactors=FALSE)
#find which ID is control, and which is not
for(j in 1:nrow(DF)){
if(DF[j,1] %in% sampleCompareNames){
 DF[j,3]<-1
   }
}#For loop for marking Controls
design<-DF[,2:ncol(DF)]
design<-as.matrix(design)
rownames(design)<-DF[,1]
#message("the design uses limma to contrast Comparison (MUT) vs. Control (WT) where MUT positive values is with respect to upward differential expresison of mutant")


#print(design)
return(design)
} #{{{ main


