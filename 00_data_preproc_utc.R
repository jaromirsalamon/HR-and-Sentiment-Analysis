setwd("~/Dropbox/PhD/2 - 2017 Data - publication/02 - Code and Data")
library(lubridate)

# full - contains data from midnight 10.5.2016 to midnight 29.6.2016 which is full export of data from eXperiment with FitBit
# HR FitBit
hr_xfb <- read.csv("data/in/heart-rate-fitbit-full.csv",header = F)
colnames(hr_xfb) <- c("date","time","hr")
hr_xfb$date_time_utc <- with_tz(ymd_hms(paste(hr_xfb$date, hr_xfb$time),tz = "Europe/Prague"), tz = "UTC")
hr_xfb <- data.frame(date_time_utc = hr_xfb$date, hr = hr_xfb$hr)
write.csv(hr_xfb, file = "data/out/experiment-1_fitbit.csv", row.names = F)

# full - contains data from midnight 30.1.2012 to 14:08:00 12.10.2016 which is full export of data from eXperiment with Peak Basis
# HR Peak Basis
hr_xpb <- read.csv("data/in/bodymetrics_2012-01-30T00-00-00_2016-10-12T14-08-00.csv",header = T)
hr_xpb$date <- ymd_hm(hr_xpb$date, tz = "UTC")
hr_xpb <- hr_xpb[hr_xpb$date >= ymd_hm("2016-08-15 00:00") & hr_xpb$date <= ymd_hm("2016-10-04 23:59"),]
hr_xpb <- data.frame(date_time_utc = hr_xpb$date, hr = hr_xpb$heart.rate, steps = hr_xpb$steps, gsr = hr_xpb$gsr,
                     calories = hr_xpb$calories, temp = hr_xpb$skin.temp)
write.csv(hr_xpb, file = "data/out/experiment-2_peak.csv", row.names = F)

# 12.7.2016 is the latest version of raw and summary data exported from twitter for eXperiment with FitBit
# Twitter FitBit
tw_xfb <- read.csv("data/in/tweets-processing-2016-07-12.csv",header = F)
colnames(tw_xfb) <- c("day_pos","id","date","date_exp","sent_num","user_name","text")
tw_xfb$date_time_utc <- with_tz(ymd_hms(tw_xfb$date, tz = "Europe/Prague"), tz = "UTC")
tw_xfb$date_time_exp <- with_tz(ymd_hms(tw_xfb$date_exp, tz = "Europe/Prague"), tz = "UTC")
tw_xfb <- data.frame(day_pos = tw_xfb$day_pos, date_time_utc = tw_xfb$date_time_utc,
                     date_time_exp = tw_xfb$date_time_exp, sent_num = tw_xfb$sent_num, text = tw_xfb$text)
write.csv(tw_xfb, file = "data/out/experiment-1_twitter.csv", row.names = F)

# 4.10.2016 is the latest version of raw and summary data exported from twitter for eXperiment with Basis
# Twitter Peak Basis
tw_xpb <- read.csv("data/in/tweets-processing-2016-10-04.csv",header = F)
colnames(tw_xpb) <- c("day_pos","id","date","date_exp","sent_num","user_name","text")
tw_xpb$sent_num[tw_xpb$sent_num == 0] = -1 # fix of 0 sentiment, hash tag is #n
tw_xpb$date_time_utc <- with_tz(ymd_hms(tw_xpb$date, tz = "Europe/Prague"), tz = "UTC")
tw_xpb$date_time_exp <- with_tz(ymd_hms(tw_xpb$date_exp, tz = "Europe/Prague"), tz = "UTC")
tw_xpb <- data.frame(day_pos = tw_xpb$day_pos, date_time_utc = tw_xpb$date_time_utc,
                     date_time_exp = tw_xpb$date_time_exp, sent_num = tw_xpb$sent_num, text = tw_xpb$text)
write.csv(tw_xpb, file = "data/out/experiment-2_twitter.csv", row.names = F)
