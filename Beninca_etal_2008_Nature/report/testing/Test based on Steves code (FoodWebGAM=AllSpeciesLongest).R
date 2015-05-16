# follow Elisa's detrending 
# green flag = nano 
# melosira = net 

### Before running this code, you must do at the R command line 
#	rm(list=ls(all=TRUE)); source("c:/lenns/R/lennsBIC.R"); 

rm(list=ls())
require(mgcv); 

######################################################################
#  Load the data into a properly structured data frame 
#######################################################################
#X=read.csv("e:/pubs/Heerkloss/interp_short_allsystem.csv");
X <- read.csv("~/Dropbox (Dept of Geography)/RREEBES/Beninca_etal_2008_Nature/data/direct from Steve/interp_short_allsystem.csv")

## Select the time period to use 
start.longest=334
start.longer=808
start.shorter=1035
#start.same.as.ours <- 341.0
##e=X$Day.Number > start.same.as.ours ## this gives  -0.01382459
e=X$Day.Number > start.longer ## this gives  0.08415112
X=X[e,]
e=X$Day.Number < 2654
X=X[e,]



X=read.csv("e:/pubs/Heerkloss/interp_short_allsystem.csv");
X <- read.csv("~/Dropbox (Dept of Geography)/RREEBES/Beninca_etal_2008_Nature/data/direct from Steve/interp_short_allsystem.csv")

## Select the time period to use 
start.longest=334
start.longer=808
start.shorter=1035
e=X$Day.Number > start.longer
X=X[e,]
e=X$Day.Number < 2654; X=X[e,]




## Function to detrend series 
Detrend=function(z) {
   fit=ksmooth(X$Day.Number,z,bandwidth=300,kernel="normal"); 
   return(z-fit$y); 
}

# create the data series 
Cyclopoids=X$Cyclopoids^0.25; 
Protozoa=X$Protozoans^0.25; 
Rotifers=X$Brachionus^0.25; 
Calanoids=X$Eurytemora^0.25;   
Pico=X$Picophytopl^0.25;
Nano=X$Green.Flagellates^0.25; 
Net=X$Melosira^0.25;  
Nitrogen=Detrend(X$TotalN^0.25);
PO4=Detrend(X$PO4^0.25); 
Bacteria=Detrend(X$Bacteria^0.25); 
Ostracods=Detrend(X$Ostracods^0.25); 
Harpacticoids=Detrend(X$Harpacticoids^0.25); 



# Make data frame z with current (time t) and future (time t+1) values of all state variables  
nx=nrow(X); m1=2:nx; m0=1:(nx-1)
Z=cbind(Cyclopoids,Protozoa,Rotifers,Calanoids,Pico,Nano,Net,Nitrogen,PO4,Bacteria,Ostracods,Harpacticoids); 
x=data.frame(Z[m0,]);  
y=data.frame(Z[m1,]); names(y)<-cbind("y1","y2","y3","y4","y5","y6","y7","y8","y9","y10","y11","y12"); 
z=cbind(x,y); 

rm(list=c("Cyclopoids", 
"Protozoa",
"Rotifers", 
"Calanoids",  
"Pico",
"Nano",
"Net",
"Nitrogen",
"PO4",
"Bacteria",
"Ostracods",
"Harpacticoids"))


# Function to compute gradient of a GAM fit with respect to all 12 state variables
# NOTE: this assumes the data set z is available as a global data frame
# NOTE: this computes a matrix with all 12 gradients at all times in the 
#       data series. 
gamgrad=function(gamfit,eps) {
	gradmat=matrix(0,dim(z)[1],12); 
	for(j in 1:12) { 
		newzup=z; newzdown=z;
		newzup[,j]=z[,j]+eps; newzdown[,j]=z[,j]-eps;
 		gradmat[,j]=predict(gamfit,newzup,type="response")-predict(gamfit,newzdown,type="response"); 
	}
	gradmat=gradmat/(2*eps)
	return(gradmat); 
}

#apply(x, 2, mean)
#apply(x, 2, var)

##########################################################################
##  Do the GAM fits 
##########################################################################

