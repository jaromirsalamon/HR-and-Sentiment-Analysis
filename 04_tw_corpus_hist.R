setwd("~/Dropbox/PhD/2016 Gigascience - publication/10 - publication")
library(ggplot2)
library(lubridate)

# Tweets related to FitBit Charge HR
tw_xfb <- read.csv("data/out/experiment-1_twitter.csv",header = T, stringsAsFactors = F)
tw_xfb$sent[tw_xfb$sent_num == -1] <- "negative"
tw_xfb$sent[tw_xfb$sent_num == 1] <- "positive"
tw_xfb$source <- "Experiment #1"

# factor for plot 1
tw_xfb$time_h <- strftime(tw_xfb$date_time, format="%H")
tw_xfb$time_h_fact <- factor(tw_xfb$time_h, levels = unique(as.character(tw_xfb$time_h)))

# factor for plot 2
tw_xfb$date_time_diff <- abs(as.numeric(difftime(strptime(tw_xfb$date_time,"%Y-%m-%d %H:%M:%S"), 
                                             strptime(tw_xfb$date_time_exp,"%Y-%m-%d %H:%M:%S"))))
tw_xfb.sub <- tw_xfb[(tw_xfb$date_time_diff > 0 & tw_xfb$date_time_diff <= 5400),]
tw_xfb.sub <- tw_xfb.sub[as.numeric(tw_xfb.sub$time_h) != 1,]

# Tweets related to Peak Basis
tw_xpb <- read.csv("data/out/experiment-2_twitter.csv",header = T, stringsAsFactors = F)
tw_xpb$sent[tw_xpb$sent_num == -1] <- "negative"
tw_xpb$sent[tw_xpb$sent_num == 1] <- "positive"
tw_xpb$source <- "Experiment #2"

# factor for plot 1
tw_xpb$time_h <- strftime(tw_xpb$date_time, format="%H")
tw_xpb$time_h_fact <- factor(tw_xpb$time_h, levels = unique(as.character(tw_xpb$time_h)))

# factor for plot 2
tw_xpb$date_time_diff <- abs(as.numeric(difftime(strptime(tw_xpb$date_time,"%Y-%m-%d %H:%M:%S"), 
                                                 strptime(tw_xpb$date_time_exp,"%Y-%m-%d %H:%M:%S"))))
tw_xpb.sub <- tw_xpb[(tw_xpb$date_time_diff > 0 & tw_xpb$date_time_diff <= 5400),]
tw_xpb.sub <- tw_xpb.sub[as.numeric(tw_xpb.sub$time_h) != 1,]

data <- rbind(tw_xfb.sub, tw_xpb.sub)

png(filename = "03_tweets_per_hour.png", 
    width = 2200, height = 1000, units = "px", res = 300, bg = "transparent")
m <- ggplot(data, aes(time_h_fact, fill = sent)) + geom_bar() + theme_bw()
m <- m + labs(x = "hours", y = "count of tweets")
m <- m + facet_wrap(~source, scales="free_x")
m <- m + scale_x_discrete(labels = c("7","","9","","11","","13","","15","","17","","19","","21","","23",""))
m
dev.off()

png(filename = "04_tweets_difference_to_expected.png", 
    width = 2200, height = 1000, units = "px", res = 300, bg = "transparent")
m <- ggplot(data, aes(round(date_time_diff/60), fill=sent)) + geom_bar() + theme_bw()
m <- m + labs(x = "minutes", y = "count of tweets")
m <- m + facet_wrap(~source, scales="fixed")
m <- m + scale_x_continuous(limits = c(0, 45))
m
dev.off()