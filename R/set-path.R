
set_path <- function(which_computer = NULL, path_file = "path.yml"){
 
  library(yaml)
  
  # there must be a yaml file called "path.yml" with a line (a list item) called "data_prefix", where the root path to the data is specified
  stopifnot(file.exists(path_file))
  path <- read_yaml(path_file)
  
  #if (which_computer == 1) path$prefix <- path$prefix1
  
  # path$data_train <- paste0(path$data_prefix, "data-raw/GermEval-2018-Data-master/germeval2018.training.txt")
  # 
  # path$data_test <- paste0(path$data_prefix, "data-raw/GermEval-2018-Data-master/germeval2018.test.txt")
  
  path$tweets_small <- paste0(path$tweet_prefix, "data-raw/tweets-small")
  
  path$tweets <- paste0(path$tweet_prefix, "data-raw/tweets")
  
  
  return(path)

}


#path <- set_constants()