gval=1.4; 
#1 Cyclopoids=f(Cyclopoids,Protozoa,Rotifers)
fit.Cyclopoids=gam(y1~s(Cyclopoids)+s(Protozoa)+s(Rotifers)+s(Cyclopoids,Protozoa)+s(Cyclopoids,Rotifers),gamma=gval,data=z); 

#2 Protozoa = f(Cyclopoids,Protozoa,Pico,Nano,Bacteria) 
fit.Protozoa=gam(y2~s(Cyclopoids)+s(Cyclopoids,Protozoa)+s(Protozoa)+s(Pico)+s(Pico,Protozoa)+s(Nano)+s(Nano,Protozoa)
+s(Bacteria)+s(Bacteria,Protozoa),gamma=gval,data=z); 

#3 Rotifers = f(Cyclopoids,Rotifers,Pico,Nano,Bacteria) 
fit.Rotifers=gam(y3~s(Cyclopoids)+s(Cyclopoids,Rotifers)+s(Rotifers)+s(Pico)+s(Pico,Rotifers)+s(Nano)+s(Nano,Rotifers)
+s(Bacteria)+s(Bacteria,Rotifers),gamma=gval,data=z); 

#4 Calanoids=f(Calanoids,Pico,Nano,Net,Bacteria); 
fit.Calanoids=gam(y4~s(Calanoids)+s(Pico)+s(Pico,Calanoids)+s(Nano)+s(Nano,Calanoids)+s(Net)+s(Net,Calanoids)+s(Bacteria)
+s(Bacteria,Calanoids),gamma=gval,data=z); 

#5 Pico=f(Protozoa,Rotifers,Calanoids,Pico,Nitrogen,PO4)
fit.Pico=gam(y5~s(Protozoa)+s(Protozoa,Pico)+s(Rotifers)+s(Rotifers,Pico)+s(Calanoids)+s(Calanoids,Pico)
+s(Pico)+s(Nitrogen)+s(Nitrogen,Pico)+s(PO4)+s(PO4,Pico),gamma=gval,data=z); 

#6 Nano=f(Protozoa,Rotifers,Calanoids,Nano,Nitrogen,PO4)
fit.Nano=gam(y6~s(Protozoa)+s(Protozoa,Nano)+s(Rotifers)+s(Rotifers,Nano)+s(Calanoids)+s(Calanoids,Nano)+s(Nano)
+s(Nitrogen)+s(Nitrogen,Nano)+s(PO4)+s(PO4,Nano),gamma=gval,data=z); 

#7 Net = f(Rotifers,Calanoids,Net,Nitrogen,PO4); 
fit.Net=gam(y7~s(Rotifers)+s(Rotifers,Net)+s(Calanoids)+s(Calanoids,Net)+s(Net)+s(Nitrogen)+s(Nitrogen,Net)+
s(PO4)+s(PO4,Net),gamma=gval,data=z); 

#8 Nitrogen=f(Pico,Nano,Net,Nitrogen,Bacteria); 
fit.Nitrogen=gam(y8~s(Pico)+s(Pico,Nitrogen)+s(Nano)+s(Nano,Nitrogen)+s(Net)+s(Net,Nitrogen)+s(Nitrogen)
+s(Bacteria)+s(Bacteria,Nitrogen),gamma=gval,data=z); 

#9 PO4=f(Pico,Nano,Net,PO4,Bacteria); 
fit.PO4=gam(y9~s(Pico)+s(Pico,PO4)+s(Nano)+s(Nano,PO4)+s(Net)+s(Net,PO4)+s(PO4)+s(Bacteria)+s(Bacteria,PO4),gamma=gval,data=z); 

#10 Bacteria=f(everything) 
fit.Bacteria=gam(y10~s(Cyclopoids)+s(Protozoa)+s(Protozoa,Bacteria)+s(Rotifers)+s(Rotifers,Bacteria)
+s(Calanoids)+s(Calanoids,Bacteria)+s(Pico)+s(Nano)+s(Net)+s(Nitrogen)+s(Nitrogen,Bacteria)+s(PO4)
+s(PO4,Bacteria)+s(Bacteria)+s(Ostracods)+s(Ostracods,Bacteria)+s(Harpacticoids),gamma=gval,data=z); 

