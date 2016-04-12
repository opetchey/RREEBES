
get.betas.sd <- function(MI.out,spline.list,eval.times){
  #browser()
  Q.tilde=eval.spline.list(spline.list,eval.times)
  #sd.tilde=Q.tilde%*%MI.out$alpha.sd
  #if(!is.na(MI.out$Phi.sd[1])){
  #  sd.tilde=Q.tilde%*%(MI.out$alpha.sd/MI.out$Phi.sd)
  #}else{
  #  sd.tilde=Q.tilde%*%(MI.out$alpha.sd)
  #}
  if(!is.na(MI.out$Phi.sd[1])){
    sd.tilde=sqrt(Q.tilde^2%*%(MI.out$alpha.sd/MI.out$Phi.sd)^2)
  }else{
    sd.tilde=sqrt(Q.tilde^2%*%(MI.out$alpha.sd)^2)
  }
  p=length(spline.list)
  beta.mat=matrix(as.numeric(sd.tilde),ncol=p,byrow=F)
  colnames(beta.mat)=MI.out$beta.names
  beta.mat
}
