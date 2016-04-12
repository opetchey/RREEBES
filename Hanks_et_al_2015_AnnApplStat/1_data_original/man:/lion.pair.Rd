
\name{lion.pair}
\alias{lion.pair}
\docType{data}
\title{
Telemetry data for mountain lions.
}
\description{
Telemetry data for two mountain lions in the Front range cougar study.
An adult female, AF79, and her subadult cub, AM80.
}
\usage{data(lion.pair)}
\examples{
\dontrun{
data(lion.pair)
attach(lion.pair)
lion1$ID
lion2$ID


##
## Running CRAWL on the lions
##

## subsetting time

startmintime=mintime

mintime=4103.085
maxtime=mintime+21

time.idx.1=which(lion1$locs.orig[,3] >= mintime & lion1$locs.orig[,3]<maxtime)
time.idx.2=which(lion2$locs.orig[,3] >= mintime & lion2$locs.orig[,3]<maxtime)

## Running crawl on lion1

lion1$locs=lion1$locs.orig[time.idx.1,]
ini.list <- list(a1.x=c(lion1$locs[1,1], 0),a1.y=c(lion1$locs[1,2], 0),P1.x=diag(c(1,1)),P1.y=diag(c(1,1)))
crawl.fit=crwMLE(data=lion1$locs,coord=c("UTM_X","UTM_Y"),Time.name="datetime",drift.model=FALSE,err.model=list(x=~1, y=~1),initial.state=ini.list,control=list(maxit=2000,trace=1, REPORT=10),polar.coord=FALSE,fixPar=c(log(10/4), log(10/4), NA,NA),initialSANN=list(maxit=2500,trace=1, REPORT=10),need.hess=1)
## pred times every 5 minute:
pred.times <- seq(min(lion1$locs$datetime), max(lion1$locs$datetime), 1/24/10) 
predObj <- crwPredict(object.crwFit=crawl.fit, pred.times, speedEst=TRUE, flat=FALSE,getUseAvail=TRUE)
sim.obj <- crwSimulator(crawl.fit,pred.times,parIS=1000,df=20,scale=18/20)
lion1$crawl.fit=crawl.fit
lion1$pred.times=pred.times
lion1$pred.obj=predObj
lion1$sim.obj=sim.obj
lion.pair$lion1 <- lion1

## Running crawl on lion2

lion2$locs=lion2$locs.orig[time.idx.2,]
ini.list <- list(a1.x=c(lion2$locs[1,1], 0),a1.y=c(lion2$locs[1,2], 0),P1.x=diag(c(1,1)),P1.y=diag(c(1,1)))
crawl.fit=crwMLE(data=lion2$locs,coord=c("UTM_X","UTM_Y"),Time.name="datetime",drift.model=FALSE,err.model=list(x=~1, y=~1),initial.state=ini.list,control=list(maxit=2000,trace=1, REPORT=10),polar.coord=FALSE,fixPar=c(log(10/4), log(10/4), NA,NA),initialSANN=list(maxit=500,trace=1, REPORT=10),need.hess=1)
## pred times every 5 minute:
pred.times <- seq(min(lion2$locs$datetime), max(lion2$locs$datetime), 1/24/10) 
predObj <- crwPredict(object.crwFit=crawl.fit, pred.times, speedEst=TRUE, flat=FALSE,getUseAvail=TRUE)
## Create crawl simulator object
## Note: this can take a LONG time
sim.obj <- crwSimulator(crawl.fit,pred.times,parIS=1000,df=20,scale=18/20)
lion2$crawl.fit=crawl.fit
lion2$pred.times=pred.times
lion2$pred.obj=predObj
lion2$sim.obj=sim.obj
lion.pair$lion2 <- lion2


##
## Plot animals over time
##
simlist=list(lion1$sim.obj,lion2$sim.obj)
movie.times=seq(mintime,maxtime,length.out=50)

## backdrop raster for plot
backdrop=stack.cropped[[7]]
#plot.ani.interact(simlist,backdrop,movie.times,legend=F,col.list=c("red","blue"),pdfname="MF.pdf")



##
##
## Data Analysis
##
##

AF79=lion1
AM80=lion2


time.idx.1=which(AF79$locs[,3] >= mintime-2 & AF79$locs[,3]<maxtime+2)
time.idx.2=which(AM80$locs[,3] >= mintime-2 & AM80$locs[,3]<maxtime+2)

mintime=max(mintime,min(AF79$locs[,3]),min(AM80$locs[,3]))
maxtime=min(maxtime,max(AF79$locs[,3]),max(AM80$locs[,3]))

#plot(stack.cropped)
#round(cor(values(stack.cropped),na.rm=T),2)

##
##
## Get Rasters for static covariates
##
##

intercept=stack.cropped[[1]]
values(intercept) <- 1

NotForest=stack.cropped[[1]]+stack.cropped[[2]]+stack.cropped[[3]]+stack.cropped[[4]]+stack.cropped[[6]]

static.cover=stack(intercept,NotForest)
names(static.cover) <- c("Intercept","NotForest")

##
##
## Get Rasters for dynamic covariates
##
##


cl=FindCenters(AM80,mintime=mintime,maxtime=maxtime,max.dist=200,max.time.dist=27,nightonly=T)
#cl=FindCenters(AF79,mintime=mintime,maxtime=maxtime,max.dist=200,max.time.dist=27,nightonly=T)
cl
kill.sites.rast=intercept
values(kill.sites.rast) <- NA
cent.cells=cellFromXY(kill.sites.rast,cl$clusters)
values(kill.sites.rast)[cent.cells] <- 0
d2kill=distance(kill.sites.rast)
plot(d2kill)

dynamic.stack=stack(d2kill,stack.cropped[[7]])
names(dynamic.stack) <- c("Dist2Kill","Elevation")


##
##
## Making spline knots for time-homogeneous model
##
##

knot.intervals.static=c(0)
knot.intervals.grad=c(0)
knot.intervals.ani=0
knot.intervals.crw=0
knot.intervals=list(static=knot.intervals.static,grad=knot.intervals.grad,ani=knot.intervals.ani,crw=knot.intervals.crw)

knot.intervals

spl.list=make.spline.list(mintime,maxtime,knot.intervals)

## pick time intervals to linearly interpolate between crawl times
t.interval=1/24/60/60




##
## MI approach (10 paths)
##

ctds.AM80=ctds.MI.prep(AM80$sim.obj,spl.list,NotForest,d2kill,conspecifics.list=list(AF79$sim.obj),num.crawl.paths=10,crw=TRUE,path.aug.interval=t.interval)

glm.out.AM80=ctds.glm.MI(ctds.AM80,method="MI",plot.cv=FALSE)

## getting betas
times.betas=0

beta.mat.AM80=get.betas(glm.out.AM80,spl.list,times.betas)
sd.mat.AM80=get.betas.sd(glm.out.AM80,spl.list,times.betas)

beta.mat.AM80
sd.mat.AM80



##
## Bayes with mh step
##

tune=.1
sd=sd.mat.AM80[1,]
sd[1] <- glm.out.AM80$intercept.sd

Phi=ctds.AM80$Phi[[1]]
tune.mat=as.matrix(solve(t(Phi)%*%Phi))

alpha.tune=tune*tune.mat
intercept.tune=.01

alpha.start=beta.mat.AM80[1,]
intercept.start <- glm.out.AM80$intercept

ctds.AM80.bayes=ctds.bayes.mh(AM80$sim.obj,spl.list,NotForest,d2kill,conspecifics.list=list(AF79$sim.obj),crw=TRUE,path.aug.interval=t.interval,alpha.start=alpha.start,intercept.start=intercept.start,intercept.tune=intercept.tune,alpha.tune.mat=alpha.tune,n.mcmc=20)

matplot(ctds.AM80.bayes$alpha.save,type="l")
ctds.AM80.bayes$accept

alphas.glm=glm.out.AM80$alpha
sd.glm=c(glm.out.AM80$alpha.sd)



beta.names.AM80 <- c("(a)  Static Cover - Not Forest","(b) Dynamic Covariate - Direction to Nearest Potential Kill Site","(c) Dynamic Covariate - Direction to AF79","(d) CRW Autoregressive Parameter")

#pdf("HistBayesMI.pdf",width=8,height=5)
par(mfrow=c(2,2))
for(i in 1:4){
  hist(ctds.AM80.bayes$alpha.save[,i],col=i)
  abline(v=alphas.glm[i],lwd=5)
  abline(v=alphas.glm[i]+1.96*sd.glm[i],lty=2,lwd=3)
  abline(v=alphas.glm[i]-1.96*sd.glm[i],lty=2,lwd=3)
}
#dev.off()





##
## Time-Varying Coefficient Analysis (with Lasso)
##


##
##
## Making spline knots for varying-coefficient model
##
##

knot.intervals.static=c(1/4)
knot.intervals.grad=c(1/4)
knot.intervals.ani=1/4
knot.intervals.crw=1/4
knot.intervals=list(static=knot.intervals.static,grad=knot.intervals.grad,ani=knot.intervals.ani,crw=knot.intervals.crw)

knot.intervals

spl.list=make.spline.list(0,1,knot.intervals,spl.option.idx=20)

## pick time intervals to linearly interpolate between crawl times
t.interval=1/24/60/60




##
## MI with stacked lasso
##


ctds.AM80=ctds.MI.prep(AM80$sim.obj,spl.list,NotForest,d2kill,conspecifics.list=list(AF79$sim.obj),num.crawl.paths=10,crw=TRUE,path.aug.interval=t.interval,spline.period=1)

glm.out.AM80=ctds.glm.MI(ctds.AM80,method="MI",plot.cv=FALSE)
glm.out.AM80.lasso=ctds.glm.MI(ctds.AM80,method="Stacked.cv",plot.cv=TRUE)


## Plotting betas
times.betas=seq(0,1,1/24/6)
beta.mat.AM80=get.betas(glm.out.AM80.lasso,spl.list,times.betas)
matplot(beta.mat.AM80,ylim=c(-1,1),type="l")


##
## Fully Bayesian version with Time-Varying Coefficient Model and Lasso Penalty
##

## Prep for Bayesian version
alpha.start=glm.out.AM80.lasso$alpha
alpha.tune=diag(glm.out.AM80$alpha.sd^2)
intercept.start=glm.out.AM80.lasso$intercept
intercept.var=glm.out.AM80$intercept.sd^2

lambda.cv=glm.out.AM80.lasso$lambda.best

tune=.05

## MCMC

library(statmod)
ctds.AM80.bayes.lasso=ctds.bayes.lasso(AM80$sim.obj,spl.list,NotForest,d2kill,conspecifics.list=list(AF79$sim.obj),crw=TRUE,path.aug.interval=t.interval,intercept.start=intercept.start,intercept.tune=tune*intercept.var,alpha.start=alpha.start,alpha.tune.mat=tune*alpha.tune,lambda=lambda.cv,spline.period=1,n.mcmc=20)

matplot(ctds.AM80.bayes.lasso$alpha.save,type="l")
ctds.AM80.bayes.lasso$accept


## source("plot.betas.r")
plot.betas(ctds.AM80.bayes.lasso,spl.list,times.betas)
plot.betas(glm.out.AM80,spl.list,times.betas)
## getting betas

betas.lasso <- get.betas(ctds.AM80.bayes.lasso,spl.list,times.betas)
betas.sd.lasso <- get.betas.sd(ctds.AM80.bayes.lasso,spl.list,times.betas)


beta.names.AM80 <- c("(a) Static Cover - Not Forest","(b) Dynamic Covariate - Direction to Nearest Potential Kill Site","(c) Dynamic Covariate - Direction to AF79","(d) CRW Autoregressive Parameter")
beta.names.AM80 <- c("(a) Cover - Not Forest","(b) Direction to Nearest PKS","(c) Direction to Conspecific","(d) CRW Autoregressive Parameter")



##pdf("LassoResults.pdf",width=8,height=7)
par(mfrow=c(2,2))
for(i in 1:4){
  max.val=max(betas.lasso[,i]+1.6*betas.sd.lasso[,i])
  min.val=min(betas.lasso[,i]-1.6*betas.sd.lasso[,i])
  plot(times.betas*24,betas.lasso[,i],col="black",type="l",lwd=3,main=beta.names.AM80[i],ylim=c(min.val,max.val),xlab="Hour of the Day",ylab=expression(beta))
  abline(h=0)
  points(times.betas*24,betas.lasso[,i]+1.96*betas.sd.lasso[,i],col="black",type="l",lty=3,lwd=2)
  points(times.betas*24,betas.lasso[,i]-1.96*betas.sd.lasso[,i],col="black",type="l",lty=3,lwd=2)
  points(times.betas*24,beta.mat.AM80[,i],col="black",type="l",lty=2,lwd=2)
  if(i==1){
      legend("bottomright",legend=c("Lasso Estimate","Bayesian Posterior Mean","Bayesian Posterior CI"),lty=c(2,1,3),lwd=2)
  }
}
##dev.off()
}
}

\format{

}
\details{
%%  ~~ If necessary, more details than the __description__ above ~~
}
\source{
%%  ~~ reference to a publication or URL from which the data were obtained ~~
}
\references{
%%  ~~ possibly secondary sources and usages ~~
}
\keyword{datasets}
