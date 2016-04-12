
\name{eval.spline.list}
\alias{eval.spline.list}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Evaluate a spline.list object.
}
\description{
Evaluates a spline.list object at given times.
}
\usage{
eval.spline.list(spline.list, times)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{spline.list}{
A list where each object is a spline object from the 'fda' package.
}
  \item{times}{
Numeric vector of times where the spline list should be evaluated.
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
function (spline.list, times) 
{
    T = length(times)
    p = length(spline.list)
    length.alpha = 0
    Q.list = list()
    for (i in 1:p) {
        Q = eval.basis(times, spline.list[[i]])
        Q.list[[i]] = Matrix(Q, sparse = TRUE)
        length.alpha = length.alpha + ncol(Q)
    }
    Q.tilde = Matrix(0, nrow = T * p, ncol = length.alpha, sparse = T)
    col.idx = 1
    for (i in 1:p) {
        Q.tilde[(T * (i - 1)) + 1:T, col.idx:(col.idx + ncol(Q.list[[i]]) - 
            1)] <- Q.list[[i]]
        col.idx = col.idx + ncol(Q.list[[i]])
    }
    Q.tilde
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
