
\name{make.Phi.mat}
\alias{make.Phi.mat}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Computes CTDS path.
}
\description{
Samples a CTCRW path from the posterior path distribution, computes the
corresponding CTDS path, and computes the data matrices for the Poisson
GLM latent variable approach.
}
\usage{
make.Phi.mat(sim.obj, spline.list, stack.static, stack.grad, other.sim.list = list(), crw = TRUE, normalize.gradients = TRUE, grad.point.decreasing = TRUE, path.aug.interval = 0, spline.period = 0,imputation.model="CRAWL")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{sim.obj}{
%%     ~~Describe \code{sim.obj} here~~
}
  \item{spline.list}{
%%     ~~Describe \code{spline.list} here~~
}
  \item{stack.static}{
%%     ~~Describe \code{stack.static} here~~
}
  \item{stack.grad}{
%%     ~~Describe \code{stack.grad} here~~
}
  \item{other.sim.list}{
%%     ~~Describe \code{other.sim.list} here~~
}
  \item{crw}{
%%     ~~Describe \code{crw} here~~
}
  \item{normalize.gradients}{
%%     ~~Describe \code{normalize.gradients} here~~
}
  \item{grad.point.decreasing}{
%%     ~~Describe \code{grad.point.decreasing} here~~
}
  \item{path.aug.interval}{
%%     ~~Describe \code{path.aug.interval} here~~
}
  \item{spline.period}{
%%     ~~Describe \code{spline.period} here~~
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
function (sim.obj, spline.list, stack.static, stack.grad, other.sim.list = list(), 
    crw = TRUE, normalize.gradients = TRUE, grad.point.decreasing = TRUE, 
    path.aug.interval = 0, spline.period = 0) 
{
    if (spline.period == 0) {
        mintime = spline.list[[1]]$rangeval[1]
        maxtime = spline.list[[1]]$rangeval[2]
    }
    else {
        mintime = min(sim.obj$datetime)
        maxtime = max(sim.obj$datetime)
    }
    t = sim.obj$datetime
    t.idx = which(t >= mintime & t <= maxtime)
    t = t[t.idx]
    p.static = nlayers(stack.static)
    p.crw = 0
    if (crw) {
        p.crw = 1
    }
    if (class(stack.grad) == "RasterLayer" | class(stack.grad) == 
        "RasterStack") {
        p.grad = nlayers(stack.grad)
        stack.gradient = rast.grad(stack.grad)
        if (normalize.gradients) {
            lengths = sqrt(stack.gradient$grad.x^2 + stack.gradient$grad.y^2)
            stack.gradient$grad.x <- stack.gradient$grad.x/lengths
            stack.gradient$grad.y <- stack.gradient$grad.y/lengths
        }
    }
    else {
        p.grad = 0
    }
    p.ani = length(other.sim.list)
    p = p.static + p.crw + p.grad + p.ani
    if (class(stack.static) == "RasterStack") {
        examplerast = stack.static[[1]]
    }
    if (class(stack.static) == "RasterLayer") {
        examplerast = stack.static
    }
    keep.idx = 0
    while (keep.idx == 0) {
        samp.new <- crwPostIS(sim.obj, fullPost = FALSE)
        if (path.aug.interval > 0) {
            xvals = samp.new$alpha.sim.x[t.idx, "mu"]
            yvals = samp.new$alpha.sim.y[t.idx, "mu"]
            taug = seq(mintime, maxtime, by = path.aug.interval)
            xaug = approx(t, xvals, xout = taug)$y
            yaug = approx(t, yvals, xout = taug)$y
            na.idx = unique(c(which(is.na(xaug)), which(is.na(yaug))))
            if (length(na.idx) > 0) {
                path.list = cbind(xaug, yaug)[-na.idx, ]
                taug = taug[-na.idx]
            }
            else {
                path.list = cbind(xaug, yaug)
                taug = taug
            }
        }
        else {
            path.list = cbind(samp.new$alpha.sim.x[t.idx, "mu"], 
                samp.new$alpha.sim.y[t.idx, "mu"])
            taug = t
        }
        path.loc.idx = cellFromXY(examplerast, path.list)
        if (length(which(is.na(path.loc.idx))) == 0) {
            keep.idx = 1
        }
    }
    locs.idx <- cumsum(c(TRUE, diff(path.loc.idx) != 0))
    first.idx = which(diff(path.loc.idx) != 0)
    start.times = taug[first.idx[-length(first.idx)]]
    end.times = taug[first.idx[-1]]
    wait.times = end.times - start.times
    locs = path.loc.idx[first.idx[-length(first.idx)]]
    if (spline.period != 0) {
        start.times = start.times\%\%spline.period
    }
    Q.tilde = eval.spline.list(spline.list, start.times)
    e = Matrix(0, ncol = p, nrow = 1)
    e.i = e
    e.i[1] = 1
    T = length(start.times)
    W = Diagonal(T) \%x\% e.i
    for (i in 2:p) {
        e.i = e
        e.i[i] = 1
        W = rBind(W, Diagonal(T) \%x\% e.i)
    }
    W = t(W)
    QQ = W \%*\% Q.tilde
    sort.idx = sort(locs, index.return = TRUE)$ix
    n.nbrs = 4
    sort.idx = rep(sort.idx, each = n.nbrs)
    time.idx = rep(1:(length(locs) - 1), each = n.nbrs)
    adj = adjacent(examplerast, locs, pairs = TRUE, sorted = TRUE, 
        id = TRUE)
    adj.cells = adj[, 3]
    start.cells = adj[, 2]
    z = rep(0, length(start.cells))
    idx.move = rep(0, length(z))
    diag.move = rep(0, length(locs))
    for (i in 1:(length(locs))) {
        idx.t = which(time.idx == i)
        idx.m = which(adj.cells[idx.t] == locs[i + 1])
        z[idx.t[idx.m]] <- 1
        if (length(idx.m) == 0) {
            diag.move[i] = 1
        }
    }
    tau = rep(wait.times, each = n.nbrs)
    if (nlayers(stack.static) > 1) {
        X.static = values(stack.static)[start.cells, ]
    }
    else {
        X.static = matrix(values(stack.static)[start.cells], 
            ncol = 1)
    }
    colnames(X.static) <- layerNames(stack.static)
    xy.cell = xyFromCell(examplerast, start.cells)
    xy.adj = xyFromCell(examplerast, adj.cells)
    v.adj = (xy.adj - xy.cell)/sqrt(apply((xy.cell - xy.adj)^2, 
        1, sum))
    if (p.grad > 0) {
        X.grad = v.adj[, 1] * stack.gradient$grad.x[start.cells, 
            ] + v.adj[, 2] * stack.gradient$grad.y[start.cells, 
            ]
        if (grad.point.decreasing == TRUE) {
            X.grad = -X.grad
        }
        colnames(X.grad) <- colnames(stack.gradient$grad.x)
    }
    crawl.ani.list = list()
    if (p.ani > 0) {
        X.loc.ani = matrix(NA, nrow = nrow(X.static), ncol = p.ani)
        Y.loc.ani = matrix(NA, nrow = nrow(X.static), ncol = p.ani)
        vec.lengths = matrix(NA, nrow = nrow(X.static), ncol = p.ani)
        colnames.ani = rep(NA, p.ani)
        for (ani in 1:p.ani) {
            sim.ani = other.sim.list[[ani]]
            samp.new.ani <- crwPostIS(sim.ani, fullPost = FALSE)
            t.ani = sim.ani$datetime
            t.idx.ani = which(t.ani >= mintime & t.ani <= maxtime)
            t.ani = t.ani[t.idx.ani]
            xvals.ani = samp.new.ani$alpha.sim.x[t.idx.ani, "mu"]
            yvals.ani = samp.new.ani$alpha.sim.y[t.idx.ani, "mu"]
            X.loc.ani[, ani] = approx(t.ani, xvals.ani, xout = start.times)$y
            Y.loc.ani[, ani] = approx(t.ani, yvals.ani, xout = start.times)$y
            vec.lengths[, ani] = sqrt((X.loc.ani - xy.cell[, 
                1])^2 + (Y.loc.ani - xy.cell[, 2])^2)
            colnames.ani[ani] = paste("Ani.", ani, sep = "")
            crawl.ani.list[[ani]] <- samp.new.ani
        }
        X.ani = v.adj[, 1] * (X.loc.ani - xy.cell[, 1]) + v.adj[, 
            2] * (Y.loc.ani - xy.cell[, 2])
        X.ani = X.ani/vec.lengths
        colnames(X.ani) <- colnames.ani
    }
    idx.move = rep(1, length(locs))
    idx.move[-which(diag.move == 1)] <- which(z == 1)
    v.moves = v.adj[rep(idx.move, each = n.nbrs), ]
    v.moves = rbind(matrix(0, ncol = 2, nrow = n.nbrs), v.moves[-(nrow(v.moves):(nrow(v.moves) - 
        n.nbrs + 1)), ])
    X.crw = apply(v.moves * v.adj, 1, sum)
    if (crw == FALSE & p.ani == 0 & p.grad > 0) {
        X = cbind(X.static, X.grad)
    }
    if (crw == FALSE & p.ani > 0 & p.grad > 0) {
        X = cbind(X.static, X.grad, X.ani)
    }
    if (crw == TRUE & p.ani == 0 & p.grad > 0) {
        X = cbind(X.static, X.grad, X.crw)
    }
    if (crw == TRUE & p.ani > 0 & p.grad > 0) {
        X = cbind(X.static, X.grad, X.ani, X.crw)
    }
    if (crw == FALSE & p.ani == 0 & p.grad == 0) {
        X = cbind(X.static)
    }
    if (crw == FALSE & p.ani > 0 & p.grad == 0) {
        X = cbind(X.static, X.ani)
    }
    if (crw == TRUE & p.ani == 0 & p.grad == 0) {
        X = cbind(X.static, X.crw)
    }
    if (crw == TRUE & p.ani > 0 & p.grad == 0) {
        X = cbind(X.static, X.ani, X.crw)
    }
    T = length(wait.times)
    p = ncol(X)
    X.vec = as.vector(t(X))
    row.idx = rep(1:nrow(X), each = p)
    col.idx.mat = matrix(1:p, nrow = nrow(X), ncol = p, byrow = T)
    col.idx.mat = col.idx.mat + p * rep(0:((nrow(X) - 1)/n.nbrs), 
        each = n.nbrs)
    col.idx = as.vector(t(col.idx.mat))
    XX = sparseMatrix(i = row.idx, j = col.idx, x = X.vec)
    Phi = XX \%*\% QQ
    list(Phi = Phi, z = z, tau = tau, samp.new = samp.new, X = X, 
        XX = XX, QQ = QQ, start.times = start.times, spline.list = spline.list)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
