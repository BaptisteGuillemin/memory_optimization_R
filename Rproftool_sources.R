install.packages("sNPLS", type="source", INSTALL_opts="--with-keep.source")
library(sNPLS)
library(proftools)
library(graph)
library(BiocGenerics)
library(Rgraphviz)

# Random dataset
X_npls <- array(rpois(15000, 10), dim=c(50, 100, 3))
Y_npls <- matrix(2+0.4*X_npls[,5,1]+0.7*X_npls[,10,1]-0.9*X_npls[,15,1]
                 +0.6*X_npls[,20,1]-0.5*X_npls[,25,1]+rnorm(50), ncol=1)

#Rprof method call
srcfile <- system.file("samples", "bootlmEx.R", package = "proftools")  
profout <- tempfile()
Rprof(file=profout, interval = 0.001, memory.profiling = TRUE, gc.profiling = TRUE, line.profiling = TRUE)

# Model to profile: sNPLS with discrete thresholdings
fit <- cv_snpls(X_npls, Y_npls, ncomp=1:2, keepJ = 1:3, keepK = 1:2, parallel = FALSE)

source(srcfile)
Rprof(NULL) # end of recording with rprof 
pd <- profileExpr(source(srcfile)) # assign with profileexpr 
unlink(profout)

# to annote library source
annotateSource(pd, value = c("pct", "time", "hits"), GC = TRUE, sep = ": ", show = TRUE)

filteredPD <- filterProfileData(pd, select = "withVisible", skip = 4)
# Filtered data for graph method 


# proftools
funsummary = funSummary(pd, byTotal = TRUE, value = c("pct", "time", "hits"),
           srclines = TRUE, GC = TRUE, memory = TRUE, self.pct = 0, total.pct = 0)

callsummary = callSummary(pd, byTotal = TRUE, value = c("pct", "time", "hits"),
            srclines = TRUE, GC = TRUE, memory = TRUE, self.pct = 0, total.pct = 0)

pathsummary = pathSummary(pd, value = c("pct", "time", "hits"),
            srclines = FALSE, GC = TRUE, memory = TRUE, total.pct = 0)

srcSummary = srcSummary(pd, byTotal = TRUE, value = c("pct", "time", "hits"),
           GC = TRUE, memory = TRUE, total.pct = 0, source = TRUE,
           width = getOption("width"))

hotpaths = hotPaths(pd, GC=TRUE, memory=TRUE, total.pct = 10.0)

datacycle = profileDataCycles(pd, GC)

### Graphs
plotProfileCallGraph(pd)

printProfileCallGraph(filterProfileData(pd))

flatprofile = flatProfile(pd, byTotal = TRUE, GC = TRUE)

printProfileCallGraph(filteredPD, file = stdout(), percent = TRUE, GC = TRUE,
                      maxnodes = NA, total.pct = 0)

flameGraph(filteredPD, svgfile, order = c("hot", "alpha", "time"),
           colormap = NULL, srclines = FALSE, cex = 0.75,
           main = "Call Graph", tooltip = FALSE)
calleeTreeMap(pd, srclines = FALSE, cex = 0.75, colormap = NULL,
              main = "Callee Tree Map", squarify = FALSE, border = NULL)
