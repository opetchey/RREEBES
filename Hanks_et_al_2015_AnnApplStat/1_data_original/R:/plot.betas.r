
plot.betas <- function(mi.out,spline.list,times.betas,col.list=c("red","blue","green","purple","black"),...){

  beta.mat=get.betas(mi.out,spline.list,times.betas)
  sd.mat=get.betas.sd(mi.out,spline.list,times.betas)
  for(i in 1:ncol(beta.mat)){
    dev.new()
    plot(c(times.betas,times.betas,times.betas),c(beta.mat[,i],beta.mat[,i]+1.96*sd.mat[,i],beta.mat[,i]-1.96*sd.mat[,i]),type="n",main=colnames(beta.mat)[i],xlab="Time",ylab="Beta")
    points(times.betas,beta.mat[,i],type="l",col=col.list[i],...)
    points(times.betas,beta.mat[,i]+1.96*sd.mat[,i],type="l",lty=2,col=col.list[i],...)
    points(times.betas,beta.mat[,i]-1.96*sd.mat[,i],type="l",lty=2,col=col.list[i],...)
  }
}
