#' arkas analysis is Phase II for basespace cloud compting algorithm it uses a single node so creating an appSession will parse the single node JSON and prepare for the workflow. the appresults are downloaded into the /data/input/appresults directory, in which there will be 1 directory for each appResults selected by the user (fasta files, comparison, and control results). The custom fasta form id : app-result-id,  the control form id: control-app-id,  the comparison form id: comparison-app-id.  these id names should not change ,so the JSON parsing won't be affected by adding new fields to form-builder. This script will take everything from /data/input/appresults and copy it to /data/scratch/samples and all the fastas to /data/scratch/fastaUpload, while outputting a appSession list with comparison names, paths, and transcriptomes input.  this is the most import part of the phase II. 
#' @param selectNames  string of names of item contents from JSON
#' @param scratchFastaPath  scratch path to copy appResult fastas to scratch
#' @param transcriptomeId  vector of transcriptomes, custom fasta uploaded
#' @param outputPath      string pathfor output to /data/output/appresults/projid/results
#' @param scratchPath     string path name for scratch path for samples
#' @param sampleDir       string path name for raw kallisto output sample Dir
#' @param inputPath       string path pointing to /data/input/appresulsts
#' @import arkas
#' @import jsonlite
#' @import biomaRt
#' @return returns a list of appSession with the correct elements for running arkas workflow in entirety, holds fasta path, fastas, sampleDir, sample-path, and outputPath. this is the central object for the entire workflow.
#' @export 
analysisAppSession<-function(selectNames,scratchFastaPath,transcriptId,outputPath,scratchPath,appinputPath, comparisonAppResultId, controlAppResultId) {

#copy all the /data/input/appresults/ comparisonId, and controlId and fasta to /data/scratch/downloads/samples,  and fasta to /data/scratch/downloads/fastaUpload

sampleList<-list()

#copy input samples to scratch
comparison<-paste0(appinputPath,"/",comparisonAppResultId,"/")
control<-paste0(appinputPath,"/",controlAppResultId,"/")

if(transcriptId!="NOINPUT"){
transcripts<-paste0(appinputPath,"/",transcriptId,"/")
}

comparisonSamples<-lapply(comparison,function(x) paste0(x,"/",dir(x)[!grepl("html",dir(x))] ))
if(length(comparisonSamples) ==0 ) {
 print("I did not detect any input comparison samples, this will cause errors...stopping..")  
   }
 stopifnot(length(comparisonSamples)>0) 
#print("detected comparison samples.")
#take basename of the app-result-ID folder of the tar.gz file, mkdir in scratch, untar in this directory. creates /data/scratch/downloads/samples/SAMPLENAME/SAMPLEID/####kallisto-oout####
srCompare<-lapply(comparison,function(x) dir(x)[grepl(".tar.gz",dir(x))])
srCommand<-paste0("mkdir /data/scratch/downloads/samples/",sub(".tar.gz","",srCompare))
lapply(srCommand,function(x) system(x))
srCompareFull<-lapply(comparison,function(x) paste0(x,"/",dir(x)[grepl(".tar.gz",dir(x))]))
untarCompare<-lapply(srCompareFull,function(x) untar(x,exdir=paste0("/data/scratch/downloads/samples/",sub(".tar.gz","",basename(x)))))
srTest<-lapply(srCompareFull,function(x) paste0("/data/scratch/downloads/samples/",sub(".tar.gz","",basename(x))))
scratchComparePath<-lapply(srTest,function(x) paste0(x,"/",dir(x),"/"))
###correcting the apID contents move into Name contents occurred from untar command
cmp.mv.command<-paste0("mv ",scratchComparePath,"* ",srTest,"/")
lapply(cmp.mv.command,system)
cmp.rm.command<-paste0("rm -r ",scratchComparePath)
lapply(cmp.rm.command,system)
##

controlSamples<-lapply(control,function(x) paste0(x,"/",dir(x)[!grepl("html",dir(x))]))
if(length(controlSamples) ==0 ) {
 message("I did not detect any input control samples, this will cause errors...stopping..")
   }
 stopifnot(length(controlSamples)>0)
##same for control
crControl<-lapply(control,function(x) dir(x)[grepl(".tar.gz",dir(x))])
crCommand<-paste0("mkdir /data/scratch/downloads/samples/",sub(".tar.gz","",crControl))
lapply(crCommand,function(x) system(x))
crControlFull<-lapply(control,function(x) paste0(x,"/",dir(x)[grepl(".tar.gz",dir(x))]))
untarControl<-lapply(crControlFull,function(x) untar(x,exdir=paste0("/data/scratch/downloads/samples/",sub(".tar.gz","",basename(x)))))

crTest<-lapply(crControlFull,function(x) paste0("/data/scratch/downloads/samples/",sub(".tar.gz","",basename(x))))
scratchControlPath<-lapply(crTest,function(x) paste0(x,"/",dir(x),"/"))
### move the contents of the ID into Name and remove ID folder.
mv.command<-paste0("mv ",scratchControlPath,"* ",crTest,"/")
lapply(mv.command,system)
rm.command<-paste0("rm -r ",scratchControlPath)
lapply(rm.command,system)

###

if(transcriptId!="NOINPUT"){
transcriptUploads<-lapply(transcripts,function(x) paste0(x,"/",dir(x)[grepl(".fa",dir(x))]))
}

#comparisonNames<-lapply(comparison,function(x) dir(x)[!grepl("html",dir(x))] )
#controlNames<-lapply(control,function(x) dir(x)[!grepl("html",dir(x))])

comparisonNames<-lapply(srCompare,function(x) sub(".tar.gz","",x))
controlNames<-lapply(crControl,function(x) sub(".tar.gz","",x))
if(transcriptId!="NOINPUT"){
transcriptNames<-lapply(transcripts,function(x) dir(x))
}

#untard into /scratch do not need to copy
#command1<-lapply(comparisonSamples,function(x) paste0("cp -r ",x," ",scratchPath))
#command2<-lapply(controlSamples,function(x) paste0("cp -r ",x," ",scratchPath))

if(transcriptId!="NOINPUT"){
command3<-lapply(transcriptUploads,function(x) paste0("cp -r ",x," ", scratchFastaPath))
}


#lapply(command1,function(x) system(x))
#lapply(command2,function(x) system(x))

if(transcriptId!="NOINPUT") {
    if(length(unlist(transcriptUploads)) >0) {
    sapply(unlist(command3),function(x) system(x))
    message("copying fasta uploads to scratch.")
    }
 }
#print("done copying to scratch path")

#create the appSession for output

if(transcriptId=="NOINPUT") {
transcriptNames<-list("NOTINPUT")
sampleList$fastaUploads<-unlist(transcriptNames)
}

sampleList$comparisonSamples<-unlist(comparisonNames)
sampleList$controlSamples<-unlist(controlNames)
#because we are using unique output directories of sampleName, when we unTar, it untars under sampleName/sampleID/*****stuff**** so we alter the sampleNames to include this hierarchy in appSession for merging.

sampleList$sampleDirPath<-scratchPath

if(transcriptId!="NOINPUT"){
    if(length(unlist(transcriptUploads))>0) {
    sampleList$fastaUploads<-unlist(transcriptNames)
    }
}
sampleList$fastaPath<-scratchFastaPath
sampleList$twa_outputPath<-paste(outputPath,"transcript-wise-Analysis",sep="/")
sampleList$gwa_outputPath<-paste(outputPath,"gene-wise-Analysis",sep="/")
sampleList$annotatedKexp_outputPath<-paste(outputPath,"AnnotatedKexp",sep="/")
sampleList$ercc_outputPath<-paste(outputPath,"ercc-Analysis",sep="/")
sampleList$enrich_outputPath<-paste(outputPath,"enrichment-Analysis",sep="/")



return(sampleList)
} #{{{ main 

