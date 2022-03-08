library(lubridate)

authorship %>% 
  select(team_id, start, end) %>% 
  slice(rep(1:n(), each = 10)) %>% 
  mutate(date = start + days(runif(90, 0, 27) %>% round())) %>% 
  mutate(all_complete = sample(c("Complete", "Incomplete"), 90, replace = TRUE)) %>% 
  mutate(var1 = sample(c("Triangle", "Circle", "Square"), 90, replace = TRUE)) %>% 
  arrange(team_id, date) %>% 
  select(team_id, date, all_complete, var1) %>% 
  write_csv("temp.csv")
