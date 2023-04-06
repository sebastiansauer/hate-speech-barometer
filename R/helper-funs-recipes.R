

count_profane <- function(text, profane_list = schimpf$word) {
  sum((tokenizers::tokenize_tweets(text, simplify = TRUE) %>% purrr::as_vector()) %in% profane_list)
}



count_emo_words <- function(text, emo_list = sentiws$word) {
  sum((tokenizers::tokenize_tweets(text, simplify = TRUE) %>% purrr::as_vector()) %in% emo_list)
}


count_emojis <- function(text, emoji_list = trimws(emj)){
  sum((tokenizers::tokenize_tweets(text, simplify = TRUE) %>% purrr::as_vector()) %in% emoji_list)
}



count_wild_emojis <- function(text, wild_emoji_list = wild_emojis){
  sum((tokenizers::tokenize_tweets(text, simplify = TRUE) %>% purrr::as_vector()) %in% wild_emoji_list)
}



