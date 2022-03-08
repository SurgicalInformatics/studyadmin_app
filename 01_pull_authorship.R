library(tidyverse)
library(lubridate)
library(scales)
library(RCurl)
library(googledrive)
drive_deauth()
drive_user()

## Example Registration data on Google Drive
"https://docs.google.com/spreadsheets/d/1O7PVV3XNH47PPQBF4Vi2jexKF9-ON83Lp7Lz96xU8X8/edit?usp=sharing" %>% 
  as_id() %>% 
  drive_download(path = here::here("project_data" , "registration.csv"), overwrite = TRUE, type = "csv")

# na = "" is necessary as by default, it includes NA, but that's the ISO2 code for Namibia...
authorship_original = read_csv(here::here("project_data" , "registration.csv"), na = "") %>% 
  filter(registration_complete == 2) %>% 
  mutate(start = dmy(start), end = dmy(end))

# Pull all Complete/Curated registrations ------------
# If pulling from REDCap:
# authorship_original = postForm(uri='https://redcap.cir.ed.ac.uk/globalsurg/api/',
#   token=as.character(source('token.secret.authorship'))[1],
#   content='record',
#   format='csv',
#   type='flat',
#   rawOrLabel='label',
#   rawOrLabelHeaders='raw',
#   exportCheckboxLabel='false',
#   exportSurveyFields='false',
#   exportDataAccessGroups='true',
#   returnFormat='json') %>% 
#   read_csv(na = "") %>% 
#   select(-contains("info")) %>% 
#   filter(firstname_1_reg != "LOCKED") %>% # this means we've merged the team into another one
#   mutate(hospital = paste(city, hospital, sep = ": "))
# END REDCap example



authorship = authorship_original %>% 
  mutate(team            = paste0(firstname_1_reg, " ",lastname_1_reg, ", ",firstname_2_reg, " ",lastname_2_reg, ", ",firstname_3_reg, " ",lastname_3_reg)) %>% 
  mutate(team_lastnames  = paste0(lastname_1_reg, ", ",lastname_2_reg, ", ", lastname_3_reg)) %>% 
  mutate(team            = str_replace_all(team, ", NA NA", "")) %>% 
  mutate(team_lastnames  = str_replace_all(team_lastnames, ", NA", "")) %>% 
  mutate(team_emails     = paste(email_1_reg, email_2_reg, email_3_reg, sep = "; ")) %>% 
  mutate(team_emails     = str_replace_all(team_emails, "; NA", "")) %>% 
  mutate(team_id = team_id %>% str_remove_all("\"")) %>% # had to use extra quotes so Google drive wouldn't convert 01 to number (so just 1)
  unite(team_id, redcap_data_access_group, team_id) %>% 
  select(country, id      = record_id, team_id, start, end,
         completed = collection_confirmed___1,
         hospital, team, team_emails,
         team_lastnames, internal_check, overlap_check) %>% 
  mutate(completed        = fct_recode(completed, "Confirmed" = "Checked", "Unconfirmed" = "Unchecked")) %>% 
  mutate(internal_check   = fct_explicit_na(internal_check, "Unchecked")) %>% 
  arrange(country, hospital, team_id) %>% 
  select(-country,everything()) %>% #moves country to the end
  ############
  # number of teams in hospital - need to know for validation
  ############
  group_by(hospital) %>% 
  mutate(n_teams = n()) %>% 
  ungroup()

rm(authorship_original)














