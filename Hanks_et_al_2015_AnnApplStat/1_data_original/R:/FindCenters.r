
FindCenters=function(ani,max.dist=200,max.time.dist=6,mintime=min(ani$locs[,3]),maxtime=max(ani$locs[,3]),nightonly=FALSE,nightstart=21/24,nightend=6/24){
  ##
  ## Function to find activity centers using the method of Knopff et al 2009
  ##
  ## "ani" is a list with elements: 
  ##  - 
  ##

  if(nightonly){
    hours=ani$locs[,3]%%1
    night=(hours-nightstart)%%1
    t.idx=which(ani$locs[,3]>=mintime & ani$locs[,3]<=maxtime & night<1-nightstart+nightend)
  }else{
    t.idx=which(ani$locs[,3]>=mintime & ani$locs[,3]<=maxtime)
  }
  
  locs=ani$locs[t.idx,-3]
  t=ani$locs[t.idx,3]
  dmat=as.matrix(dist(locs))
  dmat.t=as.matrix(dist(t))
  diag(dmat) <- NA
  dmat[upper.tri(dmat)] <- NA
  diag(dmat.t) <- NA
  dmat.t[upper.tri(dmat.t)] <- NA
  
  N=ncol(dmat)
  pairs=which(dmat<max.dist & dmat.t<max.time.dist,arr.ind=T)
  pts=unique(pairs[,1])
  pairs.cluster=rep(0,nrow(pairs))
  points.cluster=rep(0,nrow(locs))
  
  cluster=list()
  
  no.pairs=0
  clust.index=1
  while(no.pairs==0){
    stop.idx=0
    seed=which(pairs.cluster==0)[1]
    c.idx=as.vector(pairs[seed,])
    pairs.cluster[which(pairs[,1]==c.idx[1] & pairs[,2]==c.idx[2])] <- clust.index
    while(stop.idx==0){      
      points.cluster[c.idx] <- clust.index
      clust.mean=apply(locs[c.idx,],2,mean)
      d.clust=as.matrix(dist(rbind(clust.mean,locs)))[-1,1]
      d.clust[points.cluster>0] <- NA
      candidate=which.min(d.clust)  
      if(length(candidate)>0 & d.clust[candidate]<max.dist & abs(t[candidate]-t[c.idx[length(c.idx)]])<max.time.dist){
        c.idx=c(c.idx,candidate)
        points.cluster[candidate] <- clust.index
      }
      else{
        stop.idx=1
        cluster[[clust.index]] <- clust.mean        
      }
    }
    pairs.cluster[apply(matrix(pairs %in% c.idx,ncol=2),1,sum)>0] <- clust.index
    clust.index=clust.index+1
    if(length(which(pairs.cluster==0))==0){
      no.pairs=1
    }
  }
  
  clusters=c(NA,NA)
  for(j in 1:length(cluster)){
    clusters=rbind(clusters,cluster[[j]])
  }
  clusters=clusters[-1,]
  
  list(clusters=clusters,locs=locs,points.cluster=points.cluster)
}


  
