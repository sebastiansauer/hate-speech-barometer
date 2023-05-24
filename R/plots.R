plot_preds_summarized <- function(preds_summarized) {
  
  #out <- preds_summarized
  
  out <- 
    preds_summarized %>% 
    ggplot(aes(x = account_name, y = prop, fill = .pred_class, position = "fill")) +
    geom_col() +
    facet_wrap(~ year)
  
  return(out)
}
