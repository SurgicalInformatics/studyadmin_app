# This is an example app for managing collaborative data collection studies.
# Note that this is not the database or the data entry tool, it presents summaries of data pulled from the database
# In this example app, the database is a collection of Google sheets - for ease of viewing. In reality we suggest using an
# SQL based tool such as REDCap. Riinu Pius, March 2022


library(shiny)
library(tidyverse)
library(RCurl)
library(plotly)
library(shinyBS)



# Define UI for application with multiple tabs
ui <- fluidPage(
  titlePanel("Cohort studies registration&data collection overview app"),
  tags$style(HTML("
    .tabbable > .nav > li > a                  {background-color: #ffcceb;  color:black}
    .tabbable > .nav > li[class=active]    > a {background-color: #ff0099;  color:white}
  ")),
  #fluidRow(column(12, p("Text text"))),
  fluidRow(column(12, 
                  selectInput(inputId = "mycountry",
                              label = h3("Select your country:", style = "color:#ff0099"),
                              selected = "Ironvale",
                              choices = countries))),
  fluidRow(
    column(12,
           tabsetPanel(selected = "Data quality",
                       tabPanel("Collaborators", # -------------
                                fluidRow(
                                  column(12, 
                                         p(),
                                         DT::dataTableOutput("authorship")))),
                       tabPanel("Study data", # dates plots ---------------
                                fluidRow(
                                  column(12,
                                         conditionalPanel("$('html').hasClass('shiny-busy')", h3("Loading...", style="color:#FF0099")),
                                         h3(textOutput("records_info")),
                                         uiOutput("country_timeplot.ui")
                                         
                                  )
                                )
                       ),
                       tabPanel("Data quality", # -------------
                                fluidRow(
                                  column(12, 
                                         p(),
                                         selectInput(inputId   = 'myhospital',
                                                     label     = h4('Select hospital:', style = "color:#ff0099"),
                                                     selected  = study_hospitals_list[1],
                                                     choices   = study_hospitals_list, width = "420px"),
                                         conditionalPanel("$('html').hasClass('shiny-busy')", h3("Loading...", style="color:#FF0099")),
                                         textOutput("hospital_overlap_red")   %>% h3(style = "color:#ef3b2c"),
                                         textOutput("hospital_overlap_green") %>% h4(style = "color:#a6d96a"),
                                         h4(textOutput("nothing_to_plot_info")),
                                         uiOutput("hospital_timeplot.ui"),
                                         bsCollapsePanel(style = "warning", 'Variables explained (click to expand):',
                                                         includeMarkdown("variables_explained1.md")),
                                         DT::dataTableOutput("teams_summary")))),
                       tabPanel("Info and code", # -------------
                                fluidRow(
                                  column(12, 
                                         p(),
                                         includeMarkdown("README.md"))
                                )
                       )
           )
    )
  )
)



