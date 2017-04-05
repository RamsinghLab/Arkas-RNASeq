#' this runs the workflow which calls the bash script
#' @export
runWorkFlow<-function() {
library(arkas)
library(TxDbLite)
library(speedSage)
library(arkasBasespace)
library(jsonlite)
library(RColorBrewer)
library(EDASeq)
library(gplots)
library(erccdashboard)
library(rmarkdown)

fileJSON<-fromJSON("/data/input/AppSession.json")

selectNames<-fileJSON$Properties$Items$Name

#create output directory structure.
project_Id<-findSingleNodeProjectId(selectNames,fileJSON)
outputPath<-createAppResultOutputDirectory(selectNames,fileJSON)

setwd(outputPath)
command<- paste0("/runScripts/runWorkFlow.sh" )
system(command)


}

