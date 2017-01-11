library(scales)
library(ggplot2)
library(dplyr)
library(lubridate)
setwd("~/Dropbox/PhD/2016 Gigascience - publication/10 - publication")

# preprocessed data from FitBit Charge HR
hr_xfb <- read.csv("data/out/experiment-1_fitbit.csv",header = T)
summary(as.POSIXct(hr_xfb$date_time))
hr_xfb$date <- strftime(hr_xfb$date_time, "%Y-%m-%d")
hr_xfb$time <- strftime(hr_xfb$date_time, "%H:%M:%S")

# summary XFB
hr_xfb$cnt = 1
hr_xfb.agg <-aggregate(cnt ~ date, data = hr_xfb, FUN = sum, na.rm = TRUE, na.action = NULL)
summary(hr_xfb.agg$cnt)
nrow(hr_xfb)

# gap analysis XFB
date_time <- hr_xfb$date_time
hr_xfb$date_time_diff <- c(0,difftime(date_time[2:length(date_time)],date_time[1:(length(date_time)-1)]))
hr_xfb.sub <- hr_xfb[hr_xfb$date_time_diff > 15,]
hr_xfb.sub$time_h <- as.numeric(strftime(hr_xfb.sub$date_time, format="%H", tz = "UTC"))
hr_xfb.sub.agg <- aggregate(date_time_diff ~ date + time_h, data = hr_xfb.sub, FUN = sum, na.rm = T, na.action = NULL)
hr_xfb.sub.agg$source <- "Experiment #1"
hr_xfb.sub.agg <- hr_xfb.sub.agg[hr_xfb.sub.agg$date != "2016-06-29",] # irrelevant

# preprocessed data from Peak Basis
hr_xpb <- read.csv("data/out/experiment-2_peak.csv",header = T)
summary(as.POSIXct(hr_xpb$date_time))
hr_xpb$date <- strftime(hr_xpb$date_time, "%Y-%m-%d")
hr_xpb$time <- strftime(hr_xpb$date_time, "%H:%M")
hr_xpb$time <- paste(hr_xpb$time, ":00", sep = "") #adding seconds

# summary XPB
hr_xpb$cnt = 1
hr_xpb.sub <- hr_xpb[complete.cases(hr_xpb),]
hr_xpb.agg <-aggregate(cnt ~ date, data = hr_xpb.sub, FUN = sum, na.rm = TRUE, na.action = NULL)
summary(hr_xpb.agg$cnt)
nrow(hr_xpb.sub)

# gaps analysis XPB
date_time <- hr_xpb.sub$date_time
hr_xpb.sub$date_time_diff <- c(0,difftime(date_time[2:length(date_time)],date_time[1:(length(date_time)-1)]))
hr_xpb.sub <- hr_xpb.sub[hr_xpb.sub$date_time_diff > 1,]
hr_xpb.sub$time_h <- as.numeric(strftime(hr_xpb.sub$date_time, format="%H"))
hr_xpb.sub.agg <- aggregate(date_time_diff ~ date + time_h, data = hr_xpb.sub, FUN = sum, na.rm = T, na.action = NULL)
hr_xpb.sub.agg$source <- "Experiment #2"
hr_xpb.sub.agg <- hr_xpb.sub.agg[hr_xpb.sub.agg$date != "2016-10-04",] # irrelevant
hr_xpb.sub.agg$date_time_diff <- hr_xpb.sub.agg$date_time_diff * 60 # in seconds, not minutes :-)

data <- rbind(hr_xfb.sub.agg, hr_xpb.sub.agg)

png(filename = "graphs/01-gaps_in_data_per_day_and_hour.png", 
    width = 1920, height = 1080, units = "px", res = 300, bg = "transparent")
m <- ggplot(data, aes(x = as.Date(date), y = time_h))
m <- m + stat_sum(aes(group = 1, size = date_time_diff, colour = date_time_diff), show.legend = F)
m <- m + theme_bw() + labs(x = "date", y = "hours", colour = "gaps in sec.")
m <- m + scale_y_continuous(breaks = c(0:23)) + scale_x_date(date_minor_breaks = "1 day")
m <- m + scale_colour_distiller(palette = "Spectral")
m <- m + facet_wrap(~source, scales="free_x")
m
dev.off()

# gaps analysis XFB
hr_xfb.sub$night <- (parse_date_time(hr_xfb.sub$time, "%H:%M:%S") > ymd_hms("0000-01-01 00:00:01") &
                     parse_date_time(hr_xfb.sub$time, "%H:%M:%S") < ymd_hms("0000-01-01 07:30:00"))

