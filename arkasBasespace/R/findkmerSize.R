#' find the kmer size input from basespace user input
#' @param selectNames    vector of input ids used to parse the json file
#' @param fileJSON       json file from basespace
#' @return kmerSize      numeric number of the kmer user to index reference
#' @export

findkmerSize<-function(selectNames,fileJSON){
message("Parsing kmer index size ... ")
kmerSize<-unlist(fileJSON$Properties$Items$Items[which(selectNames=="Input.kmer-size")])
kmerSize<-as.numeric(unlist(kmerSize))
message("found kmer size input.")
return(kmerSize)
}




