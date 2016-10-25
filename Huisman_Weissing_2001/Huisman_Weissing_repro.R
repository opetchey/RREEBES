rm(list=ls())

library(primer)


r_star <- function(time, state, pars){ with(as.list(parms), {
  
  # initial conditions for all species and resources
  #N <- rep(0.1,2)
  #S <- rep(10, 3) # micro mol per litre
  
  R <- state[6:8]
  N <- state[1:5]
  S <- rep(10, 3)
  
  # growth rate of all species per day
  r <- rep(1,5)
  
  # mortality (m = D) per day
  m <- rep(0.25,5)
  # resource turnover
  D <- 0.25
  
  # half saturation content for each species on each resource (row = resources, column = species)
  K <- matrix(c(0.2, 0.05, 1, 0.05, 1.2, 0.25, 0.1, 0.05, 1, 0.4, 0.15, 0.95, 0.35, 0.1, 0.05), nrow=3, byrow = T)
  
  # content matrix (row = resources, column = species)
  C <- matrix(c(0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.2, 0.1, 0.1, 0.2, 0.1, 0.1, 0.2, 0.2, 0.1), nrow=3, byrow = T)
  
  
  # species specific growth rates as a function of resource availability
  # maximum growth rate determined by Liebig's law of minimum
  
  r <- rep(1,3)
  r1 <- r[1]*(R[1]/(K[1,1]+R[1]))
  r2 <- r[2]*(R[2]/(K[2,1]+R[2]))
  r3 <- r[3]*(R[3]/(K[3,1]+R[3]))
  mu1 <- min(r1,r2,r3)
  
  r <- rep(1,3)
  r1 <- r[1]*(R[1]/(K[1,2]+R[1]))
  r2 <- r[2]*(R[2]/(K[2,2]+R[2]))
  r3 <- r[3]*(R[3]/(K[3,2]+R[3]))
  mu2 <- min(r1,r2,r3)
  
  r <- rep(1,3)
  r1 <- r[1]*(R[1]/(K[1,3]+R[1]))
  r2 <- r[2]*(R[2]/(K[2,3]+R[2]))
  r3 <- r[3]*(R[3]/(K[3,3]+R[3]))
  mu3 <- min(r1,r2,r3)
  
  r <- rep(1,3)
  r1 <- r[1]*(R[1]/(K[1,4]+R[1]))
  r2 <- r[2]*(R[2]/(K[2,4]+R[2]))
  r3 <- r[3]*(R[3]/(K[3,4]+R[3]))
  mu4 <- min(r1,r2,r3)
  
  r <- rep(1,3)
  r1 <- r[1]*(R[1]/(K[1,5]+R[1]))
  r2 <- r[2]*(R[2]/(K[2,5]+R[2]))
  r3 <- r[3]*(R[3]/(K[3,5]+R[3]))
  mu5 <- min(r1,r2,r3)
  
  # species dynamics
  dn1dt <- N[1] * (mu1 - m[1])
  dn2dt <- N[2] * (mu2 - m[2])
  dn3dt <- N[3] * (mu3 - m[3])
  dn4dt <- N[4] * (mu4 - m[4])
  dn5dt <- N[5] * (mu5 - m[5])
  
  loss_R1 <- sum( 
    (C[1,1] * N[1] * mu1), 
    (C[1,2] * N[2] * mu2), 
    (C[1,3] * N[3] * mu3), 
    (C[1,4] * N[4] * mu4), 
    (C[1,5] * N[5] * mu5)
    )
  
  loss_R2 <- sum( 
    (C[2,1] * N[1] * mu1), 
    (C[2,2] * N[2] * mu2), 
    (C[2,3] * N[3] * mu3), 
    (C[2,4] * N[4] * mu4), 
    (C[2,5] * N[5] * mu5)
  )
  
  loss_R3 <- sum( 
    (C[3,1] * N[1] * mu1), 
    (C[3,2] * N[2] * mu2), 
    (C[3,3] * N[3] * mu3), 
    (C[3,4] * N[4] * mu4), 
    (C[3,5] * N[5] * mu5)
  )
  
  
  #loss2 <- sum( (C[2,1] * N[1] * mu1), (C[2,2] * N[2] * mu2))
  #loss3 <- sum( (C[3,1] * N[1] * mu1), (C[2,3] * N[2] * mu2))
  
  # resource dynamics replacement time 
  dr1dt <- D * (S[1] - R[1]) - loss_R1
  dr2dt <- D * (S[2] - R[2]) - loss_R2
  dr3dt <- D * (S[3] - R[3]) - loss_R3
  
  
  
  list(c(dn1dt, dn2dt, dn3dt, dn4dt, dn5dt, dr1dt, dr2dt, dr3dt))
})
}




library(deSolve) 
parms <- c(r=1) 

initial_cond <- c(0.1, 0.2, 0.1, 0.1, 0.1, 10, 10, 10) 

out <- ode(y = initial_cond , times = 1:5000, func = r_star, parms = parms) 

matplot(out[1:5000 , 2:9], type = "l", xlab = "time", ylab = "Conc",
        main = "5 species R* competition", lwd = 2, col=2:9)
legend("topright", c("sp1", "sp2", "sp3", "sp4","sp5", "R1", "R2", "R3"), col = 2:9, lty = 1)

library(plot3D)

lines3D(z = out[,2],
         x = out[,5],
         y = out[,3]*-1,  col="blue")


