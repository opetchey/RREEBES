
ctds.MI.prep <- function(sim.obj,spline.list,stack.static,stack.grad,conspecifics.list=NULL,crw=TRUE,num.crawl.paths=10,path.aug.interval=0,spline.period=0,imputation.model="CRAWL"){

  ##
  ## Sanity checks
  ##

  #cat("Performing Sanity Checks...")
#
 # if(length(spline.list)==nlayers(stack.static)+nlayers(stack.grad)+length(conspecifics.list)+crw){
  #  cat("Passed","\n")
  #}else{
  #  cat("Error.  Dimensions of covariates and spline lists do NOT match.","\n")
  #}
  

  z.list=list()
  Phi.list=list()
  QQ.list=list()
  XX.list=list()
  tau.list=list()
  crawl.list=list()
  time.list=list()
  
  cat("Computing Discrete Space Paths ")

  ##browser()

  for(iter in 1:num.crawl.paths){
    cat(iter," ")
    out=make.Phi.mat(sim.obj,spline.list,stack.static,stack.grad,conspecifics.list,crw=crw,path.aug.interval=path.aug.interval,spline.period=spline.period,imputation.model=imputation.model)
    Phi.list[[iter]] <- out$Phi
    XX.list[[iter]]=out$XX
    z.list[[iter]]=out$z
    QQ.list[[iter]]=out$QQ
    #Q.list[[iter]]=Q
    #X.list[[iter]]=X
    tau.list[[iter]]=out$tau
    crawl.list[[iter]]=out$samp.new
    time.list[[iter]]=out$start.times
  }

  cat("\n")

  list(z.list=z.list,Phi.list=Phi.list,tau.list=tau.list,time.list=time.list,QQ.list=QQ.list,crawl.list=crawl.list,XX.list=XX.list,beta.names=colnames(out$X),sim.obj=sim.obj,conspecifics.list=conspecifics.list,spline.list=spline.list,stack.static=stack.static,stack.grad=stack.grad,crw=crw,time.list=time.list)
}


  
