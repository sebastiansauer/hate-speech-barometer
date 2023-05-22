# this is "_targets.R" file

# load packages:
library(targets)
#library(crew)

# library(tidymodels)
# library(textrecipes)
# library(prada)
# library(datawizard)
# library(stringr)
# library(remoji)
# library(emo)

# read configuration from "config.yml":
config <- config::get()


# source funs:
source("R/set-path.R")
source("R/def-recipe1.R")
source("R/def-recipe2.R")
source("R/read-train-test-data.R")
#source("R/read-test-data.R")
source("R/def_model1.R")


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
                            "remoji",
                            "emo"
                            )
               #controller = crew_controller_local(workers = 2)
               )






# Definition der Pipeline:
list(
  tar_target(path, set_path()),
  tar_target(data_train, read_train_test_data(path$data_train)),
  tar_target(data_test, read_train_test_data(path$data_test)),
  tar_target(recipe1, def_recipe1(data_train)),
  tar_target(recipe2, def_recipe2(data_train)),
  tar_target(rec1_baked, bake(prep(recipe1), new_data = NULL)),
  tar_target(rec2_baked, bake(prep(recipe2), new_data = NULL)),
  tar_target(model1, def_model1()),
  tar_target(wf_set,
             workflow_set(preproc = list(recipe1 = recipe1, recipe2 = recipe2),
                          models = list(model1 = model1))),
  tar_target(set_fit,
             workflow_map(wf_set,
                          fn = "tune_grid",
                          grid = config$n_grid,
                          resamples = vfold_cv(data_train,
                                               v = config$v_folds,
                                               repeats = config$n_repeats,
                                               strata = c1),
                          verbose = TRUE)),
  tar_target(set_autoplot, autoplot(set_fit))
)
  
  








