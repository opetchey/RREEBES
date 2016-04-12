
\name{make.spline.list}
\alias{make.spline.list}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Makes a list of spline basis objects.
}
\description{
Makes a list of B-spline basis objects from the 'fda' package for use in
semi-parametric regression.  Different knot intervals are allowed for
different variables.
}
\usage{
make.spline.list(mintime, maxtime, knot.intervals.list, spl.option.idx=NA,...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{mintime}{
Numeric lower bound for time
}
  \item{maxtime}{
Numeric upper bound for time
}
  \item{knot.intervals.list}{
Either a vector of intervals at which spline knots should be placed, or
a list of vectors of intervals.
}
  \item{spl.option.idx}{
    legacy
    }
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
List where each element is an object of class 'basis.object' from the
'fda' package.
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
function (mintime, maxtime, knot.intervals.list) 
{
    if (class(knot.intervals.list) == "list") {
        p.list = list()
        for (i in 1:length(knot.intervals.list)) {
            p.list[[i]] = length(knot.intervals.list[[i]])
        }
    }
    else {
        if (class(knot.intervals.list) == "numeric") {
            p.list = list()
            p.list[[1]] = length(knot.intervals.list)
            knot.intervals.list = list(knot.intervals.list)
        }
        else {
            cat("knot.intervals.list must be either a numeric vector or a list of numeric vectors")
        }
    }
    spline.knots.list = list()
    spline.list = list()
    for (j in 1:length(p.list)) {
        if (p.list[[j]] > 0) {
            for (i in 1:p.list[[j]]) {
                if (knot.intervals.list[[j]][i] > 0) {
                  knots = seq(mintime, maxtime, knot.intervals.list[[j]][i])
                  if (knots[length(knots)] < maxtime) {
                    knots = c(knots, maxtime)
                  }
                  spline.knots.list[[length(spline.knots.list) + 
                    1]] = knots
                  spline.list[[length(spline.list) + 1]] = create.bspline.basis(rangeval = c(mintime, 
                    maxtime), breaks = spline.knots.list[[length(spline.knots.list)]])
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
