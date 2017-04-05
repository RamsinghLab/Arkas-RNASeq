#' rename the samples from session ID to sample Name for multi-node template
#' @param selectNames    list of input ids created by form builder on basespace, used to parse the json file
#' @param appSession    list of appSession flags used for quantification
#' @param fileJSON      json file from basespace
#' @import tools
#' @return DF             data frame of appSession ID and sample Names
#' @export

renameChildAppSessionID<-function(selectNames,appSession,fileJSON){
    sampleName<-fileJSON$Properties$Items$Items[[which(selectNames=="Input.Samples")]]$Name
    sampleID<-fileJSON$Properties$Items$Items[[which(selectNames=="Input.Samples")]]$Id
    DF<-data.frame(samples=sampleName,ID=sampleID,stringsAsFactors=FALSE)
    inDex<-sapply(DF[,2], function(x) grep(x,dir(appSession$outputPath)))
    outs<-dir(appSession$outputPath)[inDex]
    outs<-outs[!grepl("bam",outs)]
    for(i in 1:length(outs)){
    if(grepl(".tar.gz",outs[i])==TRUE){
     sampleFromID<-gsub(DF$ID,DF$samples,outs[i])
     originalSource<-paste0(appSession$outputPath,"/",outs[i])
     sampleNameDir<-sub("^([^.]*).*","\\1",basename(destin))
     destin<-paste0(appSession$outputPath,"/",sampleNameDir,"/",sampleFromID)
     command<-paste0("mv ",originalSource," ",destin)
     system(command)
     unlink(originalSource,recursive=TRUE,force=TRUE)
      }
   if(grepl(".tar.gz",outs[i])!=TRUE){
    sampleFromID<-DF[which(outs[i]==DF[,2]),1]
    originalSource<-paste0(appSession$outputPath,"/",outs[i])
    destin<-paste0(appSession$outputPath,"/",sampleFromID)
    command<-paste0("mv ",originalSource,"/* ",destin)
    system(command)
    unlink(originalSource,recursive=TRUE,force=TRUE)
     }
    } #for
    #FIX ME: check if there is sampleID.bam mv ot SampleName.bam
    if( length( list_files_with_exts(appSession$outputPath,"bam") >0) ) {
    system(paste0("mv ",appSession$outputPath,"/",sampleID,".bam"," ",appSession$outputPath,"/",sampleName,".bam"))
     } #there exists bam file , note this is only for single child node, 1 bam only
  
    return(DF)
 }#{{{main


