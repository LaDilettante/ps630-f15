rm(list=ls())

data.1 = c(2,1,9,4,3,3,7,7,5,7)
data.2 = c(2,1,0,4,1,1,0,1,1,4)

p = seq(1,10,length=100)
d1 = dgamma(p, shape=50, scale=0.1)
plot(p, d1, type='l', col='blue', 
     ylim=c(0,0.9), ylab='density', xlab='theta')
title(main='Prior distributions')
legend(x='topright', legend=c('Full Gamma','Truncated Gamma'), 
       lty=c(1,2), col=c('blue','red'), bty='n')

F = function(x) {pgamma(x, shape=50, scale=0.1)}

d2 = dgamma(p, shape=50, scale=0.1)*as.numeric(p>4 & p<6) / (F(6) - F(4)) # Truncate the prior
lines(p, d2, lty=2, col='red')

#####################################
### Update the prior with data.1 ###
#####################################

shape.post = 50+sum(data.1) # Calculate the shape and scale of the posterior Gamma
scale.post = 1/(10+length(data.1))
d1.post = dgamma(p, shape=shape.post, scale=scale.post)

# Plot the posterior density
plot(p, d1.post, type='l', col='blue',
     ylim=c(0,0.9), xlab='theta', ylab='density')
title(main='Posterior distributions')
legend(x='topright', legend=c('Full Gamma (3.98, 5.92)','Truncated Gamma (4.12, 5.79)'), 
       lty=c(1,2), col=c('blue','red'), bty='n', cex=0.7)

Fpost = function(x) {pgamma(x, shape=shape.post, scale=scale.post)}

# Find the truncated posterior
d2.post = dgamma(p, shape=shape.post, scale=scale.post)*as.numeric(p>=4 & p<=6) / 
  (Fpost(6) - Fpost(4)) 
# Plot the truncated density
lines(p, d2.post, lty=2, col='red') 

# Find the quantile function for truncated posterior
qgamma.trun.post = function(p) {
  qgamma((p*(Fpost(6)-Fpost(4))+Fpost(4)), shape=shape.post, scale=scale.post)
}
# Plot the 95 interval for both posteriors
abline(v=qgamma(0.025, shape=shape.post, scale=scale.post), col='blue')
abline(v=qgamma(0.975, shape=shape.post, scale=scale.post), col='blue')
abline(v=qgamma.trun.post(0.025), col='red')
abline(v=qgamma.trun.post(0.975), col='red')

####################################
#####Update with data.2 ############
####################################

shape.post2 = 50+sum(data.2)
scale.post2 = 1/(10+length(data.2))
d1.post2 = dgamma(p, shape=shape.post2, scale=scale.post2)
plot(p, d1.post2, type='l', col='blue',
     ylim=c(0,0.9), xlab='theta', ylab='density')
title(main='Posterior distributions - different data')
legend(x='topright', legend=c('Full Gamma','Truncated Gamma'), 
       lty=c(1,2), col=c('blue','red'), bty='n')

Fpost2.6 = pgamma(6, shape=shape.post2, scale=scale.post2)
Fpost2.4 = pgamma(4, shape=shape.post2, scale=scale.post2)
d2.post2 = dgamma(p, shape=shape.post2, scale=scale.post2)*as.numeric(p>=4 & p<=6) / 
  (Fpost2.6 - Fpost2.4) # Truncate the posterior
lines(p, d2.post2, lty=2, col='red')

# Find the quantile function for truncated posterior
qgamma.trun.post2 = function(p) {
  qgamma((p*(Fpost2.6-Fpost2.4)+Fpost2.4), shape=shape.post2, scale=scale.post2)
}

# Plot the 95 interval for both posteriors
abline(v=qgamma(0.025, shape=shape.post2, scale=scale.post2), col='blue')
abline(v=qgamma(0.975, shape=shape.post2, scale=scale.post2), col='blue')
abline(v=qgamma.trun.post2(0.025), col='red')
abline(v=qgamma.trun.post2(0.975), col='red')