## inputs
X <- data # insert accelerometry time series data here
eps <- 5 # insert sampling interval in second(s), this value is 5 in Suibkitwanchai et al. (2020)
## preliminaries
N <- length(X)
nh <- (60*60)/eps # number of ENMO values per hour
nd <- 24*nh # number of ENMO values per day
## Estimation of DFA scaling exponent
library(pracma)
Z <- cumsum(X-mean(X)) # Eq (5)
scale <- 2^seq(4,8,by=0.25)
n.scale <- length(scale)
m <- 1 # linear regression
seg <- numeric(n.scale)
f <- numeric(n.scale)
for (ns in 1:n.scale) {
  seg[ns] <- floor(length(Z)/scale[ns])
  Index <- matrix(NA, nrow = seg[ns], ncol = scale[ns])
  fit <- matrix(NA, nrow = seg[ns], ncol = scale[ns])
  RMS_local <- numeric(seg[ns])
  for (v in 1:seg[ns]) {
    Index_start <- (v-1)*scale[ns] + 1
    Index_stop <- v*scale[ns]
    Index[v,] <- Index_start:Index_stop
    C <- polyfit(Index[v,], Z[Index[v,]], m)
    fit[v,] <- polyval(C,Index[v,])
    RMS_local[v] <- sqrt(mean((fit[v,]-Z[Index[v,]])^2)) # Eq (6)
  }
  f[ns] <- sqrt(mean(RMS_local^2)) # Eq (7)
  }
C <- polyfit(log2(scale), log2(f), 1)
alpha <- C[1] # DFA scaling exponent is estimated by the slope of regression line
## outputs
alpha
