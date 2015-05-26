rm(list=ls())

library(tidyr)
library(dplyr)

## import the data
XO <- read.csv("~/Dropbox (Dept of Geography)/RREEBES/Beninca_etal_2008_Nature/data/direct from Steve/interp_short_allsystem_newnames.csv")

## Select the time period to use 
start.longest=334
start.longer=808
start.shorter=1035
start.same.as.ours <- 341.0
#e=XO$Day.Number > start.same.as.ours ## this gives  -0.01382459
e=XO$Day.Number > start.longer ## this gives   0.08415112

XO=XO[e,]
e=XO$Day.Number < 2654
XO=XO[e,]

## long format
mt <- gather(XO, key="Day.Number")
names(mt) <- c("Day.number", "variable", "value")

####################################################################################################
mt$fr.value <- mt$value^0.25

####################################################################################################
ww.td <- filter(mt, variable=="Total.dissolved.inorganic.nitrogen" |
                  variable=="Soluble.reactive.phosphorus" |
                  variable=="Bacteria" |
                  variable=="Ostracods" |
                  variable=="Harpacticoids")
## and to not detrend
ww.ntd <- filter(mt, variable!="Total.dissolved.inorganic.nitrogen" &
                   variable!="Soluble.reactive.phosphorus" &
                   variable!="Bacteria" &
                   variable!="Ostracods" &
                   variable!="Harpacticoids")
## detrend:
ww1 <- group_by(ww.td, variable) %>%
  mutate(trend=ksmooth(Day.number,fr.value,bandwidth=300,kernel="normal")$y)
ww1$dt.value <- ww1$fr.value-ww1$trend
#ww1 <- select(ww1, trend)

## don't detrend
ww2 <- ww.ntd
ww2$trend <- 0

ww2$dt.value <- ww2$fr.value

## rejoin
detrended <- rbind(ww1, ww2)

####################################################################################################
final <- detrended
final$y <- final$dt.value
summarise(final, mean=mean(y), sd=var(y))

####################################################################################################
####################################################################################################
#Means and standard deviations very similar to Steve's'
####################################################################################################
####################################################################################################

##########################################################################
## Some data shaping first
library(reshape2)
final.to.melt <- final[, c("variable", "y", "Day.number")]
names(final.to.melt)[1] <- "Species"
melted <- melt(final.to.melt, id=c("Species", "Day.number"))
X <- acast(melted, formula= Day.number ~ Species)
str(X)


### OK, lets right this properly.
### Assume the data comes in as a matrix, with the time in the rows and species in the columns

source("~/Dropbox (Dept of Geography)/RREEBES/Beninca_etal_2008_Nature/report/functions/indirect_method_functions.r")

LE <- Get_GLE_Beninca(X)
LE



###### From here on is Steve's

X <- as.data.frame(X)

# create the data series 
Cyclopoids=X$Cyclopoids
Protozoa=X$Protozoa
Rotifers=X$Rotifers 
Calanoids=X$Calanoid.copepods   
Pico=X$Picophytoplankton
Nano=X$Nanophytoplankton 
Net=X$Filamentous.diatoms
Nitrogen=X$Total.dissolved.inorganic.nitrogen
PO4=X$Soluble.reactive.phosphorus 
Bacteria=X$Bacteria 
Ostracods=X$Ostracods 
Harpacticoids=X$Harpacticoids



# Make data frame z with current (time t) and future (time t+1) values of all state variables  
nx=nrow(X); m1=2:nx; m0=1:(nx-1)
ZZ=cbind(Cyclopoids,Protozoa,Rotifers,Calanoids,Pico,Nano,Net,Nitrogen,PO4,Bacteria,Ostracods,Harpacticoids); 
x=data.frame(ZZ[m0,]);  
y=data.frame(ZZ[m1,]); names(y)<-cbind("y1","y2","y3","y4","y5","y6","y7","y8","y9","y10","y11","y12"); 
z=cbind(x,y); 


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


################################################################################## 
## Make the Jacobians
##################################################################################

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

## gives  -0.01382459


#load(file="~/Desktop/all.gams.Rdata")
#load(file="~/Desktop/Z.Rdata")







