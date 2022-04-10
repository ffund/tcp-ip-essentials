library(ggplot2)
dat <- read.csv("sender-ss.csv", header=FALSE)
names(dat) <- c("ts", "sender", "retr", "retr.total", "cwnd", "ssthresh")

senders <- data.frame(table(dat$sender))
sndlist <- senders[senders$Freq > 100,]$Var1

dat <- dat[dat$sender %in% sndlist,] 
dat$sender <- factor(dat$sender)

lost <- na.omit(dat[dat$retr>0,])

tsmin <- min(dat$ts)

q <- ggplot(dat) + geom_line(aes(x=ts-tsmin, y=cwnd, colour=as.factor(sender))) + geom_line(aes(x=ts-tsmin, y=ssthresh, colour=as.factor(sender)), linetype='twodash') 
q <- q + theme_bw() + facet_wrap(~sender, ncol=1, drop=T) + geom_vline(data=lost, aes(xintercept=ts-tsmin, colour=as.factor(sender)), alpha=0.1)
q <- q + scale_y_continuous("CWND") + scale_colour_discrete("Sender") + scale_x_continuous("Time (s)") + theme(legend.position="bottom")


svg("sender-ss.svg")
print(q)
dev.off()
