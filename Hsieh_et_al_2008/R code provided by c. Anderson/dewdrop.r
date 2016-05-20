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
x1=matrix(NA,nrow=100,ncol=100)
for(i in 1:100) {
  log.ecosystem(runif(5,.4,.8),3.5+i/1000,.00)->logsp5
  logsp5[901:1000,1]->x1[,i]
}
plot(NA,xlim=c(3.5,3.6),ylim=c(.25,1))
for(i in 1:100) points(rep(3.5+i/1000,100),x1[,i])

#how strong can ixn be w/o extinction?
y=0
for(i in 1:20) {
  for(j in 1:10) {
	log.ecosystem(runif(5,0.4,0.8),3.7,i/100)->logsp5
	y[i]=sum(logsp5[1000,]==0)
  }
}
plot(1:20/100,y,type="l",xlab="Alpha",ylab="Extinctions per 50 spp")

###############
#REAL SIM HERE#
###############



log.ecosystem(runif(5,0.4,0.8),3.57,.05,obs.err=.05,proc.err=.15)->logsp5
par(mar=c(2.5,2.5,1,.2))
layout(matrix(c(1,2,3,4,5,6),nrow=2,byrow=T))
for(i in 1:5) { plot(embed(logsp5[,i],2)); text(.4,.5,paste("Species",i)); }
t=rep(NA,5000)
for(i in 1:5) t[(i*1000-999):(i*1000)]=logsp5[,i]
i=5; j=3

#--------fig 1: no relationship, no AR, good LNLP-----------
gappy.ar(t[-999:0+i*1000],0,ardim)->beta
x=embed(t[-999:0+j*1000],ardim+1)
obs=x[,1]
x[,1]=rep(1,dim(x)[1])
pred=x%*%beta

lnlp(c(logsp5[,j],logsp5[,i]),matrix(c(1,1000),nrow=1),matrix(c(1001,1999),nrow=1),2,1,10000,1,3)->y
read.table("C:/Docs/Sugi-SIO296/lnlp/rtemp.dump0",sep=" ")->y
y[,c(2,4)]->y

pdf(file="c:/Docs/Dewdrop/fig1.pdf",height=2.153,width=6.459,title="Dewdrop: Fig 1")
layout(matrix(c(1,2,3),nrow=1))
par(mar=c(7,7,3.5,.5),mgp=c(4,1.5,0),cex=.25,cex.main=3.25,cex.lab=3.5,cex.axis=3.25,pch=19)

plot(c(0,1),c(0,1),type="n",xlab="Species 3",ylab="Species 5",main="Cross-species Correlation")
points(logsp5[,i],logsp5[,j])
text(.05,.95,"A",cex=4)

plot(c(0,1),c(0,1),xlab="Prediction using Species 5",ylab="Species 3 (true value)",type="n",main="Cross-species AR Model")
points(pred,obs)
lines(c(0,1),c(0,1),lty="dashed")
text(.05,.95,"B",cex=4)

plot(c(0,1),c(0,1),xlab="Prediction using Species 5",ylab="Species 3 (true value)",type="n",main="Cross-species S-Map")
points(y[,2],y[,1])
lines(c(0,1),c(0,1),lty="dashed")
text(.05,.95,"C",cex=4)
dev.off()

#--Fig 2: Compositing rescues dim & r--
#Find inherent dimension of series; shorten; restore by composite
win=700  #where to start in the time series
len=30
nbhd.corr=array(NA,c(5,8,3))
nbhd.err=array(NA,c(5,8,3))
lib=matrix(c(1,999-len/2),nrow=1)
pred=matrix(c(1000-len/2,999),nrow=1)
shlib=matrix(c(win-len/2,win),nrow=1)
shpred=matrix(c(win+1,win+len/2),nrow=1)

for(i in 1:5) {
	(1:5)[-i]->j
	compred=matrix(c(i*1000-win-len/2,i*1000-win),nrow=1)
	complib=matrix(c(i*1000-win-1,j*1000-win-len/2,i*1000-win+len/2,j*1000-win+len/2),nrow=5)

    for(e in 1:8) {
		nbhd(logsp5[,i],lib,pred,e,1,e+1,1,10)->y
		nbhd.corr[i,e,1]=y$corr
		nbhd.err[i,e,1]=y$err

		nbhd(logsp5[,i],shlib,shpred,e,1,e+1,1,10)->y
		nbhd.corr[i,e,2]=y$corr
		nbhd.err[i,e,2]=y$err

		nbhd(t,complib,compred,e,1,e+1,1,10)->y
		nbhd.corr[i,e,3]=y$corr
		nbhd.err[i,e,3]=y$err
	}
}
apply(nbhd.corr,c(2,3),quantile,probs=c(.025,.5,.975))->nbhd.corr
apply(nbhd.err,c(2,3),quantile,probs=c(.025,.5,.975))->nbhd.err

