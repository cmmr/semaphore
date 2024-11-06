
#' Shared Memory Atomic Operations
#' 
#' A semaphore is an integer that the operating system keeps track of.
#' Any process that knows the semaphore's identifier can increment or 
#' decrement its value, though it cannot be decremented below zero.\cr\cr
#' When the semaphore is zero, calling `decrement_semaphore(wait = FALSE)` 
#' will return `FALSE` whereas `decrement_semaphore(wait = TRUE)` will 
#' block until the semaphore is incremented by another process. 
#' If multiple processes are blocked, a single call to `increment_semaphore()` 
#' will only unblock one of the blocked processes.
#' 
#' @rdname semaphores
#' 
#' @param id        A semaphore identifier (string). `create_semaphore()` 
#'                  defaults to generating a random identifier.
#' @param value     The initial value of the semaphore.
#' @param cleanup   Remove the semaphore when R session exits.
#' @param wait      If `TRUE`, blocks until semaphore is greater than zero.
#' 
#' @return
#' * `create_semaphore()` - The created semaphore's identifier (string), invisibly when `semaphore` is non-`NULL`.
#' * `increment_semaphore()` - `TRUE`, invisibly.
#' * `decrement_semaphore(wait = TRUE)` - `TRUE`, invisibly.
#' * `decrement_semaphore(wait = FALSE)` - `TRUE` if the decrement was successful; `FALSE` otherwise.
#' * `remove_semaphore()` - `TRUE` on success; `FALSE` on error.
#' 
#' @export
#' @examples
#' 
#'     library(semaphore) 
#'     
#'     s <- create_semaphore()
#'     print(s)
#'     
#'     increment_semaphore(s)
#'     decrement_semaphore(s, wait = FALSE)
#'     decrement_semaphore(s, wait = FALSE)
#'     
#'     remove_semaphore(s)

create_semaphore <- function (id = NULL, value = 0, cleanup = TRUE) {
  
  invis <- !is.null(id)
  if (is.null(id))
    id <- paste0(collapse = '', c(
      sample(c(letters, LETTERS), 1),
      sample(c(letters, LETTERS, 0:9), 19, TRUE) ))
  
  stopifnot(isTRUE(value >= 0 && value < Inf))
  stopifnot(isTRUE(value %% 1 == 0))
  stopifnot(isTRUE(nchar(id) > 0))
  stopifnot(isTRUE(cleanup) || isFALSE(cleanup))
  
  rcpp_create_semaphore(id, value)
  
  if (isTRUE(cleanup))
    ENV$semaphores <- c(ENV$semaphores, id)
  
  if (invis) { return (invisible(id)) }
  else       { return (id)            }
}


#' @rdname semaphores
#' @export
increment_semaphore <- function (id) {
  stopifnot(isTRUE(nchar(id) > 0))
  rcpp_increment_semaphore(id)
  return (invisible(TRUE))
}


#' @rdname semaphores
#' @export
decrement_semaphore <- function (id, wait = TRUE) {
  
  stopifnot(isTRUE(nchar(id) > 0))
  stopifnot(isTRUE(wait) || isFALSE(wait))
  
  res <- rcpp_decrement_semaphore(id, wait)
  
  if (wait) { return (invisible(res)) }
  else      { return (res)            }
}


#' @rdname semaphores
#' @export
remove_semaphore <- function (id) {
  
  res <- logical(0)
  for (i in seq_along(id)) {
    stopifnot(isTRUE(nchar(id[[i]]) > 0))
    ENV$semaphores <- setdiff(ENV$semaphores, id[[i]])
    res <- c(res, rcpp_remove_semaphore(id[[i]]))
  }
  
  return (res)
}
