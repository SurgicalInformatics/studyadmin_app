# filter authorship table for country ------------
output$authorship <- DT::renderDataTable({
  
  if (input$mycountry=='ALL'){}else{
    authorship = filter(authorship, country == input$mycountry)
  }
  
  authorship %>% 
    select(-team_lastnames) %>% 
    mutate(start = format(start, "%d-%b"), end = format(end, "%d-%b")) %>% 
    DT::datatable(options = list(pageLength = 100), rownames = FALSE)
})
