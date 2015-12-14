library(devtools)
install_github("ha0ye/rEDM")

library(rEDM)

# work through some of the example data sets
data(paramecium_didinium)

mod <- simplex(paramecium_didinium$paramecium, lib = c(1, 50), pred = c(51,NROW(paramecium_didinium$paramecium)),
        norm_type = c("L2 norm"), P = 0.5, E = 1:10,
        tau = 1, tp = 1, num_neighbors = "e+1", stats_only = F,
        exclusion_radius = NULL, epsilon = NULL, silent = FALSE)
str(mod)

plot(paramecium_didinium$time, paramecium_didinium$paramecium, "l")
par(new=T)
plot(paramecium_didinium$time, mod[[1]]$model_output$pred, "l", col="blue")

data(sockeye_returns)
plot(sockeye_returns$year, sockeye_returns$Early_Stuart, "l")

mod2 <- simplex(sockeye_returns$Early_Stuart, lib = c(1, 45), pred = c(46, NROW(sockeye_returns$Early_Stuart)),
               norm_type = c("L2 norm"), P = 0.5, E = 1:10,
               tau = 1, tp = 1, num_neighbors = "e+1", stats_only = F,
               exclusion_radius = NULL, epsilon = NULL, silent = FALSE)
plot(sockeye_returns$year, sockeye_returns$Early_Stuart, "l", ylim=c(0,2))
par(new=T)
plot(sockeye_returns$year, mod2[[1]]$model_output$pred, "l", col="red", ylim=c(0,2))

# now load our simulated time series
five_sp_comp <- read.csv("/Users/Frank/Documents/Github projects/RREEBES/Hsieh_et_al_2008/data/5sp_comp_sim_data.csv")
five_sp_comp$time <- seq(1,1000)

plot(five_sp_comp$time, five_sp_comp$species.1, "l")

mod3 <- simplex(five_sp_comp$species.1, lib = c(1, 499), pred = c(500, NROW(five_sp_comp$species.1)),
                norm_type = c("L2 norm"), P = 0.5, E = 1:10,
                tau = 1, tp = 1, num_neighbors = "e+1", stats_only = F,
                exclusion_radius = NULL, epsilon = NULL, silent = FALSE)

# compare data with predictions visually
plot(five_sp_comp$time[900:1000], five_sp_comp$species.1[900:1000], "l", ylim=c(0,1))
par(new=T)
plot(five_sp_comp$time[899:999], mod3[[1]]$model_output$pred[899:999], "l", col="red", ylim=c(0,1))




