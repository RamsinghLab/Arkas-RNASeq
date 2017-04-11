# Arkas BaseSpace Application
the arkasBasespace library parses the single node json, handling multi-custom fasta upload appresults, multi control appResults, and multi comparisons appResults.

# RLibraries
Contains the annotation libraries for Homo-sapiens and Mus-musculus ENSEMBL build 84 and ERCC libraries.

# TxDbLite
Annotation software for obtaining annotation libraries.

# arkas
Quantification software which encapsulates and processes Kallisto h5 data.

# arkasAnalysisBaseSpace
these are the scripts which process user input JSON files collected during the web-cloud application input selections for Arkas-Quantification/Analysis cloud apps found on Illmina's basespace platform.

# arkasBasespace
arkasBasespace in the analysis function will contain more scripts not related to quantifying on the cloud , but analyzing on the cloud,  this arkasBasespace R package is a superset, and should be the final R package for cloud computing.

# outputReport
These are the markdown files which run the analysis pipelines to generate the HTML output file and subsequent analysis files.

# runScripts
Similar to outputReport files, but called from the command line using /bin


# steps for revising this package.
If you need to revise parts of the package, edit the libraries in this directory and rebuild arcolombo/arkasanalysisbasespace:v6. this builds ontop of githublayers. so you don't need to re-install R packages or enviroment package dependencies.  only need to edit and re-install the last layer specific to arkas. 

# updating the transcriptomes needs documentation
add steps on maintaining here. (devel use only)

# License Info
These packages are Licensed by MIT license
Copyright 2017 COPYWRIGHT Arkas, Anthony Colombo

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
