setwd("~/Dropbox/PhD/2 - 2017 Data - publication/02 - Code and Data")
library(lubridate)
library(dplyr)

## Join HR and Tweets Peak Basis
hr_xpb <- read.csv("data/out/experiment-2_peak.csv",header = T)
tw_xpb <- read.csv("data/out/experiment-2_twitter.csv",header = T)

## Truncate seconds for further join
tw_xpb$date_time <- trunc(strptime(tw_xpb$date_time, "%Y-%m-%d %H:%M:%S"), units = "mins")

hr_xpb$date_time <- as.POSIXct(hr_xpb$date_time)
tw_xpb$date_time <- as.POSIXct(tw_xpb$date_time)

hr_tw_xpb <- left_join(hr_xpb, tw_xpb, by = c("date_time" = "date_time"), suffix = c(".x", ".y"))
hr_tw_xpb <- hr_tw_xpb[order(hr_tw_xpb$date_time),]
hr_tw_xpb <- data.frame(date_time = hr_tw_xpb$date_time, hr = hr_tw_xpb$hr, gsr = hr_tw_xpb$gsr, 
                        sent_num = hr_tw_xpb$sent_num)

write.csv(hr_tw_xpb, file = "data/out/experiment-2.csv", row.names = F)

## Analysis of Gaps in the merged data
hr_tw_xpb.comp <- hr_tw_xpb[complete.cases(hr_tw_xpb),]

rm(hr_xpb)
rm(tw_xpb)
rm(hr_tw_xpb.comp)

## Join HR and Tweets FitBit
hr_xfb <- read.csv("data/out/experiment-1_fitbit.csv",header = T)
tw_xfb <- read.csv("data/out/experiment-1_twitter.csv",header = T)

hr_xfb$date_time <- as.POSIXct(hr_xfb$date_time)
tw_xfb$date_time <- as.POSIXct(tw_xfb$date_time)

## Join both datasets on the nearest date and time
#t1 <- Sys.time()
hr_tw_xfb <- cbind(tw_xfb, hr_xfb[sapply(tw_xfb$date_time, function(x) which.min(abs(difftime(x, hr_xfb$date_time)))), ])
#print( difftime( Sys.time(), t1, units = 'sec'))

hr_tw_xfb.comp <- hr_tw_xfb

## Subset and join back to original dataset to get all values
hr_tw_xfb <- hr_tw_xfb[,c(6,7,4)]
hr_tw_xfb <- left_join(hr_xfb, hr_tw_xfb, by = c("date_time" = "date_time"), suffix = c(".x", ".y"))
hr_tw_xfb <- data.frame(date_time = hr_tw_xfb$date_time, hr = hr_tw_xfb$hr.x, sent_num = hr_tw_xfb$sent_num)

write.csv(hr_tw_xfb, file = "data/out/experiment-1.csv", row.names = F)

## Analysis of Gaps in the merged data
hr_tw_xfb.comp$diff <- difftime(hr_tw_xfb.comp[,2], hr_tw_xfb.comp[,6])
head(hr_tw_xfb.comp$diff[order(-abs(hr_tw_xfb.comp$diff))],n = 20)
hr_tw_xfb.comp$sent_num[abs(hr_tw_xfb.comp$diff) > 15]

rm(hr_xfb)
rm(tw_xfb)
rm(hr_tw_xfb.comp)