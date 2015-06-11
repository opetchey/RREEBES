library(MARSS)
library(nlts)
library(mgcv)
library(np)
library(locfit)
library(forecast)
library(kernlab)
library(tsDyn)
library(ltsa)
library(timsac)
library(randomForest)

# Load in the data. This dataset only contains the 
dat = read.csv("masterDat 052015.csv",header=T) 

NAHEAD = 5 # number of points ahead to forecast
MODELS = 150  # number of candidates (this is overestimate)

# dimension predicted and predictedSE to have the same dimensions
# as dat, so that each observation will have a predicted value and se
predicted = matrix(NA,dim(dat)[1],MODELS) 
predictedSE = matrix(NA,dim(dat)[1],MODELS)

numRec = max(dat$ID) # number of unique time series 
model.output = array(list(),c(numRec,MODELS)) # list of model objects

# source Jim's file. Note that a more recent version
# of this function is here, https://github.com/James-Thorson/NLTS
source("Fn_simplex_and_smap_2012-05-04.r")

for(w in 1:numRec) {

  y = dat$Value[which(dat$ID==w)]
  
  # to standardize by the mean, uncomment
  #y = (y-mean(y,na.rm=T))/sd(y,na.rm=T)
  n.y = length(y) # length of time series
  y.train = y[1:(n.y-5)]
  y.test = y[(n.y-5+1):n.y]
  x = seq(1,length(y.train))
  
  model.count = 1
  model.names = rep("",MODELS)
  
  # Generalized additive model / GAM with spline over time/years
  gamfit = gam(y.train~s(x))
  # predict function for gam requires a new list of predictor variables as newdata
  pred = predict(gamfit, newdata = list("x" = seq(1,n.y)), se.fit=TRUE)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = pred$fit[(n.y-NAHEAD+1):n.y]
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = pred$se.fit[(n.y-NAHEAD+1):n.y]
  model.output[[w,model.count]] = gamfit
  model.names[model.count] = "GAM (gam)"  
  model.count = model.count + 1

  # Neural network time series model with embedding dimension = 1, hidden units (size) = 1
  nnetTs.11 = nnetTs(y.train,m=1,size=1)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = predict(nnetTs.11,n.ahead = NAHEAD)
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = NA
  model.output[[w,model.count]] = nnetTs.11
  model.names[model.count] = "nnetTs.11 (nnetTs)"  
  model.count = model.count + 1

  # Neural network time series model with embedding dimension = 1, hidden units (size) = 2
  nnetTs.12 = nnetTs(y.train,m=1,size=2)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = predict(nnetTs.12,n.ahead = NAHEAD)
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = NA
  model.output[[w,model.count]] = nnetTs.12
  model.names[model.count] = "nnetTs.12 (nnetTs)"  
  model.count = model.count + 1

  # Neural network time series model with embedding dimension = 2, hidden units (size) = 1  
  nnetTs.21 = nnetTs(y.train,m=2,size=1)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = predict(nnetTs.21,n.ahead = NAHEAD)
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = NA
  model.output[[w,model.count]] = nnetTs.21
  model.names[model.count] = "nnetTs.21 (nnetTs)"  
  model.count = model.count + 1
  
  # Neural network time series model with embedding dimension = 2, hidden units (size) = 2  
  nnetTs.22 = nnetTs(y.train,m=2,size=2)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = predict(nnetTs.22,n.ahead = NAHEAD)
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = NA
  model.output[[w,model.count]] = nnetTs.22
  model.names[model.count] = "nnetTs.22 (nnetTs)"  
  model.count = model.count + 1 

  # Neural network time series model with embedding dimension = 3, hidden units (size) = 1
  nnetTs.31 = nnetTs(y.train,m=3,size=1)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = predict(nnetTs.31,n.ahead = NAHEAD)
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = NA
  model.output[[w,model.count]] = nnetTs.31
  model.names[model.count] = "nnetTs.31 (nnetTs)"  
  model.count = model.count + 1 

  # Neural network time series model with embedding dimension = 3, hidden units (size) = 2  
  nnetTs.32 = nnetTs(y.train,m=3,size=2)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = predict(nnetTs.32,n.ahead = NAHEAD)
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = NA
  model.output[[w,model.count]] = nnetTs.32
  model.names[model.count] = "nnetTs.32 (nnetTs)"  
  model.count = model.count + 1
  
  # Simple random walk with no drift using the rwf() function
  fit.nodrift <- rwf(y.train,h=NAHEAD) # ~ random walk forecast model, no drift
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = fit.nodrift$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (fit.nodrift$upper[,2] - fit.nodrift$mean)/1.96
  model.output[[w,model.count]] = fit.nodrift
  model.names[model.count] = "AR - no drift (rwf)"  
  model.count = model.count + 1    

  # Simple random walk with drift using the rwf() function  
  fit.drift <- rwf(y.train,h=NAHEAD, drift=TRUE) # ~ random walk forecast model, with drift
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = fit.drift$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (fit.drift$upper[,2] - fit.drift$mean)/1.96
  model.output[[w,model.count]] = fit.drift
  model.names[model.count] = "AR - drift (rwf)"  
  model.count = model.count + 1   
  
  # Step-wise fractionally differenced auto-arima fitted model
  autoarima <- arfima(y.train) 
  f = forecast(autoarima,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96 
  model.output[[w,model.count]] = autoarima
  model.names[model.count] = "ARIMA - with frac diff (arfima)"  
  model.count = model.count + 1

  # Exponentially smoothed time series forecasts. Frequency here is just included a priori, not estimated
  fit.es <- ets(ts(y.train,frequency=1)) # exponentially smoothed time series forecasts
  f = forecast(fit.es,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96 
  model.output[[w,model.count]] = fit.es
  model.names[model.count] = "Exp smooth (freq=1) (ets)"  
  model.count = model.count + 1

  # Exponentially smoothed time series forecasts. Frequency here is just included a priori, not estimated.
  # Higher order frequencies included to try to capture age structure for things like aggregate salmon counts.    
  fit.es <- ets(ts(y.train,frequency=2)) # exponentially smoothed time series forecasts
  f = forecast(fit.es,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96 
  model.output[[w,model.count]] = fit.es
  model.names[model.count] = "Exp smooth (freq=2) (ets)"  
  model.count = model.count + 1
  
  # Exponentially smoothed time series forecasts. Frequency here is just included a priori, not estimated.
  # Higher order frequencies included to try to capture age structure for things like aggregate salmon counts.        
  fit.es <- ets(ts(y.train,frequency=3)) # exponentially smoothed time series forecasts
  f = forecast(fit.es,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96 
  model.output[[w,model.count]] = fit.es
  model.names[model.count] = "Exp smooth (freq=3) (ets)"  
  model.count = model.count + 1

  # Exponentially smoothed time series forecasts. Frequency here is just included a priori, not estimated.
  # Higher order frequencies included to try to capture age structure for things like aggregate salmon counts.      
  fit.es <- ets(ts(y.train,frequency=4)) # exponentially smoothed time series forecasts
  f = forecast(fit.es,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96 
  model.output[[w,model.count]] = fit.es
  model.names[model.count] = "Exp smooth (freq=4) (ets)"  
  model.count = model.count + 1
    
  # Structural time series model  
  fit.sts <- StructTS(y.train) # structural time series
  f = forecast(fit.sts,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96  
  model.output[[w,model.count]] = fit.sts
  model.names[model.count] = "Structural time series (freq=1) (StructTS)"  
  model.count = model.count + 1
    
  # Structural time series model. 
  # Higher order frequencies included to try to capture age structure for things like aggregate salmon counts.     
  fit.sts <- StructTS(ts(y.train,frequency=2)) # structural time series
  f = forecast(fit.sts,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96  
  model.output[[w,model.count]] = fit.sts
  model.names[model.count] = "Structural time series (freq=2) (StructTS)"  
  model.count = model.count + 1
    
  # Explore multiple options for locally weighted regression. Try linear, quadratic, cubic.
  # Also explore dimension of nearest neighbors and bandwidth, etc.
  # These loops are terribly inefficient, but find the best solution
  mse.best = 100
  pars = 0
  # these loops are over the nearest neighbors, bandwidth, and polynomial
  for(i in seq(0.2,3,0.05)) {
      # 1st order
      locreg = locfit(y.train~lp(x,nn=i, deg = 1))
      #mse.prop = sum((y[(n.y-NAHEAD+1):n.y]-predict(locreg, newdata = list("x" = seq(1,n.y)))[(n.y-NAHEAD+1):n.y])^2)
      mse.prop = mean((y.train-fitted(locreg))^2)
      if(mse.prop < mse.best) {
        pars = c(i, 1)
        mse.best = mse.prop     	
      }

      # 2nd order
      locreg = locfit(y.train~lp(x,nn=i, deg = 2))
      mse.prop = mean((y.train-fitted(locreg))^2)
      if(mse.prop < mse.best) {
        pars = c(i, 2)
        mse.best = mse.prop	
      }   

      # 3rd order
      locreg = locfit(y.train~lp(x,nn=i, deg = 3))
      mse.prop = mean((y.train-fitted(locreg))^2)
      if(mse.prop < mse.best) {
        pars = c(i, 3)
        mse.best = mse.prop	
      }   
       
  } # end i
  
  # This local regression uses the best parameters found above for nearest neighbors (nn)
  # and degree of polynomial (deg)
  locreg = locfit(y.train~lp(x, nn=pars[1], deg = pars[2])) 
  f = predict(locreg, newdata = list("x" = seq(1,n.y)))[(n.y-NAHEAD+1):n.y]
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = NA
  model.output[[w,model.count]] = locreg
  model.names[model.count] = "Local regression (locfit)"  
  model.count = model.count + 1
    
  # non-parameteric automatic bandwith selection (fixed, adaptive nn, generalized nn)
  model.np <- npreg(y.train ~ x, regtype = "ll", bwmethod = "cv.aic",gradients = TRUE)
  f = predict(model.np, newdata = list("x" = seq(1,n.y)))[(n.y-NAHEAD+1):n.y]
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = NA
  model.output[[w,model.count]] = model.np
  model.names[model.count] = "Non-param bandwidth (npreg)"  
  model.count = model.count + 1
    
  # ARIMA models. We abandoned using auto.arima and wanted to look at whether certain orders were supported. So 
  # we are fitting each model manually
  auto.arima = NULL
  try(auto.arima <- arima(ts(y.train,frequency=1), order = c(1,0,1)),silent=T)
  if(is.null(auto.arima)==F) {
  f = forecast(auto.arima,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96  
  model.output[[w,model.count]] = auto.arima
  }
  model.names[model.count] = "ARIMA 1.0.1 (arima)"  
  model.count = model.count + 1 

  # ARIMA models. We abandoned using auto.arima and wanted to look at whether certain orders were supported. So 
  # we are fitting each model manually
  auto.arima = NULL
  try(auto.arima <- arima(ts(y.train,frequency=1), order = c(1,0,0)),silent=T)
  if(is.null(auto.arima)==F) {
  f = forecast(auto.arima,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96  
  model.output[[w,model.count]] = auto.arima
  }
  model.names[model.count] = "ARIMA 1.0.0 (arima)"  
  model.count = model.count + 1 
    
  # ARIMA models. We abandoned using auto.arima and wanted to look at whether certain orders were supported. So 
  # we are fitting each model manually
  auto.arima = NULL
  try(auto.arima <- arima(ts(y.train,frequency=1), order = c(2,0,1)),silent=T)
  if(is.null(auto.arima)==F) {
  f = forecast(auto.arima,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96  
  model.output[[w,model.count]] = auto.arima
  }
  model.names[model.count] = "ARIMA 2.0.1 (arima)"  
  model.count = model.count + 1  

  # ARIMA models. We abandoned using auto.arima and wanted to look at whether certain orders were supported. So 
  # we are fitting each model manually
  auto.arima = NULL
  try(auto.arima <- arima(ts(y.train,frequency=1), order = c(1,0,2)),silent=T)
  if(is.null(auto.arima)==F) {
  f = forecast(auto.arima,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96  
  model.output[[w,model.count]] = auto.arima
  }
  model.names[model.count] = "ARIMA 1.0.2 (arima)"  
  model.count = model.count + 1   

  # ARIMA models. We abandoned using auto.arima and wanted to look at whether certain orders were supported. So 
  # we are fitting each model manually
  auto.arima = NULL  
  try(auto.arima <- arima(ts(y.train,frequency=1), order = c(2,0,2)),silent=T)
  if(is.null(auto.arima)==F) {
  f = forecast(auto.arima,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96  
  model.output[[w,model.count]] = auto.arima
  }
  model.names[model.count] = "ARIMA 2.0.2 (arima)"  
  model.count = model.count + 1

  # ARIMA models. We abandoned using auto.arima and wanted to look at whether certain orders were supported. So 
  # we are fitting each model manually
  auto.arima = NULL  
  try(auto.arima <- arima(ts(y.train,frequency=1), order = c(0,0,1)),silent=T)
  if(is.null(auto.arima)==F) {
  f = forecast(auto.arima,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96  
  model.output[[w,model.count]] = auto.arima
  }
  model.names[model.count] = "ARIMA 0.0.1 (arima)"  
  model.count = model.count + 1
 
  # ARIMA models. We abandoned using auto.arima and wanted to look at whether certain orders were supported. So 
  # we are fitting each model manually
  auto.arima = NULL  
  try(auto.arima <- arima(ts(y.train,frequency=1), order = c(0,0,2)),silent=T)
  if(is.null(auto.arima)==F) {
  f = forecast(auto.arima,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96  
  model.output[[w,model.count]] = auto.arima
  }
  model.names[model.count] = "ARIMA 0.0.2 (arima)"  
  model.count = model.count + 1 

  # ARIMA models. We abandoned using auto.arima and wanted to look at whether certain orders were supported. So 
  # we are fitting each model manually
  auto.arima = NULL  
  try(auto.arima <- arima(ts(y.train,frequency=1), order = c(2,0,0)),silent=T)
  if(is.null(auto.arima)==F) {
  f = forecast(auto.arima,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96  
  model.output[[w,model.count]] = auto.arima
  }
  model.names[model.count] = "ARIMA 2.0.0 (arima)"  
  model.count = model.count + 1  
      
  # ARIMA models. We abandoned using auto.arima and wanted to look at whether certain orders were supported. So 
  # we are fitting each model manually
  auto.arima = NULL
  try(auto.arima <- arima(ts(y.train,frequency=1), order = c(1,1,1)),silent=T)
  if(is.null(auto.arima)==F) {
  f = forecast(auto.arima,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96  
  model.output[[w,model.count]] = auto.arima
  }
  model.names[model.count] = "ARIMA 1.1.1 (arima)"  
  model.count = model.count + 1 
  
  # ARIMA models. We abandoned using auto.arima and wanted to look at whether certain orders were supported. So 
  # we are fitting each model manually
  auto.arima = NULL
  try(auto.arima <- arima(ts(y.train,frequency=1), order = c(1,1,0)),silent=T)
  if(is.null(auto.arima)==F) {
  f = forecast(auto.arima,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96  
  model.output[[w,model.count]] = auto.arima
  }
  model.names[model.count] = "ARIMA 1.1.0 (arima)"  
  model.count = model.count + 1
    
  # ARIMA models. We abandoned using auto.arima and wanted to look at whether certain orders were supported. So 
  # we are fitting each model manually
  auto.arima = NULL
  try(auto.arima <- arima(ts(y.train,frequency=1), order = c(2,1,1)),silent=T)
  if(is.null(auto.arima)==F) {
  f = forecast(auto.arima,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96  
  model.output[[w,model.count]] = auto.arima
  }
  model.names[model.count] = "ARIMA 2.1.1 (arima)"  
  model.count = model.count + 1  

  # ARIMA models. We abandoned using auto.arima and wanted to look at whether certain orders were supported. So 
  # we are fitting each model manually
  auto.arima = NULL
  try(auto.arima <- arima(ts(y.train,frequency=1), order = c(1,1,2)),silent=T)
  if(is.null(auto.arima)==F) {
  f = forecast(auto.arima,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96  
  model.output[[w,model.count]] = auto.arima
  }
  model.names[model.count] = "ARIMA 1.1.2 (arima)"  
  model.count = model.count + 1   

  # ARIMA models. We abandoned using auto.arima and wanted to look at whether certain orders were supported. So 
  # we are fitting each model manually
  auto.arima = NULL  
  try(auto.arima <- arima(ts(y.train,frequency=1), order = c(2,1,2)),silent=T)
  if(is.null(auto.arima)==F) {
  f = forecast(auto.arima,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96  
  model.output[[w,model.count]] = auto.arima
  }
  model.names[model.count] = "ARIMA 2.1.2 (arima)"  
  model.count = model.count + 1

  # ARIMA models. We abandoned using auto.arima and wanted to look at whether certain orders were supported. So 
  # we are fitting each model manually
  auto.arima = NULL  
  try(auto.arima <- arima(ts(y.train,frequency=1), order = c(0,1,1)),silent=T)
  if(is.null(auto.arima)==F) {
  f = forecast(auto.arima,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96  
  model.output[[w,model.count]] = auto.arima
  }
  model.names[model.count] = "ARIMA 0.1.1 (arima)"  
  model.count = model.count + 1
 
  # ARIMA models. We abandoned using auto.arima and wanted to look at whether certain orders were supported. So 
  # we are fitting each model manually
  auto.arima = NULL  
  try(auto.arima <- arima(ts(y.train,frequency=1), order = c(0,1,2)),silent=T)
  if(is.null(auto.arima)==F) {
  f = forecast(auto.arima,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96  
  model.output[[w,model.count]] = auto.arima
  }
  model.names[model.count] = "ARIMA 0.1.2 (arima)"  
  model.count = model.count + 1 

  # ARIMA models. We abandoned using auto.arima and wanted to look at whether certain orders were supported. So 
  # we are fitting each model manually
  auto.arima = NULL  
  try(auto.arima <- arima(ts(y.train,frequency=1), order = c(2,1,0)),silent=T)
  if(is.null(auto.arima)==F) {
  f = forecast(auto.arima,NAHEAD)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = f$mean
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = (f$upper[,2] - f$mean)/1.96  
  model.output[[w,model.count]] = auto.arima
  }
  model.names[model.count] = "ARIMA 2.1.0 (arima)"  
  model.count = model.count + 1  
  
  # gaussian process model. Like the time series approaches above, we can explore the effects
  # of treating these as having different frequencies to try to capture age structure in things
  # like salmon
  filter <- gausspr(ts(y.train,frequency=1)~x,kernel="rbfdot",kpar="automatic",type="regression")
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = predict(filter, newdata = list("x" = seq(1,n.y)))[(n.y-NAHEAD+1):n.y]
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = NA
  model.output[[w,model.count]] = filter
  model.names[model.count] = "Gaussian process (freq=1) (gausspr)"  
  model.count = model.count + 1  

  # gaussian process model. Like the time series approaches above, we can explore the effects
  # of treating these as having different frequencies to try to capture age structure in things
  # like salmon  
  filter <- gausspr(ts(y.train,frequency=2)~x,kernel="rbfdot",kpar="automatic",type="regression")
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = predict(filter, newdata = list("x" = seq(1,n.y)))[(n.y-NAHEAD+1):n.y]
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = NA
  model.output[[w,model.count]] = filter
  model.names[model.count] = "Gaussian process (freq=2) (gausspr)"  
  model.count = model.count + 1

  # gaussian process model. Like the time series approaches above, we can explore the effects
  # of treating these as having different frequencies to try to capture age structure in things
  # like salmon  
  filter <- gausspr(ts(y.train,frequency=3)~x,kernel="rbfdot",kpar="automatic",type="regression")
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = predict(filter, newdata = list("x" = seq(1,n.y)))[(n.y-NAHEAD+1):n.y]
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = NA
  model.output[[w,model.count]] = filter
  model.names[model.count] = "Gaussian process (freq=3) (gausspr)"  
  model.count = model.count + 1

  # gaussian process model. Like the time series approaches above, we can explore the effects
  # of treating these as having different frequencies to try to capture age structure in things
  # like salmon  
  filter <- gausspr(ts(y.train,frequency=4)~x,kernel="rbfdot",kpar="automatic",type="regression")
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = predict(filter, newdata = list("x" = seq(1,n.y)))[(n.y-NAHEAD+1):n.y]
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = NA
  model.output[[w,model.count]] = filter
  model.names[model.count] = "Gaussian process (freq=4) (gausspr)"  
  model.count = model.count + 1

  # state space time series model, with drift. No temporal autocorrelation in errors
  mod = MARSS(y.train,method="BFGS",silent=TRUE)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = mod$states[1,length(y.train)]+seq(1,5)*mod$par$U
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = sqrt(mod$par$Q*seq(1,5))
  model.output[[w,model.count]] = mod
  model.names[model.count] = "MARSSdrift"  
  model.count = model.count + 1 

  # state space time series model, with no drift. No temporal autocorrelation in errors
  mod = MARSS(y.train,method="BFGS",model=list(U = matrix(0,1,1)),silent=TRUE)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = mod$states[1,length(y.train)]
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = sqrt(mod$par$Q*seq(1,5)) 
  model.output[[w,model.count]] = mod
  model.names[model.count] = "MARSSnodrift"  
  model.count = model.count + 1  
  
  # use the Simplex and procedure from sugihara et al. here. Implemented in Jim Thorson's function
  simplex.embed=EmbedFn(y.train, Candidates=1:7)
  simplex.oneAhead = NltsPred(c(y.train,NA), Nembed=simplex.embed, PredNum=c(length(y.train)+1), Method="Simplex")
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):(n.y-NAHEAD+1)],model.count] = simplex.oneAhead
  predicted[which(dat$ID==w)[(n.y-NAHEAD+2):(n.y-NAHEAD+2)],model.count] = NA
  predicted[which(dat$ID==w)[(n.y-NAHEAD+3):(n.y-NAHEAD+3)],model.count] = NA
  predicted[which(dat$ID==w)[(n.y-NAHEAD+4):(n.y-NAHEAD+4)],model.count] = NA
  predicted[which(dat$ID==w)[(n.y-NAHEAD+5):(n.y-NAHEAD+5)],model.count] = NA          
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = NA
  model.output[[w,model.count]] = list(simplex.embed, simplex.oneAhead)
  model.names[model.count] = "Simplex v1"  
  model.count = model.count + 1  
    
  y = dat$Value[which(dat$ID==w)]
  n.y = length(y) # length of time series
  y.train = y[1:(n.y-5)]
  y.test = y[(n.y-5+1):n.y]
  x = seq(1,length(y.train))
  
  # use the Simplex and procedure from sugihara et al. here. Implemented in Jim Thorson's function. This 
  # differs from the simplex above in that it's predicting 1:4 time steps ahead
  simplex.embed = EmbedFn(c(y.train,NA), PredInterval=1, Candidates=1:7)
  simplex.oneAhead = NltsPred(c(y.train,NA), PredInterval=1, Nembed=simplex.embed, PredNum=c(length(y.train)+1), Method="Simplex")  # PredInterval is the number of years in next year, etc)
  simplex.embed = EmbedFn(c(y.train,NA,NA), PredInterval=2, Candidates=1:7)
  simplex.twoAhead = NltsPred(c(y.train,NA,NA), PredInterval=2, Nembed=simplex.embed, PredNum=c(length(y.train)+2), Method="Simplex")  # PredInterval is the number of years in next year, etc)  
  simplex.embed = EmbedFn(c(y.train,NA,NA,NA), PredInterval=3, Candidates=1:7)
  simplex.threeAhead = NltsPred(c(y.train,NA,NA,NA), PredInterval=3, Nembed=simplex.embed, PredNum=c(length(y.train)+3), Method="Simplex")  # PredInterval is the number of years in next year, etc)
  simplex.embed = EmbedFn(c(y.train,NA,NA,NA,NA), PredInterval=4, Candidates=1:7)
  simplex.fourAhead = NltsPred(c(y.train,NA,NA,NA,NA), PredInterval=4, Nembed=simplex.embed, PredNum=c(length(y.train)+4), Method="Simplex")  # PredInterval is the number of years in next year, etc)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):(n.y-NAHEAD+1)],model.count] = simplex.oneAhead
  predicted[which(dat$ID==w)[(n.y-NAHEAD+2):(n.y-NAHEAD+2)],model.count] = simplex.twoAhead
  predicted[which(dat$ID==w)[(n.y-NAHEAD+3):(n.y-NAHEAD+3)],model.count] = simplex.threeAhead
  predicted[which(dat$ID==w)[(n.y-NAHEAD+4):(n.y-NAHEAD+4)],model.count] = simplex.fourAhead
  predicted[which(dat$ID==w)[(n.y-NAHEAD+5):(n.y-NAHEAD+5)],model.count] = NA          
  model.output[[w,model.count]] = list(simplex.embed, simplex.oneAhead)
  model.names[model.count] = "Simplex v2"     
    
  # Sugihara's S-map procedure, as implemented in Jim Thorson's function. This is just 1-step ahead
  smap.embed = EmbedFn(y.train, Candidates=1:7)
  smap.theta = ThetaFn(y.train, Nembed=smap.embed)$Max
  smap.oneAhead = NltsPred(c(y.train,NA), Nembed=smap.embed, PredNum=length(y.train)+1, Method="Smap", Theta=smap.theta)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):(n.y-NAHEAD+1)],model.count] = smap.oneAhead
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):(n.y-NAHEAD+1)],model.count] = NA
  model.output[[w,model.count]] = list("Embed" = smap.embed, "Theta"=smap.theta)
  model.names[model.count] = "SMAP v1"  
  model.count = model.count + 1  

  # Sugihara's S-map procedure, as implemented in Jim Thorson's function. This is as above but does time steps 1:4 steps ahead
  y = dat$Value[which(dat$ID==w)]
  n.y = length(y) # length of time series
  y.train = y[1:(n.y-5)]
  y.test = y[(n.y-5+1):n.y]
  x = seq(1,length(y.train))

  smap.embed = EmbedFn(c(y.train,NA), PredInterval=1, Candidates=1:7)
  theta = ThetaFn(c(y.train,NA), PredInterval=1, Nembed=smap.embed)$Max
  smap.oneAhead = NltsPred(c(y.train,NA), PredInterval=1, Nembed=smap.embed, PredNum=c(length(y.train)+1), Method="Smap", Theta=theta)
  smap.embed = EmbedFn(c(y.train,NA,NA), PredInterval=2, Candidates=1:7)
  theta = ThetaFn(c(y.train,NA,NA), PredInterval=2, Nembed=smap.embed)$Max
  smap.twoAhead = NltsPred(c(y.train,NA,NA), PredInterval=2, Nembed=smap.embed, PredNum=c(length(y.train)+2), Method="Smap", Theta=theta)
  smap.embed = EmbedFn(c(y.train,NA,NA,NA), PredInterval=3, Candidates=1:7)
  theta = ThetaFn(c(y.train,NA,NA,NA), PredInterval=3, Nembed=smap.embed)$Max
  smap.threeAhead = NltsPred(c(y.train,NA,NA,NA), PredInterval=3, Nembed=smap.embed, PredNum=c(length(y.train)+3), Method="Smap", Theta=theta)
  smap.embed = EmbedFn(c(y.train,NA,NA,NA,NA), PredInterval=4, Candidates=1:7)
  theta = ThetaFn(c(y.train,NA,NA,NA,NA), PredInterval=4, Nembed=smap.embed)$Max
  smap.fourAhead = NltsPred(c(y.train,NA,NA,NA,NA), PredInterval=4, Nembed=smap.embed, PredNum=c(length(y.train)+4), Method="Smap", Theta=theta)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):(n.y-NAHEAD+1)],model.count] = smap.oneAhead
  predicted[which(dat$ID==w)[(n.y-NAHEAD+2):(n.y-NAHEAD+2)],model.count] = smap.twoAhead
  predicted[which(dat$ID==w)[(n.y-NAHEAD+3):(n.y-NAHEAD+3)],model.count] = smap.threeAhead
  predicted[which(dat$ID==w)[(n.y-NAHEAD+4):(n.y-NAHEAD+4)],model.count] = smap.fourAhead
  predicted[which(dat$ID==w)[(n.y-NAHEAD+5):(n.y-NAHEAD+5)],model.count] = NA          
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = NA
  model.output[[w,model.count]] = list(smap.embed, smap.oneAhead)
  model.names[model.count] = "SMAP v2"

  # Random forest approach to time series model w/lags. This block just does 1-step ahead forecasts
  y = dat$Value[which(dat$ID==w)]
  n.y = length(y) # length of time series
  y.train = y[1:(n.y-5)]  
  nX = length(y.train)
  ranfor <- randomForest(y=y.train[6:nX], x=cbind(y.train[1:(nX-5)],y.train[2:(nX-4)],y.train[3:(nX-3)],y.train[4:(nX-2)],y.train[5:(nX-1)]))
  # only do predictions one step ahead
  ranfor.pred = predict(ranfor, y[(nX-4):(nX)])
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):(n.y-NAHEAD+1)],model.count] = ranfor.pred
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):(n.y-NAHEAD+1)],model.count] = NA  
  model.output[[w,model.count]] = ranfor
  model.names[model.count] = "randomForest v1"  
  model.count = model.count + 1 
  
  n.y = length(y) # length of time series
  y.train = y[1:(n.y-5)]
  y.test = y[(n.y-5+1):n.y]
  x = seq(1,length(y.train))

  nX = length(y.train)
  ranfor <- randomForest(y=y.train[6:nX], x=cbind(y.train[1:(nX-5)],y.train[2:(nX-4)],y.train[3:(nX-3)],y.train[4:(nX-2)],y.train[5:(nX-1)]))
  # 1 step ahead
  ranfor.pred = predict(ranfor, y[(nX-4):(nX)])
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):(n.y-NAHEAD+1)],model.count] = ranfor.pred
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):(n.y-NAHEAD+1)],model.count] = NA  
  
  # 2 steps ahead
  ranfor <- randomForest(y=y.train[7:nX], x=cbind(y.train[1:(nX-6)],y.train[2:(nX-5)],y.train[3:(nX-4)],y.train[4:(nX-3)],y.train[5:(nX-2)]))
  ranfor.pred = predict(ranfor, y[(nX-4):(nX)])
  predicted[which(dat$ID==w)[(n.y-NAHEAD+2):(n.y-NAHEAD+2)],model.count] = ranfor.pred
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+2):(n.y-NAHEAD+2)],model.count] = NA
  
  # 3 steps ahead
  ranfor <- randomForest(y=y.train[8:nX], x=cbind(y.train[1:(nX-7)],y.train[2:(nX-6)],y.train[3:(nX-5)],y.train[4:(nX-4)],y.train[5:(nX-3)]))
  ranfor.pred = predict(ranfor, y[(nX-4):(nX)])
  predicted[which(dat$ID==w)[(n.y-NAHEAD+3):(n.y-NAHEAD+3)],model.count] = ranfor.pred
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+3):(n.y-NAHEAD+3)],model.count] = NA
    
  # 4 steps ahead
  ranfor <- randomForest(y=y.train[9:nX], x=cbind(y.train[1:(nX-8)],y.train[2:(nX-7)],y.train[3:(nX-6)],y.train[4:(nX-5)],y.train[5:(nX-4)]))
  ranfor.pred = predict(ranfor, y[(nX-4):(nX)])
  predicted[which(dat$ID==w)[(n.y-NAHEAD+4):(n.y-NAHEAD+4)],model.count] = ranfor.pred
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+4):(n.y-NAHEAD+4)],model.count] = NA    
    
  model.output[[w,model.count]] = ranfor
  predicted[which(dat$ID==w)[(n.y-NAHEAD+5):(n.y-NAHEAD+5)],model.count] = NA          
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = NA
  model.output[[w,model.count]] = list(smap.embed, smap.oneAhead)
  model.names[model.count] = "randomForest v2"  
  
  # Simple linear regression model
  n.y = length(y) # length of time series
  y.train = y[1:(n.y-5)]
  y.test = y[(n.y-5+1):n.y]
  x = seq(1,length(y.train))

  # Simple regression approach using lm() - observation error only
  lmfit = lm(y.train~x)
  # predict function for gam requires a new list of predictor variables as newdata
  #predicted[[2]] = predict(gamfit, newdata = list("x" = seq(1,n.y)))[(n.y-NAHEAD+1):n.y]
  pred = predict(lmfit, newdata = list("x" = seq(1,n.y)), se.fit=TRUE)
  predicted[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = pred$fit[(n.y-NAHEAD+1):n.y]
  #predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = pred$se.fit[(n.y-NAHEAD+1):n.y]
  predictedSE[which(dat$ID==w)[(n.y-NAHEAD+1):n.y],model.count] = pred$residual.scale
  model.output[[w,model.count]] = lmfit  
  model.names[model.count] = "simple regression"    
  
}

