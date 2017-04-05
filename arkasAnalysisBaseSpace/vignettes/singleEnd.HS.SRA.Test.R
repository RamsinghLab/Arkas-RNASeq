#this tests single end reads and SRA imported formate
library(arkas)
library(TxDbLite)
library(arkasBasespace)
pathBase<-system.file("extdata",package="arkasBasespace")
n4<-system.file("extdata","32138120/",package="arkasBasespace")
s4<-system.file("extdata","32140203/",package="arkasBasespace")
system(paste0("cp -r ",n4,dir(n4)," /")) #copies the demo data to /data matching how basespace creates folder hierarchy
system("sudo chmod -R 777 /data")
processChildNode()
system("sudo rm -r /data")
system(paste0("cp -r ",s4,dir(s4)," /")) #copies the demo data to /data matching how basespace creates folder hierarchy
system("sudo chmod -R 777 /data")
processChildNode()

