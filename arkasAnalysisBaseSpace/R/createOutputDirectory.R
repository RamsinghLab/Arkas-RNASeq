#' create output directory for single node computations
#' @param selectNames    vector of input id's from basespace input form
#' @return outputPath    string of basespace output directory for uploading
#' @export

createOutputDirectory<-function(selectNames) {
message("finding project ID ... ")
project_Id<-fileJSON$Properties$Items$Content[[which(selectNames=="Input.project-id")]][1]$Id
outputpath<-c("/data/output/appresults")
outputPath<-paste(outputpath,project_Id,sep="/")
message("creating /data/output/appresults/project-id directory")
dir.create(outputPath)
#results directory under project Id
outputPath_results<-paste(outputPath,"Results",sep="/")
message("creating /data/output/appresults/project-id/Results directory")
dir.create(outputPath_results)
#output path for R workspace
outputPath_Rworkspace<-paste(outputPath,"Results/Rworkspace",sep="/")
dir.create(outputPath_Rworkspace)

#The abundance output is set by createAppSession (Not sure to keep)
outputPath_samples<-paste(outputPath,"Results/abundance",sep="/")
dir.create(outputPath_samples)

#output path for Plots
outputPath_plots<-paste(outputPath,"Results/plots",sep="/")
dir.create(outputPath_plots)
#output path for csv from limma gene wise analysis
outputPath_csv<-paste(outputPath,"Results/expressionCSV",sep="/")
dir.create(outputPath_csv)
sampleCompareNames<-fileJSON$Properties$Items$Items[[which(selectNames=="Input.comparison-sample-id")]]$Name
outputPath_sampleCompareNames<-paste(outputPath_results,sampleCompareNames,sep="/")
lapply(outputPath_sampleCompareNames,dir.create)
sampleControlNames<-fileJSON$Properties$Items$Items[[which(selectNames=="Input.control-sample-id")]]$Name
outputPath_sampleControlNames<-paste(outputPath_results,sampleControlNames,sep="/")
lapply(outputPath_sampleControlNames,dir.create)
message("finished creating output sub-directories")
#programmatic values for bootstrap
return(outputPath)
}



