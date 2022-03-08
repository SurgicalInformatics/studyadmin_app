# This is an example app for managing collaborative data collection studies.
# Note that this is not the database or the data entry tool, it presents summaries of data pulled from the database
# In this example app, the database is a collection of Google sheets - for ease of viewing (see links in Info and Code tab of the app). 
# In reality we suggest using an SQL based tool such as REDCap.
# Riinu Pius, March 2022


source("01_pull_authorship.R")
source("02_data_summary_table.R")
source("03_data_plotting_functions.R")

library(DT)

myred    = "#ef3b2c"
myorange = "#feb24c"
mygreen  = "#a6d96a"


server <- function(input, output, session) {
  
  # Collaborators tab
  source(here::here("server", "authorship_table.R"), local = TRUE)$value
  
  # Study data tab
  source(here::here("server", "study_data_update_dropdown.R"), local = TRUE)$value
  source(here::here("server", "study_data_make_plots.R"), local = TRUE)$value
  source(here::here("server", "study_data_format_summary_sentence.R"), local = TRUE)$value
  source(here::here("server", "study_data_overlaps_text.R"), local = TRUE)$value
  source(here::here("server", "study_data_format_quality_table.R"), local = TRUE)$value
  


}