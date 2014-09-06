rm(list=ls())

ci.freq.res1 = c()
ci.freq.res2 = c()
ci.unif.res1 = c()
ci.unif.res2 = c()
ci.beta.res1 = c()
ci.beta.res2 = c()

n = 30
for (i in 1:10000) {
  x = rbinom(1, n, 0.8)
  p.hat = x/n
  ci.freq.error = qnorm(1-0.05/2)*sqrt(p.hat*(1-p.hat)/n)
  ci.freq.lower = p.hat - ci.freq.error
  ci.freq.upper = p.hat + ci.freq.error
  ci.freq.length = 2*ci.freq.error
  ci.freq.true = (0.8 > ci.freq.lower) & (0.8 < ci.freq.upper)
  ci.freq.res1 = c(ci.freq.res1, ci.freq.length)
  ci.freq.res2 = c(ci.freq.res2, ci.freq.true)

  ci.unif.lower = qbeta(0.025, x+1, n-x+1)
  ci.unif.upper = qbeta(1-0.025, x+1, n-x+1)
  ci.unif.length = ci.unif.upper - ci.unif.lower
  ci.unif.true = (0.8 > ci.unif.lower) & (0.8 < ci.unif.upper)
  ci.unif.res1 = c(ci.unif.res1, ci.unif.length)
  ci.unif.res2 = c(ci.unif.res2, ci.unif.true)
  
  ci.beta.lower = qbeta(0.025, x+8, n-x+2)
  ci.beta.upper = qbeta(1-0.025, x+8, n-x+2)
  ci.beta.length = ci.unif.upper - ci.unif.lower
  ci.beta.true = (0.8 > ci.unif.lower) & (0.8 < ci.unif.upper)
  ci.beta.res1 = c(ci.unif.res1, ci.unif.length)
  ci.beta.res2 = c(ci.unif.res2, ci.unif.true)
}

mean(ci.freq.res1)
mean(ci.freq.res2)

mean(ci.unif.res1)
mean(ci.unif.res2)

mean(ci.beta.res1)
mean(ci.beta.res2)