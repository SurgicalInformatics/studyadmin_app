"https://docs.google.com/spreadsheets/d/1JmGGy9fuqVg0Iy2Ho_sS0KbSpmhrSkb_XKWygrhJS8s/edit?usp=sharing" %>% 
  as_id() %>% 
  drive_download(path = here::here("project_data" , "hospitals.csv"), overwrite = TRUE, type = "csv")


hospitals = read_csv(here::here("project_data" , "hospitals.csv"), na = "", comment = "\"#")
