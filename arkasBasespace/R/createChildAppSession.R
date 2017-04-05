#' appSession for multi node process, this creates a single appSession
#' @param selectNames   vector of name item content parsed from json
#' @param transcriptomes vector of transcriptomes
#' @param outputPath     string path to output
#' @param scratchPath    string path to scratch directory used
#' @param fastqPath      string path to fastqPath
#' @param bootstrapValue  string numeric value parsed by json
#' @param kmer            numeric kmer size used to reference
#' @param bias           boolean for bias correction during quant
#' @param pseudobam      boolean for pseudobam creation
#' @param fileJSON       file json from basespace
#' @import arkas
#' @return appSession    list of appSession for quantification
#' @export


createChildAppSession<-function(selectNames,
                                 transcriptomes=allTranscriptomes,
                                 outputPath=outputPath,
                                 scratchPath, 
                                 fastqPath=fastqPath,
                                 fastaPath=fastaPath,
                                 bootstrapValue,
                                 kmer=kmer,
                                 biasPseudobam=biasPseudobam,
                                 fileJSON=fileJSON,
                                 jsonSpecies=jsonSpecies){
#scratchPath is the path that must be copied to for BSFS defined earlier
#fastqPath is the path that is usually fixed "/data/input/samples" , but is read only for BSFS enabled defined earlier

appSession<-list()
appSession$fastaFiles<-transcriptomes
appSession$samples<-fileJSON$Properties$Items$Items[which(selectNames=="Input.Samples")][[1]]$Id #get sample Id from json
names(appSession$samples)<-appSession$samples
appSession$fastqPath<-scratchPath
appSession$bias<-biasPseudobam$bias
appSession$pseudobam<-biasPseudobam$pseudobam
amiSamples<-paste0(fastqPath,"/",appSession$samples)

filePath<-paste0(amiSamples,"/",list.files(path=amiSamples,pattern="*.fastq.gz$",recursive=TRUE)) #raw full file path
fullPath<-unique(dirname(filePath)) #SRR directory path
RawPath<-dir(fullPath) #raw SRR files
scratchDestination<-paste0(scratchPath,"/",appSession$samples) #scratch path to SampleID under scratch


command<-paste0("cp ",fullPath,"/* ",scratchDestination,"/") #copy only the contents of the original SRR directory path to scratch path
print(paste0("copying samples from ",fullPath," to ",scratchDestination," ..."))

   for(j in 1:length(scratchDestination)){
    if(file.exists(scratchDestination[j])!=TRUE) {
       message(paste0("creating scratch directory ",scratchDestination[j]))
       system(paste0("mkdir ",scratchDestination[j]))
      }
  }#{create sample dir in scratch
lapply(command,function(x) system(x))
print("done copying to scratch ... ")

appSession$fastaPath<-paste0(fastaPath,"/")
appSession$bootstraps<-bootstrapValue
appSession$outputPath<-paste0(outputPath)#appresults/project_id/sampleName/
stopifnot(all(lapply(transcriptomes,function(x) file.exists(paste0(fastaPath,"/",x)))=="TRUE"))

#add a check
stopifnot(all(appSession$samples %in% dir(scratchPath)[!grepl(".json",dir(scratchPath))])==TRUE)

#FIX ME : conditionally index if no fasta uploaded...
if(all(is.na(unlist(fileJSON$Properties$Items$Items[which(selectNames=="Input.app-result-id")])))==TRUE) {
print("Detected No user Fasta input...")
  if(jsonSpecies=="Mus.musculus"){
   appSession$indexName<-"ERCC_mergedWith_Mus_musculus.GRCm38.84.cdna.all_mergedWith_Mus_musculus.GRCm38.84.ncrna_mergedWith_Mus_musculus.RepBase.21_03.mergedkallisto.0.42.4.fa.kidx"  
   }
  if(jsonSpecies=="Homo.sapiens"){
   appSession$indexName<-"ERCC_mergedWith_Homo_sapiens.GRCh38.84.cdna.all_mergedWith_Homo_sapiens.GRCh38.84.ncrna_mergedWith_Homo_sapiens.RepBase.21_03.mergedkallisto.0.42.4.fa.kidx"
    }
}
#if(!any(is.na(unlist(fileJSON$Properties$Items$Items[which(selectNames=="Input.app-result-id")])))==TRUE) {
else {
print("transcriptome intput files exists, running index...")
appSession$indexName <- indexKallisto(fastaFiles=appSession$fastaFiles, fastaPath=appSession$fastaPath, kmer=kmer)$indexName
} #only running index if someone inputs a fasta


print("finding the raw file extension illumina standard naming convention...")

splitRaw<-strsplit(RawPath,"_")
appSession$extension<-paste0("_",unique(unlist(lapply(splitRaw,function(x) x[length(x)]))))

readType<-findreadendType(selectNames,fileJSON) 
#finding readType from scratch directory
if(readType$readType=="singleEnd"){
appSession$singleEnd<-"TRUE"
appSession$lengthMean=readType$meanLength
appSession$lengthDev=readType$sdLength
}

if(readType$readType=="pairedEnd"){
appSession$singleEnd<-"FALSE"
appSession$lengthMean=readType$meanLength
appSession$lengthDev=readType$sdLength
}


 print("completed appSession creation ... ")
 return(appSession)
}

