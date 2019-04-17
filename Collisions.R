
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
