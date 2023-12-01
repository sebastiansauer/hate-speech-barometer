print('this is _targets.R file, pipeline3')

# pipeline3: workflow map with multiples recipes/models, predicting tweets (as test set), enhanced by anova race tuning

# load packages:
library(targets)
library(tarchetypes)
#library(crew)

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
#
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
source("R/plots.R")


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
                            "syuzhet"
                            )
               #controller = crew_controller_local(workers = config$n_workers)
               )






# Define the pipeline:
list(
  # setup:
  tar_target(path, set_path()),
  
  # import the train and train2 ("test") data:
  tar_target(d_train, read_train_test_data(path$data_train)),
  tar_target(d_test, read_train_test_data(path$data_test)),

  # define the recipes:
  tar_target(recipe_plain, def_recipe_plain(data_train)),
  tar_target(recipe_wordvec, def_recipe_wordvec(data_train)),
  
  tar_target(recipe_wordvec_prepped, prep(recipe_wordvec)),
  tar_target(d_train_baked,  bake(recipe_wordvec_prepped, new_data = NULL)),
  tar_target(d_test_baked, bake(recipe_wordvec_prepped, new_data = d_test)),
  tar_target(recipe_plain, def_recipe_plain(d_train_baked)),
  tar_target(recipe_plain_prepped, prep(recipe_plain)),
  
  # define models:
  tar_target(model_lasso, def_model_logistic()),
  tar_target(model_boost, def_model_boost()),
  tar_target(model_rf, def_model_rf()),

  # tune workflow 1 (Lasso):
  tar_target(wf1, fit_wf(model_lasso, recipe_plain)),
  tar_target(wf1_fit, tune_my_anova(wf1, data = d_train_baked)),
  tar_target(wf1_autoplot, autoplot(wf1_fit)),

  # tune workflow 2 (XGB):
  tar_target(wf2, fit_wf(model_boost, recipe_plain)),
  tar_target(wf2_fit, tune_my_anova(wf2, data = d_train_baked, grid = config$n_grid)),
  tar_target(wf2_autoplot, autoplot(wf2_fit)),

  # tune workflow 3 (Random Forest):  
  tar_target(wf3, fit_wf(model_rf, recipe_plain)),
  tar_target(wf3_fit, tune_my_anova(wf3, data = d_train_baked, grid = config$n_grid)),
  tar_target(wf3_autoplot, autoplot(wf3_fit)),

  # find best workflow (candidate):
  tar_target(wf_fits_l, list(wf1 = wf1_fit, wf2 = wf2_fit, wf3 = wf3_fit)),
  tar_target(wf_fits_roc, wf_fits_l %>% 
               map(~ collect_metrics(.x) %>% filter(.metric == "roc_auc")) %>% 
               list_rbind(names_to = "id") %>% 
               arrange(-mean)),
  tar_target(wf_fits_best, wf_fits_roc %>% slice_head(n = 1)),
  
  # finalize the best wf:
  tar_target(wf3_finalized, wf3 %>% finalize_workflow(wf_fits_best)),
  tar_target(final_fit, fit(wf3_finalized, d_train_baked)),
  tar_target(preds_test, predict(final_fit, d_test_baked)),
  
  # load new tweets:
  tar_files(tweets_path, path$tweets %>% list.files(full.names = TRUE, pattern = "rds$")),
  tar_target(tweets,  tweets_path %>% 
               read_and_select() %>% 
               drop_na(),
             pattern = map(tweets_path)),
 
  # tinyfy tweets, for quicker debugging:
  tar_target(tweets_df, tweets %>% 
               sample_n(size = config$n_rows) %>% 
               drop_na() %>% 
               group_by(id)),
  
  # bake each chunk individually:
  tar_target(tweets_baked, bake(recipe_wordvec_prepped, new_data = tweets_df)),
  
  # predict tweets (using the best workflow):
  tar_target(preds, predict(object = final_fit, new_data = tweets_baked)),
  tar_target(tweets_baked_preds, enrich_preds(tweets_df, preds, tweets_baked)),
  
  # show results:
  tar_target(preds_summarized, summarise_preds(tweets_baked_preds)),
  tar_target(preds_summarized_plot, plot_preds_summarized(preds_summarized))
  
 
)









