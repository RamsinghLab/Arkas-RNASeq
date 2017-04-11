#' this finds the outliers of two covarites in a SE4 object
#'
#'
#' @param diff  object from findPercentDifferenceAssays
#' 
#' @return         a kallisto Experiment of differences
#'
#' @import artemis   
#'@export
#'
#'
findOutliers<-function(diff){

data(UnannotatedTranscripts)
rowdat <- rep(UnannotatedTranscripts, nrow(diff$est_counts))
results<-KallistoExperiment(est_counts=diff$est_counts,
                            eff_length=diff$eff_length,
                            est_counts_mad=diff$est_counts_mad,
                            transcriptomes=diff$transcriptomes,
                            kallistoVersion=diff$newkallistoVersion,
                            covariates=diff$covariates,
                            features=rowdat)

rownames(results)<-diff$rownames
results<-SetTxDbLiteMetaClass(results)
outs<-diff[grepl("_Outlrs",names(diff))]
outs<-outs[which(as.numeric(summary(outs)[,1])>0)]

for(i in 1:length(outs)){
  foundTxs<-intersect(rownames(results),names(outs[[i]]))
  feats<-features(results)
  feats[foundTxs]<-outs[[i]]
  features(results)[foundTxs]<-feats[foundTxs]
  }

#add meta columns
mcols(results)$deltaTx_length<-diff[[5]]
mcols(results)$deltaGc_content<-diff[[6]]
                  
return(results)

}
