#Combine meta-analysis means by trt from symmetrical and asymmetrical distributions
#bootstrapping using the skew normal distribution
#ECA Sept 2011
# 9/16/11 - JEB rewrite for speed

rm(list=ls())
library(fGarch)

#helper functions
ci<-function(nums, int=95){
  int<-(1-(int/100))/2
  interval<-qt(int, length(nums)-1, lower.tail=F)*se(nums)
	return(interval)
}
se<-function(nums) {
  len = length(na.omit(nums))
	ret<-sd(nums, na.rm=T)/sqrt(len)
	return(ret)
}

##
#file.choose()

#read in data
decomp <- read.csv("C:\\Users\\carol\\Desktop\\carol\\NCEAS\\Cardinale WG\\Relative importance\\Meta-analyses\\Decomposition\\DecompBoot.csv", check.names=FALSE)
head(decomp)

#subset for treatment - run the below code for each treatment type 
#	code is currently set up for "N" treatments
#	invasion, N
s1=subset(decomp,decomp$factor=="N")
s1

#Calculate CI if not done by meta-analysis (i.e., SE or SD)
ss1<-s1

  ss1$CItemp=numeric(nrow(s1))
  ss1$CI.lo=numeric(nrow(s1))
  ss1$CI.up=numeric(nrow(s1))

  i=which(ss1$Err.orig=="SE")
	ss1<-within(ss1, {
 	  CItemp[i] <- qt(0.025, nobs[i]-1, lower.tail=F)*Err.orig.num[i]
	  CI.lo[i]<-s1$ln.RR[i]-CItemp[i]
	  CI.up[i]<-s1$ln.RR[i]+CItemp[i]
	})

  i=which(ss1$Err.orig=="SD")
 	 ss1<-within(ss1, {
		CItemp[i] <- qt(0.025, s1$nobs[i]-1, lower.tail=F)*s1$Err.orig.num[i]/sqrt(s1$nobs[i])
    		CI.lo[i]<-s1$ln.RR[i]-CItemp[i]
		CI.up[i]<-s1$ln.RR[i]+CItemp[i]
  })

  i=which(ss1$Err.orig=="CI")
	ss1<-within(ss1, {
		CItemp[i]=ss1$CI.max[i]
		CI.lo[i]=ss1$CI.L[i]
		CI.up[i]=ss1$CI.U[i]
  })
  

#####
#add stdev and skew columns to ss1

ss1$skew<-0
ss1$stdev<-0
a<-which(ss1$CI.type=="a") #assymetric - need to get skew
sym<-which(ss1$CI.type=="symm") #symmetric - skew=0

ss1<- within(ss1,{
  stdev[a]<-(CI.up[a]-CI.lo[a])*sqrt(nobs[a])/(2*qt(0.025, nobs[a]-1, lower.tail=F))
  skew[a]<-(CI.lo[a]-ln.RR[a]+qt(0.025, nobs[a]-1, lower.tail=F)*stdev[a]/sqrt(nobs[a]))*6*stdev[a]*stdev[a]*nobs[a]    

  stdev[sym]<-CItemp[sym]/qt(0.025, nobs[sym]-1, lower.tail=F)*sqrt(nobs[sym])
})  



#####  
#now get a bootstrapped estimate
#sample from SKEWED NORMAL distribution if ASYMM CI; NORMAL if SYMM

bootSize3<-function(n, sizeVec, vmeas, skew=NA, varType="CI", R=1){
 ss=sum(n)
 cx=array(0,dim=c(R,4))
 for(j in 1:R){ 
 	 idx<-sapply(1:ss, function(x) which(cumsum(n/sum(n))>runif(1))[1]) #get your sample
	 m<-sizeVec[idx]
	 vars<-vmeas[idx] #variance estimates
	
	 sd<-vars #default behaviour
 
	 #if(varType=="CI") sd<-vars/qt(0.025, n[idx]-1, lower.tail=F)*sqrt(n[idx])
 	 #if(varType=="sd") sd<-vars
	 #if(varType=="se") sd<-vars*sqrt(n[idx])
	 #if(varType=="var") sd<-sqrt(vars)
 
	 ret<-rnorm(ss, m, sd)
 
	 if(varType=="sdSkew") {
	   skIdx<-which(skew[idx] != 0)
	   skIdx2<-idx[skIdx] #to get the index in the original vector 'skew'
	   ret[skIdx]<-rsnorm(length(skIdx), sizeVec[skIdx2], vmeas[skIdx2], skew[skIdx2]) #changed m to sizeVec
	 	}

	cx[j,1]<-mean(ret)
	cx[j,2]<-mean(ret)-ci(ret)
	cx[j,3]<-mean(ret)+ci(ret)
	cx[j,4]<-sd(ret)
 }

 return(cx)
}


b<-with(ss1, bootSize3(nobs, ln.RR, stdev, skew, varType="sdSkew", R=10000)) 


mean(b[,1])	#mean
mean(b[,2])	#CI lower
mean(b[,3]) #CI upper
mean(b[,4]) #sd
hist(b[,1]) #hist of mean

