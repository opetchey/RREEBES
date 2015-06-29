### Assume the data comes in as a matrix, with the time in the rows and species in the columns

Get_GLE_Beninca <- function(X1,gval=1.4) {
  
  #X1=X
  
  require(mgcv)
  
  ## prepare the lagging
  end.t <- dim(X1)[1]
  
  ## change X to be a data.frame
  X1 <- as.data.frame(X1)
  
  ## make columns of X in alphabetical order
  X1 <- X1[,order(colnames(X1))]
  
  ## make a matrix of unlagged and lagged variables
  Z <- cbind(X1[-1,], X1[-end.t,])
  colnames(Z) <- c(paste("y_", names(X1), sep=""), names(X1))
  
  #1 Cyclopoids=f(Cyclopoids,Protozoa,Rotifers)
  fit.Cyclopoids <- gam(y_Cyclopoids ~ s(Cyclopoids) + s(Protozoa) + s(Rotifers) +
                          s(Cyclopoids,Protozoa) + s(Cyclopoids,Rotifers),
                        gamma=gval,data=Z); 
  
  #2 Protozoa = f(Cyclopoids,Protozoa,Picophytoplankton,Nanophytoplankton,Bacteria) 
  fit.Protozoa <- gam(y_Protozoa ~ s(Cyclopoids) + s(Cyclopoids,Protozoa) + s(Protozoa) +
                        s(Picophytoplankton) + s(Picophytoplankton,Protozoa) +
                        s(Nanophytoplankton) + s(Nanophytoplankton,Protozoa) +
                        s(Bacteria)+s(Bacteria,Protozoa),
                      gamma=gval,data=Z); 
  
  #3 Rotifers = f(Cyclopoids,Rotifers,Picophytoplankton,Nanophytoplankton,Bacteria) 
  fit.Rotifers <- gam(y_Rotifers ~ s(Cyclopoids) + s(Cyclopoids,Rotifers) +
                        s(Rotifers) + s(Picophytoplankton) +
                        s(Picophytoplankton,Rotifers) +
                        s(Nanophytoplankton) + s(Nanophytoplankton,Rotifers) +
                        s(Bacteria) + s(Bacteria,Rotifers),
                      gamma=gval,data=Z); 
  
  #4 Calanoids=f(Calanoids,Picophytoplankton,Nanophytoplankton,Filamentous.diatoms,Bacteria); 
  fit.Calanoid.copepods <- gam(y_Calanoid.copepods ~ s(Calanoid.copepods) +
                                 s(Picophytoplankton) + s(Picophytoplankton,Calanoid.copepods) +
                                 s(Nanophytoplankton) + s(Nanophytoplankton,Calanoid.copepods) +
                                 s(Filamentous.diatoms) + s(Filamentous.diatoms,Calanoid.copepods) +
                                 s(Bacteria) +
                                 s(Bacteria,Calanoid.copepods),
                               gamma=gval,data=Z); 
  
  #5 Picophytoplankton=f(Protozoa,Rotifers,Calanoid.copepods,Picophytoplankton,Total.dissolved.inorganic.nitrogen,Soluble.reactive.phosphorus)
  fit.Picophytoplankton <- gam(y_Picophytoplankton ~ s(Protozoa) + s(Protozoa,Picophytoplankton) +
                                 s(Rotifers) + s(Rotifers,Picophytoplankton) + s(Calanoid.copepods) +
                                 s(Calanoid.copepods,Picophytoplankton) + s(Picophytoplankton) +
                                 s(Total.dissolved.inorganic.nitrogen) +
                                 s(Total.dissolved.inorganic.nitrogen,Picophytoplankton) +
                                 s(Soluble.reactive.phosphorus) +
                                 s(Soluble.reactive.phosphorus,Picophytoplankton),
                               gamma=gval,data=Z); 
  
  #6 Nanophytoplankton=f(Protozoa,Rotifers,Calanoid.copepods,Nanophytoplankton,Total.dissolved.inorganic.nitrogen,Soluble.reactive.phosphorus)
  fit.Nanophytoplankton <- gam(y_Nanophytoplankton ~ s(Protozoa) + s(Protozoa,Nanophytoplankton) +
                                 s(Rotifers) + s(Rotifers,Nanophytoplankton) +
                                 s(Calanoid.copepods) + s(Calanoid.copepods,Nanophytoplankton) +
                                 s(Nanophytoplankton) + s(Total.dissolved.inorganic.nitrogen) +
                                 s(Total.dissolved.inorganic.nitrogen,Nanophytoplankton) + 
                                 s(Soluble.reactive.phosphorus) +
                                 s(Soluble.reactive.phosphorus,Nanophytoplankton),
                               gamma=gval,data=Z); 
  
  #7 Filamentous.diatoms = f(Rotifers,Calanoid.copepods,Filamentous.diatoms,Total.dissolved.inorganic.nitrogen,Soluble.reactive.phosphorus); 
  fit.Filamentous.diatoms <- gam(y_Filamentous.diatoms ~ s(Rotifers) + s(Rotifers,Filamentous.diatoms) +
                                   s(Calanoid.copepods) + s(Calanoid.copepods,Filamentous.diatoms) +
                                   s(Filamentous.diatoms) + s(Total.dissolved.inorganic.nitrogen) +
                                   s(Total.dissolved.inorganic.nitrogen,Filamentous.diatoms) +
                                   s(Soluble.reactive.phosphorus) +
                                   s(Soluble.reactive.phosphorus,Filamentous.diatoms),
                                 gamma=gval,data=Z); 
  
  #8 Total.dissolved.inorganic.nitrogen=f(Picophytoplankton,Nanophytoplankton,Filamentous.diatoms,Total.dissolved.inorganic.nitrogen,Bacteria); 
  fit.Total.dissolved.inorganic.nitrogen <- gam(y_Total.dissolved.inorganic.nitrogen ~ s(Picophytoplankton) +
                                                  s(Picophytoplankton,Total.dissolved.inorganic.nitrogen) +
                                                  s(Nanophytoplankton) +
                                                  s(Nanophytoplankton,Total.dissolved.inorganic.nitrogen) +
                                                  s(Filamentous.diatoms) +
                                                  s(Filamentous.diatoms,Total.dissolved.inorganic.nitrogen) +
                                                  s(Total.dissolved.inorganic.nitrogen) +
                                                  s(Bacteria) +
                                                  s(Bacteria,Total.dissolved.inorganic.nitrogen),
                                                gamma=gval,data=Z); 
  
  #9 Soluble.reactive.phosphorus=f(Picophytoplankton,Nanophytoplankton,Filamentous.diatoms,Soluble.reactive.phosphorus,Bacteria); 
  fit.Soluble.reactive.phosphorus <- gam(y_Soluble.reactive.phosphorus ~ s(Picophytoplankton) +
                                           s(Picophytoplankton,Soluble.reactive.phosphorus) +
                                           s(Nanophytoplankton) +
                                           s(Nanophytoplankton,Soluble.reactive.phosphorus) +
                                           s(Filamentous.diatoms) +
                                           s(Filamentous.diatoms,Soluble.reactive.phosphorus) +
                                           s(Soluble.reactive.phosphorus) +
                                           s(Bacteria) + s(Bacteria,Soluble.reactive.phosphorus),
                                         gamma=gval,data=Z); 
  
  #10 Bacteria=f(everything) 
  fit.Bacteria <- gam(y_Bacteria ~ s(Cyclopoids) + s(Protozoa) + s(Protozoa,Bacteria) + s(Rotifers) +
                        s(Rotifers,Bacteria) + s(Calanoid.copepods) + s(Calanoid.copepods,Bacteria) +
                        s(Picophytoplankton) + s(Nanophytoplankton) + s(Filamentous.diatoms) +
                        s(Total.dissolved.inorganic.nitrogen) + s(Total.dissolved.inorganic.nitrogen, Bacteria) +
                        s(Soluble.reactive.phosphorus) + s(Soluble.reactive.phosphorus, Bacteria) +
                        s(Bacteria) + s(Ostracods) + s(Ostracods,Bacteria) + s(Harpacticoids),
                      gamma=gval,data=Z); 
  
  #11 Ostracods=f(everything); 
  fit.Ostracods <- gam(y_Ostracods ~ s(Cyclopoids) + s(Protozoa) + s(Rotifers) + s(Calanoid.copepods) +
                         s(Picophytoplankton) + s(Nanophytoplankton) + s(Filamentous.diatoms) +
                         s(Total.dissolved.inorganic.nitrogen) + s(Soluble.reactive.phosphorus) +
                         s(Bacteria) + s(Bacteria,Ostracods) + s(Ostracods) + s(Harpacticoids),
                       gamma=gval,data=Z); 
  
  #12 Harpacticoids=f(everything); 
  fit.Harpacticoids <- gam(y_Harpacticoids ~ s(Cyclopoids) + s(Protozoa) + s(Rotifers) + 
                             s(Calanoid.copepods) + s(Picophytoplankton) + s(Nanophytoplankton) + 
                             s(Filamentous.diatoms) + s(Total.dissolved.inorganic.nitrogen) +
                             s(Soluble.reactive.phosphorus) + s(Bacteria) + s(Ostracods) +
                             s(Harpacticoids),
                           gamma=gval,data=Z); 
  
  
  
  
  ## put the models together into a list
  ## at present this should be alphabetical
  all.gams <- list(Bacteria=fit.Bacteria, 
                   Calanoid.copepods=fit.Calanoid.copepods, 
                   Cyclopoids=fit.Cyclopoids, 
                   Filamentous.diatoms=fit.Filamentous.diatoms, 
                   Harpacticoids=fit.Harpacticoids,
                   Nanophytoplankton=fit.Nanophytoplankton, 
                   Ostracods=fit.Ostracods, 
                   Picophytoplankton=fit.Picophytoplankton, 
                   Protozoa=fit.Protozoa, 
                   Rotifers=fit.Rotifers, 
                   Soluble.reactive.phosphorus=fit.Soluble.reactive.phosphorus,                  
                   Total.dissolved.inorganic.nitrogen=fit.Total.dissolved.inorganic.nitrogen)
  all.gams

  ##save(all.gams, file="~/Desktop/all.gams.Rdata")
  ##save(Z, file="~/Desktop/Z.Rdata")
  
  LE <- Get_LE_from_fit2(all.gams, Z[,13:24])
  rez <- list(LE, all.gams, Z)
  rez
}



