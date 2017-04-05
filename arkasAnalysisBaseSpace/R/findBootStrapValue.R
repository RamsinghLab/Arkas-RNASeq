#' finds the bootstrap value input by user on the basespace app
#' @param selectNames    vector of strings name ids input by user
#' @param fileJSON        json file parsed from basespace
#' @return bootstrapValue  string numeric for bootstrap 
#' @export

findBootStrapValue<-function(selectNames,fileJSON){
message("Parsing bootstrap values ... ")
bootstrapValue<-fileJSON$Properties$Items$Content[which(selectNames=="Input.bootstrap-sampling")]
bootstrapValue<-as.numeric(unlist(bootstrapValue))
return(bootstrapValue)
}




