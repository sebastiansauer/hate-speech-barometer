read_and_select <- function(file_name) {
  
  
  #file_name <- "/Users/sebastiansaueruser/github-repos/hate-speech-data/data-raw/tweets/tweets-to-Janine_Wissler_2021.rds"
  
  out <- 
    read_rds(file = file_name) %>% 
    select(id, text) %>% 
    mutate(id = as.character(id)) %>% 
    mutate(name = str_extract(file_name, "tweets-to-\\w+_\\d{4}") %>% str_remove("tweets-to-"))
  
 
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






enrich_preds <- function(tweets, preds, tweets_baked) {
  
  d <- tweets %>% 
    rename(tweet_id = id) %>% 
    bind_cols(preds, tweets_baked)
  
  out <-   
    d %>% 
    mutate(year = str_extract(name, pattern = "\\d{4}")) %>% 
    relocate(year, .after = id) %>% 
    mutate(account_name = str_remove(name, pattern = "_\\d{4}")) %>% 
    relocate(account_name, .after = year)
  
  return(out)
  
}





summarise_preds <- function(preds) {
  
  out <- 
    preds %>% 
    count(year, .pred_class, account_name) %>% 
    group_by(year, account_name) %>% 
    mutate(prop = n/sum(n))
  
  return(out)
}


