# nocov start
ENV <- new.env(parent = emptyenv())

.onLoad <- function (libname, pkgname) {
  
  ENV$semaphores = c()
  
  # Remove semaphores created with cleanup=TRUE
  finalizer <- function (e) {
    for (semaphore in e$semaphores)
      try(silent = TRUE, remove_semaphore(semaphore))
  }
  reg.finalizer(ENV, finalizer, onexit = TRUE)
  
}
# nocov end
