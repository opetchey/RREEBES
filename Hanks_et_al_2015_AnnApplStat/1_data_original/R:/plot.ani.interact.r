
plot.ani.interact=function(sim.obj.list,rast,times,output="pdf",save.folder="./",pdfname="ani.pdf",col.list=c("red","blue","green","purple","black"),...){
  n=length(sim.obj.list)
  mintime=min(times)
  maxtime=max(times)
  paths.list=list()
  for(i in 1:n){
    paths.list[[i]]=get.crawl.path(sim.obj.list[[i]],rast,mintime,maxtime)
  }

    if(output=="pdf"){
    pdf(paste(save.folder,pdfname,sep=""))
    time.counter=1
    for(t in times){
      time.counter=time.counter+1
      plot(rast,main=paste("Julian Day: ",round(t%%365,2)),...)
      for(i in 1:n){
        t.idx=which(paths.list[[i]]$t<=t)
        points(paths.list[[i]]$cont.path[t.idx,],col=col.list[i],type="l",lty=1,lwd=2)
        points(paths.list[[i]]$cont.path[t.idx[length(t.idx)],1],paths.list[[i]]$cont.path[t.idx[length(t.idx)],2],col="black",type="p",pch=i,cex=2)
      }
    }
    dev.off()
  }
  
  if(output=="jpg"){
    time.counter=1
    for(t in times){
      jpeg(filename=paste(save.folder,sprintf("movie%03d.jpg",time.counter),sep=""),width=800,height=800,quality=100)
      time.counter=time.counter+1
      #browser()
      plot(rast,...)
      for(i in 1:n){
        t.idx=which(paths.list[[i]]$t<=t)
        points(paths.list[[i]]$cont.path[t.idx,],col=col.list[i],type="l",lty=2)
        points(paths.list[[i]]$cont.path[t.idx[length(t.idx)],1],paths.list[[i]]$cont.path[t.idx[length(t.idx)],2],col=col.list[i],type="p",pch=i,cex=2)
      }
      dev.off()
    }
  }
}
  
