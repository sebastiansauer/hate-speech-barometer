def_recipe1 <- function(data_train) {
  
  # config::get()
  
  library(tidymodels)
  library(tidytext)
  
  n_tokens <- config$n_tokens
  
  d_reduced <- data_train %>% select(text, c1, id)
  
  recipe_out <- 
    recipe(c1 ~ ., data = d_reduced) %>%
    update_role(id, new_role = "id") %>%
    step_tokenize(text) %>%
    step_tokenfilter(text, max_tokens = n_tokens) %>%
    step_tfidf(text) %>%
    step_zv(all_predictors()) %>%
    step_normalize(all_numeric_predictors())
  
  return(recipe_out)
}


# 
# rec1 <- def_recipe(dd)
# rec1

