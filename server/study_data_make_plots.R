# dates plot ------------

# knife2skin plots ------------
output$country_timeplot <- renderPlot({
  
  if(input$mycountry == "ALL"){return(NULL)}
  
  p = plot_study_data_country(input$mycountry)
  
  if(is.character(p)){
    return(NULL)
  }else{
    print(p)
  }
})

output$hospital_timeplot <- renderPlot({
  
  if(input$mycountry == "ALL" | is.null(input$myhospital)){return(NULL)}
  
  p = plot_study_data_hospital(input$myhospital)

  if(is.character(p)){
    return(NULL)
  }else{
    print(p)
    # plotly::ggplotly(p) %>%
    #   layout(legend = list(
    #     orientation = "v",
    #     y = 1
    #   )
    #   )
  }
})

# No dates entered yet (nothing to plot). ----------
output$nothing_to_plot_info <- renderText({
  
  if(input$mycountry == "ALL" | is.null(input$myhospital)){return(NULL)}
  
  p = plot_study_data_hospital(input$myhospital)
  
  if(is.character(p)){
    return("No dates entered yet (nothing to plot).")
  }else{
    return(NULL)
  }
})

# plotOutput ------------------
output$country_timeplot.ui <- renderUI({
  plotOutput("country_timeplot", height = hospital_plot_height(input$mycountry))
})

# plotlyOutput ------------------
output$hospital_timeplot.ui <- renderUI({
  #("hospital_timeplot", height = teams_plot_height(input$mycountry, input$myhospital), width = 900)
  plotOutput("hospital_timeplot", height = teams_plot_height(input$mycountry, input$myhospital), width = 900)
})






