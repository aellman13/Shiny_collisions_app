library(leaflet)
library(tidyverse)
#### Read and Clean ####

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
collisions$DATE = date(mdy(collisions$DATE))
collisions$BOROUGH = forcats::as_factor(collisions$BOROUGH)
collisions$`VEHICLE 1 FACTOR` = forcats::as_factor(collisions$`VEHICLE 1 FACTOR`)
collisions$`VEHICLE 2 FACTOR` = forcats::as_factor(collisions$`VEHICLE 2 FACTOR`)
collisions$`VEHICLE 1 TYPE` = forcats::as_factor(collisions$`VEHICLE 1 TYPE`)
collisions$`VEHICLE 2 TYPE` = forcats::as_factor(collisions$`VEHICLE 2 TYPE`)
collisions$injury_type = forcats::as_factor(collisions$injury_type)


# Add time Season column 
collisions %>% 
  mutate(Season = if (is.na(DATE)){
                    return(NA)
                  } else if (lubridate::yday(DATE) < 79 & lubridate::yday(DATE) >355){
                    return(forcats::as_factor('Winter'))
                  } else if (lubridate::yday(DATE) <172){
                    return(forcats::as_factor('Spring'))
                  } else if (lubridate::yday(DATE) <266){
                    return(forcats::as_factor('Summer'))
                  } else {return(forcats::as_factor('Fall'))}
  )

collisions$`VEHICLE 1 TYPE` = fct_recode(collisions$`VEHICLE 1 TYPE`, Large_Commercial = "LARGE COM VEH(6 OR MORE TIRES)",
                                        Small_Commercial = "SMALL COM VEH(4 TIRES)",)

#### Mutating Data ####

# Top reasons for collisions
collisions %>% 
  group_by(`VEHICLE 1 FACTOR`) %>% 
  count() %>% 
  arrange(desc(n))

# Top vehicles in collisions
collisions %>% 
  group_by(`VEHICLE 1 TYPE`) %>% 
  count() %>% 
  arrange(desc(n))


####F Filter choices ####


     
  











