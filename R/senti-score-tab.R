senti_score_tab <- function(senti_score, group_vars = NULL){

  out <- 
    senti_score |> 
    select(id, senti_score) |> 
    na.omit() |> 
    mutate(year = str_extract(id, "\\d{4}")) |> 
    mutate(id = str_remove(id, "_\\d{4}$")) |> 
    group_by(across(any_of(group_vars))) |>
    summarise(senti_person_n = sum(senti_score),
              senti_person_prop = senti_person_n / n())
  
  return(out)
}