# Function to compute gradient of a GAM fit with respect to all 12 state variables
# NOTE: this assumes the data set z is available as a global data frame
# NOTE: this computes a matrix with all 12 gradients at all times in the 
#       data series. 
gamgrad_v2=function(gamfit, eps, zv2) {
  gradmat=matrix(0,dim(zv2)[1],12); 
  for(j in 1:12) { 
    newzup=zv2; newzdown=zv2;
    newzup[,j]=zv2[,j]+eps; newzdown[,j]=zv2[,j]-eps;
    gradmat[,j]=predict(gamfit,newzup,type="response")-predict(gamfit,newzdown,type="response"); 
  }
  gradmat=gradmat/(2*eps)
  return(gradmat); 
}





Get_LE_from_fit2 <- function(fits, X1, epsval=0.01) {
  
  nt=length(X1[,1]-1)
  Jac=array(0,c(length(fits),length(fits),nt))
  for(i in 1:length(fits))
    Jac[i,, ]= t(gamgrad_v2(fits[[i]],eps=epsval, X1));  
  
  u=rep(1,12); u=u/max(abs(u)); LE=0; 
  for (j in 1:nt) {
    u=Jac[1:12,1:12,j]%*%u; umax=max(abs(u)); LE=LE+log(umax); u=u/umax; 
  }
  
  LE.ours=LE/(3.35*nt)
  LE.ours
}
