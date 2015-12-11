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

mod <- simplex(sockeye_returns$Early_Stuart, lib = c(1, 45), pred = c(46, NROW(sockeye_returns$Early_Stuart)),
               norm_type = c("L2 norm"), P = 0.5, E = 1:10,
               tau = 1, tp = 1, num_neighbors = "e+1", stats_only = F,
               exclusion_radius = NULL, epsilon = NULL, silent = FALSE)
plot(sockeye_returns$year, sockeye_returns$Early_Stuart, "l")
par(new=T)
plot(sockeye_returns$year, mod[[3]]$model_output$pred, "l", col="red")
