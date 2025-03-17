# semaphore

<!-- badges: start -->
[![cran](https://www.r-pkg.org/badges/version/semaphore)](https://CRAN.R-project.org/package=semaphore)
[![dev](https://github.com/cmmr/semaphore/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/cmmr/semaphore/actions/workflows/R-CMD-check.yaml)
[![conda](https://anaconda.org/conda-forge/r-semaphore/badges/version.svg)](https://anaconda.org/conda-forge/r-semaphore)
[![covr](https://codecov.io/gh/cmmr/semaphore/graph/badge.svg)](https://app.codecov.io/gh/cmmr/semaphore)
<!-- badges: end -->


The goal of semaphore is to enable synchronization of concurrent R processes.

Implements [named semaphores](https://www.boost.org/doc/libs/1_86_0/doc/html/doxygen/boost_interprocess_header_reference/classboost_1_1interprocess_1_1named__semaphore.html)
from the [Boost C++ library](https://www.boost.org/). 
Semaphores are managed by the operating system, which is responsible for 
ensuring that this integer value can be safely incremented or decremented by 
multiple processes. 
Processes can also wait (blocking) for the value to become positive.

Works cross-platform, including Windows, MacOS, and Linux.


## Installation

``` r
# Install the latest stable version from CRAN:
install.packages("semaphore")

# Or the development version from GitHub:
install.packages("pak")
pak::pak("cmmr/semaphore")
```



## Usage

``` r
library(semaphore)

s <- create_semaphore()
print(s)
#> [1] "uUkKpNMbTVgaborHG4rH"

increment_semaphore(s)

decrement_semaphore(s, wait = 10)      # wait up to ten seconds
#> [1] TRUE
decrement_semaphore(s, wait = FALSE)   # return immediately
#> [1] FALSE

remove_semaphore(s)
#> [1] TRUE
```



## Example: Producer/Consumer

Open two separate R sessions on the same machine.

**Session 1 - Producer**
``` r
library(semaphore)
s <- 'mySemaphore'

create_semaphore(s)

# enable session 2 to output 'unblocked!' three times
increment_semaphore(s)
increment_semaphore(s)
increment_semaphore(s)

remove_semaphore(s)
```

**Session 2 - Consumer**
``` r
library(semaphore)
s <- 'mySemaphore'

for (i in 1:3) {

  # Block until session 1 increments the semaphore
  decrement_semaphore(s, wait = TRUE)
  
  # Do some work
  message('unblocked!')
}

message('finished')
```

