def_model1 <- function() {
  
  logistic_reg(penalty = tune(), mixture = 1) %>%
    set_mode("classification") %>%
    set_engine("glmnet")
  
}


def_model_logistic <- function() {
  
  logistic_reg(penalty = tune(), mixture = 1) %>%
    set_mode("classification") %>%
    set_engine("glmnet")
  
}



def_model_boost <- function() {
  
  boost_tree(mtry = tune(),
               trees = tune(),
               learn_rate = tune(),
               ) %>%
    set_mode("classification")
  
}




def_model_rf <- function() {
  
  rand_forest(mtry = tune(),
             trees = 2000,
             mode = "classification")
}
