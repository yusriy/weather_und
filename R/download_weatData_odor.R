# Download data for Nurashikin Yaacoof

library(weatherData)
library(openair)

stationID <- c('WMKP', # PENANG
               'WMKB', # BUTTERWORTH
               'WMKI', # IPOH
               'WMBA') # SITIAWAN)

# Starting and end date most probably in GMT, though from the data might be local
# time
start_date <- '2015-08-01'
end_date <- '2015-09-30'

# Download the data

WMKP <- getWeatherForDate(station_id = stationID[1],start_date,end_date,
                          opt_detailed = TRUE,opt_all_columns = TRUE)
WMKB <- getWeatherForDate(station_id = stationID[2],start_date,end_date,
                          opt_detailed = TRUE,opt_all_columns = TRUE)
WMKI <- getWeatherForDate(station_id = stationID[3],start_date,end_date,
                          opt_detailed = TRUE,opt_all_columns = TRUE)
WMBA <- getWeatherForDate(station_id = stationID[4],start_date,end_date,
                          opt_detailed = TRUE,opt_all_columns = TRUE)

# Rename columns
colnames(WMKP)<-c("date","time1","tempc","dewpc","hum","slp","visibility",
                  "wd","wspd","guspd","prcp","events","conditions","wdd","date_utc")
colnames(WMKB)<-c("date","time1","tempc","dewpc","hum","slp","visibility",
                  "wd","wspd","guspd","prcp","events","conditions","wdd","date_utc")
colnames(WMKI)<-c("date","time1","tempc","dewpc","hum","slp","visibility",
                  "wd","wspd","guspd","prcp","events","conditions","wdd","date_utc")
colnames(WMBA)<-c("date","time1","tempc","dewpc","hum","slp","visibility",
                  "wd","wspd","guspd","prcp","events","conditions","wdd","date_utc")

# Remove unneeded columns
WMKP <- WMKP[,-c(2,4,7,8,10,11,12,13,15)]
WMKB <- WMKB[,-c(2,4,7,8,10,11,12,13,15)]
WMKI <- WMKI[,-c(2,4,7,8,10,11,12,13,15)]
WMBA <- WMBA[,-c(2,4,7,8,10,11,12,13,15)]

# Filter data frame for improbable values
WMKP$tempc[which(WMKP$tempc < 0)] <- NA # Temperatures cannot be < 0 deg C
WMKP$wdd[which(WMKP$wdd < 0 | WMKP$wdd > 360)] <- NA # Direction cannot be < 0 deg or
# > 360 deg
WMKP$wspd[which(WMKP$wspd < 0 | WMKP$wspd=='Calm')] <- NA # Wind speed cannot be < 0 ms-1
WMKP$hum[which(WMKP$hum < 0 | WMKP$hum > 100)]  <- NA # Humidity cannot be < 0 or > 100%
WMKP$wspd <- as.numeric(WMKP$wspd)
WMKP$wspd <- WMKP$wspd * 1000 / 3600

# Filter data frame for improbable values
WMKB$tempc[which(WMKB$tempc < 0)] <- NA # Temperatures cannot be < 0 deg C
WMKB$wdd[which(WMKB$wdd < 0 | WMKB$wdd > 360)] <- NA # Direction cannot be < 0 deg or
# > 360 deg
WMKB$wspd[which(WMKB$wspd < 0 | WMKB$wspd=='Calm')] <- NA # Wind speed cannot be < 0 ms-1
WMKB$hum[which(WMKB$hum < 0 | WMKB$hum > 100)]  <- NA # Humidity cannot be < 0 or > 100%
WMKB$wspd <- as.numeric(WMKB$wspd)
WMKB$wspd <- WMKB$wspd * 1000 / 3600

# Filter data frame for improbable values
WMKI$tempc[which(WMKI$tempc < 0)] <- NA # Temperatures cannot be < 0 deg C
WMKI$wdd[which(WMKI$wdd < 0 | WMKI$wdd > 360)] <- NA # Direction cannot be < 0 deg or
# > 360 deg
WMKI$wspd[which(WMKI$wspd < 0 | WMKI$wspd=='Calm')] <- NA # Wind speed cannot be < 0 ms-1
WMKI$hum[which(WMKI$hum < 0 | WMKI$hum > 100)]  <- NA # Humidity cannot be < 0 or > 100%
WMKI$wspd <- as.numeric(WMKI$wspd)
WMKI$wspd <- WMKI$wspd * 1000 / 3600

# Filter data frame for improbable values
WMBA$tempc[which(WMBA$tempc < 0)] <- NA # Temperatures cannot be < 0 deg C
WMBA$wdd[which(WMBA$wdd < 0 | WMBA$wdd > 360)] <- NA # Direction cannot be < 0 deg or
# > 360 deg
WMBA$wspd[which(WMBA$wspd < 0 | WMBA$wspd=='Calm')] <- NA # Wind speed cannot be < 0 ms-1
WMBA$hum[which(WMBA$hum < 0 | WMBA$hum > 100)]  <- NA # Humidity cannot be < 0 or > 100%
WMBA$wspd <- as.numeric(WMBA$wspd)
WMBA$wspd <- WMBA$wspd * 1000 / 3600

WMKP <- timeAverage(WMKP,avg.time='1 hour',statistic='mean')
WMKB <- timeAverage(WMKB,avg.time='1 hour',statistic='mean')
WMKI <- timeAverage(WMKI,avg.time='1 hour',statistic='mean')
WMBA <- timeAverage(WMBA,avg.time='1 hour',statistic='mean')

## Convert back to local time
WMKP$date <- WMKP$date + 28800
WMKB$date <- WMKB$date + 28800
WMKI$date <- WMKI$date + 28800
WMBA$date <- WMBA$date + 28800

# Write to table
write.table(WMKP,'data/WMKP.csv',sep=',')
write.table(WMKB,'data/WMKB.csv',sep=',')
write.table(WMKI,'data/WMKI.csv',sep=',')
write.table(WMBA,'data/WMBA.csv',sep=',')
