#' Builds a community matrix M based on a food web, and a parameterization for the bivariate distribution
#'
#' @param FW A food web object, produced by the method eye.foodweb.cascade or similar
#' @param distribution_pairs A bivariate distribution for the pairs (possibilities are "Normal", "FourCorner", or an empirical distribution, represented by a Nx2 matrix of pairs)
#' @param mux Mean of the negative interaction strengths
#' @param muy Mean of the positive interaction strengths
#' @param sigmax Standard deviation of the negative interaction strengths
#' @param sigmay Standard deviation of the positive interaction strengths
#' @param rhoxy Correlation between the interaction strengths
#' @param mu_diagonal (0 by default) mean of the diagonal elements
#' @param sigma_diagonal (0 by default) standard deviation for the diagonal elements
#'
#' @return The community matrix M
#' @examples
#' M <- eye.parameterize.M(eye.foodweb.cascade())
#' M <- eye.parameterize.M(eye.foodweb.niche(size = 30, connectance = 0.2),
#'      distribution_pairs = "FourCorner", mux = -1, muy = 1, sigmax = 2, sigmay = 1, rhoxy = -0.5)
#' @export
eye.parameterize.M <- function(FW,
                               distribution_pairs = "Normal",
                               mux = -1,
                               muy = 0.5,
                               sigmax = 1/4,
                               sigmay = 1/4,
                               rhoxy = -2/3,
                               mu_diagonal = 0,
                               sigma_diagonal = 0){
  S <- FW$size
  M <- matrix(0, S, S)
  ## Get off-diagonal coefficients
  NumPairs <- FW$L
  if (is.matrix(distribution_pairs) == TRUE){
    my.pairs <- eye.pairs.from.empirical(num_pairs = NumPairs,
                                         empirical_distribution = distribution_pairs)
  } else {
    if (distribution_pairs == "Normal"){
      my.pairs <- eye.pairs.from.normal(num_pairs = NumPairs,
                                        mux = mux,
                                        muy = muy,
                                        sigmax = sigmax,
                                        sigmay = sigmay,
                                        rhoxy = rhoxy)
    }
    if (distribution_pairs == "FourCorner"){
      my.pairs <- eye.pairs.from.fourcorner(num_pairs = NumPairs,
                                          mux = mux,
                                          muy = muy,
                                          sigmax = sigmax,
                                          sigmay = sigmay,
                                          rhoxy = rhoxy)
    }
  }
  M[FW$links] <- my.pairs[ , 1]
  M[FW$links[,2:1]] <- my.pairs[ , 2]
  ## Optional: set diagonal
  diag(M) <- rnorm(S, mean = mu_diagonal, sd = sigma_diagonal)
  return(M)
}

#' Builds a community matrix M based on a food web model, and a parameterization for the bivariate distribution
#'
#' @param foodweb_model A food web model. Possible options are "Random", "Cascade", "Niche" or a file name containing an adjacency matrix
#' @param size The number of species in the foodweb
#' @param connectance The connectance of the food web
#' @param distribution_pairs A bivariate distribution for the pairs (possibilities are "Normal", "FourCorner", or an empirical distribution, represented by a Nx2 matrix of pairs)
#' @param mux Mean of the negative interaction strengths
#' @param muy Mean of the positive interaction strengths
#' @param sigmax Standard deviation of the negative interaction strengths
#' @param sigmay Standard deviation of the positive interaction strengths
#' @param rhoxy Correlation between the interaction strengths
#' @param mu_diagonal (0 by default) mean of the diagonal elements
#' @param sigma_diagonal (0 by default) standard deviation for the diagonal elements
#'
#' @return The community matrix M
#' @examples
#' M <- eye.buildfoodweb.and.parameterize.M(foodweb_model = "Cascade", size = 100, connectance = 0.2,
#'      distribution_pairs = "Normal", mux = -1, muy = 1, sigmax = 1, sigmay = 1, rhoxy = -0.2,
#'      mu_diagonal = -3, sigma_diagonal = 0)
#' @export
eye.buildfoodweb.and.parameterize.M <- function(foodweb_model = "Cascade",
                                                size = 100,
                                                connectance = 0.1,
                                                distribution_pairs = "Normal",
                                                mux = -3,
                                                muy = 1.5,
                                                sigmax = 1,
                                                sigmay = 0.75,
                                                rhoxy = -2/3,
                                                mu_diagonal = 0,
                                                sigma_diagonal = 0){
  FW <- NULL
  # if it's a file
  if (file.exists(foodweb_model) == TRUE){
    FW <- eye.foodweb.file(foodweb_model)
  }
  if (foodweb_model == "Cascade"){
    FW <- eye.foodweb.cascade(size, connectance)
  }
  if (foodweb_model == "Niche"){
    FW <- eye.foodweb.niche(size, connectance)
  }
  if (foodweb_model == "Random"){
    FW <- eye.foodweb.niche(size, connectance)
  }
  if (is.null(FW)){
    stop("Invalid food web model. Please enter Random, Cascade, Niche, or a file name for the adjacency matrix.")
  }
  M <- eye.parameterize.M(FW, distribution_pairs, mux, muy, sigmax, sigmay, rhoxy, mu_diagonal, sigma_diagonal)
  return(M)
}
