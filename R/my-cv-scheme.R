my_cv_scheme <- function(){
  
  out <- vfold_cv(data_train,
                  v = config$v_folds,
                  repeats = config$n_repeats,
                  strata = c1)
  
  return(out)
}
