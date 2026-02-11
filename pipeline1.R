print('this is _targets.R file, pipeline1')

# pipeline1: workflow map with 2 recipes and 2 models

# load packages:
library(targets)
library(tarchetypes)
#library(crew)

#library(tidyverse)
#library(tidymodels)
#library(textrecipes)
#library(prada)
#library(datawizard)
#library(stringr)
#library(remoji)
#library(emo)

# read configuration from "config.yml":
config <- config::get()


# source funs:
source("R/set-path.R")
source("R/def-recipes.R")
source("R/read-train-test-data.R")
source("R/def-models.R")
source("R/my-cv-scheme.R")


# tar options:
tar_option_set(packages = c("readr", 
                            "dplyr", 
                            "ggplot2", 
                            "purrr", 
                            "stringr",
                            "easystats", 
                            "prada",
                            "tidymodels", 
                            "textrecipes",
                            "textrecipes",
                            #"remoji",
                            #"emo",
                            "syuzhet"
                            )
               #controller = crew_controller_local(workers = 2)
               )






# Definition der Pipeline:
list(
  tar_target(path, set_path()),
  
  # import the train and test data:
  tar_target(data_train, read_train_test_data(path$data_train), packages = "datawizard"),
  tar_target(data_test, read_train_test_data(path$data_test), packages = "datawizard"),
  tar_target(data_tt, data_train %>% bind_rows(data_test)),
  
  # define the recipes:
  tar_target(recipe_plain, def_recipe_plain(data_train)),
  tar_target(recipe_wordvec, def_recipe_wordvec(data_train)),
  
  # bake the recipes (train data):
  # tar_target(d_train_rec1_baked, bake(prep(recipe_plain), new_data = NULL)),
  tar_target(d_train_rec2_baked, bake(prep(recipe_wordvec), new_data = NULL)),
  #tar_target(d_tt_rec2_baked, bake(prep(recipe_plain), new_data = NULL)),
  
  # define models:
  tar_target(model_lasso, def_model_lasso()),
  tar_target(model_rf, def_model_rf()),
  
  # tune all workflows:
  tar_target(wf_set,
             workflow_set(preproc = list(recipe_wordvec = recipe_wordvec),
                          models = list(model1 = model_lasso,
                                        model2 = model_rf))),
  tar_target(set_fit,  # 6 GB on disk, 18 GB in memory!
             workflow_map(wf_set,
                          fn = "tune_grid",
                          grid = config$n_grid,
                          resamples = vfold_cv(data_train,
                                               v = config$v_folds,
                                               repeats = config$n_repeats,
                                               strata = c1),
                          seed = 42,
                          verbose = config$verbose)),
  
  # plot the performance metrics:
  tar_target(set_autoplot, autoplot(set_fit)),  # 10 GB!
  tar_target(wf_metrics, collect_metrics(set_fit))
)
  
  








