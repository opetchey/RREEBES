#' Sample pairs of interactions from a bivariate normal distribution
#'
#' @param num_pairs The number of pairs to sample
#' @param mux The desired mean for the first marginal distribution
#' @param muy The desired mean for the second marginal distribution
#' @param sigmax The desired standard deviation for the first marginal distribution
#' @param sigmay The desired standard deviation for the second marginal distribution
#' @param rhoxy The desired correlation between the pairs of interaction strengths
#'
#'
#' @return A num_pairs x 2 matrix of interaction strengths sampled from the distribution
#' @examples
#' mypairs <- eye.pairs.from.normal() # default values
#' mypairs <- eye.pairs.from.normal(450)
#' mypairs <- eye.pairs.from.normal(num_pairs = 450)
#' mypairs <- eye.pairs.from.normal(num_pairs = 450, mux = 0, muy = 0,
#'            sigmax = 1, sigmay = 1, rhoxy = 0) # as for May's matrices
#' @export
#' @import MASS
eye.pairs.from.normal <- function(num_pairs = 10,
                              mux = -1,
                              muy = 0.5,
                              sigmax = 1/4,
                              sigmay = 1/4,
                              rhoxy = -2/3){
  mus <- c(mux, muy)
  covariance.matrix <- matrix(c(sigmax^2,
                                rhoxy * sigmax * sigmay,
                                rhoxy * sigmax * sigmay,
                                sigmay^2),
                              2, 2)
  Pairs <- mvrnorm(num_pairs, mus, covariance.matrix)
  return(Pairs)
}

#' Sample pairs of interactions from the "Four-Corner" distribution described
#' in Allesina et al. 2014
#'
#' @param num_pairs The number of pairs to sample
#' @param mux The desired mean for the first marginal distribution
#' @param muy The desired mean for the second marginal distribution
#' @param sigmax The desired standard deviation for the first marginal distribution
#' @param sigmay The desired standard deviation for the second marginal distribution
#' @param rhoxy The desired correlation
#'
#'
#' @return A num_pairs x 2 matrix of interaction strengths sampled from the distribution
#' @examples
#' mypairs <- eye.pairs.from.fourcorner() # default values
#' mypairs <- eye.pairs.from.fourcorner(450)
#' mypairs <- eye.pairs.from.fourcorner(num_pairs = 450)
#' mypairs <- eye.pairs.from.fourcorner(num_pairs = 450, mux = 0, muy = 0,
#'            sigmax = 1, sigmay = 1, rhoxy = 0) # as for May's matrices
#' @export
eye.pairs.from.fourcorner <- function(num_pairs = 10,
                                  mux = -1,
                                  muy = 0.5,
                                  sigmax = 1/4,
                                  sigmay = 1/4,
                                  rhoxy = -2/3){
  gamma <- (rhoxy + 1) / 2
  PosNeg <- sign(rnorm(num_pairs))
  SwitchSign <- sign(runif(num_pairs, -(1-gamma), gamma))
  Pairs <- cbind(mux + PosNeg * sigmax, muy + PosNeg * SwitchSign * sigmay)
  return(Pairs)
}

#' Sample pairs of interactions from an empirical distribution
#'
#' @param num_pairs The number of pairs to sample
#' @param empirical_distribution A Nx2 matrix with the effects of consumers on resources
#'                                in the first column and those of resources on consumers in the second.
#'
#'
#' @return A num_pairs x 2 matrix of interaction strengths sampled from the distribution
#' @examples
#' mypairs <- eye.pairs.from.empirical(100, matrix(runif(20), 10, 2))
#' @export
eye.pairs.from.empirical <- function(num_pairs = 10,
                                 empirical_distribution = NULL){
  if (is.matrix(empirical_distribution) == TRUE){
    NR <- dim(empirical_distribution)[2]
    if (NR == 2){
      Pairs <- matrix(num_pairs, 2)
      SampledPairs <- sample(1:NR, num_pairs, replace = TRUE)
      Pairs <- empirical_distribution[SampledPairs,]
      return(Pairs)
    }
  }
  stop("The empirical_distribution must be a N x 2 matrix!")
}
