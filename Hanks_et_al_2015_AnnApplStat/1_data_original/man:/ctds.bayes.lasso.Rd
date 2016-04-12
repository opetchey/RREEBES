
\name{ctds.bayes.lasso}
\alias{ctds.bayes.lasso}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{MCMC sampler with Bayesian lasso prior
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
ctds.bayes.lasso(sim.obj, spline.list, stack.static, stack.grad, conspecifics.list = NULL, crw = TRUE, path.aug.interval = 0, spline.period = 0, intercept.start = 0, intercept.tune = 1, alpha.start, alpha.tune.mat, lambda = NA, lambda.prior.r = 1, lambda.prior.q = 0.5, Phi.mean = NA, Phi.sd = NA, n.mcmc = 10)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{sim.obj}{
%%     ~~Describe \code{sim.obj} here~~
}
  \item{spline.list}{
%%     ~~Describe \code{spline.list} here~~
}
  \item{stack.static}{
%%     ~~Describe \code{stack.static} here~~
}
  \item{stack.grad}{
%%     ~~Describe \code{stack.grad} here~~
}
  \item{conspecifics.list}{
%%     ~~Describe \code{conspecifics.list} here~~
}
  \item{crw}{
%%     ~~Describe \code{crw} here~~
}
  \item{path.aug.interval}{
%%     ~~Describe \code{path.aug.interval} here~~
}
  \item{spline.period}{
%%     ~~Describe \code{spline.period} here~~
}
  \item{intercept.start}{
%%     ~~Describe \code{intercept.start} here~~
}
  \item{intercept.tune}{
%%     ~~Describe \code{intercept.tune} here~~
}
  \item{alpha.start}{
%%     ~~Describe \code{alpha.start} here~~
}
  \item{alpha.tune.mat}{
%%     ~~Describe \code{alpha.tune.mat} here~~
}
  \item{lambda}{
%%     ~~Describe \code{lambda} here~~
}
  \item{lambda.prior.r}{
%%     ~~Describe \code{lambda.prior.r} here~~
}
  \item{lambda.prior.q}{
%%     ~~Describe \code{lambda.prior.q} here~~
}
  \item{Phi.mean}{
%%     ~~Describe \code{Phi.mean} here~~
}
  \item{Phi.sd}{
%%     ~~Describe \code{Phi.sd} here~~
}
  \item{n.mcmc}{
%%     ~~Describe \code{n.mcmc} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (sim.obj, spline.list, stack.static, stack.grad, conspecifics.list = NULL, 
    crw = TRUE, path.aug.interval = 0, spline.period = 0, intercept.start = 0, 
    intercept.tune = 1, alpha.start, alpha.tune.mat, lambda = NA, 
    lambda.prior.r = 1, lambda.prior.q = 0.5, Phi.mean = NA, 
    Phi.sd = NA, n.mcmc = 10) 
{
    loglik.pois <- function(z, tau, Phi, alpha, intercept) {
        xb = intercept + as.numeric(Phi \%*\% Matrix(as.numeric(alpha), 
            ncol = 1))
        sum(z * xb - tau * exp(xb), na.rm = T)
    }
    P = length(alpha.start)
    alpha = alpha.start
    alpha[which(alpha == 0)] <- 1e-06
    intercept = intercept.start
    alpha.int = c(intercept, alpha)
    alpha.tune.mat = diag(c(intercept.tune, diag(alpha.tune.mat)))
    lambda.2 = (lambda.prior.r/lambda.prior.q)^2
    if (!is.na(lambda)) {
        lambda.2 = lambda^2
    }
    D = Diagonal(length(alpha))
    one = Matrix(1, nrow = 1, ncol = length(alpha))
    alpha.save = matrix(NA, nrow = n.mcmc, ncol = length(alpha))
    lambda.save = rep(NA, n.mcmc)
    intercept.save = rep(NA, n.mcmc)
    accept = 0
    for (iter in 1:n.mcmc) {
        cat(iter, " ")
        out = make.Phi.mat(sim.obj, spline.list, stack.static, 
            stack.grad, conspecifics.list, crw = crw, path.aug.interval = path.aug.interval, 
            spline.period = spline.period)
        if (is.na(Phi.sd[1])) {
            Phi = out$Phi
        }
        else {
            Phi = out$Phi
            Phi = t((t(Phi) - Phi.mean)/Phi.sd)
        }
        XX = out$XX
        z = out$z
        QQ = out$QQ
        tau = out$tau
        crawl = out$samp.new
        s2 = 1/rinvgauss(P, sqrt(lambda.2/alpha^2), lambda.2)
        alpha.prior.var = diag(c(10^3, as.numeric(s2)))
        if (is.na(lambda)) {
            lambda.2 = rgamma(1, lambda.prior.r + P, , 1/(1/lambda.prior.q + 
                0.5 * sum(s2)))
        }
        alpha.int.star = rmvnorm(1, alpha.int, sigma = alpha.tune.mat)
        intercept.star = alpha.int.star[1]
        alpha.star = alpha.int.star[-1]
        mh1 = loglik.pois(z, tau, Phi, alpha.star, intercept.star) + 
            dmvnorm(alpha.int.star, rep(0, P + 1), alpha.prior.var, 
                log = TRUE)
        mh2 = loglik.pois(z, tau, Phi, alpha, intercept) + dmvnorm(alpha.int, 
            rep(0, P + 1), alpha.prior.var, log = TRUE)
        if (runif(1) < exp(mh1 - mh2)) {
            alpha = alpha.star
            intercept = intercept.star
            alpha.int = alpha.int.star
            accept = accept + 1
        }
        alpha.save[iter, ] <- alpha
        intercept.save[iter] <- intercept
        lambda.save[iter] <- sqrt(lambda.2)
    }
    alpha = apply(alpha.save, 2, mean)
    alpha.sd = apply(alpha.save, 2, sd)
    list(alpha = alpha, alpha.sd = alpha.sd, alpha.save = alpha.save, 
        intercept.save = intercept.save, lambda.save = lambda.save, 
        accept = accept, Phi.sd = Phi.sd)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
