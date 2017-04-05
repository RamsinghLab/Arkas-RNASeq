#' runs the multi-node template on baseSpace parses each child node appSession.JSON. the /data/input/appSesson is explicitly defined in the callback.js.  this script is to organize the running of child nodes; designed to process the kallisto quant and analysis on single node. 
#'
#' @import arkas
#' @import jsonlite
#' @import biomaRt
#' @import DT
#' @export

#library(arkas)
#library(jsonlite)
#library(hash)
#library(biomaRt)
#library(DT) #htmlwidgets for CSV as interactive
#source scripts for single node processing
#source("/bin/createAppSession.R")
#source("/bin/findTranscriptInput.R") #single node only
#source("/bin/renameAppSessionID.R")
#source("/bin/createOutputDirectory.R") #single node only
#source("/bin/findBootStrapValue.R") #OK for multi node children

#sourcing for multi-node
#source("/bin/createChildOutputDirectory.R")
#source("/bin/findChildProjectId.R")
#source("/bin/findChildTranscriptInput.R") 
#source("/bin/createChildAppSession.R")
#source("/bin/createChildReference.R")
#source("/bin/renameChildAppSession.R")
#source("/bin/findbiasPseudobam.R")
#source("/bin/findkmerSize.R")

processChildNode<-function(){
fastaFiles<-NULL
fastaIndex<-NULL
fileJSON<-fromJSON("/data/input/AppSession.json")
#fastaPath is fixed within container
fastaPath<-c("/Package_data/fasta")


if(file.exists("/data/scratch/")!=TRUE){
system("mkdir /data/scratch/")
}

if(file.exists("/data/output/")!=TRUE){
system("mkdir /data/output/")
    if(file.exists("/data/output/appresults")!=TRUE) {
     system("mkdir /data/output/appresults")
     }
}


fastqPath<-c("/data/input/samples") #source to be copied to scratch (fixed)
    if(file.exists("/data/scratch/downloads")!=TRUE){
system("mkdir /data/scratch/downloads")
    if(file.exists("/data/scratch/downloads/samples")!=TRUE){
    system("mkdir /data/scratch/downloads/samples")
   }
}#if mkdir /data/scratch/downloads

scratchPath<-c("/data/scratch/downloads/samples")
scratchFastaPath<-"/data/scratch/downloads/fastaUploads"

#parsing the AppSession.json from child

selectNames<-fileJSON$Properties$Items$Name
project_Id<-findChildProjectId(selectNames,fileJSON)
outputPath<-createChildOutputDirectory(selectNames,fileJSON) #create /scratch/samples and /scratch/fastUploads

#programmatic values for bootstrap
message("Parsing bootstrap values ... ")
bootstrapValue<-findBootStrapValue(selectNames,fileJSON)
message("found bootstrap value...")

kmer<-findkmerSize(selectNames,fileJSON)
#FIX ME- include the case where neither bias / PB are selected "FALSE" is input
biasPseudobam<-findbiasPseudobam(selectNames,fileJSON)
#find the children transcript inputs, same for all children
transcriptomes<-findChildTranscriptInput(selectNames,fileJSON)
message("checking if any fasta file was uploaded ... ")
allTranscriptomes<-createChildReference(selectNames,
                                           fileJSON,
                                           transcriptomes,
                                           fastaPath,
                                           scratchFastaPath)

#create child appSession for each child 
appSession<-createChildAppSession(selectNames,
                                  allTranscriptomes,
                                  outputPath=outputPath,
                                  scratchPath,
                                  fastqPath=fastqPath,
                                  fastaPath=fastaPath,
                                  bootstrapValue,
                                  kmer=kmer,
                                  biasPseudobam=biasPseudobam,
                                  fileJSON)

#need to run findDupes.R to identify and output the duplicate entries if custom was uploaded


#run kallisto
message("running quant ....")
results <- lapply(appSession$samples,
                    runKallisto,
                    indexName=appSession$indexName,
                    fastqPath=appSession$fastqPath,
                    fastaPath=appSession$fastaPath,
                    bootstraps=appSession$bootstraps,
                    outputPath=appSession$outputPath,
                    bias=appSession$bias,
                    pseudobam=appSession$pseudobam,
                    singleEnd=appSession$singleEnd,
                    lengthMean=appSession$lengthMean,
                    lengthDev=appSession$lengthDev,
                    extension=appSession$extension,
                    tarBall=TRUE)

message("done .... moving quantification files to appresults/SampleName...")

sampleNameDataFrame<-renameChildAppSessionID(selectNames,appSession,fileJSON)

message("done with quantification...next child node ... ")

message("creating output html report ...")
generateOutputReports(outputDir=appSession$outputPath,inputDir="/outputReport/")




} #{{{
