
\name{ctds.bayes.mh}
\alias{ctds.bayes.mh}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  MCMC sampler with Gaussian prior on regression parameters
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
ctds.bayes.mh(sim.obj, spline.list, stack.static, stack.grad, conspecifics.list = NULL, crw = TRUE, path.aug.interval = 0, spline.period = 0, s2 = 10^6, intercept.start = 0, intercept.tune = 1, alpha.start, alpha.tune.mat, n.mcmc = 10)
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
  \item{s2}{
%%     ~~Describe \code{s2} here~~
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
    crw = TRUE, path.aug.interval = 0, spline.period = 0, s2 = 10^6, 
    intercept.start = 0, intercept.tune = 1, alpha.start, alpha.tune.mat, 
    n.mcmc = 10) 
{
    alpha.prior.var = diag(s2, length(alpha.start))
    loglik.pois <- function(z, tau, Phi, alpha, intercept) {
        xb = intercept + as.numeric(Phi \%*\% Matrix(as.numeric(alpha), 
            ncol = 1))
        sum(z * xb - tau * exp(xb), na.rm = T)
    }
    alpha = alpha.start
    intercept = intercept.start
    D = Diagonal(length(alpha))
    one = Matrix(1, nrow = 1, ncol = length(alpha))
    alpha.save = matrix(NA, nrow = n.mcmc, ncol = length(alpha))
    intercept.save = rep(NA, n.mcmc)
    accept = 0
    for (iter in 1:n.mcmc) {
        cat(iter, " ")
        out = make.Phi.mat(sim.obj, spline.list, stack.static, 
            stack.grad, conspecifics.list, crw = crw, path.aug.interval = path.aug.interval, 
            spline.period = spline.period)
        Phi = out$Phi
        XX = out$XX
        z = out$z
        QQ = out$QQ
        tau = out$tau
        crawl = out$samp.new
        alpha.star = rmvnorm(1, alpha, sigma = alpha.tune.mat)
        intercept.star = rnorm(1, intercept, sqrt(intercept.tune))
        mh1 = loglik.pois(z, tau, Phi, alpha.star, intercept.star) + 
            dmvnorm(alpha.star, alpha, alpha.prior.var, log = TRUE)
        mh2 = loglik.pois(z, tau, Phi, alpha, intercept) + dmvnorm(alpha, 
            alpha.star, alpha.prior.var, log = TRUE)
        if (runif(1) < exp(mh1 - mh2)) {
            alpha = alpha.star
            intercept = intercept.star
            accept = accept + 1
        }
        alpha.save[iter, ] <- alpha
        intercept.save[iter] <- intercept
    }
    alpha = apply(alpha.save, 2, mean)
    alpha.sd = apply(alpha.save, 2, sd)
    int = mean(intercept.save)
    int.sd = sd(intercept.save)
    list(alpha = alpha, alpha.sd = alpha.sd, alpha.save = alpha.save, 
        intercept = int, intercept.sd = int.sd, intercept.save = intercept.save, 
        accept = accept)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
