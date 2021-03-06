#### R code to plot weather variables from Env. Tech PWS linked ###############
# via Weather Underground (Station: IPULAUPI4)
# Author: Jason Jon Benedict
# Edited: Yusri Yusup
# Date: 2015-06-27

#### 1. Load required libraries #########
# Note: Do not forget to install them first!
library(weatherData)
library(ggplot2)
library(mgcv)
library(scales)
library(plyr)
library(reshape2)
library(gridExtra)
library(lubridate)
#library(weathermetrics) # Does not work

#### 2. Station and date details ############################

# Personal Weather Station (PWS) at Environmental Technology,
# School of Industrial Technology, Universiti Sains Malaysia.
# List of parameters
# * Wind speed (ms-1)
# * Wind direction (deg)
# * Temperature (deg C)
# * Relative humidity (%)

station.id="IPULAUPI4"
date=strftime(as.POSIXct(Sys.Date()),format='%Y-%m-%d')

#### 3. Download detailed weather station data ##############################

# 'wd' stands for 'weather data'
wd<-getDetailedWeather(station.id,date,station_type = "id", opt_all_columns=T)

# Rename columns
colnames(wd)<-c("time","time1","tempc","dewpc","slp","wd","wdd","wspd","guspd",
                "hum","prcp","conditions","cc","rain","software","date_utc",
                "unk")

# Convert to appropriate times, even UTC
# Local time
wd$time<-as.POSIXct(wd$time1,format="%Y-%m-%d %H:%M:%S")
# UTC time
wd$date_utc <-as.POSIXct(wd$date_utc,format='%Y-%m-%d %H:%M:%S')

# Remove unnecessary columns particular to this weather station
wd <- wd[,-c(2,5,9,11,12,13,14,17)]

# Filter data frame for improbable values
wd$tempc[which(wd$tempc < 0)] <- NA # Temperatures cannot be < 0 deg C
wd$dewpc[which(wd$dewpc < 0)] <- NA # Temperatures cannot be < 0 deg C
wd$wdd[which(wd$wdd < 0 | wd$wdd > 360)] <- NA # Direction cannot be < 0 deg or
                                                # > 360 deg
wd$wspd[which(wd$wspd < 0 | wd$wspd=='Calm')] <- NA # Wind speed cannot be < 0 ms-1
wd$hum[which(wd$hum < 0 | wd$hum > 100)]  <- NA # Humidity cannot be < 0 or > 100%

#### 4. Plot temperatures #####################################################

dt_p <- ggplot(wd, aes(time, tempc)) + 
  xlab("Time (local time)") + ylab(as.expression(expression( paste("Temperature (", degree,"C)","\n")))) + 
  geom_line(colour="red",size=2) +
  geom_point(colour="red",size=1)+
  theme_bw() +
  ggtitle(paste('Plot of weather variables for',station.id, 'on',strftime(date,"%d-%b-%Y"))) +
  theme(plot.title = element_text(lineheight=1.2, face="bold",size = 16, colour = "grey20"),
        panel.border = element_rect(colour = "black",fill=F,size=1),
        panel.grid.major = element_line(colour = "grey",size=0.25,linetype='longdash'),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "ivory",colour = "black"))

dt_p

#### 4. Plot windspeed ########################################################

dws_p <- ggplot(wd, aes(time,wspd)) +
  geom_line(col="darkblue",size=2) +       
  ylab("km/h\n")+
  xlab("Time (local time)")+
  scale_y_continuous(limits=c(0,10))+
  theme_bw()+
  theme(plot.title = element_text(lineheight=1.2, face="bold",size = 16, colour = "grey20"),
        panel.border = element_rect(colour = "black",fill=F,size=1),
        panel.grid.major = element_line(colour = "grey",size=0.25,linetype='longdash'),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "ivory",colour = "black"))+        
  ggtitle(paste('Plot of wind speed for',station.id, 'on',strftime(date,"%d-%b-%Y")))

dws_p

#### 5. Plot wind vectors #####################################################

wd$u <- (-1 * wd$wspd) * sin((wd$wdd) * pi / 180.0)
wd$v <- (-1 * wd$wspd) * cos((wd$wdd) * pi / 180.0)
dw = subset(wd, u != 0 & v != 0)

v_breaks = pretty_breaks(n = 5)(min(dw$v):max(dw$v))
v_labels = abs(v_breaks)

dwd_p <-  ggplot(data = dw, aes(x = time, y = 0)) +
  theme_bw() +
  theme(plot.margin = unit(c(0, 1, 0.5, 0.5), 'lines')) +
  geom_segment(aes(xend = time + u*360, yend = v), arrow = arrow(length = unit(0.15, "cm")), size = 0.5) + 
  geom_point(data = subset(dw, !is.na(u)), alpha = 0.5,size=1) +
  ggtitle("Wind vectors\n")+
  scale_y_continuous(name = "Wind Vectors (km/h)\n", labels = v_labels, breaks = v_breaks)+
  theme(plot.title = element_text(lineheight=1.2, face="bold",size = 16, colour = "grey20"),
        panel.border = element_rect(colour = "black",fill=F,size=1),
        panel.grid.major = element_line(colour = "grey",size=0.25,linetype='longdash'),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "ivory",colour = "black")) +
  ggtitle(paste('Plot of wind vectors for',station.id, 'on',strftime(date,"%d-%b-%Y")))

dwd_p

##### 6. Plot Relative Humidity ################################################

dh_p <-  ggplot(wd, aes(time, hum)) + 
  geom_point(colour="royalblue4",size=2) +
  geom_step(col="royalblue",size=2)+
  xlab("Time (local time)") + ylab("Relative Humidity (%)\n") + 
  ggtitle("Relative humidity\n")+
  theme_bw() +
  theme(plot.title = element_text(lineheight=1.2, face="bold",size = 16, colour = "grey20"),
        panel.border = element_rect(colour = "black",fill=F,size=1),
        panel.grid.major = element_line(colour = "grey",size=0.25,linetype='longdash'),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "ivory",colour = "black")) +
  ggtitle(paste('Plot of relative humidity for',station.id, 'on',strftime(date,"%d-%b-%Y")))

dh_p


#### Export weather variables plot to a CSV file ##############################
write.table(wd,'data.csv',sep=',',row.names=FALSE)
# Remove all temporary variables
rm(dw,date,dh_p,dt_p,dws_p,dwd_p,station.id,v_breaks,v_labels)
