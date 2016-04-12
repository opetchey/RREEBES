
\name{make.fourier.list}
\alias{make.fourier.list}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Make Fourier spline basis object
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
make.fourier.list(mintime, maxtime, nbasis.list, spl.option.idx = NA, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{mintime}{
%%     ~~Describe \code{mintime} here~~
}
  \item{maxtime}{
%%     ~~Describe \code{maxtime} here~~
}
  \item{nbasis.list}{
%%     ~~Describe \code{nbasis.list} here~~
}
  \item{spl.option.idx}{
%%     ~~Describe \code{spl.option.idx} here~~
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
function (mintime, maxtime, nbasis.list, spl.option.idx = NA, 
    ...) 
{
    if (class(nbasis.list) == "list") {
        p.list = list()
        for (i in 1:length(nbasis.list)) {
            p.list[[i]] = length(nbasis.list[[i]])
        }
    }
    else {
        if (class(nbasis.list) == "numeric") {
            p.list = list()
            p.list[[1]] = length(nbasis.list)
            nbasis.list = list(nbasis.list)
        }
        else {
            cat("nbasis.list must be either a numeric vector or a list of numeric vectors")
        }
    }
    spline.knots.list = list()
    spline.list = list()
    for (j in 1:length(p.list)) {
        if (p.list[[j]] > 0) {
            for (i in 1:p.list[[j]]) {
                if (nbasis.list[[j]][i] > 0) {
                  if (spl.option.idx == j) {
                    spline.list[[length(spline.list) + 1]] = create.fourier.basis(rangeval = c(mintime, 
                      maxtime), nbasis = nbasis.list[[j]][i], 
                      ...)
                  }
                  else {
                    spline.list[[length(spline.list) + 1]] = create.fourier.basis(rangeval = c(mintime, 
                      maxtime), nbasis = nbasis.list[[j]][i])
                  }
                }
                else {
                  spline.knots.list[[length(spline.knots.list) + 
                    1]] = NA
                  spline.list[[length(spline.list) + 1]] = create.constant.basis(rangeval = c(mintime, 
                    maxtime))
                }
            }
        }
    }
    spline.list
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
