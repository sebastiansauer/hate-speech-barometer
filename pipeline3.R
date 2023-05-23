# this is "_targets.R" file

# load packages:
library(targets)
library(tarchetypes)
library(crew)

library(tidyverse)
library(finetune)
library(tidymodels)
library(textrecipes)
library(prada)
library(pradadata)
library(datawizard)
library(stringr)
library(remoji)
library(emo)

data(sentiws)

# read configuration from "config.yml":
config <- config::get()


# source funs:
source("R/set-path.R")
source("R/def-recipes.R")
source("R/read-train-test-data.R")
#source("R/read-test-data.R")
source("R/def-models.R")
source("R/tune-wf.R")
source("R/read-tweets.R")
source("R/helper-funs.R")


# tar options:
tar_option_set(packages = c("readr", 
                            "dplyr", 
                            "ggplot2", 
                            "purrr", 
                            "stringr",
                            "easystats", 
                            "prada",
                            "pradadata",
                            "tidymodels", 
                            "tidytext",
                            "textrecipes",
                            "remoji",
                            "finetune",
                            "emo",
                            "remoji"
                            )
               
               #controller = crew_controller_local(workers = config$n_workers)
               )






# Define the pipeline:
list(
  # setup:
  tar_target(path, set_path()),
  
  # import the train and train2 ("test") data:
  tar_target(data_train, read_train_test_data(path$data_train)),
  tar_target(data_train2, read_train_test_data(path$data_test)),
  tar_target(data_tt, data_train %>% 
               bind_rows(data_train2)),
  
  # define the recipes:
  tar_target(recipe2, def_recipe2(data_tt)),
  tar_target(recipe2_prepped, prep(recipe2)),
  tar_target(d_tt_rec2_baked, bake(recipe2_prepped, new_data = NULL)),
  tar_target(recipe_plain, def_recipe_plain(d_tt_rec2_baked)),
  tar_target(recipe_plain_prepped, prep(recipe_plain)),
  
  # define models:
  tar_target(model_lasso, def_model_logistic()),
  tar_target(model_boost, def_model_boost()),
  tar_target(model_rf, def_model_rf()),

  # tune all workflows:
  tar_target(wf1, fit_wf(model_lasso, recipe_plain)),
  tar_target(wf1_fit, tune_my_anova(wf1, data = d_tt_rec2_baked)),
  tar_target(wf1_autoplot, autoplot(wf1_fit)),

  tar_target(wf2, fit_wf(model_boost, recipe_plain)),
  tar_target(wf2_fit, tune_my_anova(wf2, data = d_tt_rec2_baked)),
  tar_target(wf2_autoplot, autoplot(wf2_fit)),
  
  tar_target(wf3, fit_wf(model_rf, recipe_plain)),
  tar_target(wf3_fit, tune_my_anova(wf3, data = d_tt_rec2_baked)),
  tar_target(wf3_autoplot, autoplot(wf3_fit)),

  # find best workflow (candidate):
  tar_target(wf_fits_l, list(wf1 = wf1_fit, wf2 = wf2_fit, wf3 = wf3_fit)),
  tar_target(wf_fits_roc, wf_fits_l %>% 
               map(~ collect_metrics(.x) %>% filter(.metric == "roc_auc")) %>% 
               list_rbind(names_to = "id") %>% 
               arrange(-mean)),
  tar_target(wf_fits_best, wf_fits_roc %>% slice_head(n = 1)),
  
  # finalize wf:
  tar_target(wf3_finalized, wf3 %>% finalize_workflow(select_best(wf3_fit, metric = "roc_auc"))),
  tar_target(final_fit, fit(wf3_finalized, d_tt_rec2_baked)),
  
  # load new tweets:
  tar_target(tweets_files, path$tweets, format = "file"),

  # read all the tweets into a character vector, df and list (a lot of data!)
  tar_target(tweets_df, read_tweets(path$tweets), packages = c("tidyverse")),

  tar_target(tweets_l, tweets_df %>% split(tweets_df$id)),
  tar_target(tweets_l_nona, tweets_l %>% list_drop_empty(),
             packages = c("vctrs", "tidyverse")),
  
  # tinyfy tweets, for quicker debugging:
  tar_target(tweets_df_tiny, tweets_df %>% group_by(id) %>% sample_frac(size = .0001)),
  tar_target(tweets_l_tiny, tweets_df_tiny %>% split(tweets_df$id) %>% list_drop_empty(),
             packages = c("vctrs", "tidyverse")),
  
  # bake each chunk individually:
  tar_target(tweets_baked, bake(recipe2_prepped, new_data = tweets_df_tiny)),
  

  # predict tweets (using the best workflow):
  tar_target(preds, predict(object = final_fit, new_data = tweets_baked))
  
  # plot results:
  
 
)









