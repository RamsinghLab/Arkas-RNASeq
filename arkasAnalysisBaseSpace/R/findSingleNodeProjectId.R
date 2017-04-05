#' finds the project ID from the input basespace, required for uploading back, this is for single node
#' @param selectNames     vector of strings of input ids from basespace
#' @param fileJSON        json file used to parse
#' @return projectID      string numeric of project id used for uploading back to baseSpace
#' @export

findSingleNodeProjectId<-function(selectNames,fileJSON){
message("Finding project Id for single node ... ")
projectID<-fileJSON$Properties$Items$Content[[which(selectNames=="Input.project-id")]]$Id
projectID<-(unlist(projectID))
message("Found...")
return(projectID)
}

