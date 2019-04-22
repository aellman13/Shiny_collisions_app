library(leaflet)
library(tidyverse)
library(DT)
library(shinydashboard)
library(ggmap)


collisions = collisions %>% 
  mutate(Weekend = ifelse(Weekday %in% c('Saturday', 'Sunday'), 'Weekend', 'Weekday'))

collisions = collisions %>% 
  mutate(Hour_of_Day = lubridate::hour(TIME))

collisions %>% 
  group_by(Hour_of_Day) %>% 
  summarise(n=n()) %>% 
  arrange(desc(n))


collisions %>% 
  group_by(Weekday) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n)) %>% 
  first()


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


collisions %>%
  filter(collisions$`UNIQUE KEY` %in% col_sample,
         Weekend %in% 'Weekend', 
         between(x = hour(TIME), lower = 0,
                 upper = 24),
         between(x = DATE, lower= as.Date('2015-01-01'),
                 upper = as.Date('2017-01-01'))) %>% 
  group_by(`VEHICLE 1 FACTOR`) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n))
  
