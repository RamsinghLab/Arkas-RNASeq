#' find the read type single end or paired end input from the basespace interface or imported from SRA, for single end reads the length mean is found from find the average length of the sequences
#' @param selectNames    vector of input ids from basespace form
#' @param fileJSON       json file from basespace
#' @import Biostrings
#' @return endType   a flag singleEnd,with length stats, or paireEnd passed into appSession
#' @export
findreadendType<-function(selectNames,fileJSON){
message("Parsing the read type, single or paired user selection ...")

readType<-unlist(fileJSON$Properties$Items$Items[grepl("Input.*-sample-id.IsPairedEnd",selectNames)])

if(readType=="singleEnd") {
  #need mean of read length
  # std of read length
  # output a list
 fastqFile<-paste0("/data/scratch/downloads/samples/",list.files(path="/data/scratch/downloads/samples/",pattern=".fastq.gz",recursive=TRUE))

input<-readDNAStringSet(fastqFile,format="fastq")
meanLength<-mean(width(input))
sdLength<-sd(width(input))
    if(sdLength==0){
    sdLength<-0.001
    }
endType<-list(readType,meanLength,sdLength)
names(endType)<-c("readType","meanLength","sdLength")
 } #singleEnd

if(readType=="pairedEnd"){
 #output not a list
endType<-list(readType,0.01,0.01)
names(endType)<-c("readType","meanLength","sdLength")
 }#pairedEnd

message(paste0("found ",readType," input selection ..."))
return(endType)
}
