
set_constants <- function(which_computer = 1){
  
  path <- list()
  
  path$prefix1 <- "/home/sebastian/GitHub/hate-speech-data/"
  
  if (which_computer == 1) path$prefix <- path$prefix1
  
  path$data_train <- paste0(path$prefix, "data-raw/GermEval-2018-Data-master/germeval2018.training.txt")
  
  path$data_test <- paste0(path$prefix, "data-raw/GermEval-2018-Data-master/germeval2018.test.txt")
  
  path$tweets_small <- paste0(path$prefix, "data-raw/tweets-small")
  
  path$tweets <- paste0(path$prefix, "data-raw/tweets")
  
  
  return(path)

}


path <- set_constants()
