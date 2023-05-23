
# setup -------------------------------------------------------------------

library(targets)
library(tidymodels)
library(tidyverse)
library(textrecipes)
library(prada)
library(datawizard)
library(stringr)

tar_load(data_train)
tar_load(data_test)


# read configuration from "config.yml":
config <- config::get()



tar_load(wf1_fit)
tar_load(wf2_fit)
tar_load(wf3_fit)



wf_fits_l <-
  list(wf1 = wf1_fit, wf2 = wf2_fit, wf3 = wf3_fit)


wf_fits_roc <- 
wf_fits_l %>% 
  map(~ collect_metrics(.x) %>% filter(.metric == "roc_auc")) %>% 
  list_rbind(names_to = "id") %>% 
  arrange(-mean)


wf_fits_best <-
  wf_fits_roc %>% 
  slice_head(n = 1)


tar_load(wf_fits_best)
tar_load(wf3)
tar_load(wf3_fit)



m1 <-
mtcars |> 
  split(mtcars$cyl)  









# wf1 ---------------------------------------------------------------------



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

# wf 2 --------------------------------------------------------------------


tar_load(model1)
tar_load(recipe2)

wf2 <-
  workflow() %>% 
  add_model(model1) %>% 
  add_recipe(recipe2)


data("schimpfwoerter", package = "pradadata")


data("sentiws", package = "pradadata")
data("wild_emojis", package = "pradadata")


# function `count_lexicon` comes from package `prada`
# https://github.com/sebastiansauer/prada


fit2 <-
  wf2 %>% 
  tune_grid(
    resamples = vfold_cv(data_train, 
                         v = config$v_folds, 
                         repeats = config$n_repeats,
                         strata = c1),
    grid = config$n_grid
  )
fit1

collect_metrics(fit2)

autoplot(fit1)




# set fit -----------------------------------------------------------------





set_fit <-
workflow_map(wf_set,
             fn = "tune_grid",
             verbose = TRUE,
             grid = config$n_grid,
             resamples = vfold_cv(data_train, 
                                  v = config$v_folds, 
                                  repeats = config$n_repeats,
                                  strata = c1))
                                  





# dvi ---------------------------------------------------------------------




sample_data <- tibble(text = c("sch\U00f6n", "scho\U0308n"))

rec <- recipe(~., data = sample_data) %>%
  step_text_normalization(text)
rec

bake(prep(rec), new_data = NULL)