#11 Ostracods=f(everything); 
fit.Ostracods=gam(y11~s(Cyclopoids)+s(Protozoa)+s(Rotifers)+s(Calanoids)+s(Pico)+s(Nano)+s(Net)
+s(Nitrogen)+s(PO4)+s(Bacteria)+s(Bacteria,Ostracods)+s(Ostracods)+s(Harpacticoids),gamma=gval,data=z); 

#12 Harpacticoids=f(everything); 
fit.Harpacticoids=gam(y12~s(Cyclopoids)+s(Protozoa)+s(Rotifers)+s(Calanoids)+s(Pico)+s(Nano)+s(Net)
+s(Nitrogen)+s(PO4)+s(Bacteria)+s(Ostracods)+s(Harpacticoids),gamma=gval,data=z); 

## Save the fits 
##save.image("~/Dropbox (Dept of Geography)/RREEBES/Beninca_etal_2008_Nature/data/direct from Steve/all_Gams.Rdata")
##load("~/Dropbox (Dept of Geography)/RREEBES/Beninca_etal_2008_Nature/data/direct from Steve/all_Gams.Rdata")


################################################################################## 
## Make the Jacobians
##################################################################################
# load("e:/pubs/Heerkloss/lennsruns/FoodWebGAMAllSpeciesLonger.Rdata"); 

nt=length(m0); Jac=array(0,c(12,12,nt)); 

Jac=array(0,c(12,12,nt)); epsval=0.01; 
fit=fit.Cyclopoids; Jac[1,1:12,1:nt]= t(gamgrad(fit,eps=epsval));  
fit=fit.Protozoa; Jac[2,1:12,1:nt] = t(gamgrad(fit,eps=epsval));  
fit=fit.Rotifers; Jac[3,1:12,1:nt] = t(gamgrad(fit,eps=epsval));  
fit=fit.Calanoids; Jac[4,1:12,1:nt] = t(gamgrad(fit,eps=epsval));  
fit=fit.Pico; Jac[5,1:12,1:nt] = t(gamgrad(fit,eps=epsval));  
fit=fit.Nano; Jac[6,1:12,1:nt] = t(gamgrad(fit,eps=epsval));  
fit=fit.Net; Jac[7,1:12,1:nt] = t(gamgrad(fit,eps=epsval));  
fit=fit.Nitrogen; Jac[8,1:12,1:nt] =  t(gamgrad(fit,eps=epsval));  
fit=fit.PO4; Jac[9,1:12,1:nt] = t(gamgrad(fit,eps=epsval));  
fit=fit.Bacteria; Jac[10,1:12,1:nt] = t(gamgrad(fit,eps=epsval));  
fit=fit.Ostracods; Jac[11,1:12,1:nt] = t(gamgrad(fit,eps=epsval));  
fit=fit.Harpacticoids; Jac[12,1:12,1:nt] = t(gamgrad(fit,eps=epsval));  


################################################################################## 
##  Compute GLE using the Jacobians
##################################################################################

u=rep(1,12); u=u/max(abs(u)); LE=0; 
for (j in 1:nt) {
	u=Jac[1:12,1:12,j]%*%u; umax=max(abs(u)); LE=LE+log(umax); u=u/umax; 
}

LE=LE/(3.35*nt); LE; 
# save.image("e:/projects/Heerkloss/lennsruns/FoodWebGAMAllSpeciesLongest.Rdata"); 

## gives -0.01382459




## Here work from Z
colnames(Z)
colnames(Z) <- c("Cyclopoids", "Protozoa", "Rotifers", "Calanoid.copepods",
                 "Picophytoplankton", "Nanophytoplankton", "Filamentous.diatoms",
                 "Total.dissolved.inorganic.nitrogen", "Soluble.reactive.phosphorus",
                 "Bacteria", "Ostracods", "Harpacticoids")

source("~/Desktop/indirect_method_functions.r")


LE <- Get_GLE_Beninca(Z)
LE

## gives -0.01382459

