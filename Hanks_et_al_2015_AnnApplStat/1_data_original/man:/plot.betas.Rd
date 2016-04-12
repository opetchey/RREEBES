
\name{plot.betas}
\alias{plot.betas}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Plot time-varying beta posterior distributions
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
plot.betas(mi.out, spline.list, times.betas, col.list = c("red", "blue", "green", "purple", "black"), ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{mi.out}{
%%     ~~Describe \code{mi.out} here~~
}
  \item{spline.list}{
%%     ~~Describe \code{spline.list} here~~
}
  \item{times.betas}{
%%     ~~Describe \code{times.betas} here~~
}
  \item{col.list}{
%%     ~~Describe \code{col.list} here~~
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
function (mi.out, spline.list, times.betas, col.list = c("red", 
    "blue", "green", "purple", "black"), ...) 
{
    beta.mat = get.betas(mi.out, spline.list, times.betas)
    sd.mat = get.betas.sd(mi.out, spline.list, times.betas)
    for (i in 1:ncol(beta.mat)) {
        dev.new()
        plot(c(times.betas, times.betas, times.betas), c(beta.mat[, 
            i], beta.mat[, i] + 1.96 * sd.mat[, i], beta.mat[, 
            i] - 1.96 * sd.mat[, i]), type = "n", main = colnames(beta.mat)[i], 
            xlab = "Time", ylab = "Beta")
        points(times.betas, beta.mat[, i], type = "l", col = col.list[i], 
            ...)
        points(times.betas, beta.mat[, i] + 1.96 * sd.mat[, i], 
            type = "l", lty = 2, col = col.list[i], ...)
        points(times.betas, beta.mat[, i] - 1.96 * sd.mat[, i], 
            type = "l", lty = 2, col = col.list[i], ...)
    }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
