
\name{plot.ani.interact}
\alias{plot.ani.interact}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Plots CTCRW paths for multiple animals over time 
}
\description{
Creates either a pdf or a series of jpg images showing the movement of
one or more animals over time.
}
\usage{
plot.ani.interact(sim.obj.list, rast, times, output = "pdf", save.folder = "./", pdfname = "ani.pdf", col.list = c("red", "blue", "green", "purple", "black"), ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{sim.obj.list}{
%%     ~~Describe \code{sim.obj.list} here~~
}
  \item{rast}{
%%     ~~Describe \code{rast} here~~
}
  \item{times}{
%%     ~~Describe \code{times} here~~
}
  \item{output}{
%%     ~~Describe \code{output} here~~
}
  \item{save.folder}{
%%     ~~Describe \code{save.folder} here~~
}
  \item{pdfname}{
%%     ~~Describe \code{pdfname} here~~
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
function (sim.obj.list, rast, times, output = "pdf", save.folder = "./", 
    pdfname = "ani.pdf", col.list = c("red", "blue", "green", 
        "purple", "black"), ...) 
{
    n = length(sim.obj.list)
    mintime = min(times)
    maxtime = max(times)
    paths.list = list()
    for (i in 1:n) {
        paths.list[[i]] = get.crawl.path(sim.obj.list[[i]], rast, 
            mintime, maxtime)
    }
    if (output == "pdf") {
        pdf(paste(save.folder, pdfname, sep = ""))
        time.counter = 1
        for (t in times) {
            time.counter = time.counter + 1
            plot(rast, main = paste("Julian Day: ", round(t\%\%365, 
                2)), ...)
            for (i in 1:n) {
                t.idx = which(paths.list[[i]]$t <= t)
                points(paths.list[[i]]$cont.path[t.idx, ], col = col.list[i], 
                  type = "l", lty = 1, lwd = 2)
                points(paths.list[[i]]$cont.path[t.idx[length(t.idx)], 
                  1], paths.list[[i]]$cont.path[t.idx[length(t.idx)], 
                  2], col = "black", type = "p", pch = i, cex = 2)
            }
        }
        dev.off()
    }
    if (output == "jpg") {
        time.counter = 1
        for (t in times) {
            jpeg(filename = paste(save.folder, sprintf("movie\%03d.jpg", 
                time.counter), sep = ""), width = 800, height = 800, 
                quality = 100)
            time.counter = time.counter + 1
            plot(rast, ...)
            for (i in 1:n) {
                t.idx = which(paths.list[[i]]$t <= t)
                points(paths.list[[i]]$cont.path[t.idx, ], col = col.list[i], 
                  type = "l", lty = 2)
                points(paths.list[[i]]$cont.path[t.idx[length(t.idx)], 
                  1], paths.list[[i]]$cont.path[t.idx[length(t.idx)], 
                  2], col = col.list[i], type = "p", pch = i, 
                  cex = 2)
            }
            dev.off()
        }
    }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
