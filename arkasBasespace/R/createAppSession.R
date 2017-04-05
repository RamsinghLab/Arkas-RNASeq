#' create appSession for single node process

#' @param selectNames     string of names of item contents from json
#' @param transcriptomes  vector of transcriptomes
#' @param outputPath      string path name for output
#' @param scratchPath     string path name scratch path
#' @param fastqPath       string path name for fastq files
#' @import arkas
#' @return appSession     list with the required flags for quantification
#' @export

createAppSession<-function(selectNames,transcriptomes,outputPath=outPath,scratchPath,fastqPath){
#scratchPath is the path that must be copied to for BSFS
#fastqPath is the path that is usually fixed "/data/input/samples" , but is read only for BSFS enabled

appSession<-list()
appSession$fastaFiles<-transcriptomes
appSession$samples<-fileJSON$Properties$Items$Items[which(selectNames=="Input.Samples")][[1]]$Id #get sample Id from json
names(appSession$samples)<-appSession$samples
appSession$fastqPath<-scratchPath

message("copying samples from /data/input/samples to /data/scratch/downloads/samples...")
amiSamples<-paste0(fastqPath,"/",appSession$samples)
command<-paste0("cp -ra ",amiSamples," ",scratchPath,"/")
scratchDestination<-paste0(scratchPath,"/",appSession$samples)
   for(j in 1:length(scratchDestination)){
    if(file.exists(scratchDestination[j])!=TRUE) {
       message(paste0("creating scratch directory ",scratchDestination[j]))
       system(paste0("mkdir ",scratchDestination[j]))
      }
  }#{create sample dir in scratch
lapply(command,function(x) system(x))


appSession$fastaPath<-fastaPath
appSession$bootstraps<-bootstrapValue
appSession$outputPath<-paste0(outputPath,"/Results/abundance")
stopifnot(all(lapply(transcriptomes,function(x) file.exists(paste0(fastaPath,"/",x)))=="TRUE"))

#add a check
stopifnot(all(appSession$samples %in% dir(scratchPath)[!grepl(".json",dir(scratchPath))])==TRUE)

message("transcriptome files exists, O.K., running index...")
appSession$indexName <- indexKallisto(fastaFiles=appSession$fastaFiles, fastaPath=appSession$fastaPath)$indexName
  message("completed appSession creation ... ")
 return(appSession)
}

