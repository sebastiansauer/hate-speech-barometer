

tune_my_anova <- function(wf, data, grid = NULL) {
  
  library(finetune)
  library(tidymodels)
  
  config <- config::get()
  
  if (is.null(grid)) grid <- config$n_grid
  
  # tune the workflow
  out <-
    wf %>% 
    tune_race_anova(
      resamples = vfold_cv(data, v = config$v_folds, 
                           repeats = config$n_repeats, 
                           strata = c1),
      grid = grid,
      control = control_race(verbose = config$verbose)
    )
  
  return(out)
  
}



tune_my_grid <- function(wf, data, grid = NULL) {
  
  
  library(finetune)
  library(tidymodels)
  
  config <- config::get()
  
  if (is.null(grid)) grid <- config$n_grid
  
  # tune the workflow
  out <-
    wf %>% 
    tune_grid(
      resamples = vfold_cv(data, v = config$v_folds, 
                           repeats = config$n_repeats, 
                           strata = c1),
      grid = grid,
      control = control_grid(verbose = config$verbose)
    )
  
  return(out)
  
}



fit_wf <- function(wf_model, wf_recipe) {
  
  library(finetune)
  library(tidymodels)
  
  wf <-
    workflow() %>% 
    add_recipe(wf_recipe) %>% 
    add_model(wf_model)
  
  return(wf)
  
}



