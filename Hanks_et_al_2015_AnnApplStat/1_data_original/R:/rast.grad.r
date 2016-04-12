
rast.grad=function(rasterstack){

  ## Last Modified 20120702
  ##
  ## Takes a raster stack or raster and creates two matrices
  ##  which contain the x and y coordinates of the gradient
  ##  of each raster layer.
  ##
  ## 

  if(class(rasterstack)=="RasterStack"){
    #browser()
  xy=xyFromCell(rasterstack[[1]],1:length(values(rasterstack[[1]])))
  X=xy
  X.grad.x=rep(NA,length(values(rasterstack[[1]])))
  X.grad.y=rep(NA,length(values(rasterstack[[1]])))
  for(k in 1:nlayers(rasterstack)){
    X=cbind(X,values(rasterstack[[k]]))
    slope=terrain(rasterstack[[k]],opt="slope")
    aspect=terrain(rasterstack[[k]],opt="aspect")
    grad.x=-1*slope*cos(.5*pi-aspect)
    values(grad.x)[is.na(values(grad.x))] <- 0
    grad.y=-1*slope*sin(.5*pi-aspect)
    values(grad.y)[is.na(values(grad.y))] <- 0
    X.grad.x=cbind(X.grad.x,values(grad.x))
    X.grad.y=cbind(X.grad.y,values(grad.y))  
  }
  X.grad.x=X.grad.x[,-1]
  colnames(X.grad.x) <- names(rasterstack)
  X.grad.y=X.grad.y[,-1]
  colnames(X.grad.y) <- names(rasterstack)
  rasterexample=rasterstack[[1]]
  }
  if(class(rasterstack)=="RasterLayer"){
    xy=xyFromCell(rasterstack,1:length(values(rasterstack)))
    X=xy
    X=cbind(X,values(rasterstack))
    slope=terrain(rasterstack,opt="slope")
    aspect=terrain(rasterstack,opt="aspect")
    grad.x=-1*slope*cos(.5*pi-aspect)
    values(grad.x)[is.na(values(grad.x))] <- 0
    X.grad.x=matrix(values(grad.x),ncol=1)
    grad.y=-1*slope*sin(.5*pi-aspect)
    values(grad.y)[is.na(values(grad.y))] <- 0
    X.grad.y=matrix(values(grad.y),ncol=1)
    rasterexample=rasterstack
  }
  list(xy=xy,grad.x=X.grad.x,grad.y=X.grad.y,rast.grad.x=grad.x,rast.grad.y=grad.y)
}