pdf(file="c:/Docs/Dewdrop/fig2.pdf",height=8,width=15,title="Dewdrop: Fig 2")
layout(matrix(1:3,nrow=1))
#layout(matrix(1:6,nrow=2))
par(mar=c(4,5,3,.5),mgp=c(2.5,1,0),cex=.8,cex.main=2.25,cex.lab=2,cex.axis=1.5,pch=19)
plot(c(1,8),c(0,max(nbhd.corr)),type="n",xlab="Dimension",ylab="Correlation",main="Long time series (N=1000)")
for(i in 1:3) lines(lowess(1:8,nbhd.corr[i,,1]),lwd=3-abs(2-i), lty=abs(2-i)+1)
text(1,.95,"A",cex=2)
#plot(c(1,8),c(min(nbhd.err),max(nbhd.err)),type="n",xlab="Dimension",ylab="Error")
#for(i in 1:5) lines(lowess(1:8,nbhd.err[i,,1]),lwd=3-abs(2-i), lty=abs(2-i)+1)

plot(c(1,8),c(0,max(nbhd.corr)),type="n",xlab="Dimension",ylab="Correlation",main=paste("Short time series (N=",len,")",sep=""))
for(i in 1:3) lines(lowess(1:8,nbhd.corr[i,,2]),lwd=3-abs(2-i),lty=abs(2-i)+1)
text(1,.95,"B",cex=2)
#plot(c(1,8),c(min(nbhd.err),max(nbhd.err)),type="n",xlab="Dimension",ylab="Error")
#for(i in 1:3) lines(lowess(1:8,nbhd.err[i,,2]),lwd=3-abs(2-i),lty=abs(2-i)+1)

plot(c(1,8),c(0,max(nbhd.corr)),type="n",xlab="Dimension",ylab="Correlation",main=paste("Composite series (N=",len," x5)",sep=""))
for(i in 1:3) lines(lowess(1:8,nbhd.corr[i,,3]),lwd=3-abs(2-i),lty=abs(2-i)+1)
text(1,.95,"C",cex=2)
#plot(c(1,8),c(min(nbhd.err),max(nbhd.err)),type="n",xlab="Dimension",ylab="Error")
#for(i in 1:3) lines(lowess(1:8,nbhd.err[i,,3]),lwd=3-abs(2-i),lty=abs(2-i)+1)
dev.off()

#--Fig 3: Compositing rescues nonlinear signal & r--
#panel 1 lib=985; lib2=15; lib3=30x4+15
testlambda=c(0,exp(0:9*.76753)*.01)
fig1b=array(NA,c(100,5,11,3))
clib=matrix(c(1,31,61,91,30,60,90,120),nrow=4)
for(i in 1:100) {
	floor(runif(1,30,969))->x
	pred=matrix(c(x,x+14),nrow=1)
	llib=matrix(c(1,x+15,x-1,999),nrow=2)
	shlib=matrix(c(x-15,x-1),nrow=1)
	for(j in 1:5) {
		t=as.vector(logsp5[-15:14+x,c(j,(1:5)[-j])])
		fig1b[i,j,,1]=lnlp(logsp5[,j],llib,pred,2,1,10000,1,testlambda)$corr
		fig1b[i,j,,2]=lnlp(logsp5[,j],shlib,pred,2,1,10000,1,testlambda)$corr
		fig1b[i,j,,3]=lnlp(t,clib,matrix(c(121,149),nrow=1),2,1,10000,1,testlambda)$corr
	}
}
apply(fig1b,c(2,3,4),quantile,c(.05,.5,.95))->fig1b.q

