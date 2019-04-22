
server <- function(input, output){ 
    
    col_sample = sample(x = collisions$`UNIQUE KEY`, size = 20000, replace = F)    
    
    filtered1 = reactive({
            collisions %>%
            filter(collisions$`UNIQUE KEY` %in% col_sample,
                   if (input$radio == 'All'){ Weekend == 'Weekend' | Weekend== 'Weekday'
                   } else{Weekend == input$radio}, 
                   between(x = hour(TIME), lower = input$time_slider[1],
                                            upper = input$time_slider[2]),
                    between(x = DATE, lower = input$dates[1],
                                        upper = input$dates[2]))
    })


    output$map <- renderLeaflet({
         leaflet(data = collisions) %>%
            addProviderTiles("OpenStreetMap.Mapnik") %>%
            setView(lng=-73.935242, lat=40.730610 , zoom=11)
        
     
    })
    
    observe(
        leafletProxy("map", data = filtered1()) %>% 
            clearMarkerClusters() %>% 
            addMarkers(clusterOptions = markerClusterOptions())
    )
    observe(
    output$topFactor <- DT::renderDataTable(
        filtered1() %>% 
            group_by(`VEHICLE 1 FACTOR`) %>% 
            summarise(n = n()) %>% 
            arrange(desc(n))
    ))
    
    output$Danger_hours <- renderInfoBox({
        infoBox(title = 'Most Dangerous Time Zone', 
                value = '2:00 - 8:00 PM',
                icon = icon("far fa-clock"),
                color = "blue")
        })
    
    #### Charts ####
    
    output$plot = renderPlot({
         collisions %>%
             filter(Dangerous_or_Deadly == input$D_o_D) %>%
             group_by_(input$x_axis, input$fill) %>%
             summarize(n=n()/12) %>%
             ggplot() +
             geom_col(aes_string(x = input$x_axis, y = 'n', fill=input$fill), position='dodge') +
            ggtitle(str_c('Average collision frequency by ', 
                                as.character(input$x_axis), 
                                'and ', 
                                as.character(input$fill), 
                                'per month')) +
            xlab(as.character(input$x_axis)) +
            ylab('Number of Collisions')
         
     })
    
    # output$table <- DT::renderDataTable({
    #     datatable(collisions2, rownames=FALSE) %>% 
    #         formatStyle(input$selected,  
    #                 background="skyblue", fontWeight='bold')})
     
     
}