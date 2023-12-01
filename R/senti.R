
hate_score <- function(tweets_text){
  
  data("sentiws", package = "pradadata")
  
  # tweets_text <- tweets_text_small
  
  neg_words_vec <-
    sentiws %>% 
    filter(neg_pos == "neg") |>  
    pull(word)
  
  sentiws_neg <-
    sentiws |> 
    filter(neg_pos == "neg")
  
  out <-
  tweets_text %>% 
    mutate(senti_score = get_sentiment(text, 
                                       method = "custom",
                                       lexicon = sentiws_neg)) |> 
    select(-text)

  return(out)
  
  
}


