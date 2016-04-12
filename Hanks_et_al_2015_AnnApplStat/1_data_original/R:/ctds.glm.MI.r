
ctds.glm.MI <- function(ctds.obj,nfolds=10,nlambda=100,plot.cv=FALSE,method="Stacked.cv",cv.param="min",...){

  ## Last Updated: 20120716
  ##
  ## Fits the Poisson GLM for the CTDS model of animal movement using multiple
  ##    imputation to integrate over the uncertainty in the movement path.
  ##    The GLM is fit using the 'glmnet' package.
  ##
  ## Inputs:
  ##
  ## ctds.obj - A "ctds" object (output from "ctds.MI.prep")
  ## plot.cv - if "TRUE", then plots the CV-error as a function of the 
  ##    lasso tuning parameter.  If "FALSE", no plot. 
  ## method - Right now the only method is "Stacked".  Others are planned.
  ## 
  ## All other arguments are inputs to the 'cv.glmnet' function in the
  ##    'glmnet' package.
  ##
  ## 

  if(method=="Stacked.cv"){
    
    ## Compiling stuff
    cat("\n")
    cat("Compiling Matrices, ",length(ctds.obj$Phi.list)," Total:","\n")
    cat("1  ")
    
    Phi=ctds.obj$Phi.list[[1]]
    z=ctds.obj$z.list[[1]]
    tau=ctds.obj$tau.list[[1]]
    colsums=apply(abs(Phi),2,sum)
    for(i in 2:length(ctds.obj$z.list)){
      cat(i," ")
      z=c(z,ctds.obj$z.list[[i]])
      Phi=rBind(Phi,ctds.obj$Phi.list[[i]])
      tau=c(tau,ctds.obj$tau.list[[i]])
      colsums=colsums+apply(abs(ctds.obj$Phi.list[[i]]),2,sum)
    }
    cat("\n")
    
    zero.idx=which(colsums==0)
    na.idx=which(is.na(colsums))

    #browser()

    ## fix for times outside of observation window
    Phi[which(is.na(Phi))] <- 0

    Phi.mean=apply(Phi,2,mean)
    Phi.sd=apply(Phi,2,sd)
    Phi.scaled=scale(Phi)
    #for(r in 1:nrow(Phi)){
    #  Phi.scaled[,r]=(Phi[,r]-Phi.mean[r])/Phi.sd[r]
    #}

    cat("Fitting GLM with Lasso Penalty Chosen Via Cross-Validation")
    
    glm.out=cv.glmnet(Phi.scaled,z,family="poisson",offset=log(tau),exclude=zero.idx,nfolds=nfolds,nlambda=nlambda,standardize=F,...)
    #glm.out=cv.glmnet(Phi,z,family="poisson",offset=log(tau),exclude=zero.idx,nfolds=nfolds,nlambda=nlambda,...)
    if(plot.cv==TRUE){
      plot(glm.out)
    }
    cat("\n")
    cat("Finishing","\n")
    if(cv.param=="min"){
      lambda.pen=glm.out$lambda.1se
    }
    if(cv.param=="1se"){
      lambda.pen=glm.out$lambda.1se
    }
    ##browser()
    coeffs=predict(glm.out,s=lambda.pen,type="coefficients")@x
    nonzero.coeffs=predict(glm.out,s=lambda.pen,type="nonzero")[[1]]
    nonzero.ratio=length(nonzero.coeffs)/ncol(Phi)
    nonzero.ratio
    alpha.hat=coeffs[-1]
    intercept.hat=coeffs[1]
    alpha.hat=rep(0,ncol(Phi))
    alpha.hat[nonzero.coeffs]=coeffs[-1]
    alpha.hat
    
    out=list(Phi=Phi,z=z,tau=tau,zero.idx=zero.idx,nfolds=nfolds,nlambda=nlambda,alpha=alpha.hat,intercept=intercept.hat,lambda.best=lambda.pen,alpha.nonzero.proportion=nonzero.ratio,glmnet.out=glm.out,beta.names=ctds.obj$beta.names,Phi.mean=Phi.mean,Phi.sd=Phi.sd)
  }
  if(method=="MI"){
    #browser()
    glm.out.list=list()
    alpha.list=list()
    num.imputations=length(ctds.obj$z.list)
    for(i in 1:num.imputations){
      Phi=as.matrix(ctds.obj$Phi.list[[i]])
      z=matrix(ctds.obj$z.list[[i]],ncol=1)
      tau=matrix(ctds.obj$tau.list[[i]])
      colsums=apply(abs(Phi),2,sum)
      Phi[which(is.na(Phi))] <- 0
      zero.idx=which(colsums==0)
      #browser()
      glm.out.list[[i]]=glm(z~Phi,family="poisson",offset=log(tau))
      #browser()
      alpha.list[[i]]=list(alpha=glm.out.list[[i]]$coeff,alpha.sd=summary(glm.out.list[[i]])$coeff[,2],na.idx=which(is.na(glm.out.list[[i]]$coeff)))
    }
    alpha.mat=matrix(NA,nrow=num.imputations,ncol=length(alpha.list[[1]]$alpha))
    alpha.var.mat=matrix(NA,nrow=num.imputations,ncol=length(alpha.list[[1]]$alpha))
    for(i in 1:num.imputations){
      alpha.mat[i,]=alpha.list[[i]]$alpha
      if(length(alpha.list[[i]]$na.idx)>0){
        alpha.var.mat[i,-alpha.list[[i]]$na.idx]=alpha.list[[i]]$alpha.sd^2
      }else{
        alpha.var.mat[i,]=alpha.list[[i]]$alpha.sd^2
      }
    }
    alpha=apply(alpha.mat,2,mean,na.rm=T)
    alpha.sd=sqrt(apply(alpha.var.mat,2,mean,na.rm=T)+apply(alpha.mat,2,var,na.rm=T))
    out=list(Phi=Phi,intercept=alpha[1],intercept.sd=alpha.sd[1],alpha=alpha[-1],alpha.sd=alpha.sd[-1],alpha.list=alpha.list,beta.names=ctds.obj$beta.names,Phi.mean=NA,Phi.sd=NA)
  }
  out
}

    
    
