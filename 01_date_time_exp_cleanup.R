setwd("~/Dropbox/PhD/2016 Gigascience - publication/10 - publication")
library(ggplot2)
library(lubridate)

### Tweets related to FitBit Charge HR
tw_xfb <- read.csv("data/out/experiment-1_twitter.csv",header = T, stringsAsFactors = F)
# reference diff calculation
tw_xfb$date_time_diff <- abs(as.numeric(difftime(strptime(tw_xfb$date_time,"%Y-%m-%d %H:%M:%S"), strptime(tw_xfb$date_time_exp,"%Y-%m-%d %H:%M:%S"))))
#nrow(tw_xfb[tw_xfb$date_time_diff < 0, c(2,3,6)]) #0
#nrow(tw_xfb[tw_xfb$date_time_diff > 5400, c(2,3,6)]) #7

# fix of big differences
dt <- paste(strftime(tw_xfb$date_time[tw_xfb$date_time_diff > 5400], format="%Y-%m-%d")," 23:59:59")
tw_xfb$date_time_exp[tw_xfb$date_time_diff > 5400] <- strftime(ymd_hms(dt, tz = "Europe/Prague") + days(-1),"%Y-%m-%d %H:%M:%S")
rm(dt)
# reference diff recalcution
tw_xfb$date_time_diff <- abs(as.numeric(difftime(strptime(tw_xfb$date_time,"%Y-%m-%d %H:%M:%S"), strptime(tw_xfb$date_time_exp,"%Y-%m-%d %H:%M:%S"))))
#nrow(tw_xfb[tw_xfb$date_time_diff < 0, c(2,3,6)]) #0
#nrow(tw_xfb[tw_xfb$date_time_diff > 5400, c(2,3,6)]) #2

tw_xfb <- data.frame(day_pos = tw_xfb$day_pos, date_time = tw_xfb$date_time, 
                     date_time_exp = tw_xfb$date_time_exp, sent_num = tw_xfb$sent_num, text = tw_xfb$text)
write.csv(tw_xfb, file = "data/out/experiment-1_twitter.csv", row.names = F)

### Tweets related to Peak Basis
tw_xpb <- read.csv("data/out/experiment-2_twitter.csv",header = T, stringsAsFactors = F)
# reference diff calculation
tw_xpb$date_time_diff <- abs(as.numeric(difftime(strptime(tw_xpb$date_time,"%Y-%m-%d %H:%M:%S"), strptime(tw_xpb$date_time_exp,"%Y-%m-%d %H:%M:%S"))))
#nrow(tw_xpb[tw_xpb$date_time_diff < 0, c(2,3,6)]) #0
#nrow(tw_xpb[tw_xpb$date_time_diff > 5400, c(2,3,6)]) #9

# fix of big differences
dt <- paste(strftime(tw_xpb$date_time[tw_xpb$date_time_diff > 5400], format="%Y-%m-%d")," 23:59:59")
tw_xpb$date_time_exp[tw_xpb$date_time_diff > 5400] <- strftime(ymd_hms(dt, tz = "Europe/Prague") + days(-1),"%Y-%m-%d %H:%M:%S")
rm(dt)
# reference diff recalcution
tw_xpb$date_time_diff <- abs(as.numeric(difftime(strptime(tw_xpb$date_time,"%Y-%m-%d %H:%M:%S"), strptime(tw_xpb$date_time_exp,"%Y-%m-%d %H:%M:%S"))))
#nrow(tw_xpb[tw_xpb$date_time_diff < 0, c(2,3,6)]) #0
#nrow(tw_xpb[tw_xpb$date_time_diff > 5400, c(2,3,6)]) #0

tw_xpb <- data.frame(day_pos = tw_xpb$day_pos, date_time = tw_xpb$date_time, 
                     date_time_exp = tw_xpb$date_time_exp, sent_num = tw_xpb$sent_num, text = tw_xpb$text)
write.csv(tw_xpb, file = "data/out/experiment-2_twitter.csv", row.names = F)


### time diff analysis of records with wrong date_time_exp attached
# Tweets related to FitBit Charge HR
tw_xfb$dummy = 1
tw_xfb.agg <-aggregate(dummy ~ date_time_exp, data = tw_xfb, sum)
nrow(tw_xfb.agg[tw_xfb.agg$dummy > 1,]) #32
#tw_xfb.agg[tw_xfb.agg$dummy > 1,]

tw_xfb.sub$dummy = 1
tw_xfb.sub.agg <-aggregate(dummy ~ date_time_exp, data = tw_xfb.sub, sum)
nrow(tw_xfb.sub.agg[tw_xfb.sub.agg$dummy > 1,]) #32

# Tweets related to Peak Basis
tw_xpb$dummy = 1
tw_xpb.agg <-aggregate(dummy ~ date_time_exp, data = tw_xpb, sum)
nrow(tw_xpb.agg[tw_xpb.agg$dummy > 1,]) #8
#tw_xpb.agg[tw_xpb.agg$dummy > 1,]

tw_xpb.sub$dummy = 1
tw_xpb.sub.agg <-aggregate(dummy ~ date_time_exp, data = tw_xpb.sub, sum)
nrow(tw_xpb.sub.agg[tw_xpb.sub.agg$dummy > 1,]) #8