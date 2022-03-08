teams_data_summary = function(mycountry){
  
  teams_summary = study_data %>%
    filter(country_name == mycountry) %>% 
    group_by(dag_team) %>% 
    mutate(date_min = min(date, na.rm = TRUE),
           date_max = max(date, na.rm = TRUE)) %>% 
    # group_by(dag_team, all_complete) %>% 
    # mutate(n_all = n()) %>% 
    group_by(dag_team) %>% 
    mutate(groups_variable = paste(unique(var1), collapse = "-")) %>% 
    # count incomplete-op. only missing-complete
    mutate(n_complete   = sum(all_complete == "Complete"),
           n_half       = sum(all_complete == "Half"),
           n_incomplete = sum(all_complete == "Incomplete")) %>% 
    distinct(dag_team, date_min, date_max, groups_variable, n_complete, n_half, n_incomplete) %>% 
    rename(team_id = dag_team) %>% 
    ungroup() %>% 
    na.omit() %>% 
    left_join(select(authorship, team_id, team_lastnames, start, end, completed, internal_check, overlap_check)) %>% 
    # create summary cells for incomplete-half-complete counts
    mutate(`red-orange-green` = paste(n_incomplete, n_half, n_complete, sep = "-")) %>% 
    mutate(all_complete = ifelse(n_incomplete == 0, "Yes", "No")) %>% 
    mutate(all_complete = ifelse(all_complete == "Yes" & n_half > 0, "Almost", all_complete)) %>% 
    select(team_id, team_lastnames, groups_variable, `red-orange-green`, date_min, date_max, start, end, completed, internal_check, overlap_check, all_complete) %>%
    # check if min and max dates are withing declared data collection dates, handle missingness
    mutate(date_min_out = if_else(date_min < start | is.na(date_min < start), "Yes", "No"),
           date_max_out = if_else(date_max > end   | is.na(date_max > end), "Yes", "No")) %>%
    mutate(start_missing = if_else(is.na(start), "Yes", "No"),
           end_missing   = if_else(is.na(end),   "Yes", "No")) %>%
    mutate_if(is.POSIXct, format, format = "%d-%b") %>%
    mutate_if(is.Date, format, format = "%d-%b")
  
  return(teams_summary)
  
}