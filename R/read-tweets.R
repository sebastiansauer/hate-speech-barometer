read_tweets <- function(tweets_data_path) {
  
  
  stopifnot(file.exists(tweets_data_path))
  
  #cols_to_select <- c("id", "author_id", "created_at", "text", "public_metrics")
  cols_to_select <- c("id", "text")
  
  config <- config::get()
  
  #if (config$tinyfy) 
  #  tweets_data_path <- "/Users/sebastiansaueruser/github-repos/hate-speech/data-raw/tweets-small"
  
 
  
  tweet_data_files_names_w_path <-
    list.files(
      path = tweets_data_path,
      full.names = TRUE,
      pattern = ".rds")
  
  
  tweet_data_files_names <-
    list.files(
      path = tweets_data_path,
      full.names = FALSE,
      pattern = ".rds")
  
  names(tweet_data_files_names_w_path) <- 
    tweet_data_files_names |>  
    str_remove("^tweets-to-") |> 
    str_remove(".rds$")
  
  ds <-
    tweet_data_files_names_w_path |>  
    set_names() |> 
    map_dfr(~ read_and_select(.x, cols = cols_to_select), .id = "id") |> 
    mutate(id = str_extract(id, "tweets-to-\\w+_\\d{4}") %>% str_remove("tweets-to-"))
  
  # remove users attributes:
  attr(ds, "users") <- NULL
  
  
  return(ds)
}

# out <- read_rds(tweet_data_files_names[4])
# cols_to_select %in% names(out1)
# out1 %>% select(any_of(cols_to_select))
  
      
