#' create an ouptut Directory with correct paths for uploading to basespace this is for single node, more for analysis phase II.  also creates a scratch directory hierarchy.
#' @param selectNames  list of input ids created by formbuilder used to parse json file
#' @param fileJSON      file json read from appSession
#' @return outputPath   a path to output directory
#' @export

createAppResultOutputDirectory<-function(selectNames,fileJSON) {
message("finding project ID ... ")
project_Id<-findSingleNodeProjectId(selectNames,fileJSON)
outputpath<-c("/data/output/appresults") #fixed path for bsfs enabled

outputPath<-paste(outputpath,project_Id,sep="/") #required path must include project id to be uploaded back to BS
message("creating /data/output/appresults/project-id directory")

#need to check the existence of files
if(file.exists("/data/output")!=TRUE){
system("mkdir /data/output")
    if(file.exists("/data/output/appresults")!=TRUE) {
    system("mkdir /data/output/appresults")
     }
}#if /data/output DNE

if(file.exists("/data/output/appresults")!=TRUE) {
system("mkdir /data/output/appresults")
}

message("making /data/output/appresults/projID")
system(paste0("mkdir ",outputPath))
print("making /data/output/appresults/projID/sampleName")
system(paste0("mkdir ",outputPath,"/Results"))


#/data/output/appresults/projID/results directory must contain 
# twa, gwa, erccanalysis, annotatedKexp, enrichmentAnalysis
print("creating analysis output directories for twa, gwa, enrichment,and normalization data..")
dir.create(paste(outputPath,"Results","transcript-wise-Analysis",sep="/"))
dir.create(paste(outputPath,"Results","gene-wise-Analysis",sep="/"))
dir.create(paste(outputPath,"Results","ercc-Analysis",sep="/"))
dir.create(paste(outputPath,"Results","AnnotatedKexp",sep="/"))
dir.create(paste(outputPath,"Results","enrichment-Analysis",sep="/"))


message("creating /data/scratch/ directory ... for write access ... ")

 if(file.exists("/data/scratch")!=TRUE){
system("mkdir /data/scratch")
  }

  if(file.exists("/data/scratch/downloads")!=TRUE){
system("mkdir /data/scratch/downloads") 
  } #if !/scratch/downloads
    if(file.exists("/data/scratch/downloads/samples")!=TRUE){
    system("mkdir /data/scratch/downloads/samples")
   } #if !/scratch/downloads/samples
 
   if(file.exists("/data/scratch/downloads/fastaUploads")!=TRUE){
   system("mkdir /data/scratch/downloads/fastaUploads")
   }#if !/scratch/downloads/fastaUploads


return(paste0(outputPath,"/Results/"))
}



