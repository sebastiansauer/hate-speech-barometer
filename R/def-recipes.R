# definitions of recipes




# recipe 1 ----------------------------------------------------------------



def_recipe1 <- function(data_train) {
  
  config <- config::get()
  
  d_reduced <- data_train %>% select(text, c1, id)
  
  recipe_out <- 
    recipe(c1 ~ ., data = d_reduced) %>%
    update_role(id, new_role = "id") %>%
    step_tokenize(text) %>%
    step_tokenfilter(text, max_tokens = config$n_tokens) %>%
    step_tfidf(text) %>%
    step_zv(all_predictors()) %>%
    step_normalize(all_numeric_predictors())
  
  return(recipe_out)
}



# recipe 2 ----------------------------------------------------------------

def_recipe2 <- function(data_train) {
  
  config <- config::get()
  
  #data("schimpwoerter", package = "pradadata")
  schimpfwoerter <- data_read("https://raw.githubusercontent.com/sebastiansauer/pradadata/master/data-raw/schimpfwoerter.csv")
  data("sentiws", package = "pradadata")
  data("wild_emojis", package = "pradadata")
  
  
  
  d_reduced <- data_train %>% select(text, c1, id)
  
  recipe_def <-
    recipe(c1 ~ ., data = d_reduced) %>%
    update_role(id, new_role = "id") %>%
    step_text_normalization(text) %>%
    step_mutate(emo_count = map_int(text, ~ count_lexicon_vec(.x, tolower(sentiws$word)))) %>% 
    step_mutate(schimpf_count = map_int(text, ~ count_lexicon_vec(.x, tolower(schimpfwoerter$word)))) %>%   
    step_mutate(emoji_count =  map_int(text, ji_count)) %>%   # package "emo"
    step_mutate(text_copy = text) %>% 
    step_textfeature(text_copy) %>% 
    step_tokenize(text) %>%
    step_stopwords(text, language = "de", stopword_source = "snowball") %>%
    step_stem(text) %>%
    step_tokenfilter(text, max_tokens = config$n_tokens) %>%
    step_tfidf(text) %>%
    step_zv(all_predictors()) %>%
    step_normalize(all_numeric_predictors()) %>% 
    step_impute_mean(all_numeric_predictors()) %>% 
    step_mutate(across(where(is.integer), as.numeric))
  
  return(recipe_def)
}




# recipe_plain ------------------------------------------------------------


def_recipe_plain <- function(data_train) {
  
  recipe_def <-
    recipe(c1 ~ ., data = data_train) %>%  
    update_role(id, new_role = "id") 
  
  return(recipe_def)
  
}


  
