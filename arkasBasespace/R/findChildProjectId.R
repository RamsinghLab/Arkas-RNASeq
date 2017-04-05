#' finds the project ID from the input basespace, required for uploading back
#' @param selectNames     vector of strings of input ids from basespace
#' @param fileJSON        json file used to parse
#' @return projectID      string numeric of project id used for uploading back to baseSpace
#' @export

findChildProjectId<-function(selectNames,fileJSON){
message("finding project Id for child node ... ")
projectID<-fileJSON$Properties$Items$Content[which(selectNames=="Input.project-id")]
projectID<-(unlist(projectID))
message("found...")
return(projectID)
}

