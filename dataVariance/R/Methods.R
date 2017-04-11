#new generics for KallistoDifference Eobjectperiments
setGeneric("SetTxDbLiteMetaClass", function(object) standardGeneric("SetTxDbLiteMetaClass"))


#'
#'
#' Sets meta columns type to match TxDbLite classes
#'@import GenomicRanges
#'@export
setMethod("SetTxDbLiteMetaClass",signature="KallistoExperiment",
function(object){
class(mcols(object)$tx_length)<-"integer"
class(mcols(object)$gc_content)<-"numeric"
 class(mcols(object)$tx_id)<-"character"
 class(mcols(object)$gene_id)<-"character"
 class(mcols(object)$gene_name)<-"character"
class(mcols(object)$entrezid)<-"character"
 class(mcols(object)$tx_biotype)<-"character"
 class(mcols(object)$gene_biotype)<-"character"
class(mcols(object)$biotype_class)<-"character"
 return(object)

})
