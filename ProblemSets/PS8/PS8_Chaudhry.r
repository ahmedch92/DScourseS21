library(tidyverse)
library(nloptr)
library(dplyr)
library(modelsummary)
library(broom.mixed)

#Q.4

seed.set(1234567)

X <- matrix(rnorm(1000000), nrow = 100000, ncol = 10)
X [, 1]<- 1

eps <- matrix(rnorm(100000, mean = 0, sd = 0.5), nrow = 100000)

beta <- matrix(c(1.5, -1, -0.25, 0.75, 3.5, -2, 0.5, 1, 1.25, 2))

Y <- X%*%beta + eps

#Q.5

beta_hat <- solve(crossprod(X))%*%(crossprod(X,Y))

comparison <- as_tibble_col(beta_hat,"beta_hat")
comparison <- comparison %>% add_column(beta)
comparison

#Q.6

obj_func <- function(beta,Y,X) {
  return (sum((Y-X%*%beta)^2))
}


gradient <- function(beta_graid,Y,X) {
  return (as.vector(-2*t(X)%*%(Y-X%*%beta_graid)))
}

# initial values
beta0 <- matrix(rnorm(10, mean = 0, sd=0.5), 10, 1)


gradient_descent <- function(Y, X, beta_g, object, grad, learn_rate, tol, max_iter) {
  
  n=dim(Y)[1]
  m <- beta_g
  c <- matrix(rnorm(n,mean = 0,sd=0.5),n,1)
  
  yhat <- X%*%m+c
  MSE <- object(m,Y,X)
  
  converged = F
  iterations = 0
  
  while(converged == F) {
    m_new <- m - learn_rate * grad(m,Y,X)
    m <- m_new
    c <- Y-X%*%m
    yhat <- X%*%m+c
    MSE_new <- object(m,Y,X)
    if(MSE - MSE_new <= tol) {
      converged = T
      
      return(m)
    }
    iterations = iterations + 1
    if(iterations > max_iter) { 
      converged = T
      return(m)
    }
  }
}


# Run the function 

learn_rate <- 0.0000003
tol <- 0.0000000001
max_iter <- 1000

beta_hat_gradident <- gradient_descent(Y, X, beta0,obj_func, gradient, learn_rate , tol , max_iter)


#Q.7 

options <- list("algorithm"="NLOPT_LD_LBFGS","xtol_rel"= 1.0e-6,"maxeval"= 1e3)
beta_BFGS <- nloptr( x0=beta0,eval_f=obj_func,eval_grad_f=gradient,opts=options,Y=Y,X=X)
beta_BFGS$solution

options <- list("algorithm"="NLOPT_LN_NELDERMEAD","xtol_rel"=1.0e-8)
beta_NM <- nloptr( x0=beta0,eval_f=obj_func,opts=options,Y=Y,X=X)

beta_hat_BFGS <- beta_NM$solution


#Q.8

gradient_MLE <- function (theta ,Y, X) {
  grad <- as.vector( rep (0, length (theta )))
  beta <- theta [1:( length ( theta) -1)]
  sig <- theta [ length (theta )]
  grad [1:( length ( theta) -1)] <- -t(X)%*%(Y - X%*%beta )/(sig ^2)
  grad[ length (theta )] <- dim (X)[1] /sig - crossprod (Y-X%*%beta )/(sig^3)
  return ( grad )
}
objfun_MLE <- function(beta, Y , X) {
  return (sum((Y-X%*%beta[1:( length (beta) -1)])^2))
}
#theta0 <- runif(dim(X)[2]+1)
theta0 <- append(as.vector(summary(lm(Y~X-1))$coefficients[,1]),runif(1))
options <- list("algorithm"="NLOPT_LD_LBFGS","xtol_rel"=1.0e-6,"maxeval"=1e3)
beta_MLE <- nloptr(x0=theta0, eval_f=objfun_MLE, eval_grad_f=gradient_MLE, opts=options, Y=Y, X=X)

beta_hat_MLE <- round(beta_MLE$solution,3)



#Q.9 

beta_hat_ols <- lm(Y~X-1)

modelsummary(beta_hat_ols, output = 'latex')
