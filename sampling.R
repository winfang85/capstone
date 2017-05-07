
source("systematic.R")
source("clean_text.R")

DATASET_DIR = "./Capstone_Dataset/"
SAMPLE_DIR  = "./Samples/"

SAMPLE_CORPUS = "sample_corpus.txt" 
SAMPLE_CLEAN  = "sample_clean.txt"

DATASET_LANG  = "en_US"
PERCENT_SAMPLE = 30   ## 30% 

cFiles <- c("news","twitter","blogs")

totLines <- 0
totSize <- 0

file_name <- function(case) 
{
  case <- paste0(case,".txt")
  fname <- paste(paste(paste0(DATASET_DIR,DATASET_LANG),DATASET_LANG,sep="/"),case,sep=".")
  return(fname)
}


read_dataset <- function() 
{
    startTime <- Sys.time()

    print(paste("Sampling",PERCENT_SAMPLE,"percent of corpora files."))
    
    for(f in cFiles) {
      txtFile <- readLines( file_name(f), skipNul=TRUE, encoding="latin" )
      nLines <- length(txtFile)
      totLines <- totLines + nLines

      print(paste(paste0(paste("Read",f),".txt =>"),nLines,"lines"))

      # determine a systematic sample for these lines of text
      nSample <- as.integer(PERCENT_SAMPLE * nLines / 100)
      cat("Sampling", nSample, "lines\n")
      cSampleLines <- systematic_sample(nSample, nLines, 1)

      df <- data.frame(TEXT=NA, stringsAsFactors=FALSE)
      n <- 0
      for(i in cSampleLines) {
	# sample a line with cleaning (punctuation, extra spaces and 'lowercasing')
	df[n,1] <- clean_text(txtFile[i], numbers=FALSE)
	n <- n+1 
      }	

      # save in a RDS file
      saveRDS(df,paste0(f,".rds"))

      fSize <- object.size(df)
      totSize <- totSize + fSize
    }

    stopTime <- Sys.time()

    print(sprintf('Read %s lines of text and write to 3 RDS files (%s) in %.3f minutes',
	  format(totLines,big.mark=','), format(totSize, units="KB"), 
	  difftime(stopTime, startTime, units = "mins")))

}

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

