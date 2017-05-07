systematic_sample <- function(n, N, initial=F)
{
  k <- floor(N/n)
  if(initial==F)
     initial <- sample(1:k,1)
  cat("Interval=", k, " Starting value=", initial, "\n")
  # Put the origin in the value ’initial’
  shift <- (1:N) - initial
  # I search numbers who are multiple of number k
  # Equivalent to find the rest of { a%%b = 0 } 
  return( (1:N)[(shift %% k) == 0] )
}
