# Data quality tab
output$teams_summary <- DT::renderDataTable({
  
  if(input$mycountry == "ALL"){return(NULL)}
  
  
  teams_data_summary(input$mycountry) %>% 
    DT::datatable(rownames = FALSE,
                  options = list(pageLength = 100,
                                 # hide columns 10 onwards (used to colour a previous one)
                                 columnDefs = list(list(visible=FALSE, targets=c(10:15))))
    ) %>% 
    formatStyle("red-orange-green", "all_complete",
                background = styleEqual(c("Yes", "Almost", "No"), c(mygreen, myorange, myred))) %>% 
    formatStyle("date_min", "date_min_out",
                background = styleEqual(c("No", "Yes"), c(mygreen, myorange))) %>% 
    formatStyle("date_max", "date_max_out",
                background = styleEqual(c("No", "Yes"), c(mygreen, myorange))) %>% 
    formatStyle("start", "start_missing",
                background = styleEqual(c("No", "Yes"), c(mygreen, myred))) %>% 
    formatStyle("end", "end_missing",
                background = styleEqual(c("No", "Yes"), c(mygreen, myred))) %>% 
    formatStyle("completed",
                backgroundColor = styleEqual(c("Confirmed", "Unconfirmed"), c(mygreen, myred))) %>% 
    formatStyle("internal_check",
                background = styleEqual(c("Yes", "No"), c(mygreen, myred)))
  
  
})