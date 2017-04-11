#' this finds the percent difference of two covarites in a SE4 object
#'
#' @param kexpNew        a kallisto experiment from artemis
#' @param kexpOrigin     a kallisto experiment considered 'origin' to be compare to
#'
#' @return            a list with a bunch of difference data
#'
#'
#' @import arkas
#'
#'@export
#'
#'


findStandardizedMeanDifference<-function(kexpNew,kexpOrigin){
message(paste0("finding the difference between : ",kallistoVersion(kexpNew)," and ", kallistoVersion(kexpOrigin)))
#check the parameters for types
  stopifnot((class(kexpNew)[[1]]=="KallistoExperiment"))
  message("checking assays names ...")
  stopifnot(names(assays(kexpNew))==names(assays(kexpOrigin)))
  message("assays names O.K. ...")
  message("checking transcriptomes...")
  stopifnot(identical(transcriptomes(kexpNew),transcriptomes(kexpOrigin)))
  message("checking covariates ... ")
  stopifnot(identical(colData(kexpNew),colData(kexpOrigin)))
  message("checking row names. ..")
  stopifnot(identical(rownames(kexpNew),rownames(kexpOrigin)))
  covariatesList<-as.list(names(assays(kexpNew)))
#need to add GC_content and tx_length as target covariates
  message("checking meta colnames ... ")
  stopifnot(identical(colnames(mcols(rowRanges(kexpNew))),colnames(mcols(rowRanges(kexpOrigin)))))


  covariatesList<-append(covariatesList,list(colnames(mcols(rowRanges(kexpNew)))[grepl("tx_length",colnames(mcols(rowRanges(kexpNew))))]))
covariatesList<-append(covariatesList,list(colnames(mcols(rowRanges(kexpNew)))[grepl("gc_content",colnames(mcols(rowRanges(kexpNew))))]))

names(covariatesList)<-covariatesList
resNew<-lapply(covariatesList,function(x) .kexpAssayAccessor(x,kexpNew))
resOrigin<-lapply(covariatesList,function(x) .kexpAssayAccessor(x,kexpOrigin))
message("checking list lengths ... ")
stopifnot(length(resNew)==length(resOrigin))
resultsDiffList<-.calculateDifferenceFromList(kexpNew,resNew,resOrigin)
resultsDiffList$transcriptomes<-transcriptomes(kexpNew)
resultsDiffList$newkallistoVersion<-kallistoVersion(kexpNew)
resultsDiffList$covariates<-colData(kexpNew)$ID
resultsDiffList$rownames<-rownames(kexpNew)
return(resultsDiffList)
 } #top


.kexpAssayAccessor<-function(type,kexp){
 if(type=="est_counts"){
    results<-assays(kexp)$est_counts

   }
else if(type=="tpm"){
    results<-assays(kexp)$tpm
   }

  else if(type=="eff_length"){
    results<-assays(kexp)$eff_length
   }

  else if(type=="est_counts_mad"){
    results<-assays(kexp)$est_counts_mad
   }

  else if(type=="tx_length"){
    results<-as.matrix(mcols(rowRanges(kexp))$tx_length)
    rownames(results)<-rownames(kexp)
    colnames(results)<-"tx_length"
   }
    else if(type=="gc_content"){
    results<-as.matrix(mcols(rowRanges(kexp))$gc_content)
    rownames(results)<-rownames(kexp)
    colnames(results)<-"gc_content"
   }   

  else{

   message("I'm afraid, I don't know how to access ...")
   }
    return(results)

}


.calculateDifferenceFromList<-function(kexp,resNew,resOrigin){
  diffList<-list()
  outliers<-NULL
  outLiars<-list()

  for(k in 1:length(resNew)){
  dataN<-resNew[[k]]
  dataO<-resOrigin[[k]]
  diffMatrix<-matrix(data=NA,nrow=nrow(dataN),ncol=ncol(dataN))
stopifnot(rownames(dataN)==rownames(dataO)) #this must be true!!!
  rownames(diffMatrix)<-rownames(dataN)
  colnames(diffMatrix)<-colnames(dataN)
 # diffMatrix<-(dataN-dataO)/(dataO + 1)
   ##standardized mean difference
   x<-dataN-dataO
   X<-x-mean(x)
   X<-X/(sd(X)/sqrt(ncol(X)))
   diffMatrix<-X
  outliers<-rownames(diffMatrix)[ which(abs(diffMatrix)>1.01)]
  outliers<-outliers[(!is.na(outliers))]
  diffList[[k]]<-diffMatrix
  names(diffList)[k]<-names(resNew)[k]
  outLiars[[k]]<-rowRanges(kexp)[outliers]
  names(outLiars)[k]<-paste0(names(resNew)[k],"_Outlrs")

}#for top res

for(m in 1:length(outLiars)){
diffList<-append(diffList,list(outLiars[[m]]))
names(diffList)[which(names(diffList)=="")]<-names(outLiars)[m]
}

return(diffList)

}#top of function


