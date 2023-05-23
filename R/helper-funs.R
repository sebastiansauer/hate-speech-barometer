read_and_select <- function(file_name) {
  
  
 # test_file <- "/Users/sebastiansaueruser/github-repos/hate-speech-data/data-raw/tweets/tweets-to-Tino_Chrupalla_2021.rds"
  
  out <- 
    read_rds(file = file_name)
  out <- 
    out %>% 
    select(id, text) %>% 
    mutate(id = as.character(id))
  
  # if ("public_metrics" %in% names(out)) {
  #   out <-
  #     out %>% 
  #     mutate(id = as.character(id))
  # }    
  # 
  # if ("public_metrics" %in% names(out)) {
  #   out <- 
  #     out %>% 
  #     unnest_wider(public_metrics)
  # } else {
  #   out <-
  #     out %>% 
  #     mutate(public_metrics = NA)
  # }
  # 
  config <- config::get()
  
  if (config$verbose) cat(paste0("Data file", file_name, " was read.\n"))
  
  return(out)
}





count_lexicon_df <- function(data, lexicon, col, group) {
  
  lexicon <-
    lexicon %>%
    mutate(word = tolower(word))
  
  data %>% 
    unnest_tokens(output = word, input = {{col}}) %>% 
    inner_join(lexicon, by = "word") %>% 
    group_by({{group}}) %>% 
    summarise(n = n())
}







count_lexicon_vec <- function(vec, lexicon_vec) {
  
  data <- tibble(col = tolower(vec))
  lexicon <- tibble(word = tolower(lexicon_vec))
  
  data_long <- 
    data %>% 
    unnest_tokens(output = word, input = col)
  
  d_joined <-
    data_long %>% 
    inner_join(lexicon, by = "word")
  
  d_summ <-
    d_joined %>% 
    summarise(n = n())
  
  out <- d_summ %>% pull(n)
  
  return(out)
}
