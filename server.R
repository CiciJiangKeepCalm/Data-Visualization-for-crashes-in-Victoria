
# Define a server for the Shiny app
function(input, output) {
  
  
  output$myMapSummary <- renderLeaflet({
    
    if (input$year=="Summary"){
      leaflet(data = myData) %>%
        addTiles() %>%
        addMarkers(lat = myData$LATITUDE, lng = myData$LONGITUDE, 
                   popup = ~as.character(myData$location ),
                   
                   clusterOptions = markerClusterOptions()) 
    }
    
    else{
      data1 <- myData[which(myData$ACCIDENT_Year==as.numeric(input$year)),]
      leaflet(data = data1) %>%
        addTiles() %>%
       
      addProviderTiles(providers$Esri.NatGeoWorldMap, group = "NationalMap") %>% 
        addTiles(options = providerTileOptions(noWrap = TRUE), group="Toner") %>% 
        addMarkers(
          lng = ~data1$LONGITUDE,
          lat = ~data1$LATITUDE,
          clusterOptions = markerClusterOptions()
    
        ) %>% 
        
        addHeatmap(
          lng = ~data1$LONGITUDE,
          lat = ~data1$LATITUDE,
          radius = 12,
          blur = 20,
          cellSize = 25
        ) %>% 
        
        addLayersControl(
          
          baseGroups = c("NationalMap","Toner"), 
          options = layersControlOptions(collapsed = FALSE)
        )
      
    }
   
  })
  # Find geolocalisation coordinates when user clicks
  observeEvent(input$geoloc, {
    js$geoloc()
  })
  
  # zoom on the corresponding area 
  observe({
    if(!is.null(input$lat)){
      map <- leafletProxy("myMapSummary")
      dist <- 0.2
      lat <- input$lat
      lng <- input$long
      map %>% fitBounds(lng - dist, lat - dist, lng + dist, lat + dist)
    }
  })
  
  output$type<- renderGvis({
    
    # year accident_type
    
    gvisMotionChart(type, idvar="ACCIDENT_TYPE", timevar="ACCIDENT_Year")
    
    
  })


  output$LIGHT_CONDITION<- renderGvis({
    
    # year LIGHT_CONDITION
  
    gvisMotionChart(LIGHT_CONDITION,idvar='LIGHT_CONDITION',timevar = 'ACCIDENT_Year')
                          
    
  })
  
  output$Light_time<- renderPlotly(
  {
    if (input$Range == "Only view the data with light condition is DAY") {
  
      set <- Light_time[which(Light_time$LIGHT_CONDITION=="Day" ),]
          print(
            ggplotly(
              
              ggplot(data = set, aes(x = ACCIDENT_TIME, y = Amount, color=LIGHT_CONDITION)) +
                geom_point() +geom_line() +scale_x_continuous(breaks=set$ACCIDENT_TIME) + labs(x = "Time")

        ) )  
    }  else if (input$Range == "Only view the data except light condition is DAY") {
      
      set <- Light_time[which(Light_time$LIGHT_CONDITION!="Day" ),]
      print(
        ggplotly(
          
          ggplot(data = set, aes(x = ACCIDENT_TIME, y = Amount, color=LIGHT_CONDITION)) +
            geom_point() +geom_line() +scale_x_continuous(breaks=set$ACCIDENT_TIME) + labs(x = "Time")
          
        ) ) 
    }
    else if (input$Range == "View all") {
      print(
        ggplotly(
          
          ggplot(data = Light_time, aes(x = ACCIDENT_TIME, y = Amount, color=LIGHT_CONDITION)) +
            geom_point() +geom_line() +scale_x_continuous(breaks=Light_time$ACCIDENT_TIME) + labs(x = "Time")
          
        ) ) 
    }
       
     else if (input$Range == "Dark No street lights") {
 
        set <- Light_time[which(Light_time$LIGHT_CONDITION=="Dark No street lights" ),]
        print(
          ggplotly(
            
            ggplot(data = set, aes(x = ACCIDENT_TIME, y = Amount,color=LIGHT_CONDITION)) +
              geom_point() +geom_line() +scale_x_continuous(breaks=set$ACCIDENT_TIME) + labs(x = "Time")
            
          ) )  
      }  else if (input$Range == "Dark Street lights off") {
        
        set <- Light_time[which(Light_time$LIGHT_CONDITION=="Dark Street lights off" ),]
        print(
          ggplotly(
            
            ggplot(data = set, aes(x = ACCIDENT_TIME, y = Amount, color=LIGHT_CONDITION)) +
              geom_point() +geom_line() +scale_x_continuous(breaks=set$ACCIDENT_TIME) + labs(x = "Time")
            
          ) ) 
      }
      else if (input$Range == "Dusk/Dawn") {
        
        set <- Light_time[which(Light_time$LIGHT_CONDITION=="Dusk/Dawn" ),]
        print(
          ggplotly(
            
            ggplot(data = set, aes(x = ACCIDENT_TIME, y = Amount, color=LIGHT_CONDITION)) +
              geom_point() +geom_line() +scale_x_continuous(breaks=set$ACCIDENT_TIME) + labs(x = "Time")
            
          ) ) 
      }
      else if (input$Range == "Dark Street lights on") {
        
        set <- Light_time[which(Light_time$LIGHT_CONDITION=="Dark Street lights on" ),]
        print(
          ggplotly(
            
            ggplot(data = set, aes(x = ACCIDENT_TIME, y = Amount,color=LIGHT_CONDITION)) +
              geom_point() +geom_line() +scale_x_continuous(breaks=set$ACCIDENT_TIME) + labs(x = "Time")
            
          ) ) 
      }
      
    })
  
  output$severity<- renderGvis({
    
    # year severity
    
    gvisMotionChart(Severity,idvar='SEVERITY',timevar = 'ACCIDENT_Year')
    
    
  })
  
  output$plot <- renderGvis({
    
    data1 <- dataRegionYear[which(dataRegionYear$ACCIDENT_Year==input$year1 ),]
    
    data1$Rank <-  rank(-data1$Amount,ties.method= "min")
    data1<-arrange(data1,Rank)
    
    data1<-head(data1,input$num)
    
    gvisBarChart(data1,xvar = 'LGA_NAME',yvar = "Amount")
    
    
  })
  
  
  output$myMap <- renderLeaflet({
    
    data1 <- myData[which(myData$ACCIDENT_Year==input$year),]
    
    data1 <- data1[which(data1$LGA_NAME==input$Region),]
    leaflet(data = data1) %>%
      addTiles() %>%
      addMarkers(lat = data1$LATITUDE, lng = data1$LONGITUDE, 
                 popup = ~as.character(data1$location ),
                 
                 clusterOptions = markerClusterOptions()) 
  })
  
  output$type_time<- renderPlotly(
    {
      
      if (input$plotType == "Summary (all types)") {
        print(
          ggplotly(
            
            ggplot(data = type_time, aes(x = ACCIDENT_TIME, y = Amount, color=ACCIDENT_TYPE)) +
              geom_point() +geom_line() +scale_x_continuous(breaks=type_time$ACCIDENT_TIME) + labs(x = "Time")
            
          )) 
        
      }
      else{
      dataset<- type_time[which(type_time$ACCIDENT_TYPE==input$typeAccident),]
      
        print(
          ggplotly(
            
            ggplot(data = dataset, aes(x = ACCIDENT_TIME, y = Amount, color=ACCIDENT_TYPE)) +
              geom_point() +geom_line() +scale_x_continuous(breaks=dataset$ACCIDENT_TIME) + labs(x = "Time")
            
          ))  
  
    
    }
  
  
})

}