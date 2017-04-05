library(arkas)
library(TxDbLite)
library(arkasBasespace)
pathBase<-system.file("extdata",package="arkasBasespace")
default1<-system.file("extdata","32133582/",package="arkasBasespace")
default2<-system.file("extdata","32133583/",package="arkasBasespace")
system(paste0("sudo cp -r ",default1,dir(default1)," /")) #copies the demo data to /data matching how basespace creates folder hierarchy
system("sudo chmod -R 777 /data")
processChildNode()
system("sudo rm -r /data")

system(paste0("sudo cp -r ",default2,dir(default2)," /")) #copies the demo data to /data matching how basespace creates folder hierarchy
system("sudo chmod -R 777 /data")
processChildNode()
system("sudo rm -r /data")

