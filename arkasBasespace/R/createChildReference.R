#' create a reference and copy files to scratch directory
#' @param selectNames    vector of list of items from JSON
#' @param fileJSON       list of json elements parsed by jsonlite
#' @param transcriptomes vector of input transcriptomes default or manual
#' @param fastaPath      string path to fasta path
#' @param scratchFastaPath string to path to scratch directory
#' @return  transcriptomes list of transcriptomes input for quantification
#' @export

createChildReference<-function(selectNames,fileJSON,transcriptomes,fastaPath,scratchFastaPath){
#fastaPath is set earlier, /Package_data/fasta  in docker container
#scratchPath defined earlier

#the checkbox is mandatory, and if the user doesn't wish to use any defaults, it is advised to select ERCC only.

#scratchFastaPath = /data/scratch/downloads/fastaUploads
fastaUpload<-fileJSON$Properties$Items$Items[which(selectNames=="Input.app-result-id")]
#by defaul Input.AppResult and the Input.app-result-id should have "NA" if no fasta file was selcted
fastaResult<-fileJSON$Properties$Items$Items[which(selectNames=="Input.AppResults")]
if( (fastaUpload =="NA") || (fastaResult=="NA") ) {
 #no fasta uploaded, use checkbox input only
 message("no fasta files were uploaded ... continuing ...")
  return(transcriptomes)
} # no fasta uploaded

if( (fastaUpload !="NA") || (fastaResult!="NA") ) {
    #grab the checkbox and merge
   fastaId<-fastaUpload[[1]]$Id
   fastaSession<-fastaUpload[[1]]$AppSession$Id
 message(paste0("fasta file found ID: ", fastaId, " Session: ",fastaSession))
  customPath<-paste0("/data/input/appresults/",fastaId)  
  fastaFile<-dir(customPath) #currently only support a single fasta file uploaded
   message("copying ", fastaFile," to ", scratchFastaPath)
   command<-paste0("cp -ra ",customPath,"/",fastaFile, " ",scratchFastaPath,"/")
  lapply(command,function(x) system(x)) #cp fastaFile vector to /data/scratch/downloads/fastaUpload
 message("done copying... compressing ... ")
 gzipCommand<-paste0("gzip ",scratchFastaPath,"/",fastaFile) 
   lapply(gzipCommand,function(x) system(x))  #gzip uploadedFasta file vectors
 fastaFile<-paste0(fastaFile,".gz") 
 message(paste0("done ... moving ", fastaFile," to ", fastaPath))
 
  mvCommand<-paste0("mv ", scratchFastaPath,"/",fastaFile, " ", fastaPath)
    lapply(mvCommand,function(x) system(x)) #moving fasta file to /Package_fasta/
  transcriptomes<-c(transcriptomes,fastaFile)

} #if fasta was uploaded

return(transcriptomes)

}#main {{{
