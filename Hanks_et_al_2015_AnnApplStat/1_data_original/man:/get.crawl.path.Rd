
\name{get.crawl.path}
\alias{get.crawl.path}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Sample a CTCRW path from a "crawl" sim.obj
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
get.crawl.path(sim.obj, raster, mintime, maxtime, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{sim.obj}{
%%     ~~Describe \code{sim.obj} here~~
}
  \item{raster}{
%%     ~~Describe \code{raster} here~~
}
  \item{mintime}{
%%     ~~Describe \code{mintime} here~~
}
  \item{maxtime}{
%%     ~~Describe \code{maxtime} here~~
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
function (sim.obj, raster, mintime, maxtime, ...) 
{
    if (class(raster) == "RasterStack") {
        examplerast = raster[[1]]
    }
    if (class(raster) == "RasterLayer") {
        examplerast = raster
    }
    t = sim.obj$datetime
    t.idx = which(t >= mintime & t <= maxtime)
    t = t[t.idx]
    keep.idx = 0
    while (keep.idx == 0) {
        samp.new <- crwPostIS(sim.obj, fullPost = FALSE)
        path.list = cbind(samp.new$alpha.sim.x[t.idx, "mu"], 
            samp.new$alpha.sim.y[t.idx, "mu"])
        path.loc.idx = cellFromXY(examplerast, path.list)
        if (length(which(is.na(path.loc.idx))) == 0) {
            keep.idx = 1
        }
    }
    list(t = t, cont.path = path.list, cells.path = path.loc.idx)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