pdf(file="c:/Docs/Dewdrop/fig3.pdf",height=3.7,width=6.459,title="Dewdrop: Fig 3")
par(mar=c(3.5,3.5,2,1),mgp=c(2.15,.8,0),cex.main=1.8,cex.lab=1.75,cex.axis=1.3)
layout(matrix(1:3,nrow=1))
plot(c(.01,1),c(min(fig1b.q),max(fig1b.q)),xlab="Theta",ylab="Correlation",main="Long, N=1000",type="n",log="x")
for(i in 1:3) for(j in 1:5) lines(testlambda,fig1b.q[i,j,,1],lwd=2-abs(2-i), lty=abs(2-i)+1)
for(j in 1:5) lines(c(.01,10),rep(fig1b.q[2,j,1,1],2),lwd=1)
text(.01,.97,"A",cex=1.5)
plot(c(.01,1),c(min(fig1b.q),max(fig1b)),xlab="Theta",ylab="Correlation",main="Short, N=30",type="n",log="x")
for(i in 1:3) for(j in 1:5) lines(testlambda,fig1b.q[i,j,,2],lwd=2-abs(2-i), lty=abs(2-i)+1)
for(j in 1:5) lines(c(.01,10),rep(fig1b.q[2,j,1,2],2),lwd=1)
text(.01,.97,"B",cex=1.5)
plot(c(.01,1),c(min(fig1b.q),max(fig1b)),xlab="Theta",ylab="Correlation",main="Dewdrop, N=30 x5",type="n",log="x")
for(i in 1:3) for(j in 1:5) lines(testlambda,fig1b.q[i,j,,3],lwd=2-abs(2-i), lty=abs(2-i)+1)
for(j in 1:5) lines(c(.01,10),rep(fig1b.q[2,j,1,3],2),lwd=1)
text(.01,.97,"C",cex=1.5)
dev.off()

#----Fig 4: How time series length affects nonlinearity and predictability---
n.corr=array(NA,dim=c(5,9,6))
n.err=array(NA,dim=c(5,9,6))
n.lst=c(4,8,16,32,64,128,256,512,999)
for(i in 1:5) {
  sp.pred=(1:5)[-i]
  #for(j in 1:length(n.lst)) {
  for(j in 9) {
	n=n.lst[j]
    pred=matrix(c(i,i)*1000-c(n,1),nrow=1,byrow=T)
    lib=matrix(rep(sp.pred,2),nrow=4)*1000-matrix(c(rep(n,4),1,1,1,1),nrow=4)
    lnlp(t,pred,lib,2,1,10000,1,c(0,.1,.4,1.5,6,10))->y
	if(!is.null(dim(y[1]))) {
      n.corr[i,j,]=y$corr
      n.err[i,j,]=y$err
	}
  }
}

for(i in 1:5) {
	apply(n.corr[i,,2:5],1,max,na.rm=T)->n.corr[i,,2]
	apply(n.err[i,,2:5],1,min,na.rm=T)->n.err[i,,2]
}

pdf(file="c:/Docs/Dewdrop/fig4a.pdf",height=8,width=12,title="Dewdrop: Fig 4a")
par(mar=c(4,5,.5,.5),mgp=c(2.5,1,0),cex=.8,cex.main=2.25,cex.lab=2,cex.axis=1.5,pch=19)
layout(matrix(c(1,2,3,4,5,6),nrow=2,byrow=T))
for(i in 1:5) {
  plot(c(1,9),c(min(n.corr[,2:9,1:2],na.rm=T),1),axes=F,type="n",xlab="N of each series",ylab="Correlation")
  box()
  axis(2)
  axis(1,at=9:1,labels=n.lst)
  lines(9:1,n.corr[i,,1],lwd=1)
  lines(9:1,n.corr[i,,2],lwd=2)
  lines(9:1,tanh(atanh(n.corr[i,,2])-1.96*sqrt(1/(n.lst-3)+1/(n.lst*4-3))),lty="dashed")
  lines(9:1,tanh(atanh(n.corr[i,,2])+1.96*sqrt(1/(n.lst-3)+1/(n.lst*4-3))),lty="dashed")
  text(3,.8,paste("Species",i),cex=1.75)
}
dev.off()

pdf(file="c:/Docs/Dewdrop/fig4b.pdf",height=8,width=12,title="Dewdrop: Fig 4b")
par(mar=c(4,5,.5,.5),mgp=c(2.5,1,0),cex=.8,cex.main=2.25,cex.lab=2,cex.axis=1.5,pch=19)
layout(matrix(c(1,2,3,4,5,6),nrow=2,byrow=T))
for(i in 1:5) {
  plot(c(1,9),c(min(n.err[,2:9,1:2],na.rm=T),max(n.err[,2:9,1:2],na.rm=T)),axes=F,type="n",xlab="N of each series",ylab="Mean Absolute Error")
  box()
  axis(2)
  axis(1,at=9:1,labels=n.lst)
  lines(9:1,n.err[i,,1],lwd=1)
  lines(9:1,n.err[i,,2],lwd=2)
  text(3,.8*max(n.err[,2:9,1:2],na.rm=T),paste("Species",i),cex=1.75)
}                                      
dev.off()

