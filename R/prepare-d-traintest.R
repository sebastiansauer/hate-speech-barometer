

d_train <- read_tsv("/Users/sebastiansaueruser/github-repos/hate-speech/data-raw/GermEval-2018-Data-master/germeval2018.training.txt", col_names = FALSE)


d_test <- read_tsv("/Users/sebastiansaueruser/github-repos/hate-speech/data-raw/GermEval-2018-Data-master/germeval2018.test.txt", col_names = FALSE)



d_traintest <- 
  d_train %>% 
  bind_rows(d_test)

names(d_traintest) <- c("text", "c1", "c2")

write_csv(d_traintest, file = "data-raw/d-traintest.csv")
