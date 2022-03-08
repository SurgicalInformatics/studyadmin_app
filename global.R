library(tidyverse)
library(lubridate)
library(googledrive)

drive_deauth()
drive_user()


# Countries and ISO2 codes lookup database -------------
"https://docs.google.com/spreadsheets/d/1pCLf-oTH3AAtIoqc7RkdkUTFcBuVXRt331pjCSZf6_4/edit?usp=sharing" %>% 
  as_id() %>% 
  drive_download(path = here::here("project_data" , "countries.csv"), overwrite = TRUE, type = "csv")

country_lookup = read_csv(here::here("project_data", "countries.csv"), na = "")

# Pull all countries that have registered to take part in the study------------
authorship_countries = read_csv(here::here("project_data" , "registration.csv"), na = "") %>% 
  select(country, city, hospital, dag = redcap_data_access_group) %>% 
  arrange(country) %>% 
  unique() %>% 
  mutate(hospital = paste(city, hospital, sep = ": "))
  
  
countries = c("ALL", unique(authorship_countries$country))


# Example Study data --------------
"https://docs.google.com/spreadsheets/d/1niUR0QpKYHRP0TYjTDPwfJzSanGZV1lh24air4t-6do/edit?usp=sharing" %>% 
  as_id() %>% 
  drive_download(path = here::here("project_data" , "study_data.csv"), overwrite = TRUE, type = "csv")

# na = "" is necessary as by default, it includes NA, but that's the ISO2 code for Namibia...
study_data = read_csv(here::here("project_data" , "study_data.csv"), na = "") %>% 
  mutate(date_present = if_else(is.na(date), "date-missing", "date-ok")) %>% 
  # regexp to extract the team ID number (e.g. 01, 02, etc) from the end of the data access group
  mutate(team     = str_extract(dag_team, "[:digit:]{2}$")) %>% 
  # similar regexp to then remove the number from the variable (leaving iso2_hospital/hospital shortname behind)
  mutate(dag      = str_remove(dag_team, "_[:digit:]{2}$")) %>% 
  # regexp to extraxt the ISO2 code from the front, then making it uppercase
  mutate(iso2     = str_extract(dag_team, "^[:alpha:]{2}") %>% toupper()) %>% 
  # join ISO2 codes with country names
  left_join(country_lookup) 

# counts how many records with dates each team has entered - if 0 they won't be included in the
# drop-down list for plots
study_hospitals = study_data %>% 
  count(dag, date_present) %>% 
  arrange(dag, date_present) %>% 
  spread(date_present, n, fill = 0) %>% 
  mutate(Total = `date-missing` + `date-ok`) %>% 
  left_join(authorship_countries) %>% 
  arrange(hospital)

study_hospitals_list        = study_hospitals$dag
names(study_hospitals_list) = study_hospitals$hospital



