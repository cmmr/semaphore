ENV <- list2env(list(semaphores = c()), parent = emptyenv())

.onLoad <- function(libname, pkgname) {
  
  # Remove semaphores created with cleanup=TRUE
  finalizer <- function (e) {
    for (semaphore in e$semaphores)
      try(silent = TRUE, remove_semaphore(semaphore))
  }
  reg.finalizer(ENV, finalizer, onexit = TRUE)
  
}
