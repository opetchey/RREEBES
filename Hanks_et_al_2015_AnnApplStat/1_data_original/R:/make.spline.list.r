
make.spline.list <- function(mintime,maxtime,knot.intervals.list,spl.option.idx=NA,...){

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

  if(class(knot.intervals.list)=="list"){
    p.list=list()
    for(i in 1:length(knot.intervals.list)){
      p.list[[i]]=length(knot.intervals.list[[i]])
    }
  }else{
    if(class(knot.intervals.list)=="numeric"){
      p.list=list()
      p.list[[1]]=length(knot.intervals.list)
      knot.intervals.list=list(knot.intervals.list)
    }else{
      cat("knot.intervals.list must be either a numeric vector or a list of numeric vectors")
    }
  }

  #browser()

  ## making spline knots
  spline.knots.list=list()
  spline.list=list()

  for(j in 1:length(p.list)){
    if(p.list[[j]]>0){
      for(i in 1:p.list[[j]]){
        if(knot.intervals.list[[j]][i]>0){
          knots=seq(mintime,maxtime,knot.intervals.list[[j]][i])
          if(knots[length(knots)]<maxtime){
            knots=c(knots,maxtime)
          }
          spline.knots.list[[length(spline.knots.list)+1]]=knots
          if(spl.option.idx==j){
            spline.list[[length(spline.list)+1]]=create.bspline.basis(rangeval=c(mintime,maxtime),breaks=spline.knots.list[[length(spline.knots.list)]],...)
          }else{
            spline.list[[length(spline.list)+1]]=create.bspline.basis(rangeval=c(mintime,maxtime),breaks=spline.knots.list[[length(spline.knots.list)]])
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
