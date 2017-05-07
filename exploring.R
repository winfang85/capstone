
DATASET_DIR = "./Capstone_Dataset/"
SAMPLE_DIR  = "./Samples/"
SAMPLE_CLEAN  = "sample_clean.txt"

cFiles <- c("news","twitter","blogs")

source("plotting.R")
source("removeFeatures.R")

#-- packages required --#

if(!require("tm")) {
    install.packages("tm")
}
if(!require("quanteda")) {
    install.packages("quanteda")
}

library(tm)			# https://cran.r-project.org/web/packages/tm/index.html
library(quanteda)		# http://pnulty.github.io/

#-- auxiliary functions --#

objRDS <- function(f) {
  return( readRDS(paste0(f, ".rds")) )
}

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

gc(TRUE)	# garbage collector

startTime <- Sys.time()

# generate 3 txt files with corpora sampling from "Swift Key Dataset", in case of not exists

if(!file.exists(SAMPLE_DIR)) {
  dir.create(SAMPLE_DIR)
  lapply(cFiles, 
    function(i) {
      write.table(objRDS(i), paste0(SAMPLE_DIR,i,".txt"), sep="\t", col.names=FALSE, quote=FALSE, row.names=FALSE, append=TRUE) }
  )
}  
print(paste("Directory",SAMPLE_DIR,"Corpus' created with 3 sample text files."))

# create a primary Corpus using "tm" package that contains all sample texts (as Source) to be cleaned
# (because cleaning functions for "quanteda' package aren't working fine...)

# generate a clean txt file with corpora sampling , in case of not exists

if(!file.exists(SAMPLE_CLEAN)) 
{
  cp <- Corpus(DirSource(SAMPLE_DIR), readerControl = list(language="lat"))
  print("Corpus object's created.")

  #cp <- removeTweetFeatures(cp)
  cp <- removeOtherFeatures(cp, numbers=TRUE, punctuation=FALSE, spaces=TRUE, stopwords=TRUE)
  
  # and now, rewrite these data to another file representing sample Corpora already clean up
  dfClean <- data.frame(text=unlist(sapply(cp, `[`, "content")), stringsAsFactors=F) 
  write.table(dfClean, SAMPLE_CLEAN, col.names=FALSE, quote=FALSE, row.names=FALSE, append=TRUE)
  
  print(paste(SAMPLE_CLEAN,"is generated"))

  # plotting a word cloud graph
  plot_word_cloud(cp)
  print("Word cloud graph has been successfully saved.")
  rm(cp)	# (release memory)
}

# this 'sample clean text file' could be a source to "corpus" method in "quanteda" package
mycorp <- corpus(textfile(SAMPLE_CLEAN))

# summarizing my corpora
summary(mycorp)

# tokenize the texts from the corpora (one-gram, 2-grams, 3-grams) in data frames in order to
# show its frequency distribution

print("Tokenizing data...")
for(i in 1:3) {
  tk <- tokenize(mycorp, ngrams=i, concatenator=',')
  plot_bar_gram( table_tokens(tk), i)
}
rm(tk)		# release memory

# create a dfm, removing stopwords and stemming (not lowering, because it's already done)
# Ref.: https://github.com/kbenoit/quanteda/issues/50

mydfm <- dfm(mycorp, verbose = TRUE, toLower = FALSE, language="english", stem=TRUE, 
  removeNumbers = TRUE, removePunct = TRUE, removeSeparators = TRUE) 

# ignoredFeatures = stopwords('english'),

# basic dimensions of the dfm
print("Dimensions of dfm - Document-Frequency Matrix")
print(dim(mydfm))

# displaying 25 top words
print("25 top frequency words")
print(topfeatures(mydfm, 25))

stopTime <- Sys.time()

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

print(sprintf('Processing time: %6.2f minutes',  difftime(stopTime, startTime, units = "mins"))) 
     
