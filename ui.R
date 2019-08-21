library(datasets)
library("googleVis")
library(leaflet)

fluidPage(theme = shinytheme("united"),

navbarPage(h4("Analyse of Crashes in Victoria"),
           
           tabPanel('Introduction',
                    sidebarLayout(    
                      sidebarPanel(
                     
                        h5('In Australia, there were 19.2 million registered motor vehicles as at 31 January 2018. The
potential losses of car crashes are significant which not only threatens the life of residents
                                   but also cause vital losses to the society and economy.'
),
hr(),
       h5('On this website , you can see the trend of
            number of crashes between 2014-2018. Also the amount of crashes
in a selected region and the top Region have most crashes was given.
Besides,  trends of different light condition, 
          accident type and so on between years and hours were included.'
                                  ) ,
hr(),
h6('Data source: Crashes-last-five-years, retrieved from https://www.data.vic.gov.au/data/dataset/crasheslast-
five-years')),
                        
                    img(src='https://thumbs.dreamstime.com/z/cars-road-seamless-pattern-funny-small-car-van-lorry-bus-trees-signs-children-vector-illustration-kids-91444195.jpg?imwidth=450',height = 500)
                    
                      ))
                      
           ,
    
               tabPanel("Summary on Map",
       
                        sidebarLayout(    
                          sidebarPanel(
                           
                            selectInput("year", "Choose summary or select a certain year", 
                                        c("Summary"="Summary",
                                          "2014"="2014",
                                          "2015"="2015",
                                          "2016"="2016",
                                          "2017"="2017",
                                          "2018"="2018"
                                        ),selected ="2016"
                                        
                            ),
                            useShinyjs(),
                            
                            extendShinyjs(text = jsCode),
                            # One button and one map
                            br(),
                            actionButton("geoloc", "Localize me", class="btn btn-pill btn-light", onClick="shinyjs.geoloc()"),
                            
                            hr(),
                            helpText("'Localize me' helps showing the map of your current location")
                            ),
                            mainPanel(
                     
                            leafletOutput("myMapSummary")
                            ) 
                            
                        )),
                          
               
               tabPanel("Rank between Region",
                        
                        titlePanel("Top region has most crashes"),
                        sidebarLayout(      
                          sidebarPanel(
                            numericInput("num", "Please enter the number of Region you'd like to view on ranking list", value = 5),
                            selectInput("year1", "Choose year:", 
                                        c(
                                          "2014"="2014",
                                          "2015"="2015",
                                          "2016"="2016",
                                          "2017"="2017",
                                          "2018"="2018"
                                        ),selected ="2016"
                                        
                            ),
       
                            hr(),
                            helpText("Please enter a number smaller than 10."),
                            
                            selectInput("Region", label = h3("Region"), 
                                        choices = myData$LGA_NAME),
                            hr(),
                            helpText("Please choose a region to view its data on the map")
                          ),
                          mainPanel(
                            htmlOutput("plot"),
                            leafletOutput("myMap")
                            
                          )
                        )
               ),
               navbarMenu('Change between year',
                          tabPanel("Severity",
          
                                   sidebarLayout(      
                                     sidebarPanel('Here shows interactive chart between the amount of accidents in
                                                  specific severity and Year'
                             
                                     ),
                                     
                                     mainPanel(
                                       htmlOutput("severity")
                                     )
                                   )
                          ),
                          tabPanel("Light condition",
                                   sidebarLayout(      
                                    
                                     sidebarPanel('Here shows interactive chart between the amount of accidents in
                                                  specific light condition and Year'
                                       
                                     ),
                                     
                                     mainPanel(
                                       htmlOutput("LIGHT_CONDITION")
                                     )
                                   )),
                          tabPanel("Accident type",
                                   sidebarLayout(      
                                     
                                     sidebarPanel(
                                       'Here shows interactive chart between the amount of accidents in
                                                  specific accident type and Year'
                   
                                     ),
                                     
                                     mainPanel(
                                       htmlOutput("type")
                                     )
                                   ))
               ),
           navbarMenu('Change between hours',
   
                      tabPanel("Light condition",
                               sidebarLayout(      
                                 
                                 sidebarPanel(
                                   radioButtons("Range", "Please select your data range",
                                                c("Only view the data with light condition is DAY", 
                                                  "Only view the data except light condition is DAY",
                                                  "View all",
                                                  "Dark No street lights",
                                                 "Dark Street lights off",
                                                 "Dark Street lights on",
                                                 "Dusk/Dawn"
                                                 
                                               )
                                               
                                   )
                                   
                                 ),
                                 mainPanel(
                                   plotlyOutput("Light_time")
                             
                                 )
                               )),
                      tabPanel("Accident type",
                       sidebarLayout(      
                         
                         sidebarPanel(
                           radioButtons("plotType", "Please select your view choice",
                                        c("Summary (all types)", 
                                          "Only view one type")
                                        ),
                           hr(),
                           helpText("If you select 'Only view one type', please select a type from  below"),
                           selectInput("typeAccident", "Accident Type", 
                                       choices = myData$ACCIDENT_TYPE)
                          
                           
                         ),
                         mainPanel(
                           plotlyOutput("type_time")
                           
                         )
                       )
                      ))
      

))
  