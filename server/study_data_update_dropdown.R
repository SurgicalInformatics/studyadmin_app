observe({
  
  if(input$mycountry == "ALL"){
    study_hospitals_filtered = study_hospitals
  }else{
    study_hospitals_filtered = filter(study_hospitals, country == input$mycountry)
  }
  
  study_hospitals_filtered_list = study_hospitals_filtered$dag
  names(study_hospitals_filtered_list) = study_hospitals_filtered$hospital
  updateSelectInput(session, "myhospital",
                    choices  = study_hospitals_filtered_list
  )
  
})