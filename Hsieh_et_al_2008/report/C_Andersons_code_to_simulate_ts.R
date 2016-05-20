log.ecosystem<-function(N,r,alpha,obs.err=0,proc.err=0) {
  x=matrix(NA,nrow=1000,ncol=5)
  for(i in 1:1000) {
    x[i,]<-N
    #N*exp(r*(1-N/K))-alpha*sum(N)+alpha*N->N #alternative model
    r*N*(1-N)-alpha*sum(N)+alpha*N->N
    N*as.integer(N>0)*runif(5,1-proc.err,1+proc.err)->N
  }
  x=x*matrix(runif(5000,1-obs.err,1+obs.err),nrow=1000)
  return(x)
}

log.ecosystem(runif(5,0.4,0.8),3.57,.05,obs.err=.05,proc.err=.15)->logsp5
par(mar=c(2.5,2.5,1,.2))
layout(matrix(c(1,2,3,4,5,6),nrow=2,byrow=T))
for(i in 1:5) { plot(embed(logsp5[,i],2)); text(.4,.5,paste("Species",i)); }
t=rep(NA,5000)
for(i in 1:5) t[(i*1000-999):(i*1000)]=logsp5[,i]
i=5; j=3

write.csv(logsp5, "/Users/Frank/Documents/Github projects/RREEBES/Hsieh_et_al_2008/data/5sp_comp_sim_data_CA_code.csv")
