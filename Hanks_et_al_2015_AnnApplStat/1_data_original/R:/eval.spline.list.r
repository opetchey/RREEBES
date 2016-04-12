
eval.spline.list <- function(spline.list,times){

  T=length(times)
  p=length(spline.list)
  length.alpha=0
  Q.list=list()
  for(i in 1:p){
    Q=eval.basis(times,spline.list[[i]])
    Q.list[[i]]=Matrix(Q,sparse=TRUE)
    length.alpha=length.alpha+ncol(Q)
  }

  ## combine all Q matrices
  Q.tilde=Matrix(0,nrow=T*p,ncol=length.alpha,sparse=T)
  col.idx=1
  for(i in 1:p){
    Q.tilde[(T*(i-1))+1:T,col.idx:(col.idx+ncol(Q.list[[i]])-1)] <- Q.list[[i]]
    col.idx=col.idx+ncol(Q.list[[i]])
  }
  Q.tilde
}
