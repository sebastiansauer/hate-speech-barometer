# pipeline2


library(targets)
library(dplyr)
library(readr)
library(future)
library(future.callr)

config <- config::get()

#source funs:
source("R/set-path.R")
#source("R/def-recipes.R")
source("R/read-tweets.R")
source("R/helper-funs.R")
source("R/senti.R")
source("R/senti-score-tab.R")
source("R/senti-tab-plot.R")

#tweets_data_path <- "/Users/sebastiansaueruser/github-repos/hate-speech/data-raw/tweets"


# set options for target-pipeline (e.g, defining omnipresent packages):
tar_option_set(packages = c("dplyr"),
               format = "qs")

# prepare for parallel processing:
future::plan(future::multisession, workers = 4)




# Define the pipeline:
list(
  # define input of pipeline:
  tar_target(tweets_files, tweets_data_path, format = "file"),
  tar_target(path, set_path()),
  
  # read all the tweets into a character vector:
  tar_target(tweets_text, read_tweets(path$tweets), packages = c("tidyverse")),
  
  # tinyfy (mostly for quicker debugging):
  tar_target(tweets_text_small, tweets_text %>% slice_head(n = 100)),
  
  # compute hate score per tweet:
  tar_target(senti_score, hate_score(tweets_text), packages = c("prada", "pradadata", "tidytext")),
  
  # compute table with results 1:
  tar_target(senti_tab, senti_score_tab(senti_score, group_vars = c("id", "year")), packages = "stringr"),
  
  # compute table with results 2:  
  tar_target(senti_tab2, senti_score_tab(senti_score, group_vars = c("id")), packages = "stringr"),
  
  # now plot all the results:
  tar_target(senti_plot, senti_tab_plot(senti_tab), packages = c("ggplot2")),
  tar_target(senti_plot2, senti_tab_plot2(senti_tab2), packages = c("ggplot2")),
  tar_target(senti_plot3, senti_tab_plot3(senti_tab2), packages = c("ggplot2"))
)










