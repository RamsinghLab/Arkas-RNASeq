#' find the read type single end or paired end input from the basespace interface or imported from SRA, for single end reads the length mean is found from find the average length of the sequences using bash
#' @param selectNames    vector of input ids from basespace form
#' @param fileJSON       json file from basespace
#' @return endType   a flag singleEnd,with length stats, or paireEnd passed into appSession
#' @export
findreadendType<-function(selectNames,fileJSON){
print("Parsing the read type, single or paired user selection ...")

readType<-unlist(fileJSON$Properties$Items$Items[grepl("Input.*-sample-id.IsPairedEnd",selectNames)])

if(readType=="singleEnd") {
  #need mean of read length
  # std of read length
  # output a list
 fastqFile<-paste0("/data/scratch/downloads/samples/",list.files(path="/data/scratch/downloads/samples/",pattern=".fastq.gz",recursive=TRUE))
 Meancommand<-paste0("calculate-sequence-length-mean.sh ",fastqFile)
  Stdcommand<-paste0("std-length-distribution.sh ",fastqFile)

    meanLength<-as.numeric(system(Meancommand,intern=TRUE))
    sdLength<-as.numeric(system(Stdcommand,intern=TRUE))
  endType<-list(readType,meanLength,sdLength)
  names(endType)<-c("readType","meanLength","sdLength")
 }#single End

if(readType=="pairedEnd"){
 #output not a list
endType<-list(readType,0.01,0.01)
names(endType)<-c("readType","meanLength","sdLength")
 }#pairedEnd

print(paste0("found ",readType," input selection ..."))
return(endType)
}
