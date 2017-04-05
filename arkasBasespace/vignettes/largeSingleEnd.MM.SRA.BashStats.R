#this tests single end reads and SRA imported formate where the single End reads are very large, which uncovered an error using DNAStringSet, so know the single end stats are found from BASH. this also using a JSON with species-radio.
library(arkas)
library(TxDbLite)
library(arkasBasespace)
pathBase<-system.file("extdata",package="arkasBasespace")
n4<-system.file("extdata","large-SE-MM-bash-stats/",package="arkasBasespace")
system(paste0("cp -r ",n4,dir(n4)," /")) #copies the demo data to /data matching how basespace creates folder hierarchy
system("sudo chmod -R 777 /data")
processChildNode()
system("sudo rm -r /data")


