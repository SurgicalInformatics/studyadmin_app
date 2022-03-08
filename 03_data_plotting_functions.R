library(tidyverse)
library(scales)
library(ggbeeswarm)

var1_missing  = "Missing"

plot_study_data_country = function(mycountry = NULL){
  
  if(mycountry == "ALL"){return("Select a country.")}
  
  plot_data = study_data %>%
    filter(country_name == mycountry) %>% 
    filter(var1 != "Missing") %>% 
    mutate(dummy = 1) %>% 
    mutate(month = month(date)) %>% 
    filter(! is.na(date))
  
  if(nrow(plot_data) == 0){return("Nothing to plot")}
  
  
  plot_data %>% 
    mutate(Record = "Record") %>% 
    mutate(var = var1 %>% fct_drop(only = "Missing") %>% fct_rev()) %>% 
    ggplot(aes(text = var1, x = date, colour = var1, y = fct_rev(dag), alpha = var1, shape = var1)) +
    geom_quasirandom(groupOnX = FALSE, size = 2, stroke = 1) +
    #geom_point() +
    theme_bw() +
    #coord_flip() +
    scale_shape_manual(values = c(21, 22, 24)) +
    scale_colour_manual('',  values = c("#fdc086", "#1f78b4", "#984ea3"), drop = FALSE) +
    scale_alpha_manual('', values = c(0.8, 1, 1),                       drop = FALSE, guide = FALSE) +
    #scale_fill_brewer(palette = 'Paired') +
    ylab('') +
    xlab("Date") +
    theme(
      #axis.ticks.y = element_blank(),
      panel.grid.major.y = element_blank(),
      panel.grid.minor.x = element_blank(),
      legend.position = 'top',
      axis.text.x = element_text(colour='black',  size = 12),
      axis.title.x = element_blank(),
      axis.text.y = element_text(colour='black',  size = 13),
      #strip.text = element_text(size = 20),
      legend.text = element_text(size = 14)) +
    guides(fill = guide_legend(reverse=T), shape = "none") +
    scale_x_date(date_breaks = "1 month",
                 limits = dmy(c("26/3/2018", "7/12/2018")),
                 date_labels = "%b",
                 expand = c(0, 0)) +
    NULL
  
  
}

plot_study_data_hospital = function(myhospital){


  plot_data = study_data %>%
    filter(dag == myhospital) %>% 
    filter(var1 != "Missing") %>% 
    filter(! is.na(date))
  
  if(nrow(plot_data) == 0){return("Nothing to plot")}
  
  n_teams = plot_data$dag_team %>% unique() %>% length()
  
  plot_data %>% 
    mutate(Record = "Record") %>% 
    ggplot(aes(text = paste("Team:", dag_team), x = date, colour = all_complete, y = var1, shape = var1)) +
    geom_quasirandom(groupOnX = FALSE, size = 2) +
    scale_shape_manual(values = c(16, 15, 17)) +
    theme_bw() +
    #coord_flip() +
    scale_colour_manual('', values = c("#4daf4a", "#feb24c", "#e41a1c"), drop = FALSE) +
    #scale_fill_brewer(palette = 'Paired') +
    ylab("") +
    xlab("Date") +
    theme(
      #axis.ticks.y = element_blank(),
      strip.text = element_text(size = 16),
      strip.background = element_rect(fill = "white"),
      panel.grid.minor = element_blank(),
      legend.position = 'none',
      axis.text.x = element_text(colour='black', size = 12),
      axis.text.y = element_text(colour='black', size = 11),
      #strip.text = element_text(size = 20),
      legend.text = element_text(size = 14)) +
    scale_x_date(date_breaks = "1 month",
                     limits = dmy(c("26/3/2018", "7/12/2018")),
                     date_labels = "%b",
                     expand = c(0, 0)) +
    facet_wrap(~dag_team, ncol = 1) +
    guides(shape = "none") +
    NULL
  
  
}

#plot_k2s(mydag = "cz_hrad_charun")
#plot_k2s_country(mycountry = "United States")
#plotly::ggplotly()




# all teams within a hospital
teams_plot_height = function(mycountry, myhospital){
  if(mycountry == "ALL"){
    return("100")
  } else{
    plot_data = study_data %>%
      filter(country_name == mycountry & dag == myhospital) %>% 
      filter(var1 != "Missing")
    
    if(nrow(plot_data) == 0){return("10")}
    
    n_dags = n_distinct(plot_data$dag_team)
    myheight = n_dags*90 + 150
    return(paste0(myheight))
    
  }
}

# all hospitals within a country
hospital_plot_height = function(mycountry){
  if(mycountry == "ALL"){
    return("100")
  } else{
    plot_data = study_data %>%
      filter(country_name == mycountry) %>% 
      filter(var1 != "Missing")
    
    if(nrow(plot_data) == 0){return("10")}
    
    n_dags =  n_distinct(plot_data$dag)
    myheight = n_dags*50 + 100
    return(paste0(myheight))
    
  }
}

# for testing/debugging:
#plot_study_data_hospital("wi_shore_child")
#plot_study_data_country("Ironvale")
#teams_plot_height("Wilarith", "wi_shore_child")

