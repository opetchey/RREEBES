#' Calculates various approximations for the real part of the leading eigenvalue
#' of the community matrix M.
#'
#' It returns the expectation for the real part of the rightmost eigenvalue of M
#' according to May (Nature 1972), Tang et al (Ecology Letters 2014), and
#' Allesina et al. (Nature Communications 2015) derivations.
#'
#'
#' @param M The community matrix. Note that for the Allesina et al. (eyeball) approximation, M should contain (almost) no
#'        positive coefficients in the upper triangular part and (almost) no negative coefficients in the lower-triangular
#'        part
#' @param calculate_eigenvalues (TRUE by default) calculate the actual eigenvalues of M and return them
#'
#' @return A list composed of:
#' \describe{
#' \item{$M}{The community matrix}
#' \item{$M.eigenvalues}{The eigenvalues of M (if calculate_eigenvalues = TRUE)}
#' \item{$ReL1.observed }{The actual real part of the rightmost eigenvalue of M}
#' \item{$ReL1.May }{The prediction according to May's approximation}
#' \item{$ReL1.TangEtAl}{The prediction according to Tang et al. approximation}
#' \item{$ReL1.eyeball}{The prediction according to the "eyeball" approach in Allesina et al. }
#' \item{$May.stats}{List containing the relevant statistics for computing May's approximation}
#' \item{$TangEtAl.stats}{List containing the relevant statistics for computing the approximation of Tang et al.}
#' \item{$eyeball.stats}{List containing the relevant statistics for computing the eyeball approximation of Allesina et al.}
#' }
#'
#' @examples
#' M <- eye.parameterize.M(eye.foodweb.cascade())
#' eye.approximate.ReL1(M)
#' @export
eye.approximate.ReL1 <- function(M, calculate_eigenvalues = TRUE){
  if (calculate_eigenvalues == TRUE){
    ev <- eigen(M, only.values = TRUE, symmetric = FALSE)$values
  }
  S <- dim(M)[1]
  NOffDiag <- S * (S - 1)
  ## First, deal with diagonal elements
  d <- mean(diag(M))
  diag(M) <- 0
  ## Second, compute stats
  ## For May and Tang et al.
  mu <- sum(M) / NOffDiag
  sigma2 <- sum(M^2) / NOffDiag - mu^2
  sigma <- sqrt(sigma2)
  rho <- (sum(M * t(M)) / NOffDiag - mu^2) / sigma2
  ## For eyeball
  muU <- mean(M[upper.tri(M)])
  sigmaU2 <- sum(M[upper.tri(M)]^2) * 2 / NOffDiag - muU^2
  muL <- mean(M[lower.tri(M)])
  sigmaL2 <- sum(M[lower.tri(M)]^2) * 2 / NOffDiag - muL^2
  sigmaU <- sqrt(sigmaU2)
  sigmaL <- sqrt(sigmaL2)
  rhoUL <- (sum(M * t(M)) / NOffDiag - muU * muL) / (sigmaU * sigmaL)
  ## May's stability criterion
  ReL1.May <- max((S-1) * mu, sqrt((S-1) * sigma2) - mu) + d
  ## Tang et al. stability criterion
  ReL1.TangEtAl <- max((S-1) * mu, sqrt((S-1) * sigma2) * (1 + rho) - mu) + d
  ## Eyeball approximation
  ## radius for the spectrum of A
  coeff <- (-muL / muU)^(1 / S)
  coeff2 <- (-muL / muU)^(2 / S)
  r.a <- (muU - muL) * coeff / (coeff2 - 1)
  ## center for the spectrum of A
  c.a <- (muL - muU * coeff2) / (coeff2 -1)
  Re.eigenA.middle <- r.a + c.a
  x <- -muL / muU
  thetak <- pi / S
  Re.eigenA.extreme <- (1 + (x^(1/S) * cos(thetak) -1) * (1 + x) / (1 + x^(2/ S) - 2 * x^(1/S) * cos(thetak))) * -muU
  ## Now spectrum of B
  ## Approximation of alpha
  alpha <- S * (sigmaL^2 - sigmaU^2) / log(sigmaL^2 / sigmaU^2)
  r.b <- (alpha + rhoUL * sigmaU * sigmaL * (S-1)) / sqrt(alpha)
  s.b <- (alpha - rhoUL * sigmaU * sigmaL * (S-1)) / sqrt(alpha)
  ReL1.eyeball <- max(Re.eigenA.extreme, r.b + Re.eigenA.middle) + d
  ReL1.observed <- NULL
  M.eigenvalues <- NULL
  ## if desired, calculate the actual ReL1.observed
  if (calculate_eigenvalues == TRUE){
    ReL1.observed <- max(Re(ev))
    M.eigenvalues <- ev
  }
  return(list(M = M,
              M.eigenvalues = M.eigenvalues,
              ReL1.observed = ReL1.observed,
              ReL1.May = ReL1.May,
              ReL1.TangEtAl = ReL1.TangEtAl,
              ReL1.eyeball = ReL1.eyeball,
              May.stats = list(S = S, V = sigma2, E = mu, d = d),
              TangEtAl.stats = list(S = S, V = sigma2, E = mu, rho = rho, d = d),
              eyeball.stats = list(S = S, muU = muU, muL = muL,
                                   sigmaU = sigmaU, sigmaL = sigmaL,
                                   rhoUL = rhoUL,
                                   d = d,
                                   radius.A = r.a,
                                   center.A = c.a,
                                   radius.B.h = r.b,
                                   radius.B.v = s.b)
              ))
}
