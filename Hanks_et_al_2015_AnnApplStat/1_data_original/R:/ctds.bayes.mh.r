
ctds.bayes.mh <- function(sim.obj,spline.list,stack.static,stack.grad,conspecifics.list=NULL,crw=TRUE,path.aug.interval=0,spline.period=0,s2=10^6,intercept.start=0,intercept.tune=1,alpha.start,alpha.tune.mat,n.mcmc=10){


  ##
  ## Preliminaries
  ##

  alpha.prior.var=diag(s2,length(alpha.start))

  loglik.pois <- function(z,tau,Phi,alpha,intercept){
    xb=intercept+as.numeric(Phi%*%Matrix(as.numeric(alpha),ncol=1))
    sum(z*xb-tau*exp(xb),na.rm=T)
  }

  

  
  
  alpha=alpha.start
  #alpha=Matrix(0,ncol=1,nrow=ncol(out$Phi))
  intercept=intercept.start
  
  D=Diagonal(length(alpha))
  one=Matrix(1,nrow=1,ncol=length(alpha))

  alpha.save=matrix(NA,nrow=n.mcmc,ncol=length(alpha))
  intercept.save=rep(NA,n.mcmc)

  accept=0
  
  for(iter in 1:n.mcmc){

    cat(iter," ")

    #browser()

    
    ##
    ## Sample continuous path and convert to CTDS path
    ##

    out=make.Phi.mat(sim.obj,spline.list,stack.static,stack.grad,conspecifics.list,crw=crw,path.aug.interval=path.aug.interval,spline.period=spline.period)
    Phi=out$Phi
    XX=out$XX
    z=out$z
    QQ=out$QQ
    tau=out$tau
    crawl=out$samp.new

    ##
    ## Sample alphas
    ##

    alpha.star=rmvnorm(1,alpha,sigma=alpha.tune.mat)
    intercept.star=rnorm(1,intercept,sqrt(intercept.tune))

##    browser()
    mh1=loglik.pois(z,tau,Phi,alpha.star,intercept.star)+dmvnorm(alpha.star,alpha,alpha.prior.var,log=TRUE)
    mh2=loglik.pois(z,tau,Phi,alpha,intercept)+dmvnorm(alpha,alpha.star,alpha.prior.var,log=TRUE)

    if(runif(1)<exp(mh1-mh2)){
      alpha=alpha.star
      intercept=intercept.star
      accept=accept+1
    }

    #cat("(",accept,") ")
    

    alpha.save[iter,] <- alpha
    intercept.save[iter] <- intercept
  }
  alpha=apply(alpha.save,2,mean)
  alpha.sd=apply(alpha.save,2,sd)
  int=mean(intercept.save)
  int.sd=sd(intercept.save)
  list(alpha=alpha,alpha.sd=alpha.sd,alpha.save=alpha.save,intercept=int,intercept.sd=int.sd,intercept.save=intercept.save,accept=accept)
}
