library(leaflet)
library(tidyverse)
library(DT)
library(shinydashboard)
library(ggthemes)


#Read in database
collisions = read_csv('database.csv')

#collapse injury type columns in to one column and values in to one column
collisions = collisions %>% gather(key = injury_type, value = num_injuries,
                                   `PERSONS KILLED`,
                                   `PERSONS INJURED`,
                                   `CYCLISTS INJURED`,
                                   `CYCLISTS KILLED`,
                                   `MOTORISTS INJURED`,
                                   `MOTORISTS KILLED`,
                                   `PEDESTRIANS INJURED`,
                                   `PEDESTRIANS KILLED`)

# Change date column in to date class 
collisions$DATE = lubridate::date(lubridate::mdy(collisions$DATE))
collisions$BOROUGH = forcats::as_factor(collisions$BOROUGH)
collisions$`VEHICLE 1 FACTOR` = forcats::as_factor(collisions$`VEHICLE 1 FACTOR`)
collisions$`VEHICLE 2 FACTOR` = forcats::as_factor(collisions$`VEHICLE 2 FACTOR`)
collisions$`VEHICLE 1 TYPE` = forcats::as_factor(collisions$`VEHICLE 1 TYPE`)
collisions$`VEHICLE 2 TYPE` = forcats::as_factor(collisions$`VEHICLE 2 TYPE`)
collisions$injury_type = forcats::as_factor(collisions$injury_type)

# Get rid of extraneous columns
collisions$`VEHICLE 5 FACTOR` = NULL
collisions$`VEHICLE 4 FACTOR` = NULL
collisions$`VEHICLE 3 FACTOR` = NULL
collisions$`VEHICLE 2 FACTOR` = NULL
collisions$`VEHICLE 5 TYPE` = NULL
collisions$`VEHICLE 4 TYPE` = NULL
collisions$`VEHICLE 3 TYPE` = NULL
collisions$`VEHICLE 2 TYPE` = NULL

#Filter dataset down to Vehicle - Person Collisions
collisions = collisions %>% 
  filter(num_injuries>0)

# Fix Column Names
names(collisions) = make.names(names = names(collisions), unique = TRUE)

# Make an hour of the day column
collisions = collisions %>% 
  mutate(Hour_of_Day = lubridate::hour(TIME))

# Add Dangerous or Deadly Column
collisions = collisions %>% 
  mutate(Dangerous_or_Deadly = 
           ifelse(str_detect(injury_type, 'KILLED'), 'DEADLY', 'DANGEROUS'))
collisions$Dangerous_or_Deadly = as.factor(collisions$Dangerous_or_Deadly)

# Add Weekday Column
collisions = collisions %>% 
  mutate(Weekday = weekdays(DATE))

# Add Weekend Column
collisions = collisions %>% 
  mutate(Weekend = ifelse(Weekday=='Saturday'|Weekday=='Sunday', 'Weekend', 'Weekday'))

#Add column for type of Transportation

collisions = collisions %>% 
  mutate(transport = ifelse(str_detect(injury_type, 'PERSONS')|str_detect(injury_type, 'PEDESTRIANS'), 'Pedestrian', 
                            ifelse(str_detect(injury_type, 'CYCLISTS'), 'Cyclist', 'Motorist')))


#Vector for Select input for the Map selector
x1 = data_frame(x = c('BOROUGH', 'VEHICLE.1.TYPE', 'injury_type', 'VEHICLE.1.FACTOR', 'Hour_of_Day'))
x1$x = as.factor(x1$x)


# Sample of rows so that the map is not too cluttered 
col_sample = sample(x = collisions$UNIQUE.KEY, size = 30000, replace = F)  





  
