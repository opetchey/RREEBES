
make.fourier.list <- function(mintime,maxtime,nbasis.list,spl.option.idx=NA,...){

  ## Last Updated 20120716
  ##
  ## Creates a list of basis objects (from the 'fda' package)
  ## 
  ## mintime - lower end of the time interval
  ## maxtime - upper end of the time interval
  ## knot.intervals.list - either a numeric vector or a list containing
  ##   the time intervals at which regularly-spaced knots will be used 
  ##   for each of the basis objects.  If the time interval = 0, then a
  ##   constant basis will be used.  Otherwise, B-spline basis functions
  ##   will be used.
  ##
  ## Output is a list of length equal to the number of elements in
  ##   knot.intervals.list, with one 'fda' basis object per list entry
  ##

  if(class(nbasis.list)=="list"){
    p.list=list()
    for(i in 1:length(nbasis.list)){
      p.list[[i]]=length(nbasis.list[[i]])
    }
  }else{
    if(class(nbasis.list)=="numeric"){
      p.list=list()
      p.list[[1]]=length(nbasis.list)
      nbasis.list=list(nbasis.list)
    }else{
      cat("nbasis.list must be either a numeric vector or a list of numeric vectors")
    }
  }

  #browser()

  ## making spline knots
  spline.knots.list=list()
  spline.list=list()

  for(j in 1:length(p.list)){
    if(p.list[[j]]>0){
      for(i in 1:p.list[[j]]){
        if(nbasis.list[[j]][i]>0){
          if(spl.option.idx==j){
            spline.list[[length(spline.list)+1]]=create.fourier.basis(rangeval=c(mintime,maxtime),nbasis=nbasis.list[[j]][i],...)
          }else{
            spline.list[[length(spline.list)+1]]=create.fourier.basis(rangeval=c(mintime,maxtime),nbasis=nbasis.list[[j]][i])
          }
        }else{
          spline.knots.list[[length(spline.knots.list)+1]]=NA
          spline.list[[length(spline.list)+1]]=create.constant.basis(rangeval=c(mintime,maxtime))
        }
      }
    }
  }
  spline.list
}
