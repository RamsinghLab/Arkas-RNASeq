#' arkas analysis is Phase II for basespace cloud compting algorithm it uses a single node so arkasJSONparse.R will parse the single node JSON and prepare for the workflow. the appresults are downloaded into the /data/input/appresults directory, in which there will be 1 directory for each appResults selected by the user (fasta files, comparison, and control results). The custom fasta form id : app-result-id,  the control form id: control-app-id,  the comparison form id: comparison-app-id.  these id names should not change ,so the JSON parsing won't be affected by adding new fields to form-builder. 
#' @import arkas
#' @import jsonlite
#' @import biomaRt
#' @return returns a list of appSession with the correct elements for running arkas workflow in entirety
#' @export 
processAnalysisWorkflow<-function() {
appSession<-list()

#grab JSON file
fileJSON<-fromJSON("/data/input/AppSession.json")
fastaPath<-c("/Package_data/fasta")

if(file.exists("/data/scratch/")!=TRUE){
system("mkdir /data/scratch/")
}

if(file.exists("/data/output/")!=TRUE){
system("mkdir /data/output/")
    if(file.exists("/data/output/appresults")!=TRUE) {
     system("mkdir /data/output/appresults")
     }
}


fastqPath<-c("/data/input/samples") #source to be copied to scratch (fixed)
    if(file.exists("/data/scratch/downloads")!=TRUE){
system("mkdir /data/scratch/downloads")
    if(file.exists("/data/scratch/downloads/samples")!=TRUE){
    system("mkdir /data/scratch/downloads/samples")
   }
}#if mkdir /data/scratch/downloads


scratchPath<-c("/data/scratch/downloads/samples")
scratchFastaPath<-"/data/scratch/downloads/fastaUploads"

appinputPath<-"/data/input/appresults"

selectNames<-fileJSON$Properties$Items$Name
#for devel
source("/home/arcolombo/Documents/github_repos/Arkas-Analysis-BaseSpace/docker/arkasBasespace/R/findSingleNodeProjectId.R")
source("/home/arcolombo/Documents/github_repos/Arkas-Analysis-BaseSpace/docker/arkasBasespace/R/createAppResultOutputDirectory.R")
source("/home/arcolombo/Documents/github_repos/Arkas-Analysis-BaseSpace/docker/arkasBasespace/R/analysisAppSession.R")
source("/home/arcolombo/Documents/github_repos/Arkas-Analysis-BaseSpace/docker/arkasBasespace/R/createDesignMatrixFromAppSession.R")
source("/home/arcolombo/Documents/github_repos/Arkas-Analysis-BaseSpace/docker/arkasBasespace/R/erccAnalysis.R")

#create output directory structure.
project_Id<-findSingleNodeProjectId(selectNames,fileJSON)
#create /data/output/projectID/Results and scratch directories
outputPath<-createAppResultOutputDirectory(selectNames,fileJSON) 
#creates /data/output/appresults/22431410/results AnnotatedKexp , ercc-Analysis ,transcript-wise-Analysis, enrichment-Analysis , gene-wise-Analysis

#Parse the species from radio buttons. 1 for mouse 2 human
#call it jsonSpecies


#create appSession
#copy to scratch
comparisonAppResultId<-fileJSON$Properties$Items$Items[[which(selectNames=="Input.comparison-app-id")]]$Id
controlAppResultId<-fileJSON$Properties$Items$Items[[which(selectNames=="Input.control-app-id")]]$Id

#find the transcript id
transcriptId<-fileJSON$Properties$Items$Items[[which(selectNames=="Input.app-result-id")]]$Id

#copy all sample files to /data/scratch/downloads/samples
appSession<-analysisAppSession(selectNames,scratchFastaPath,transcriptId,outputPath,scratchPath,appinputPath,comparisonAppResultId,controlAppResultId)  #creates appSession with cmparison samples names, and control samples names, while copying all appResults to /data/scratch  and the list includes the fasta transcriptomes for downstream TxDblite package creation



if(length(appSession)==0) {
message("I detected either empty comparison samples ,or empty control samples...please re-upload comparison samples *and* control samples... stopping..")
}

stopifnot(length(appSession)>0)


#TxDbLite, validate transcripts or build libraries
defaultFastaPath<-"/Package_data/fasta/"
defaultFastas<-dir(defaultFastaPath)[grepl("*.fa.gz",dir(defaultFastaPath))]

uniqTranscript<-appSession$fastaUploads[!(appSession$fastaUploads %in% defaultFastas)]
#FIX ME: name check , support Ensembl / RepBase, and run TxDbLite on supported fastas. but why support older versions of Ensembl/ Repbase.  better to support tRNA and mito transcripts


#Merge Kallisto
merged<-mergeKallisto(c(appSession$comparisonSamples,appSession$controlSamples)
                         ,outputPath=appSession$sampleDirPath)



# found then build TxDbLite Annotation Library
message("the kallisto data found transcriptome libraries given as:")
transcriptomes(merged)


#Annotate Kexp
annotatedKexp<-annotateFeatures(merged,"transcript")
message("saving annotated Kexp to output directory")
save(annotatedKexp,file=paste0(appSession$annotatedKexp_outputPath,"/annotatedKexp.RData"))

#create Design Matrix
#FIX ME: add txt upload design matrices
message("creating two group comparison design matrix.")
design<-createDesignMatrixFromAppSession(appSession)
metadata(annotatedKexp)$design<-design

#Find ERCCs, if ERCCs found run Ercc analysis
message("detecting erccs..")
erccs<- counts(annotatedKexp)[grepl("^ERCC",rownames(counts(annotatedKexp))),]


if(nrow(erccs) >0) {
message("successfully detected erccs, checking if any erccs were counted greater than 0..")
    #detect if any erccs have counts > 0
    if( any(rowSums(erccs) >0) ) {
      message("detected ERCC counts, running ercc analysisi...")
    #run ercc analysis
     erccResults<-erccAnalysis(annotatedKexp,appSession)       
     #for html output printing, must show all the erccResults$Figures 
     erccResults$Figures[1]
     erccResults$Figures[2] 
     erccResults$Figures[3]
     erccResults$Figures[4]
     erccResults$Figures[5]
     erccResults$Figures[6]
     erccResults$Figures[7]

    #run RUV normalizaiton with ercc spikes is 
     message("using ercc spike ins to remove unwanted variance...")
     if(ncol(annotatedKexp)>6) {
     message("calculating normalization tuning parameter...") 
    tuningParam<-round(ncol(annotatedKexp)/6)
     } 
    if(ncol(annotatedKexp)<=6) {
    tuningParam<-1
    }
    ruvResults<-ruvNormalization(annotatedKexp,k=tuningParam,spikeIns=TRUE,p.cutoff=1,byLevel="gene_id")
       ruvResults$W
      message("saving normalized counts to output")
      write.csv(ruvResults$normalizedCounts,file=paste0(appSession$ercc_outputPath,"/ruvERCCNormalizedCounts.csv"),row.names=TRUE)
      head(ruvResults$normalizedCounts,50)
       message("done with normalization data")
      } #detected ercc counts
} #found erccs 



#Run RUV normalization for inSilico case
   if( nrow(erccs)==0 ||   !any(rowSums(erccs)>0) ) {
  #if no erccs detected,  or if no erccs have counts greater than 0,  run ruv with inSilico detection
    message("removing unwanted variance using in silico controls, not using ercc spike in counts...")
      if(ncol(annotatedKexp)>6) {
     message("calculating normalization tuning parameter...")
     tuningParam<-round(ncol(annotatedKexp)/6)
       }
     if(ncol(annotatedKexp)<=6) {
      tuningParam<-1
      }
   
    ruvResults<-ruvNormalization(annotatedKexp,k=tuningParam,spikeIns=FALSE,p.cutoff=1,inSilico=NULL,normalized.cutoff=1,byLevel="gene_id")
     print(ruvResults$W)
     write.csv(ruvResults$normalizedCounts,file=paste0(appSession$ercc_outputPath,"/ruvInSilicoNormalizedCounts.csv"),row.names=TRUE)
   message("done with inSilico normalization")
    } #no erccs 

#heatmap ruvResults
gnCnts<-collapseBundles(annotatedKexp,"gene_id")
idx<-which(colnames(gnCnts)==appSession$comparisonSamples)
colnames(gnCnts)[idx]<-"Trt_0"

idx2<-which(colnames(gnCnts)==appSession$controlSamples)
colnames(gnCnts)[idx2]<-"Ctrl_1"



#Run GWA , support Advaita, need gene names and gene titles
GWA<-geneWiseAnalysis(annotatedKexp,design=design,
                       how="cpm",
                       p.cutoff=0.05,
                       fold.cutoff=1,
                       read.cutoff=1,
                       species=jsonSpecies,
                        fitOnly="FALSE")

#prepare for advaita output

limmad<-as.data.frame(GWA$limmaWithMeta)
advaita<-cbind(rownames(limmad),
                limmad[,5],
                limmad[,4],
                limmad[,3],
                limmad[,6],
                limmad[,1],
                as.character(limmad[,8]),
                as.character(limmad[,10]))

colnames(advaita)<-c("ID","adj.P.Val","P.Value","t","B","logFC","Gene.symbol","Gene.title")


#save output
write.table(advaita,file=paste0(appSession$gwa_outputPath,"/geneWiseAnalysis.advaita.txt"),quote=FALSE,row.names=FALSE,col.names=TRUE)
#print topTable
print(GWA$top[1:50,])
message("completed gene wise analysis, saved the advaita compatible output of differentially expressed genes")

# Run TWA
TWA<-transcriptWiseAnalysis(annotatedKexp,design,p.cutoff=0.05,fold.cutoff=1,coef=2,read.cutoff=1)
 #save output
write.table(TWA$top,file=paste0(appSession$twa_outputPath,"/transcriptWiseAnalysis.txt"),quote=FALSE,row.names=FALSE,col.names=TRUE)

#print topTable
print(TWA$top[1:50,])


#Run enrichment analysis
message("completed transcript level Diff.Expr Analysis, running enrichment reactome set analysis ...")

#transcript level

trnxMap<-mapToReactome(rownames(annotatedKexp),
                       type="transcript",
                       species=jsonSpecies,
                       build=84)

rSets<-reactomeSets(species=jsonSpecies,type="transcript",mappedReactome=trnxMap)

message("found reactome gene set for transcript level, transforming expression to log base 2 ")
print(rSets)

message("filtering transcripts which the row sum is 0 across all samples...")
idx<-which(rowSums(counts(annotatedKexp))>0)

filteredTrnx<-counts(annotatedKexp)[idx,]

tL<-log2(filteredTrnx+0.001)

if(any(is.infinite(tL))==TRUE) {
message("I detected infinite values...")
}

idx<-which(colnames(tL)==appSession$comparisonSamples)
colnames(tL)[idx]<-"compare_0"

idx2<-which(colnames(tL)==appSession$controlSamples)
colnames(tL)[idx2]<-"cntrol_1"

#running speedSage
tx.Results<-qusageArm(tL,
                      colnames(tL),
                      "compare_0-cntrol_1", 
                       rSets,
                       var.equal=FALSE,
                       n.points=2^12)
  
#print reactome plots
message(paste0("pathway activity statistics for ",numPathways(tx.Results), " activated pathways"))
summary(tx.Results)
p.vals<-pdf.pVal(tx.Results)
print(p.Vals)
plot(tx.Results,xlab="Transcript Set Activation")
q.vals<-p.adjust(p.vals,method="fdr")
message("the fdr adjusted p.vals of each transcript set is:")
tx.Stats<-data.frame(names(tx.Results$pathways),q.vals)
print(tx.Stats)

qsTable(tx.Results,number=numPathways(tx.Results))

if(numPathways(tx.Results) <=10) {
message("plotting confidence intervals of pathways")
plotCIs(tx.Results)
}

if(numPathways(tx.Results)>10) {
message(paste0("plotting ",numPathways(tx.Results), " detected pathways"))
plot(tx.Results)
}

#plot URL
message("printing Reactome Urls for exploration...")
tx.Url<- getReactomeUrl(summary(tx.Results)[,1])
tx.DF<-data.frame(summary(tx.Results),tx.Url)

print(tx.DF)
#save output

write.table(tx.DF,file=paste0(appSession$enrich_outputPath,"/transcript-enrichment.txt"),quote=FALSE,row.names=FALSE,col.names=TRUE,sep="\t")
save(tx.Results,file=paste0(appSession$enrich_outputPath,"/tx.Results.RData"))


#
#save results


message("done with transcript level enrichment.\n")
#gene level

message("starting gene level enrichment.\n") 
coll<-collapseBundles(annotatedKexp,"gene_id")

gnMap<-mapToReactome(rownames(coll),
                       type="gene",
                       species=jsonSpecies,
                       build=84)

grSets<-reactomeSets(species=jsonSpecies,type="gene",mappedReactome=gnMap)

message("found reactome gene set for gene level, transforming expression to log base 2 ")
print(grSets)

message("filtering transcripts which the row sum is 0 across all samples...")

gidx<-which(rowSums(coll)>0)

filteredGn<-coll[gidx,]

message("transforming the data to log2 counts...")
gtL<-log2(filteredGn+0.001)

if(any(is.infinite(gtL))==TRUE) {
message("I detected infinite values...")
}

gIdx<-which(colnames(gtL)==appSession$comparisonSamples)
colnames(gtL)[gIdx]<-"compare_0"

gIdx2<-which(colnames(gtL)==appSession$controlSamples)
colnames(gtL)[gIdx2]<-"cntrol_1"




gn.Results<-qusageArm(gtL,
                      colnames(tL),
                      "compare_0-cntrol_1",
                       grSets,
                       var.equal=FALSE,
                       n.points=2^12)



#plot results 
message(paste0("pathway activity statistics for ",numPathways(gn.Results), " activated pathways"))
summary(gn.Results)
p.vals<-pdf.pVal(gn.Results)
print(p.Vals)
plot(gn.Results,xlab="Gene Set Activation")
q.vals<-p.adjust(p.vals,method="fdr")
message("the fdr adjusted p.vals of each gene set is:")
gn.Stats<-data.frame(names(gn.Results$pathways),q.vals)
print(gn.Stats)

qsTable(gn.Results,number=numPathways(gn.Results))

if(numPathways(gn.Results) <=10) {
message("plotting confidence intervals of pathways")
plotCIs(gn.Results)
}

if(numPathways(gn.Results)>10) {
message(paste0("plotting ",numPathways(gn.Results), " detected pathways"))
plot(gn.Results)
}



#plot URLs
message("printing Reactome Urls for exploration...")
gn.Url<- getReactomeUrl(summary(gn.Results)[,1])
gn.DF<-data.frame(summary(gn.Results),gn.Url)

print(gn.DF)
#save output

write.table(gn.DF,file=paste0(appSession$enrich_outputPath,"/gene-enrichment.txt"),quote=FALSE,row.names=FALSE,col.names=TRUE,sep="\t")
save(gn.Results,file=paste0(appSession$enrich_outputPath,"/gn.Results.RData"))





} #{{{ main
