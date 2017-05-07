
if(!require("tm")) {
    install.packages("tm")
}
library(tm)

DATASET_DIR = "./Capstone_Dataset/"

totSize <- 0
totLines <- 0
totWords <- 0

cFiles = c("blogs", "news", "twitter")

sizeOf <- function(f) {
  nmFile = paste0("en_US/en_US.",f,".txt")
  arq <- paste(DATASET_DIR,nmFile,sep="")
  print(arq)
  file_size <- file.info(arq)$size / 1024 / 1024
  print(paste(sprintf("%5.1f",file_size),"Megabytes"))
  
  totSize <<- totSize + file_size
}

linesOf <- function(f) {
  nmFile = paste0("en_US/en_US.",f,".txt")
  arq <- paste(DATASET_DIR,nmFile,sep="")
  print(arq)
  len <- length(readLines(arq))
  print(paste(format(len,big.mark=" ",decimal.mark="."),"lines of text"))  
  
  totLines <<- totLines + len
}

wordsOf <- function(f) {
  nmFile = paste0("en_US/en_US.",f,".txt")
  arq <- paste(DATASET_DIR,nmFile,sep="")
  print(arq)
  x <- readLines(arq)
  nWords <- sum(stri_count(x, regex="\\S+"))
  print(paste(format(nWords,big.mark=" ",decimal.mark="."),"words in text"))  
  
  totWords <<- totWords + nWords
}

lapply(cFiles, function(f) sizeOf(f))

lapply(cFiles, function(f) linesOf(f))

lapply(cFiles, function(f) wordsOf(f))

print(paste("Total size is",sprintf("%5.1f",totSize,"Megabytes")))
print(paste("Total lines is",format(totLines,big.mark=" ",decimal.mark=".")))
print(paste("Total words is",format(totWords,big.mark=" ",decimal.mark=".")))
