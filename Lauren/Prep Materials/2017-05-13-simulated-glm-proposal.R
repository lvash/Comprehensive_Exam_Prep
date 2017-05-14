##### Multinomial generalized linear model
##### 13 May 2017
##### LVA

require(foreign)
require(nnet)
require(ggplot2)
require(reshape2)

## Hypothetical predictor: gene expression
## Three outcomes: uninfected, infected/asymptomatic, infected/symptomatic

ml <- read.dta("http://stats.idre.ucla.edu/stat/data/hsbdemo.dta")
with(ml, table(ses, prog))

with(ml, do.call(rbind, tapply(write, prog, function(x) c(M = mean(x), SD = sd(x)))))

ml$prog2 <- relevel(ml$prog, ref = "academic")

#### GLM TEST
simDF<-data.frame(pond=c(rep("Exposed",150), rep("Naive",150)),stat = rep(c("uninfected", "infected-asymptomatic", "infected-symptomatic"), each = 100), gxp = c(rnorm(100,mean=50),rnorm(100,mean=100),rnorm(100,mean=200)))

test <- multinom(pond ~ stat + gxp, data = simDF)

summary(test)

z <- summary(test)$coefficients/summary(test)$standard.errors
z

p <- (1 - pnorm(abs(z), 0, 1)) * 2
p

dses <- data.frame(stat = c("uninfected", "infected-asymptomatic", "infected-symptomatic"), gxp = mean(simDF$gxp))
predict(test, newdata = dses, "probs")


dwrite <- data.frame(stat = rep(c("uninfected", "infected-asymptomatic", "infected-symptomatic"), each = 151), gxp = rep(c(50:200), 3))

## store the predicted probabilities for each value of ses and write
pp.write <- cbind(dwrite, predict(test, newdata = dwrite, type = "probs", se = TRUE))
names(pp.write)[3]<-"probability"
## calculate the mean probabilities within each level of ses
by(pp.write[,2:3], pp.write$stat, colMeans)

## melt data set to long for ggplot2
lpp <- melt(pp.write, id.vars = c("stat", "gxp"), value.name = "probability")
head(lpp)  # view first few rows

ggplot(lpp, aes(x = gxp, y = probability, colour = stat)) + geom_line() + facet_grid(variable ~ ., scales = "free")


### original example
ml$prog2 <- relevel(ml$prog, ref = "academic")
test <- multinom(prog2 ~ ses + write, data = ml)
dses <- data.frame(ses = c("uninfected", "infected-asymptomatic", "infected-symptomatic"), write = mean(ml$write))
predict(test, newdata = dses, "probs")
dwrite <- data.frame(ses = rep(c("uninfected", "infected-asymptomatic", "infected-symptomatic"), each = 41), write = rep(c(30:70),
                                                                                   3))

## store the predicted probabilities for each value of ses and write
pp.write <- cbind(dwrite, predict(test, newdata = dwrite, type = "probs", se = TRUE))

## calculate the mean probabilities within each level of ses
by(pp.write[, 3:5], pp.write$ses, colMeans)
## melt data set to long for ggplot2
lpp <- melt(pp.write, id.vars = c("ses", "write"), value.name = "probability")
head(lpp)  # view first few rows

names(lpp)<-c("HealthStatus","GeneExpression","PondType","Probability")
dim(lpp)
## plot predicted probabilities across write values for each level of ses
## facetted by program type




table(lpp$HealthStatus)

lpp$PondType2<-rep(c("Naive", "Exposed", "Control"),each=123)
lpp$HealthStatus2<-rep(c("uninfected", "infected-asymptomatic", "infected-symptomatic"), each=41, times=3)
# lpp$GenesExpression2<-rep(c(runif(41, min=10,max=60), runif(41,min=10,max=60), runif(41,min=10,max=60)), times=3)
lpp$GenesExpression2<-c(70:30, 30:70, 30:70, 30:70, 30:70, 30:70, 70:30, 30:70, 30:70)

ggplot(lpp, aes(x = GenesExpression2, y = Probability, colour = HealthStatus2)) + geom_line() + facet_grid(PondType2 ~  ., scales = "free")
lpp


data.frame(Reproduction=)
reprod<-c(2.65, 2.57, 2.3, 2.23, 2.3)
surv<-c(11, 17, 23, 27, 15.2)

plot(x=surv, y=reprod)


