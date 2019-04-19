library(leaflet)
library(tidyverse)
library(DT)
library(shinydashboard)


collisions = collisions %>% 
  mutate(Weekend = ifelse(Weekday %in% c('Saturday', 'Sunday'), 'Weekend', 'Weekday'))


collisions %>%
  filter(Dangerous_or_Deadly == 'DEADLY') %>% 
  group_by(injury_type, BOROUGH) %>% 
  summarize(n=n()) %>%  
  ggplot() + 
  geom_col(aes(x = injury_type, y = n, fill = BOROUGH), position='dodge')
  
x1 = data_frame(x = c('BOROUGH', 'VEHICLE 1 TYPE', 'injury_type', 'VEHICLE 1 FACTOR'))
x1$x = as.factor(x1$x)


collisions %>% 
    filter(Weekday %in% c('Monday', "Tuesday", 'Saturday'),
           between(x = hour(TIME), lower = 10, 
                   upper = 24),
           between(x = DATE, lower = as.Date('2016-04-04'), 
                   upper = '2016-08-04'))
col_sample = sample(x = collisions$`UNIQUE KEY`, size = 40000, replace = F)
collisions %>%
  filter(collisions$`UNIQUE KEY` %in% col_sample)
