library(arkas)
library(TxDbLite)
library(speedSage)
library(arkasBasespace)
library(arkasAnalysisBaseSpace)
library(jsonlite)
library(RColorBrewer)
library(EDASeq)
library(gplots)
library(Rccdashboard)
library(rmarkdown)

appSession<-list()
#grab JSON file
fileJSON<-fromJSON("/data/input/AppSession.json")
fastaPath<-c("/Package_data/fasta")

#prepare folder hierarchy
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

appinputPath<-"/data/input/appresults"

selectNames<-fileJSON$Properties$Items$Name

#create output directory structure.
project_Id<-findSingleNodeProjectId(selectNames,fileJSON)
#create /data/output/projectID/Results and scratch directories
outputPath<-createAppResultOutputDirectory(selectNames,fileJSON)
#creates /data/output/appresults/22431410/Results AnnotatedKexp , ercc-Analysis ,transcript-wise-Analysis, enrichment-Analysis , gene-wise-Analysis

render("/outputReport/processAnalysisWorkFlow.Rmd",output_dir=outputPath)

