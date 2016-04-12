
\name{FindCenters}
\alias{FindCenters}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Find activity centers from telemetry data
}
\description{
Find activity centers defined by telemetry locations that are close in
time and space.
}
\usage{
FindCenters(ani, max.dist = 200, max.time.dist = 6, mintime = min(ani$locs[, 3]), maxtime = max(ani$locs[, 3]),nightonly=FALSE,nightstart=21/24,nightend=6/24)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ani}{
an object of class 'ani'.
}
  \item{max.dist}{
maximum distance in space two telemetry locations can be to define an
activity center. 
}
  \item{max.time.dist}{
maximum time between two telemetry locations that define an activity center.
}
  \item{mintime}{
lower bound on the time interval searched for activity centers.
}
  \item{maxtime}{
upper bound on the time interval searched for activity centers.
}
  \item{nightonly}{
Logical.  If TRUE, only consider activity centers visited at night.
}
  \item{nightstart}{
Time (in hours/24) when night starts.
}
  \item{nightend}{
Time (in hours/24) when night ends.
}
}
\details{
This function finds activity centers defined by locations where at least
two telemetry locations are within 'max.dist' in space and
'max.time.dist' in time.  The activity center is defined to be the
central (average) point of all the telemetry locations within the
space-time window defined by 'max.dist' and 'max.time.dist'.  If the
k-th telemetry location is used to define the p-th activity center,
which has coordinates in the p-th row of 'clusters', then the
k-th value in the 'points.cluster' vector is equal to p
The k-th
value in the 
'points.cluster' vector is 0 if the k-th telemetry location was not used
to define an activity center.
}
\value{
  A list with the following elements:
  \item{clusters}{ a numeric matrix where each row contains the spatial
    location of one activity center}
  \item{points.cluster}{ a numeric vector of length 'nrow(ani@locs)'.}
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

data(lion.pair)
cl=FindCenters(lion.pair$lion1,max.dist=200,max.time.dist=20)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
