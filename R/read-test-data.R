read_test_data <- function(path_to_data = path$data_test) {
  
  d <- data_read(path_to_data, header = FALSE, quote = "")
  
  names(d) <- c("text", "c1", "c2")
  
  d$c2 <- NULL
  
  d$id <- as.character(1:nrow(d))
  
  return(d)
  
}
