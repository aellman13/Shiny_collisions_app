
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
                            column(4, radioButtons("radio", label = h3("Weekend or Weekday"),
                                                   choices = list("All" = c("Weekend", 'Weekday'), 
                                                                  "Weekday" = c('Weekday'), 
                                                                  "Weekend" = c('Weekend')), 
                                                                    selected = c('Weekend'))),
                            column(4, sliderInput("time_slider", label = h3("Time of Day (24 hr)"), 
                                                  min = 0, max = 24, value = c(0,1))),
                            column(4, dateRangeInput("dates", label = h3("Date range"), 
                                                     start = "2015-01-01",
                                                     end = "2017-02-28")),
                            leafletOutput('map', height = 600)),
                            #radioButtons("radio", label = h3("Radio buttons"),
                                    #choices = list("Choice 1" = 1, "Choice 2" = 2), selected = 1),
                    
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
                            plotOutput('plot')
                        
                )
            )
        )
    )
    )

