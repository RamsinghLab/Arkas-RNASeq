#the docker container must first be built, the path directories in processChildNode are designed for the container.  this may not be ideal, but the tests will prevent uploading bad container files onto the dockerHub repository which is the main goal.

library(arkas)
library(TxDbLite)
library(arkasBasespace)
pathBase<-system.file("extdata",package="arkasBasespace")
n4<-system.file("extdata","32279248/",package="arkasBasespace")

system(paste0("cp -r ",n4,dir(n4)," /")) #copies the demo data to /data matching how basespace creates folder hierarchy
system("sudo chmod -R 777 /data")
processChildNode()
system("sudo rm -r /data")

