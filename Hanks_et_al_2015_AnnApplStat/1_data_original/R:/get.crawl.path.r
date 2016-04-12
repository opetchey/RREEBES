
get.crawl.path <- function(sim.obj,raster,mintime,maxtime,...){
  if(class(raster)=="RasterStack"){
        examplerast=raster[[1]]
  }
  if(class(raster)=="RasterLayer"){
    examplerast=raster
  }

  t=sim.obj$datetime
  t.idx=which(t>=mintime & t<=maxtime)
  t=t[t.idx]

  keep.idx=0
  while(keep.idx==0){
    samp.new <- crwPostIS(sim.obj, fullPost=FALSE)
    path.list=cbind(samp.new$alpha.sim.x[t.idx,'mu'], samp.new$alpha.sim.y[t.idx,'mu'])
    path.loc.idx=cellFromXY(examplerast,path.list)
    if(length(which(is.na(path.loc.idx)))==0){
      keep.idx=1
    }
  }
  list(t=t,cont.path=path.list,cells.path=path.loc.idx)
}
