#' QC plots of ERCC spike-in controls this is targeted for PHase II inputing an appSession list
#'
#' @param kexp            something that behaves like a KallistoExperiment 
#'  @param appSession     a list of analysis workflow items, including comparison names and control names
#' @import RUVSeq 
#' @import reshape2
#' @import Rccdashboard
#' @export
#' @return returns plots and images of ercc analysis
erccAnalysis <- function(kexp,appSession) {

  #data(ERCC_annotated)
  ERCC_counts <- counts(kexp)[ grep("ERCC", rownames(kexp)), ] 
  if (nrow(ERCC_counts) < 1) stop("You do not seem to have any ERCC controls.")
  currentDir<-getwd()

  #this analysis works for n X 7 data frame:  
  options(width=60, continue = "  ")
  counts<-assays(kexp)$est_counts
  Feature<-rownames(counts)

  countsDF<-data.frame(counts,stringsAsFactors=FALSE,check.names=FALSE)
  

comparisonMatch<-colnames(countsDF)[colnames(countsDF) %in% appSession$comparisonSamples]

 for(i in 1:length(comparisonMatch) ) {
 idx<-which(colnames(countsDF)==comparisonMatch[i])
 colnames(countsDF)[idx]<-paste0("COMP_",i)
 }

controlMatch<-colnames(countsDF)[colnames(countsDF) %in% appSession$controlSamples]
   for(i in 1:length(controlMatch) ) {
  idx2<-which(colnames(countsDF)==controlMatch[i])
  colnames(countsDF)[idx2]<-paste0("CNTRL_",i)
   }


  #must be integer values
  countsDF<-round(countsDF)
  erccDF<-cbind(Feature,countsDF)
  rownames(erccDF)<-NULL 
 #Must remove all the values for every row that contain a 0 for all columns
  #countDF<-countDF[which(rowSums(countsDF)>0),]
setwd(appSession$ercc_outputPath) 

datType<-"count"
  isNorm=FALSE
  exTable=erccDF
  filenameRoot="ercc_analysis"
  sample1Name="COMP"
  sample2Name="CNTRL"
  erccmix="RatioPair"
  erccdilution=1/100
  spikeVol<-1
  totalRNAmass=0.500
  choseFDR<-0.05
  repNormFactor<-NULL
  ratioLim=c(-4,4)
  signalLim=c(-14,14)
  userMixFile=NULL


 exDat <- initDat(datType=datType, isNorm = isNorm, exTable=exTable,
                     repNormFactor=repNormFactor, filenameRoot=filenameRoot,
                     sample1Name=sample1Name, sample2Name=sample2Name,
                     erccmix=erccmix, erccdilution=erccdilution,
                     spikeVol=spikeVol, totalRNAmass=totalRNAmass,
                     choseFDR=choseFDR,ratioLim = ratioLim,
                     signalLim = signalLim,userMixFile=userMixFile)


#a more specific control flow

exDat<-est_r_m(exDat)
    # Evaluate the dynamic range of the experiment (Signal-Abundance plot)
    # Not required for subsequent functions
exDat<-dynRangePlot(exDat)

 # Test for differential expression between samples
    # Required for all subsequent functions
    exDat <- geneExprTest(exDat)

 # Generate ROC curves and AUC statistics
    # Not Required for subsequent functions
    exDat <- erccROC(exDat)



if(length(controlMatch)==length(comparisonMatch)) {
#exDat<-runDashboard(datType="count", 
#  isNorm=FALSE,
#  exTable=erccDF,
#  filenameRoot="ercc_analysis",
#  sample1Name="COMP",
#  sample2Name="CNTRL",
#  erccmix="RatioPair",
#  erccdilution=1/100,
#  spikeVol=1,
#  totalRNAmass=0.500,
#  choseFDR=0.1)
 # exDat <- est_r_m(exDat)
 # exDat <- dynRangePlot(exDat)
 # exDat <- geneExprTest(exDat)
 # exDat <- erccROC(exDat)
  #multiple plot 1 pdf per page 
 # saveERCCPlots(exDat, plotsPerPg = "single", plotlist = exDat$Figures)
  if(nrow(ERCC_counts[rowSums(ERCC_counts)>2,]) >=20) {
   exDat<-estLODR(exDat,kind = "ERCC", prob=0.9)
 }

}
   setwd(currentDir)
  return(exDat)
} #{{{main
