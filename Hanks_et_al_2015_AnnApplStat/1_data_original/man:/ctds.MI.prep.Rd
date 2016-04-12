
\name{ctds.MI.prep}
\alias{ctds.MI.prep}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Compute a continuous-time discrete-space movement path
}
\description{
Samples from the posterior predictive path distribution of a CTCRW model
for animal movement from the CRAWL package, and transforms each CTCRW
path into a CTDS path on a grid.
}
\usage{
ctds.MI.prep(sim.obj, spline.list, stack.static, stack.grad,
conspecifics.list = NULL, crw = TRUE, num.crawl.paths = 10,
path.aug.interval = 0, spline.period = 0, imputation.model="CRAWL")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{sim.obj}{
An object of type 'crwSimulator' from the 'crawl' package
}
  \item{spline.list}{
A list where each object is a spline object from the 'fda' package
}
  \item{stack.static}{
A 'RasterStack' object from the 'raster' package
}
  \item{stack.grad}{
A 'RasterStack' object from the 'raster' package
}
  \item{conspecifics.list}{
A list where each object is of type 'crwSimulator' from the 'crawl' package
}
  \item{crw}{
Logical.  If 'TRUE' then include a correlated random walk term in the model
}
  \item{num.crawl.paths}{
Integer-valued number of path realizations.
}
  \item{path.aug.interval}{
Numeric value indicating the temporal resolution at which the path
should be subsampled
}
  \item{spline.period}{
Legacy.
}
  \item{imputation.model}{
Either "CRAWL" for the CTCRW imputation model or "BB" for a brownian
bridge imputation model.
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

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