nrow(hr_xfb.sub[hr_xfb.sub$date_time_diff >     15 & hr_xfb.sub$date_time_diff <   300,])
nrow(hr_xfb.sub[hr_xfb.sub$date_time_diff >=   300 & hr_xfb.sub$date_time_diff <  2700,])
nrow(hr_xfb.sub[hr_xfb.sub$date_time_diff >=  2700 & hr_xfb.sub$date_time_diff < 10000,])
nrow(hr_xfb.sub[hr_xfb.sub$date_time_diff >= 10000,])
nrow(hr_xfb.sub[hr_xfb.sub$date_time_diff >     15,])

nrow(hr_xfb.sub[hr_xfb.sub$date_time_diff >     15 & hr_xfb.sub$date_time_diff <   300 & !hr_xfb.sub$night,])
nrow(hr_xfb.sub[hr_xfb.sub$date_time_diff >=   300 & hr_xfb.sub$date_time_diff <  2700 & !hr_xfb.sub$night,])
nrow(hr_xfb.sub[hr_xfb.sub$date_time_diff >=  2700 & hr_xfb.sub$date_time_diff < 10000 & !hr_xfb.sub$night,])
nrow(hr_xfb.sub[hr_xfb.sub$date_time_diff >= 10000 & !hr_xfb.sub$night,])
nrow(hr_xfb.sub[hr_xfb.sub$date_time_diff >     15 & !hr_xfb.sub$night,])

# gaps analysis XFB
hr_xpb.sub$date_time_diff <- hr_xpb.sub$date_time_diff * 60
hr_xpb.sub$night <- (parse_date_time(hr_xpb.sub$time, "%H:%M:%S") > ymd_hms("0000-01-01 00:00:01") &
                       parse_date_time(hr_xpb.sub$time, "%H:%M:%S") < ymd_hms("0000-01-01 07:30:00"))

nrow(hr_xpb.sub[hr_xpb.sub$date_time_diff >     15 & hr_xpb.sub$date_time_diff <   300,])
nrow(hr_xpb.sub[hr_xpb.sub$date_time_diff >=   300 & hr_xpb.sub$date_time_diff <  2700,])
nrow(hr_xpb.sub[hr_xpb.sub$date_time_diff >=  2700 & hr_xpb.sub$date_time_diff < 10000,])
nrow(hr_xpb.sub[hr_xpb.sub$date_time_diff >= 10000,])
nrow(hr_xpb.sub[hr_xpb.sub$date_time_diff >     15,])

nrow(hr_xpb.sub[hr_xpb.sub$date_time_diff >     15 & hr_xpb.sub$date_time_diff <   300 & !hr_xpb.sub$night,])
nrow(hr_xpb.sub[hr_xpb.sub$date_time_diff >=   300 & hr_xpb.sub$date_time_diff <  2700 & !hr_xpb.sub$night,])
nrow(hr_xpb.sub[hr_xpb.sub$date_time_diff >=  2700 & hr_xpb.sub$date_time_diff < 10000 & !hr_xpb.sub$night,])
nrow(hr_xpb.sub[hr_xpb.sub$date_time_diff >= 10000 & !hr_xpb.sub$night,])
nrow(hr_xpb.sub[hr_xpb.sub$date_time_diff >     15 & !hr_xpb.sub$night,])

# HR summary
hr_xfb$night <- (parse_date_time(hr_xfb$time, "%H:%M:%S") > ymd_hms("0000-01-01 02:00:00") &
                 parse_date_time(hr_xfb$time, "%H:%M:%S") < ymd_hms("0000-01-01 07:30:00"))
hr_xfb$work <- (parse_date_time(hr_xfb$time, "%H:%M:%S") > ymd_hms("0000-01-01 08:00:00") &
                  parse_date_time(hr_xfb$time, "%H:%M:%S") < ymd_hms("0000-01-01 08:30:00"))

summary(hr_xfb$hr[hr_xfb$night]) #Mean: 71.63
summary(hr_xfb$hr[!hr_xfb$night]) #Mean: 92.42
summary(hr_xfb$hr[hr_xfb$work]) #Mean: 100.7

hr_xpb$night <- (parse_date_time(hr_xpb$time, "%H:%M:%S") > ymd_hms("0000-01-01 02:00:00") &
                   parse_date_time(hr_xpb$time, "%H:%M:%S") < ymd_hms("0000-01-01 07:30:00"))
hr_xpb$work <- (parse_date_time(hr_xpb$time, "%H:%M:%S") > ymd_hms("0000-01-01 08:00:00") &
                  parse_date_time(hr_xpb$time, "%H:%M:%S") < ymd_hms("0000-01-01 08:30:00"))

summary(hr_xpb$hr[hr_xpb$night]) #Mean: 71.47
summary(hr_xpb$hr[!hr_xpb$night]) #Mean: 94.74
summary(hr_xpb$hr[hr_xpb$work]) #Mean: 99.46



