# overlap_check text display ---------------


hospital_overlap <- reactive({
  req(input$myhospital)
  if(input$mycountry == "ALL"){return(NULL)}
  
  # hardcoded input values for testing:
  #input = tibble(mycountry = NA, myhospital = NA)
  #input$mycountry = "Ironvale"
  #input$myhospital = "ir_grey_gen"
  overlap_info = teams_data_summary(input$mycountry) %>% 
    filter(str_detect(team_id, input$myhospital)) %>% 
    mutate(hospital_dag = str_remove(team_id, "_[:digit:]{2}$")) %>% 
    distinct(overlap_check) %>% 
    pull(overlap_check)
  
  return(overlap_info)
  
})

output$hospital_overlap_green = renderText({
  
  req(input$myhospital, hospital_overlap())
  
  if(input$mycountry == "ALL"){return(NULL)}
  
  
  if (hospital_overlap() == "No overlap"){
    return("No overlap detected - all teams collecting different periods for different cancers.")
  } else{
    return(NULL)
  }
})


output$hospital_overlap_red = renderText({
  req(input$myhospital, hospital_overlap())
  if(input$mycountry == "ALL"){return(NULL)}
  
  if (hospital_overlap() == "Overlap detected"){
    return("Overlap detected - some teams have overlapping collection periods.")
  } else{
    return(NULL)
  }
})