
\name{ctds.glm.MI}
\alias{ctds.glm.MI}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Fit Poisson GLM using multiple imputation
}
\description{
Fits the CTDS model of animal movement using multiple imputation.
Currently two methods are available: "Stacked.cv" which fits a group lasso
estimator by stacking the imputations with tuning parameter chosen through cross-validation, and
"MI" which uses standard multiple imputation with no shrinkage. 
}
\usage{
ctds.glm.MI(ctds.obj, nfolds = 10, nlambda = 100, plot.cv = FALSE, method = "Stacked.cv", cv.param = "min", ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ctds.obj}{
%%     ~~Describe \code{ctds.obj} here~~
}
  \item{nfolds}{
%%     ~~Describe \code{nfolds} here~~
}
  \item{nlambda}{
%%     ~~Describe \code{nlambda} here~~
}
  \item{plot.cv}{
%%     ~~Describe \code{plot.cv} here~~
}
  \item{method}{
%%     ~~Describe \code{method} here~~
}
  \item{cv.param}{
%%     ~~Describe \code{cv.param} here~~
}
  \item{\dots}{
%%     ~~Describe \code{\dots} here~~
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
function (ctds.obj, nfolds = 10, nlambda = 100, plot.cv = TRUE, 
    method = "Stacked.cv", cv.param = "min", ...) 
{
    if (method == "Stacked.cv") {
        cat("\n")
        cat("Compiling Matrices, ", length(ctds.obj$Phi.list), 
            " Total:", "\n")
        cat("1  ")
        Phi = ctds.obj$Phi.list[[1]]
        z = ctds.obj$z.list[[1]]
        tau = ctds.obj$tau.list[[1]]
        colsums = apply(abs(Phi), 2, sum)
        for (i in 2:length(ctds.obj$z.list)) {
            cat(i, " ")
            z = c(z, ctds.obj$z.list[[i]])
            Phi = rBind(Phi, ctds.obj$Phi.list[[i]])
            tau = c(tau, ctds.obj$tau.list[[i]])
            colsums = colsums + apply(abs(ctds.obj$Phi.list[[i]]), 
                2, sum)
        }
        cat("\n")
        zero.idx = which(colsums == 0)
        na.idx = which(is.na(colsums))
        Phi[which(is.na(Phi))] <- 0
        cat("Fitting GLM with Lasso Penalty Chosen Via Cross-Validation")
        glm.out = cv.glmnet(Phi, z, family = "poisson", offset = log(tau), 
            exclude = zero.idx, nfolds = nfolds, nlambda = nlambda, 
            ...)
        if (plot.cv == TRUE) {
            plot(glm.out)
        }
        cat("\n")
        cat("Finishing", "\n")
        if (cv.param == "min") {
            lambda.pen = glm.out$lambda.1se
        }
        if (cv.param == "1se") {
            lambda.pen = glm.out$lambda.1se
        }
        coeffs = predict(glm.out, s = lambda.pen, type = "coefficients")@x
        nonzero.coeffs = predict(glm.out, s = lambda.pen, type = "nonzero")
        nonzero.ratio = length(nonzero.coeffs)/ncol(Phi)
        nonzero.ratio
        alpha.hat = coeffs[-1]
        intercept.hat = coeffs[1]
        alpha.hat = rep(0, ncol(Phi))
        alpha.hat[nonzero.coeffs] = coeffs[-1]
        alpha.hat
        out = list(Phi = Phi, z = z, tau = tau, zero.idx = zero.idx, 
            nfolds = nfolds, nlambda = nlambda, alpha = alpha.hat, 
            intercept = intercept.hat, lambda.best = lambda.pen, 
            alpha.nonzero.proportion = nonzero.ratio, glmnet.out = glm.out, 
            beta.names = ctds.obj$beta.names)
    }
    if (method == "MI") {
        glm.out.list = list()
        alpha.list = list()
        num.imputations = length(ctds.obj$z.list)
        for (i in 1:num.imputations) {
            Phi = as.matrix(ctds.obj$Phi.list[[i]])
            z = matrix(ctds.obj$z.list[[i]], ncol = 1)
            tau = matrix(ctds.obj$tau.list[[i]])
            colsums = apply(abs(Phi), 2, sum)
            zero.idx = which(colsums == 0)
            glm.out.list[[i]] = glm(z ~ Phi, family = "poisson", 
                offset = log(tau))
            alpha.list[[i]] = list(alpha = glm.out.list[[i]]$coeff, 
                alpha.sd = summary(glm.out.list[[i]])$coeff[, 
                  2], na.idx = which(is.na(glm.out.list[[i]]$coeff)))
        }
        alpha.mat = matrix(NA, nrow = num.imputations, ncol = length(alpha.list[[1]]$alpha))
        alpha.var.mat = matrix(NA, nrow = num.imputations, ncol = length(alpha.list[[1]]$alpha))
        for (i in 1:num.imputations) {
            alpha.mat[i, ] = alpha.list[[i]]$alpha
            alpha.var.mat[i, -alpha.list[[i]]$na.idx] = alpha.list[[i]]$alpha.sd^2
        }
        alpha = apply(alpha.mat, 2, mean, na.rm = T)
        alpha.sd = sqrt(apply(alpha.var.mat, 2, mean, na.rm = T) + 
            apply(alpha.mat, 2, var, na.rm = T))
        out = list(intercept = alpha[1], intercept.sd = alpha.sd[1], 
            alpha = alpha[-1], alpha.sd = alpha.sd[-1], alpha.list = alpha.list)
    }
    out
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
