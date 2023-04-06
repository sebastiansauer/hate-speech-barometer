senti_tab_plot <- function(senti_tab, type = 1){
  
  
  out <-
    senti_tab |> 
    ggplot(aes(x = senti_person_prop, y = reorder(id, senti_person_prop))) + 
    geom_col() + 
    labs(y = "Politician",
         title = "Words with negative emotional connotation towards German politicians")
  
  
  if (type == 1) out <- out + facet_wrap(~ year)
  
  return(out)
}


senti_tab_plot2 <- function(senti_tab){
  
  out <-
    senti_tab |> 
    ggplot(aes(x = senti_person_prop, y = reorder(id, senti_person_prop))) + 
    geom_col() + 
    labs(y = "Politician",
         title = "Amount of negativity in Tweets towards German politicians",
         subtitle = "Number of negative words, normalized by number of tweets in 2021-2021, sent to top-tier German politicians",
         x = "Proportion of words with a negative connotation",
         caption = "BMWK: As vice-chancellor Robert Habeck does not have a Twitter account,\n the account of his ministry has been taken as a proxy.\nThis graph shows a selection of politicians only (based on approx. 1 million tweets).")
  
  return(out)
}



senti_tab_plot3 <- function(senti_tab){
  
  out <-
    senti_tab |> 
    ggplot(aes(x = senti_person_n, y = reorder(id, senti_person_n))) + 
    geom_col() + 
    labs(y = "Politician",
         title = "Words with negative emotional connocation towards German politicians")
  
  return(out)
}
