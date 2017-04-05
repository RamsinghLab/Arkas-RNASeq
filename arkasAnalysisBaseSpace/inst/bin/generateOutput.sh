#!/bin/bash

#this renders the html to be picked up by iframe

Rscript -e 'library(rmarkdown);render("/outputReport/generateOutputResults.Rmd",)'
