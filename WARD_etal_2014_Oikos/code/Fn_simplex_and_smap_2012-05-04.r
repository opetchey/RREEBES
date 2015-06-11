

# Tent function
TentFn = function(X, S=2){
  if(X < 0.5) Y = S*X
  if(X >= 0.5) Y = S*(1-X)
  return(Y)
}

# Simulate Tent timeseries
SimTentFn = function(Nobs, S){
  Y = numeric(Nobs)
  Y[1] = runif(1)
  for(i in 2:Nobs) Y[i] = TentFn(Y[i-1], S=S)
  return(Y)
}

# Simulate predator-prey dynamics
SimPredPreyFn = function(Nobs, Nt=100, A=0.04, B=0.05, C=0.2, E=1){
  X = Y = matrix(NA, ncol=Nobs, nrow=Nt)
  X[1,1] = runif(1)
  Y[1,1] = runif(1)
  for(T in 1:Nobs){
    for(dT in 2:Nt){
      X[dT,T] = X[dT-1,T] + ( A*X[dT-1,T] - B*X[dT-1,T]*Y[dT-1,T] ) / Nt
      Y[dT,T] = Y[dT-1,T] + ( E*B*X[dT-1,T]*Y[dT-1,T] - C*Y[dT-1,T] ) / Nt
    }
    if(T<Nobs){
      X[1,T+1] = X[Nt,T]
      Y[1,T+1] = Y[Nt,T]
    }
  }
  List = list(X=X[1,], Y=Y[1,])
  matplot(cbind(X[1,],Y[1,]), type="l", xlab="Year", ylab="Abundance")
  return(List)
}

# Make prediction for observation PredNum of timeseries Y and embedding dimension Embed
NltsPred = function(Y, Nembed, PredNum, Method, Theta=NA){

  if(PredNum<=Nembed) stop("Can't predict less than or equal to Nembed")

  L = length(Y)
  Neighbors = Nembed+1

  # Basis expansion by lag
  Mat = matrix(NA, nrow=L-Nembed, ncol=2+Nembed)
  colnames(Mat) = c("ObsNum","Y",paste("X",1:Nembed,sep=""))
  Mat[,'ObsNum'] = (Nembed+1):L
  Mat[,'Y'] = Y[(Nembed+1):L]
  for(i in 1:Nembed){
    Mat[,2+i] = Y[(Nembed+1):L - i]
  }

  # Make library
  Which = which(Mat[,1]==PredNum)
  PredObs = Mat[Which,]
  LibObs = Mat[-Which,]

  # Identify neighbors
  Distance = sqrt( rowSums( ( LibObs[,-c(1:2),drop=FALSE] - outer(rep(1,L-Nembed-1),PredObs[-c(1:2)]) )^2 ) )

  # Simplex
  if(Method=="Simplex"){
    WhichNeighbor = order(Distance)[1:Neighbors]
    Ypred = LibObs[WhichNeighbor,'Y']
    Pred = mean(Ypred)
  }
  
  # Smap (derived from Glaser et al. 2011 CJFAS)
  if(Method=="Smap"){
    Weight = exp(-Theta*Distance/mean(Distance))
    B = Weight * LibObs[,'Y']
    A = Weight * cbind(rep(1,nrow(LibObs)), LibObs[,-match(c('ObsNum','Y'),colnames(LibObs))])
    SVD = svd(A)   # A = SVD$u %*% diag(SVD$d) %*% t(SVD$v); solve(A) = SVD$v %*% diag(1/SVD$d) %*% t(SVD$u)
    Ainv = SVD$v %*% diag(1/SVD$d) %*% t(SVD$u)
    C = Ainv %*% B
    Pred = c(1, PredObs[-match(c('ObsNum','Y'),colnames(LibObs))]) %*% C
  }

  # This is my original idea of how Smaps would work, and seems to perform similarly (based on almost no testing)
  if(Method=="Local_Linear"){
    Weight = exp(-Theta*Distance/mean(Distance))
    Ypred = LibObs[,'Y']*Weight
    Xpred = LibObs[,-match(c('ObsNum','Y'),colnames(LibObs))]*Weight
    Lm = lm(Ypred ~ Xpred + 0)
    Pred = ( PredObs[-match(c('ObsNum','Y'),colnames(LibObs))] %*% coef(Lm) )[1]
  }

  return(Pred)
}

# Estimate correlation for a given Embedding Dimension, Method, and Theta
NltsFn = function(Y, Nembed, Theta=NA, Method){

  # Table of leave-on-out predictions
  Table = array(NA, dim=c(length(Y),2))
  for(i in (Nembed+1):length(Y)){
    Pred = NltsPred(Y=Y, Nembed=Nembed, PredNum=i, Theta=Theta, Method=Method)
    Table[i,1:2] = c(Y[i],Pred)
  }

  # Calculate and return Correlation
  Corr = cor(Table[,1], Table[,2], use="complete.obs")
  Return = list(Table=Table, Corr=Corr)

  return(Return)
}

# Search for optimal embedding dimension
EmbedFn = function(Y, Candidates=1:5){
  Corr = numeric(length(Candidates))
  for(E in Candidates){
    Output = NltsFn(Y, Nembed=Candidates[E], Method="Simplex", Theta=NA)
    Corr[E] = Output$Corr
  }
  #plot(Corr, type="b", ylim=c(0,1), xlim=range(Candidates))
  Max = which.max(Corr)
  return(Max)
}

# Search for optimal Theta
ThetaFn = function(Y, ThetaSet=c(0,exp(seq(-3,3))), Nembed){
  Corr = numeric(length(ThetaSet))
  for(ThetaI in 1:length(ThetaSet)){
    Output = NltsFn(Y, Nembed=Nembed, Method="Smap", Theta=ThetaSet[ThetaI])
    Corr[ThetaI] = Output$Corr
  }
  #plot(Corr, type="b", ylim=c(0,1), xlim=range(ThetaSet))
  Max = which.max(Corr)
  return(list(Corr=Corr, Max=Max))
}
