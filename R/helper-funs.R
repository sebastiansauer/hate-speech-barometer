read_and_select <- function(file_name, cols) {
  
  out <- 
    read_rds(file = file_name)
  out <- 
    out %>% 
    select(any_of(cols))
  
  if ("public_metrics" %in% names(out)) {
    out <-
      out %>% 
      mutate(id = as.character(id))
  }    
  
  if ("public_metrics" %in% names(out)) {
    out <- 
      out %>% 
      unnest_wider(public_metrics)
  } else {
    out <-
      out %>% 
      mutate(public_metrics = NA)
  }
  
  config <- config::get()
  
  if (config$verbose) cat(paste0("Data file", file_name, " was read.\n"))
  
  return(out)
}



