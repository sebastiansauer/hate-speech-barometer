# definitions of recipes




# recipe 1 ----------------------------------------------------------------



def_recipe_tfidf <- function(data_train) {
  
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
  
  # get project configuration:
  config <- config::get()
  
  # import dictionaries:
  # schimpfwoerter <- data_read("https://raw.githubusercontent.com/sebastiansauer/pradadata/master/data-raw/schimpfwoerter.csv")
  data("sentiws", package = "pradadata")
  data("wild_emojis", package = "pradadata")
  data("schimpfwoerter", package = "pradadata")
  
  # preprocess dictionaries:
  sentiws$word <- tolower(sentiws$word)
  schimpfwoerter$value <- 1
  
  
  # reduce data to 3 columns for efficiency:
  d_reduced <- data_train %>% select(text, c1, id)
  
  # define preprocessing of data:
  recipe_def <-
    
    # define model term: output ~ input variables:
    recipe(c1 ~ ., data = d_reduced) %>%
    
    # exclude id variable from modelling:
    update_role(id, new_role = "id") %>%
    
    # ascify text:
    step_text_normalization(text) %>%
    
    # count words with emotional connotation:
    step_mutate(emo_count = get_sentiment(text,
                                          method = "custom",
                                          lexicon = sentiws)) %>% 
    
    # count abusive words:
    step_mutate(schimpf_count = get_sentiment(text,
                                              method = "custom",
                                              lexicon = schimpfwoerter)) %>% 
    
    # count emojis:
    step_mutate(emoji_count =  str_count(text, "\\p{So}")) %>%   # code for Emojis/Sonderzeichen
    
    # copy text column:
    step_mutate(text_copy = text) %>% 
    
    # convert text column into text features such as character count etc:
    step_textfeature(text_copy) %>% 
    
    # tokenize texts (words):
    step_tokenize(text) %>%
    
    # remove stopwords: 
    step_stopwords(text, language = "de", stopword_source = "snowball") %>%
    
    # step tokens:
    step_stem(text) %>%
    
    # reduce to n most frequent tokens:
    step_tokenfilter(text, max_tokens = config$n_tokens) %>%
    
    # count word frequency:
    step_tfidf(text) %>%
    
    # remove zero variance (zv) variables:
    step_zv(all_predictors()) %>%
    
    # z-transform:
    step_normalize(all_numeric_predictors()) %>% 
    
    # impute missing values:
    step_impute_mean(all_numeric_predictors()) %>% 
    
    # transform integer to numeric (some models appear to like that):
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




# recipe word-vecs --------------------------------------------------------


def_recipe_wordvec <- function(data_train) {
  
  config <- config::get()
  
  # reduce data to 3 columns for efficiency:
  d_reduced <- data_train %>% select(text, c1, id)
  
  
  # import word embeddings:
  wiki_de_embeds <- arrow::read_feather(file = set_path()$wordvec)
  names(wiki_de_embeds)[1] <- "word"
  wiki <- as_tibble(wiki_de_embeds)                                      
  
  # define recipe based on (German) wordvectors:
  rec_def <- 
    rec1 <-
    recipe(c1 ~ ., data = d_reduced) |> 
    update_role(id, new_role = "id")  |> 
    step_tokenize(text) |> 
    step_stopwords(text, language = "de", stopword_source = "snowball") |> 
    step_word_embeddings(text,
                         embeddings = wiki,
                         aggregation = "mean") 
  
  return(rec_def)
  
}
