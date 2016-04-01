# This code implements a multispecies competition model based on the logistic map (https://en.wikipedia.org/wiki/Logistic_map)
# the equilibrium density depends on the growth rate (steady state at values between 1 and 2, extinction below 1, chaos > 3.7, fluctuations > 3)

# set seed
set.seed()

## Specify the number of species
S <- 5

#growth rate in the eight-mode oscillation regime below the threshold to chaos
r <- rep(3.57, S)

# specify alphas
alpha <- 0.05
a <- rep(alpha,S)

# simulate 1000 time steps
t=seq(1,1000, by=1)

# specify matrix to hold results
N <- matrix(nrow=S, ncol=length(t))

# set initial conditions randomly
N[,1] <- runif(S)

# simulate dynamics using the discrete logistic growth model; add process noise at the end
for (i in 1:(length(t)-1)) {
 
  N[,i+1] = (r * N[,i] * (1- N[,i] - a*N[,i])) * runif(1,0.85,1.15)
  
}

# add some observation noise to time series
N <- N * runif(length(N), 0.85, 1.15)

# plot results
matplot(t,t(N[1:S,]), "l",ylim=c(0,1), xlim=c(0,1000),col=2:5)


output <- as.data.frame(t(N[1:S,]))
names(output) <- paste0("species ", 1:S)

# check for correlation in abundances
plot(output$`species 1`, output$`species 5`)

#write.csv(output, "/Users/Frank/Documents/Git projects/RREEBES/Hsieh_et_al_2008/data/5sp_comp_sim_data.csv", row.names=F)

