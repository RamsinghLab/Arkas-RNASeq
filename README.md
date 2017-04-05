# Arkas BaseSpace Application
the arkasBasespace library parses the single node json, handling multi-custom fasta upload appresults, multi control appResults, and multi comparisons appResults.

#arkasBasespace
arkasBasespace in the analysis function will contain more scripts not related to quantifying on the cloud , but analyzing on the cloud,  this arkasBasespace R package is a superset, and should be the final R package for cloud computing.

#Docker Container
this Dockerfile currently builds arcolombo/arkasanalysis:v2 FROM arcolombo/arkasgithublayer:v1

#steps for revising this package.
If you need to revise parts of the package, edit the libraries in this directory and rebuild arcolombo/arkasanalysisbasespace:v1. this builds ontop of githublayers. so you don't need to re-install R packages or enviroment package dependencies.  only need to edit and re-install the last layer specific to arkas. 

#updating the transcriptomes needs documentation
add steps on maintaining here.
