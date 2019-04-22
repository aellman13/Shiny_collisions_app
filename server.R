
server <- function(input, output){ 
    
      
    
    
    # Data Table for Leaflet Proxy Map
    col_sample = reactive({
        sample(x = collisions$UNIQUE.KEY, size = input$sample, replace = F)  
    })
    
    # filtered1 = reactive({
    #         collisions %>%
    #         filter(UNIQUE.KEY %in% col_sample,
    #                if (input$radio == 'All'){ Weekend == 'Weekend' | Weekend== 'Weekday'
    #                } else{Weekend == input$radio},
    #                between(x = lubridate::hour(TIME), left = input$time_slider[1],
    #                                         right = input$time_slider[2]),
    #                 between(x = DATE, left = input$dates[1],
    #                                     right = input$dates[2]))
    # })
   
    # Initial Map
    output$map <- renderLeaflet({
         leaflet(data = collisions) %>%
            addProviderTiles("OpenStreetMap.Mapnik") %>%
            setView(lng=-73.935242, lat=40.730610 , zoom=11)
        
     
    })
    
    # Leaflet Proxy - Markers
    observe(
        leafletProxy("map", data = collisions %>% 
                                        filter(UNIQUE.KEY %in% col_sample(),
                                               if (input$radio_transport == 'All'){ transport == 'Pedestrian' | 
                                                                                    transport== 'Cyclist'| 
                                                                                    transport== 'Motorist'
                                               } else{transport == input$radio_transport},
                                          if (input$radio_weekend == 'All'){ Weekend == 'Weekend' | Weekend== 'Weekday'
                                          } else{Weekend == input$radio_weekend},
                                          between(x = lubridate::hour(TIME), left = input$time_slider[1],
                                                  right = input$time_slider[2]),
                                          between(x = DATE, left = input$dates[1],
                                                  right = input$dates[2]))) %>% 
            clearMarkerClusters() %>% 
            addMarkers(clusterOptions = markerClusterOptions())
    ) 
    
    # Table #1 - Tab 2 
    observe(
    output$topFactor <- DT::renderDataTable(
        collisions %>% 
            group_by_(input$x_axis) %>% 
            summarise(Percent_of_Total_Collisions = round((n()/nrow(collisions))*100, 2)) %>% 
            arrange(desc(Percent_of_Total_Collisions))
    ))
    # Table 2 - Tab 2
    observe(
        output$topFill <- DT::renderDataTable(
            collisions %>% 
                group_by_(input$fill) %>% 
                summarise(Percent_of_Total_Collisions = round((n()/nrow(collisions))*100, 2)) %>% 
                arrange(desc(Percent_of_Total_Collisions))
        ))
    
    # output$Danger_hours <- renderInfoBox({
    #     infoBox(value = '2-8 PM',
    #             icon = icon("far fa-clock"),
    #             color = "blue")
    #     })
    
    #### Charts ####
    
    
    # Graph - Tab 2
    output$plot = renderPlot({
         collisions %>%
             filter(Dangerous_or_Deadly == input$D_o_D) %>%
             group_by_(input$x_axis, input$fill) %>%
             summarize(n=n()/12) %>% 
             top_n(n = 8, wt = n) %>% 
             ggplot() +
             geom_col(aes_string(x = input$x_axis, y = 'n', fill=input$fill), position = 'dodge') +
            xlab(as.character(input$x_axis)) +
            ylab('Number of Collisions') +
            ggtitle(label = str_c('Average Monthly Collisions by ', 
                                  as.character(input$x_axis), 
                                  ' and ', 
                                  as.character(input$fill))) +
            theme_fivethirtyeight() + 
            scale_color_fivethirtyeight() + 
            theme(plot.title = element_text(hjust = 0.5))
         
     })
   
    
    
    # output$table <- DT::renderDataTable({
    #     datatable(collisions2, rownames=FALSE) %>% 
    #         formatStyle(input$selected,  
    #                 background="skyblue", fontWeight='bold')})
     
     
}