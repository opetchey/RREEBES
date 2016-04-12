
\name{rast.grad}
\alias{rast.grad}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Create gradient maps from raster
}
\description{
Takes a raster object and calculates the x and y coordinates of the gradient.
}
\usage{
rast.grad(rasterstack)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{rasterstack}{
%%     ~~Describe \code{rasterstack} here~~
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
function (rasterstack) 
{
    if (class(rasterstack) == "RasterStack") {
        xy = xyFromCell(rasterstack[[1]], 1:length(values(rasterstack[[1]])))
        X = xy
        X.grad.x = rep(NA, length(values(rasterstack[[1]])))
        X.grad.y = rep(NA, length(values(rasterstack[[1]])))
        for (k in 1:nlayers(rasterstack)) {
            X = cbind(X, values(rasterstack[[k]]))
            slope = terrain(rasterstack[[k]], opt = "slope")
            aspect = terrain(rasterstack[[k]], opt = "aspect")
            grad.x = -1 * slope * cos(0.5 * pi - aspect)
            values(grad.x)[is.na(values(grad.x))] <- 0
            grad.y = -1 * slope * sin(0.5 * pi - aspect)
            values(grad.y)[is.na(values(grad.y))] <- 0
            X.grad.x = cbind(X.grad.x, values(grad.x))
            X.grad.y = cbind(X.grad.y, values(grad.y))
        }
        X.grad.x = X.grad.x[, -1]
        colnames(X.grad.x) <- layerNames(rasterstack)
        X.grad.y = X.grad.y[, -1]
        colnames(X.grad.y) <- layerNames(rasterstack)
        rasterexample = rasterstack[[1]]
    }
    if (class(rasterstack) == "RasterLayer") {
        xy = xyFromCell(rasterstack, 1:length(values(rasterstack)))
        X = xy
        X = cbind(X, values(rasterstack))
        slope = terrain(rasterstack, opt = "slope")
        aspect = terrain(rasterstack, opt = "aspect")
        grad.x = -1 * slope * cos(0.5 * pi - aspect)
        values(grad.x)[is.na(values(grad.x))] <- 0
        X.grad.x = matrix(values(grad.x), ncol = 1)
        grad.y = -1 * slope * sin(0.5 * pi - aspect)
        values(grad.y)[is.na(values(grad.y))] <- 0
        X.grad.y = matrix(values(grad.y), ncol = 1)
        rasterexample = rasterstack
    }
    list(xy = xy, grad.x = X.grad.x, grad.y = X.grad.y, rast.grad.x = grad.x, 
        rast.grad.y = grad.y)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