##Table B1
gappy.ar<-function(x,gap=0,ord) {
#The gap would be ON row [gap]
	e=ord+1
	d=embed(x,e)
	if(gap[1]!=0) {
		y=0
		for(i in 1:length(gap)) y[((i-1)*ord+1):(i*ord)]=(gap[i]-ord):(gap[i]-1)
		d=d[-y,]
	}
	as.matrix(lm(d[,1]~d[,2:e])$coefficients)->lmod
	row.names(lmod)[1]="b"
	for(i in 2:e) row.names(lmod)[i]=paste("t-",i-1,sep="")
	return(lmod)
}

ardim=2
crospred=array(NA,dim=c(5,5,2))
for(i in 1:5) {
	gappy.ar(t[-999:0+i*1000],0,ardim)->beta
	for(j in 1:5) {
		if(i!=j) {  # predict j by i			
			x=embed(t[-999:0+j*1000],ardim+1)
			obs=x[,1]
			x[,1]=rep(1,dim(x)[1])
			pred=x%*%beta
			sxy=sum(obs*pred)-sum(obs)*sum(pred)/length(obs)
			sxx=sum(obs^2)-sum(obs)^2/length(obs)
			syy=sum(pred^2)-sum(pred)^2/length(pred)
			crospred[j,i,1]=sxy/sqrt(sxx*syy) #corr
			crospred[j,i,2]=mean(abs(obs-pred)) #MAErr
		}
	}
}

write.table(crospred[,,1],"c:/comp_tab1.csv",sep="\t",row.names=F,col.names=F)
write.table(crospred[,,2],"c:/comp_tab1.csv",sep="\t",row.names=F,col.names=F,append=T)


for(i in 1:5) {
	for(j in 1:5) {
		if(i!=j) { #predicting i from j
			lnlp(c(logsp5[,j],logsp5[,i]),matrix(c(1,1000),nrow=1),matrix(c(1001,1999),nrow=1),2,1,10000,1,6)->y
			crospred[i,j,1]=y$corr
			crospred[i,j,2]=y$err
		}
	}
}

write.table(crospred[,,1],"c:/comp_tab1.csv",sep="\t",row.names=F,col.names=F,append=T)
write.table(crospred[,,2],"c:/comp_tab1.csv",sep="\t",row.names=F,col.names=F,append=T)

lnlp<-function(x,lib,pred,e,tau,b,Tp,lambda) {
 path="C:/Docs/Sugi-SIO296/lnlp/"
tmp=getwd()
setwd(path)
params=c("data","lib","pred","e","tau","b","Tp","lambda")
vals=list(x,lib,pred,e,tau,b,Tp,lambda)
for(i in 1:8)
write.table(vals[[i]],paste(params[i],sep=""),row.names=F,col.names=F)
system("lnlp.exe -F data -L lib -P pred -d e -T tau -n b -t Tp -l lambda -o rtemp")
ans=try(read.table("rtemp.stat",skip=3,comment=""))
if(dim(ans)[2]==8 || is.null(dim(ans))) #error
ans=0
else
colnames(ans)=c("ID","E","tau","Tp","b","lambda","err","corr","pval","pct.sign")
for(i in 1:8) unlink(params[i])
setwd(tmp)
return(ans)
}

#---Figure B1------
for(i in 1:5) t[(i*1000-999):(i*1000)]=logsp5[,i]
i=5; j=3
gappy.ar(t[-999:0+i*1000],0,ardim)->beta
x=embed(t[-999:0+j*1000],ardim+1)
obs=x[,1]
x[,1]=rep(1,dim(x)[1])
pred=x%*%beta
pred-obs->resid
pdf(file="c:/Docs/Dewdrop/figB1.pdf",height=6,width=6,title="Dewdrop: Fig B1")
par(mar=c(4.5,5.5,3.2,.5),mgp=c(3,1,0),cex=.5,cex.main=2.75,cex.lab=2.25,cex.axis=2,pch=19)
plot(c(0,1),c(-.25,.6),xlab="Species 3 at t",ylab="Error in Species 5 at t+1",main="Residual Delay Map",type="n")
points(obs[-999],resid[-1],pch=19)
obs2=obs[-999]^2
lmod=lm(resid[-1]~obs[-999]+obs2)$coefficients
xc=0:100/100
lines(xc,lmod[1]+lmod[2]*xc+lmod[3]*xc^2,lty="dashed",lwd=1.5)
text(.15,0,"Corr=.6417",cex=2.5)
dev.off()

