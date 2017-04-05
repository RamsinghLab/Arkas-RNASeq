#' find the bias or pseudobam input from the basespace interface
#' @param selectNames    vector of input ids from basespace form
#' @param fileJSON       json file from basespace
#' @return biasPBList    list of bias or pseudobam flags used for quant
#' @export
findbiasPseudobam<-function(selectNames,fileJSON){
message("Dave, I'm parsing the bias, or pseudobam user selection ...")
biasPB<-unlist(fileJSON$Properties$Items$Items[which(selectNames=="Input.bias-pseudobam")])

biasPB<-unlist(strsplit(biasPB,","))

bias<-biasPB[grepl("bias",biasPB)]
PB<-biasPB[grepl("bam",biasPB)]
biasPBList<-list()
      if( length(bias)> 0) {
       message("found bias input selection ... ")
       biasPBList$bias<-"TRUE"
      }
     if(length(PB)>0){
     message("found pseudobam input selection ...")
     biasPBList$pseudobam<-"TRUE"
      }
      if( length(bias)== 0) {
      message("found bias input selection ... ")
       biasPBList$bias<-"FALSE"
      }
     if(length(PB)==0){
     message("found pseudobam input selection ...")
     biasPBList$pseudobam<-"FALSE"
     }
message("done finding bias /pbam input selection ...")
return(biasPBList)
}
