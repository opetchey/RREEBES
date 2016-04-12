
\name{get.betas}
\alias{get.betas}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Obtain beta(t) after a spline expansion.
}
\description{
Obtains beta(t) by evaluating the spline basis expansion at a
user-specified set of times.
}
\usage{
get.betas(MI.out, spline.list, eval.times)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{MI.out}{
an object of class "MI.out".
}
  \item{spline.list}{
an object of class "spline.list".
}
  \item{eval.times}{
a numeric vector of times when the spline basis expansion should be evaluated.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
a matrix with 'length(eval.times)' 'rows and length(spline.list)'
columns where the k-th column contains the values 'beta_k(t)' evaluated
at 't=eval.times'.
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Ephraim M. Hanks
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
%##---- Should be DIRECTLY executable !! ----
%##-- ==>  Define data, use random,
%##--	or do  help(data=index)  for the standard data sets.
%
%## The function is currently defined as
%function (MI.out, spline.list, eval.times) 
%{
%    Q.tilde = eval.spline.list(spline.list, eval.times)
%    beta.tilde = Q.tilde \%*\% MI.out$alpha
%    p = length(spline.list)
%    beta.mat = matrix(as.numeric(beta.tilde), ncol = p, byrow = F)
%    colnames(beta.mat) = MI.out$beta.names
%    beta.mat
%  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
