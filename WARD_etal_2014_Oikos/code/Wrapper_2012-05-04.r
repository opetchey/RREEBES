

RootFile = "C:\\Users\\James Thorson\\Desktop\\UW Hideaway\\NLTS\\"

source(paste(RootFile,"Fn_simplex_and_smap_2012-05-04.r",sep=""))

# Generate tent function timeseries
Y = SimTentFn(Nobs=100, S=1.75)
X = seq(0,1, length=1e4); plot(x=X, y=sapply(X, FUN=TentFn, S=1.75))
plot(y=Y[-1], x=Y[-Nobs])
plot(x=Y[-Nobs], y=Y[-1])

# Generate Lotka-Volterra timeseries
Y = SimPredPreyFn(Nobs=100, Nt=100, A=0.4, B=0.5, C=0.2, E=1)$Y

# Simplex
Output = NltsFn(Y, Nembed=1, Method="Simplex")
EmbedFn(Y, Candidates=1:10)
NltsPred(c(Y,NA), Nembed=4, PredNum=length(Y)+1, Method="Simplex")

# S-map
Output = NltsFn(Y, Nembed=4, Method="Smap", Theta=1)
ThetaFn(Y, Nembed=4)
NltsPred(c(Y,NA), Nembed=4, PredNum=length(Y)+1, Method="Smap", Theta=1)