#----fig 4; gains from compositing more time series--------
fig4=array(NA,dim=c(5,16,2,11))
len=20; st=450
p=matrix(c(1,len-1),nrow=1)
for(i in 1:5) {
	t2=2; t3=6; t4=12
	lnlp(logsp5[1:len+st,i],p,p,2,1,1000,1,0:10/5)->y
	fig4[i,1,1,]=y$corr
	fig4[i,1,2,]=y$err
	print(paste(i,"on self in slot 1"))

	#one spp to predict other
	for(j in (1:5)[-i]) {
		lnlp(c(logsp5[1:len+st,c(i,j)]),matrix(c(0:1*len+1,1:2*len-1),nrow=2),p,2,1,1000,1,0:10/5)->y
		fig4[i,t2,1,]=y$corr
		fig4[i,t2,2,]=y$err
		print(paste(i,"by",j,"in slot",t2))
		k=j+1; t2=t2+1
		while(k<=5) { #two others
			if(k!=i) {
			lnlp(c(logsp5[1:len+st,c(i,j,k)]),matrix(c(0:2*len+1,1:3*len-1),nrow=3),p,2,1,1000,1,0:10/5)->y
			fig4[i,t3,1,]=y$corr
			fig4[i,t3,2,]=y$err
			print(paste(i,"by",j,k,"in slot",t3))
			t3=t3+1; l=k+1
			while(l<=5) { #three others
				if(l!=i) {
				lnlp(c(logsp5[1:len+st,c(i,j,k,l)]),lib=matrix(c(0:3*len+1,1:4*len-1),nrow=4),p,2,1,1000,1,0:10/5)->y
				fig4[i,t4,1,]=y$corr
				fig4[i,t4,2,]=y$err
				print(paste(i,"by",j,k,l,"in slot",t4))
				t4=t4+1
				}
				l=l+1
			}
			}
			k=k+1
		}
	}
	lnlp(c(logsp5[1:len+st,i],logsp5[1:len+st,(1:5)[-i]]),matrix(c(0:4*len+1,1:5*len-1),nrow=5),p,2,1,1000,1,0:10/5)->y
	fig4[i,16,1,]=y$corr
	fig4[i,16,2,]=y$err
	print(paste(i,"by all others in slot 16"))
}

fig4.mx=array(NA,dim=c(5,16,2))
for(i in 1:5) for(j in 1:16) {
	max(fig4[i,j,1,])->fig4.mx[i,j,1]
	min(fig4[i,j,2,])->fig4.mx[i,j,2]
}

plot(c(0,4),c(min(fig4.mx[,,1]),max(fig4.mx[,,1])),type="n",xlab="# of Composited Time Series",ylab="Correlation")
for(i in 1:5) {
	points(c(0,rep(1,4),rep(2,6),rep(3,4),4),c(fig4.mx[i,1,1],fig4.mx[i,2:5,1],fig4.mx[i,6:11,1],fig4.mx[i,12:15,1],fig4.mx[i,16,1]))
	lines(0:4,c(fig4.mx[i,1,1],mean(fig4.mx[i,2:5,1]),mean(fig4.mx[i,6:11,1]),mean(fig4.mx[i,12:15,1]),fig4.mx[i,16,1]))
}

plot(c(0,4),c(min(fig4.mx[,,2]),max(fig4.mx[,,2])),type="n",xlab="# of Composited Time Series",ylab="MAError")
for(i in 1:5) {
	points(c(0,rep(1,4),rep(2,6),rep(3,4),4),c(fig4.mx[i,1,2],fig4.mx[i,2:5,2],fig4.mx[i,6:11,2],fig4.mx[i,12:15,2],fig4.mx[i,16,2]))
	lines(0:4,c(fig4.mx[i,1,2],mean(fig4.mx[i,2:5,2]),mean(fig4.mx[i,6:11,2]),mean(fig4.mx[i,12:15,2]),fig4.mx[i,16,2]))
}


