# This code implements a multispecies competition model based on the logistic map (https://en.wikipedia.org/wiki/Logistic_map)
# the equilibrium density depends on the growth rate (steady state at values between 1 and 2, extinction below 1, chaos > 3.7, fluctuations > 3)

# set seed
set.seed()

## Specify the number of species
S <- 5
alpha <- 0.005

#growth rate in the eight-mode oscillation regime below the threshold to chaos
r <- rep(3.57, S)

# play around with growth rates to understand behaviour and steady state
#r<- runif(5, 1, 2)

# add some process noise on the interaction coefficient
#a <- matrix(runif(S^2, 0.85, 1.15), nrow=S, ncol=S)*alpha
#a <- matrix(alpha, nrow=S, ncol=S)
a <- rep(alpha,S)


# set diagonal elements to 1
#diag(a) <- NA

# simulate 1000 time steps
t=seq(1,1000, by=1)

# specify matrix to hold results
N <- matrix(nrow=S, ncol=length(t))

# set initial conditions randomly
N[,1] <- runif(S)

# simulate dynamics using the standard logistic map

for (i in 1:(length(t)-1)) {
 
  N[,i+1] = (r * N[,i] * (1- N[,i] - a*N[,i])) * runif(1,0.95,1.05)
  
}

# add observation noise
N <- N * runif(length(N), 0.85, 1.15)

# plot results
matplot(t,t(N[1:S,]), "l",ylim=c(0,1), xlim=c(0,1000),col=2:5)


output <- as.data.frame(t(N[1:S,]))
names(output) <- paste0("species ", 1:S)

write.csv(output, "/Users/Frank/Documents/Git projects/RREEBES/Hsieh_et_al_2008/data/5sp_comp_sim_data.csv", row.names=F)

