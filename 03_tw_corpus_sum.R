setwd("~/Dropbox/PhD/2016 Gigascience - publication/10 - publication")

# Tweets related to FitBit Charge HR
tw_xfb <- read.csv("data/out/experiment-1_twitter.csv",header = T)
tw_xfb$date <- strptime(tw_xfb$date_time, "%Y-%m-%d")
tw_xfb$all_tweets <- 1
tw_xfb$pos_tweets <- as.integer(as.logical(tw_xfb$sent_num == "1"))
tw_xfb$neg_tweets <- as.integer(as.logical(tw_xfb$sent_num == "-1"))

tw_xfb.stats <- data.frame(date = tw_xfb$date, all_tweets = tw_xfb$all_tweets, pos_tweets = tw_xfb$pos_tweets, neg_tweets = tw_xfb$neg_tweets)
tw_xfb.stats.agg <- aggregate(x = tw_xfb.stats[c("all_tweets","pos_tweets","neg_tweets")], FUN = sum, 
                     by = list(date = tw_xfb.stats$date))
tw_xfb.stats.agg$source <- "Experiment #1"

tw_xfb.sum <- colSums(tw_xfb.stats.agg[c("all_tweets","pos_tweets","neg_tweets")])
tw_xfb.sum
tw_xfb.sum["pos_tweets"]/tw_xfb.sum["neg_tweets"]
summary(tw_xfb.stats.agg[tw_xfb.stats.agg$date != "2016-06-29",c("all_tweets","pos_tweets","neg_tweets")])
nrow(tw_xfb.stats.agg[tw_xfb.stats.agg$all_tweets >= 20,])
nrow(tw_xfb.stats.agg[tw_xfb.stats.agg$all_tweets >= 20,]) / nrow(tw_xfb.stats.agg[tw_xfb.stats.agg$date != "2016-06-29",])

summary(as.POSIXct(tw_xfb$date_time))

# Tweets related Peak Basis
tw_xpb <- read.csv("data/out/experiment-2_twitter.csv",header = T)
tw_xpb$date <- strptime(tw_xpb$date_time, "%Y-%m-%d")
tw_xpb$all_tweets <- 1
tw_xpb$pos_tweets <- as.integer(as.logical(tw_xpb$sent_num == "1"))
tw_xpb$neg_tweets <- as.integer(as.logical(tw_xpb$sent_num == "-1"))

tw_xpb.stats <- data.frame(date = tw_xpb$date, all_tweets = tw_xpb$all_tweets, pos_tweets = tw_xpb$pos_tweets, neg_tweets = tw_xpb$neg_tweets)
tw_xpb.stats.agg <- aggregate(x = tw_xpb.stats[c("all_tweets","pos_tweets","neg_tweets")], FUN = sum, 
                              by = list(date = tw_xpb.stats$date))
tw_xpb.stats.agg$source <- "Experiment #2"

tw_xpb.sum <- colSums(tw_xpb.stats.agg[c("all_tweets","pos_tweets","neg_tweets")])
tw_xpb.sum
tw_xpb.sum["pos_tweets"]/tw_xpb.sum["neg_tweets"]
summary(tw_xpb.stats.agg[tw_xpb.stats.agg$date != "2016-10-04",c("all_tweets","pos_tweets","neg_tweets")])
nrow(tw_xpb.stats.agg[tw_xpb.stats.agg$all_tweets >= 20,])
nrow(tw_xpb.stats.agg[tw_xpb.stats.agg$all_tweets >= 20,]) / nrow(tw_xpb.stats.agg[tw_xpb.stats.agg$date != "2016-10-04",])
summary(as.POSIXct(tw_xpb$date_time))

data <- rbind(tw_xfb.stats.agg[tw_xfb.stats.agg$date != "2016-06-29",], tw_xpb.stats.agg[tw_xpb.stats.agg$date != "2016-10-04",])

png(filename = "graphs/02_counts_of_documents_created_per_day.png", width = 1920, height = 1080, units = "px", res = 300, bg = "transparent")
m <- ggplot(data, aes(x=date,y=all_tweets)) + geom_point(shape = 21, colour = "red", fill = "orange", size = .8)
m <- m + scale_y_continuous(limits=c(0, 25)) + theme_bw()
m <- m + labs(x = "date", y = "count of tweets")
m <- m + geom_smooth(method = "lm", se = FALSE, color='blue', size = .4)
m <- m + facet_wrap(~source, scales="free")
m
dev.off()