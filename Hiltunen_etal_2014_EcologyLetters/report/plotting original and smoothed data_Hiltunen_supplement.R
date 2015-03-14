## Plotting original data + smooths for retrospective analysis of eco-evo dynamics. 
## Hiltunen et al. 2014 supplementary material - not reproduced

rm(list = ls())

dat_loc <- "C:/Users/Jason/Documents/RREEBES/Hiltunen_etal_2014_EcologyLetters/data/"  # change me! 
image_loc <- "C:/Users/Jason/Documents/RREEBES/Hiltunen_etal_2014_EcologyLetters/images/"


setwd(dat_loc) 

sets=c("Barnet 1981",
"Bohannan 1997",
"Dulos 1984",
"Canale 1973",
"Jost 1973",
"van den Ende 1973",
"Tsuchiya 1972 set A",
"Tsuchiya 1972 set B",
"Tsuchiya 1972 set C",
"Gause 1934",
"Luckinbill 1973",
"Luckinbill 1974",
"Veilleux 1976 set A",
"Veilleux 1976 set B",
"Veilleux 1976 set C",
"Boraas 1985",
"Yoshida 2003",
"Yoshida 2007",
"Huffaker 1958",
"Utida 1957 set A",
"Utida 1957 set B")

setwd(image_loc)
pdf(file="AllOriginalData.pdf",onefile=TRUE); 

for(j in 1:length(sets)) {
set=sets[j];
X=read.csv(paste(dat_loc,set,".csv", sep="")); # change me! 

par(mfrow=c(2,1),mgp=c(2,1,0),mar=c(4,4,2.5,1),cex.main=1)

########## Undo log10-transformations in some data sets 
if(set=="Dulos 1984"|set=="van den Ende 1973"|set=="Barnet 1981"|set=="Bohannan 1997") {
	X$prey_pop <- 10^(X$prey_pop); 
	X$pred_pop <- 10^(X$pred_pop); 
}

start_cut= X$start[1] #how much to remove from the start
end_cut=X$end[1] 

##### Assemble prey data frames 
preyX=X$prey_time; preyY=X$prey_pop;
##removing NaNs
Q=cbind(preyX,preyY); Q=na.omit(Q);
preyX=Q[,1]; preyY=Q[,2];
##scaling 
preyX=preyX/max(preyX); preyY=preyY/max(preyY)
## make data frames 
prey1=cbind(preyX,preyY)
prey1=data.frame(prey1)
prey_all=data.frame(prey1)
prey1=prey1[prey1$preyX>start_cut,];
prey1=prey1[prey1$preyX<end_cut,];

#### Assemble predator data frames 
predX=X$pred_time; predY=X$pred_pop;
##removing NaNs
Q=cbind(predX,predY); Q=na.omit(Q);
predX=Q[,1]; predY=Q[,2];
##scaling 
predX=predX/max(predX); predY=predY/max(predY)
##make data frames 
pred1=cbind(predX,predY)
pred1=data.frame(pred1)
pred_all=data.frame(pred1)
pred1=pred1[pred1$predX>start_cut,];
pred1=pred1[pred1$predX<end_cut,];


######################################################## 
# Plot data without smoothing on arithmetic scale
########################################################
plot(prey_all, type='o',col = "black",xlab=" ", ylab="Scaled Populations",ylim=c(0, 1),xlim=c(min(prey_all[,1]), 1),cex=1.2)
lines(pred_all, type='o',col = "black",ylim=c(0, 1),xlim=c(min(prey_all[,1]), 1))

lines(prey1, type='o',col = "green3",lwd=3,ylim=c(0, 1),xlim=c(min(prey_all[,1]), 1),cex=1.25)
lines(pred1, type='o',col = "red",lwd=3,ylim=c(0, 1),xlim=c(min(prey_all[,1]), 1),pch=16,cex=1.5)

title(paste(set,": Original data (black part omitted from analyses)"))

############################################################ 
#Plot data on log scale, with smooths
#############################################################
prey1$preyY=log10(prey1$preyY); pred1$predY=log10(pred1$predY); 

smooth_prey=smooth.spline(prey1$preyX,prey1$preyY); 
maxdf=0.67*length(prey1$preyX); 
if(smooth_prey$df>maxdf) smooth_prey=smooth.spline(prey1$preyX,prey1$preyY,df=maxdf);  

smooth_pred=smooth.spline(pred1$predX,pred1$predY); 
maxdf=0.67*length(pred1$predX); 
if(smooth_pred$df>maxdf) smooth_pred=smooth.spline(pred1$predX,pred1$predY,df=maxdf); 

px.prey=seq(min(prey1[, 1]),max(prey1[, 1]),length=100);
px.pred=seq(min(pred1[, 1]),max(pred1[, 1]),length=100);

smooth_pred2=predict(smooth_pred,px.pred)$y; 
smooth_prey2=predict(smooth_prey,px.prey)$y; 

ylims=range(c(prey1$preyY,pred1$predY)); 

plot(px.prey,smooth_prey2, type='l',xlab="Scaled time", ylab="log10(Scaled Populations)",
lwd=3,col = "green3", ylim=ylims,xlim=c(min(prey_all[,1]), 1))
lines(prey1, type='p',col = "green3",lwd=3,xlim=c(min(prey_all[,1]), 1))

lines(px.pred,smooth_pred2, type='l',lwd=3, 
col = "red",xlim=c(min(prey_all[,1]), 1))
lines(pred1, type='p',col = "red",lwd=3,xlim=c(min(prey_all[,1]), 1))

title(paste(set, ": Smoothed log populations"))

}
dev.off(); 
