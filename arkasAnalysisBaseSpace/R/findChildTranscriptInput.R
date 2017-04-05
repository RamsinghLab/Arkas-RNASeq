#' finds the transcripts input by user for creating a transcriptome creates a hash table by storing things into the environment
#' @param selectNames    vector of input id's used for parsing the json file
#' @param fileJSON       json file from basespace
#' @import hash
#' @return transcriptomes   vector of transcriptomes
#' @export
findChildTranscriptInput<-function(selectNames,fileJSON){

transcriptInput<-fileJSON$Properties$Items$Items[which(selectNames=="Input.checkbox-transx")]
transcript<-unlist(strsplit(unlist(transcriptInput),",")) #vector with length equal to number of checkboxes check

#for child nodes the input is passed into a comma separated string , need to pass into a list of each entry



hash=new.env(hash=TRUE,parent=emptyenv(),size=100L)
transcriptomeValue<-list()
transcriptomeValue[[1]]<-"ERCC.fa.gz"
transcriptomeValue[2]<-"Homo_sapiens.GRCh38.84.cdna.all.fa.gz"
transcriptomeValue[[2]][2]<-"Homo_sapiens.GRCh38.84.ncrna.fa.gz"
transcriptomeValue[3]<-"Homo_sapiens.RepBase.21_03.merged.fa.gz"
transcriptomeValue[4]<-"Mus_musculus.GRCm38.84.cdna.all.fa.gz"
transcriptomeValue[[4]][2]<-"Mus_musculus.GRCm38.84.ncrna.fa.gz"
transcriptomeValue[5]<-"Mus_musculus.RepBase.21_03.merged.fa.gz"
#transcriptomeValue[[5]][2]<-"Mus_musculus.RepBase.v20_05.rodrep.fa.gz"
transcriptomeValue[6]<-"Drosophila_melanogaster.BDGP6.81.cdna.all.fa.gz"
transcriptomeValue[[6]][2]<-"Drosophila_melanogaster.BDGP6.81.ncrna.fa.gz"
transcriptomeValue[7]<-"Drosophila_melanogaster.v20_05.melansub.fa.gz"
transcriptomeValue[[7]][2]<-"Drosophila_melanogaster.v20_05.melrep.fa.gz"

transcriptomeKey<-  c("0",
                      "2",
                      "20",
                       "1",
                       "10",
                        "3",
                       "30"
                       )
hTrnx<-hash(transcriptomeKey,transcriptomeValue)

transcriptomes<-lapply(transcript,function(x) hTrnx[[x]])
message("Parsing completed for user selected transcriptomes. O.K. ")
return(unlist(transcriptomes))
}


