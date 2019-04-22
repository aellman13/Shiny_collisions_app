
shinyUI(
    
    dashboardPage(
        dashboardHeader(title = 'My Shiny Project'),
        
        dashboardSidebar(
            sidebarMenu(menuItem(text = 'Collisions Map', tabName = 'map'),
                        menuItem(text = 'Tables and Charts', tabName = 'chart'))),
        
        dashboardBody(
            tabItems(
                # Map page with input selectors
                tabItem(tabName = 'map',
                            column(4, radioButtons("radio_weekend", label = h3("Weekend or Weekday"),
                                                   choices = list("All" = "All", 
                                                                  "Weekday" = c('Weekday'), 
                                                                  "Weekend" = c('Weekend')), 
                                                                  selected = 'All'),
                                   radioButtons("radio_transport", label = h3("Transportation Type"),
                                                choices = list("All" = "All", 
                                                               "Pedestrian" = c('Pedestrian'), 
                                                               "Cyclist" = c('Cyclist'),
                                                               "Motorist" = c('Motorist')), 
                                                selected = 'All')),
                                    
                            column(4, sliderInput("time_slider", label = h3("Time of Day (24 hr)"), 
                                                  min = 0, max = 24, value = c(7,11))),
                                        
                            column(4, dateRangeInput("dates", label = h3("Date range"), 
                                                     start = "2015-01-01",
                                                     end = "2015-12-28"),
                                    br(),
                                   
                                        sliderInput("sample", label = 'Number of data points', min = 5000, max = 100000, value = 20000)),
                                        
                                    box(width = 12, background = 'blue', height = 15),
                                    br(),
                                    # actionButton("update" ,  
                                    #                 label = HTML("Update map and center<br />around provided address"), 
                                    #                 icon("refresh")),
                                    leafletOutput('map', height = 600),
                        
                        box(width = 12, height = 15, background = 'blue')
                            
                        ),
                    
                # Chart Pages with input selectors
                tabItem(tabName = 'chart',
                        
                            column(4, selectizeInput(inputId = "D_o_D", 
                                    label = 'Deadly or Dangerous?', 
                                    choices = levels(collisions$Dangerous_or_Deadly))),
                            column(4,selectizeInput(inputId = "x_axis", 
                                    label = 'Choose Injury Variable', 
                                    choices = x1$x)),
                            column(4,selectizeInput(inputId = "fill", 
                                    label = 'Choose Subset Variable', 
                                    choices = x1$x)),
                        br(),
                        
                            fluidRow(
                                plotOutput('plot'),
                                br(),
                                br(),
                                br(),
                                column(5, 
                                       box(height = 12, background = 'blue', title = 'Top 10 (x axis)'),
                                       DT::dataTableOutput('topFactor')),
                                column(2),
                                column(5,
                                       box(height = 12, background = 'blue', title = 'Top 10 (legend)'),
                                       DT::dataTableOutput('topFill'))
                                )
                            
                        
                        
                )
            )
        )
    )
    )

