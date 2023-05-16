# _targets.R file
library(targets)


config <- config::get()


#source funs:
source("R/set-constants.R")
source("R/def-recipe.R")
source("R/def-recipe2.R")
source("R/read-train-data.R")
source("R/read-test-data.R")
source("R/def_model1.R")


# Optionen, z.B. allgemein verfügbare Pakete in den Targets:
tar_option_set(packages = c("readr", 
                            "dplyr", 
                            "ggplot2", 
                            "purrr", 
                            "stringr",
                            "easystats", 
                            "tidymodels", 
                            "textrecipes"))




# Definition der Pipeline:
list(
  tar_target(constants, set_constants()),
  tar_target(data_train, read_train_data()),
  tar_target(data_test, read_test_data()), 
  tar_target(recipe1, def_recipe1(data_train)),
  tar_target(recipe2, def_recipe2(data_train)),
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
  tar_target(set_autoplot,
             autoplot(set_fit))

)
  
  








