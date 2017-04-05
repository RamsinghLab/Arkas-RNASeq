#' renames the appSession ID which is default sample name convention to sample name
#' @param selectNames    vector of strings of input ids used to parse json
#' @param appSession     list of appSession flags used for quantification
#' @import tools
#' @return DF            data frame of sample Names and sample ID 
#' @export

renameAppSessionID<-function(selectNames,appSession){
    sampleCompareNames<-fileJSON$Properties$Items$Items[[which(selectNames=="Input.comparison-sample-id")]]$Name
    sampleCompareID<-fileJSON$Properties$Items$Items[[which(selectNames=="Input.comparison-sample-id")]]$Id
    sampleControlNames<-fileJSON$Properties$Items$Items[[which(selectNames=="Input.control-sample-id")]]$Name
    sampleControlID<-fileJSON$Properties$Items$Items[[which(selectNames=="Input.control-sample-id")]]$Id
    DF<-data.frame(samples=c(sampleCompareNames,sampleControlNames),ID=c(sampleCompareID,sampleControlID),stringsAsFactors=FALSE)
    inDex<-sapply(DF[,2], function(x) grep(x,dir(appSession$outputPath)))
    outs<-dir(appSession$outputPath)[inDex]

    for(i in 1:length(outs)){
    sampleFromID<-DF[which(outs[i]==DF[,2]),1]
    originalSource<-paste0(appSession$outputPath,"/",outs[i])
    destin<-paste0(outputPath,"/","Results","/",sampleFromID)
    command<-paste0("cp -ra ",originalSource,"/. ",destin,"/")
    system(command)
    }#moving ID outs to sample Name out

   return(DF)
 }#{{{main


