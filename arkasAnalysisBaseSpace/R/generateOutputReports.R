#' this runs generateOutputReports.Rmd triggered by a shell script to report the kallisto version used for quantifying transcripts
#' @param outputDir output directory to put the html file which should be the app Session output path
#' @param inputDir this is the input directory which contains the Rmd file for rendering
#' @importFrom rmarkdown render
#' @export
#' @return return an html
generateOutputReports<-function(outputDir=appSession$outputPath, inputDir="/outputReport/"){
#fix me: find system file
#pathtoBash<-system.file("bin", "generateOutput.sh", package="arkasBasespace")

rmarkdown::render(paste0(inputDir, "generateOutputResults.Rmd"), output_dir=outputDir)

}