#----OLD CODE---
#use 3 to predict other 2; find lambda
#sim in rows, dim in cols
lnlp.corr=matrix(NA,nrow=10,ncol=8)
lnlp.err=matrix(NA,nrow=10,ncol=8)
w=1
for(i in 1:5) {
  j=i+1
  while(j<=5) {
    k=j+1
    while(k<=5) {
      sp.pred=(1:5)[-c(i,j,k)]
      lib=matrix(c(i,i,j,j,k,k)*1000-rep(c(995,1),3),nrow=3,byrow=T)
      pred=matrix(rep(sp.pred,2),nrow=2)*1000-matrix(c(995,995,1,1),nrow=2)
      lnlp(t,lib,pred,3,1,1000,1,c(0,.2,1,3,7,10,15,20))->y
      lnlp.corr[w,]=y$corr
      lnlp.err[w,]=y$err
      k=k+1
      w=w+1
    }
    j=j+1                                                               
  }
}
layout(1)
c(0,.2,1,3,7,10,15,20)->x
par(mar=c(2.5,2.5,2,.1),mgp=c(1.5,.5,0))
plot(c(0,20),c(min(lnlp.corr[,-1],na.rm=T),max(lnlp.corr,na.rm=T)),type="n",xlab="theta",ylab="corr",main="ON=PN=10%, a=.05")
for(i in 1:10) lines(x,lnlp.corr[i,],lwd=2)

plot(c(0,20),c(min(lnlp.err),max(lnlp.err[,-1],na.rm=T)),type="n",xlab="theta",ylab="MSError",main="ON=PN=10%, a=.05")
for(i in 1:10) lines(x,lnlp.err[i,],lwd=2)
apply(lnlp.err,1,min)->mx
rep(0,8)->z
for(i in 1:10) {
	index(lnlp.err[i,]==mx[i])->y
	for(j in 1:length(y)) z[y[j]]=z[y[j]]+1/length(y)
}
sum(x*z)/10->avg
plot(x,z,ylab="freq",xlab="theta",main="Best theta (10% PN, a=.05)",type="l")
lines(c(avg,avg),c(0,3),lty="dashed",lwd=2)
text(avg,1,paste("Mean=",avg,sep=""))


#Finding lambda
layout(1)
plot(c(.01,10),c(min(fig1b.l),max(fig1b.l)),type="n",xlab="Theta",ylab="corr.",log="x")
for(i in 1:5) for(j in 1:10) lines(testlambda,fig1b.l[i,j,])
lines(testlambda,apply(fig1b.l,c(3),sum)/50,lwd=3,col="red")
#looks like 2 for n=30, pred-n=15


#---What if we don't composite?
nodew=array(0,c(23,2))
for(i in 45:67) {
	gappy.ar(fish[1:15,i],0,5)->beta
	x=embed(fish[16:33,i],6)
	obs=x[,1]
	x[,1]=rep(1,dim(x)[1])
	pred=x%*%beta
	sxy=sum(obs*pred)-sum(obs)*sum(pred)/length(obs)
	sxx=sum(obs^2)-sum(obs)^2/length(obs)
	syy=sum(pred^2)-sum(pred)^2/length(pred)
	nodew[i-44,1]=sxy/sqrt(sxx*syy) #corr
	nodew[i-44,2]=mean(abs(obs-pred)) #MAErr
}

nodew=array(0,c(23,12,2))
for(i in 45:67) {
	lnlp(fish[,i],matrix(c(1,15),nrow=1),matrix(c(16,34),nrow=1),5,1,1000,1,c(0,.05,1:10/10))->y
	y$corr->nodew[i-44,,1]
	y$err->nodew[i-44,,2]
}


##Make distance table
sp5.dist=array(NA,dim=c(901,898),dimnames=list(rownames(sp5.emb)[899:1799],rownames(sp5.emb)[1:898]))
for(i in 899:1799)
	sp5.dist[i-898,]=((sp5.emb[i,2]-sp5.emb[1:898,2])^2+(sp5.emb[i,3]-sp5.emb[1:898,3])^2+(sp5.emb[i,4]-sp5.emb[1:898,4])^2)^.5
write.table(sp5.dist,"c:/Docs/Dewdrop/sp5dist.txt",quote=F)
sp5.nn=array(NA,dim=c(901,10),dimnames=list(rownames(sp5.emb)[899:1799],paste("nn",1:10)))
for(i in 899:1799)
	sp5.nn[i-898,]=as.integer(names(sort(sp5.dist[i-898,])[1:10]))
write.table(sp5.nn,"c:/Docs/Dewdrop/sp5nn.txt",quote=F)
  
