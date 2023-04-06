def_recipe2 <- function(data_train) {
  
  
  
  #data("schimpwoerter", package = "pradadata")
  schimpfwoerter <- data_read("https://raw.githubusercontent.com/sebastiansauer/pradadata/master/data-raw/schimpfwoerter.csv")
  data("sentiws", package = "pradadata")
  data("wild_emojis", package = "pradadata")

  
  config::get()
  
  n_tokens <- config$n_tokens
  
  d_reduced <- data_train %>% select(text, c1, id)
  
  recipe_def <-
    recipe(c1 ~ ., data = d_reduced) %>%
    update_role(id, new_role = "id") %>%
    step_text_normalization(text) %>%
    step_mutate(emo_count = map_int(text, ~count_lexicon(.x, sentiws$word))) %>% 
    step_mutate(schimpf_count = map_int(text, ~ count_lexicon(.x, schimpfwoerter$word))) %>% 
    step_mutate(emoji_count =  map_int(text,  ~ count_lexicon(remoji::emoji(remoji::list_emoji(), pad = FALSE), collapse = "|"))) %>% 
    step_mutate(text_copy = text) %>% 
    step_textfeature(text_copy) %>% 
    step_tokenize(text) %>%
    step_stopwords(text, language = "de", stopword_source = "snowball") %>%
    step_stem(text) %>%
    step_tokenfilter(text, max_tokens = n_tokens) %>%
    step_tfidf(text) %>%
    step_zv(all_predictors()) %>%
    step_normalize(all_numeric_predictors(), -starts_with("textfeature"), -ends_with("_count"))
  
  return(recipe_def)
}


# 
# rec1 <- def_recipe(dd)
# rec1

