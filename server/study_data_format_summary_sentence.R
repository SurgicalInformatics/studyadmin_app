# N records from country text -------
output$records_info = renderText({
  if(input$mycountry == "ALL"){
    return("Select your country.")
  }else{
    country_info = study_hospitals %>%
      filter(country == input$mycountry)
    
    if (str_detect(input$mycountry, "United") | str_detect(input$mycountry, "Federation")){
      country_article = "the "
    } else {
      country_article = ""
    }
    
    if(nrow(country_info) == 0){return(paste0("0 patients from ", country_article, input$mycountry))}
    
    country_n = country_info$Total %>% sum()
    if(country_n == 1){return(paste0("1 patient from ", country_article, input$mycountry))}
    return(paste(country_n, "patients from", country_article, input$mycountry))
  }
  
})