
hate_score <- function(tweets_text){
  
  
  # THIS FUNCTION RUNS FOR APPROX 15 HOURS ON MY MACHINE
  
  data("sentiws")
  
  # tweets_text <- tweets_text_small
  
  neg_words_vec <-
    sentiws %>% 
    filter(neg_pos == "neg") |>  
    pull(word)
  
  out <-
  tweets_text %>% 
    mutate(senti_score = map_int(text, ~ count_lexicon(txt = .x, lexicon = neg_words_vec))) |> 
    select(-text)
  
  
  # neg_words <-
  #   sentiws %>% 
  #   filter(neg_pos == "neg") %>% 
  #   select(word)
  
  # out <-
  #   tweets_text %>% 
  #   select(text, id) %>% 
  #   mutate(id = factor(id)) %>% 
  #   unnest_tokens(word, text) %>% 
  #   inner_join(neg_words) %>% 
  #   group_by(id) %>%
  #   summarise(n = n())
   # mutate(senti_score = map_int(text, ~ count_lexicon(txt = text, lexicon = neg_words)))
  
  return(out)
  
  
}


