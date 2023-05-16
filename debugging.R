wf1 <-
  workflow() %>% 
  add_model(model1) %>% 
  add_recipe(recipe1)


fit1 <-
  wf1 %>% 
  tune_grid(
    resamples = vfold_cv(data_train, 
                         v = config$v_folds, 
                         repeats = config$n_repeats,
                         strata = c1),
    grid = config$n_grid
  )
fit1

collect_metrics(fit1)

autoplot(fit1)


set_fit <-
workflow_map(wf_set,
             fn = "tune_grid",
             grid = config$n_grid,
             resamples = vfold_cv(data_train, 
                                  v = config$v_folds, 
                                  repeats = config$n_repeats,
                                  strata = c1))
                                  
