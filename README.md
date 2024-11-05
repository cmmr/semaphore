# semaphore

<!-- badges: start -->
[![dev](https://github.com/cmmr/semaphore/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/cmmr/semaphore/actions/workflows/R-CMD-check.yaml)
[![cran](https://www.r-pkg.org/badges/version/semaphore)](https://CRAN.R-project.org/package=semaphore)
[![conda](https://anaconda.org/conda-forge/r-semaphore/badges/version.svg)](https://anaconda.org/conda-forge/r-semaphore)
<!-- badges: end -->


The goal of semaphore is to enable synchronization of concurrent R processes.
  
Implements named semaphores from the Boost C++ library. 
A semaphore object is shared amongst several processes.
This integer value can be safely incremented or decremented by
multiple processes. Processes can also wait (blocking) for the 
value to become non-zero.


## Installation

``` r
# Install the latest stable version from CRAN:
install.packages("semaphore")

# Or the development version from GitHub:
install.packages("pak")
pak::pak("cmmr/semaphore")
```



## Example

``` r
library(semaphore)

s <- create_semaphore()
print(s)
#> [1] "uUkKpNMbTVgaborHG4rH"

increment_semaphore(s)

decrement_semaphore(s, wait = FALSE)
#> [1] TRUE
decrement_semaphore(s, wait = FALSE)
#> [1] FALSE

remove_semaphore(s)
#> [1] TRUE
```
