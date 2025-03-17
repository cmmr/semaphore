
#' Shared Memory Atomic Operations
#' 
#' A semaphore is an integer that the operating system keeps track of.
#' Any process that knows the semaphore's identifier can increment or 
#' decrement its value, though it cannot be decremented below zero.\cr\cr
#' When the semaphore is zero, calling `decrement_semaphore(wait = FALSE)` 
#' will return `FALSE` whereas `decrement_semaphore(wait = TRUE)` will 
#' block until the semaphore is incremented by another process. 
#' If multiple processes are blocked, a single call to `increment_semaphore()` 
#' will only unblock one of the blocked processes.\cr\cr
#' It is possible to wait for a specific amount of time, for example, 
#' `decrement_semaphore(wait = 10)` will wait for 10 seconds. If the semaphore 
#' is incremented within those 10 seconds, the function will immediately return 
#' `TRUE`. Otherwise it will return `FALSE` at the 10 second mark.
#' 
#' @rdname semaphores
#' 
#' @param id        A semaphore identifier (string). `create_semaphore()` 
#'                  defaults to generating a random identifier. A custom
#'                  id should be at most 251 characters and must not contain 
#'                  slashes (`/`).
#' @param value     The initial value of the semaphore.
#' @param cleanup   Remove the semaphore when R session exits.
#' @param wait      Whether/how long to wait for the semaphore: 
#' * `FALSE`: return immediately.
#' * `TRUE`: block until semaphore available.
#' * **integer**: this many seconds at most.
#' 
#' @return
#' * `create_semaphore()` - The created semaphore's identifier (string), invisibly when `semaphore` is non-`NULL`.
#' * `increment_semaphore()` - `TRUE`, invisibly.
#' * `decrement_semaphore()` - `TRUE` if the decrement was successful; `FALSE` otherwise, invisibly when `wait=TRUE`.
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
  if (is.null(id)) {
    id <- paste(collapse = '', c(
      sample(c(letters, LETTERS), 1),
      sample(c(letters, LETTERS, 0:9), 19, TRUE) ))
  }
  
  validate_id(id)
  stopifnot(is_unsigned_int(value))
  stopifnot(is_logical(cleanup))
  
  rcpp_create_semaphore(id, value)
  
  if (isTRUE(cleanup))
    ENV$semaphores <- c(ENV$semaphores, id)
  
  if (invis) { return (invisible(id)) }
  else       { return (id)            }
}


#' @rdname semaphores
#' @export
increment_semaphore <- function (id) {
  rcpp_increment_semaphore(validate_id(id))
  return (invisible(TRUE))
}


#' @rdname semaphores
#' @export
decrement_semaphore <- function (id, wait = TRUE) {
  
  validate_id(id)
  stopifnot(is_logical(wait) || is_unsigned_int(wait))
  
  if (is.numeric(wait)) {
    return (rcpp_decrement_semaphore(id, TRUE, as.integer(wait)))
    
  } else if (isTRUE(wait)) {
    return (invisible(rcpp_decrement_semaphore(id, TRUE, 0L)))
    
  } else {
    return (rcpp_decrement_semaphore(id, FALSE, 0L))
  }
}


#' @rdname semaphores
#' @export
remove_semaphore <- function (id) {
  sapply(id, validate_id)
  ENV$semaphores <- setdiff(ENV$semaphores, id)
  invisible(sapply(id, rcpp_remove_semaphore))
}



validate_id <- function (id) {
  stopifnot(is.character(id))
  stopifnot(length(id) == 1)
  stopifnot(!is.na(id))
  stopifnot(nchar(id) > 0)
  stopifnot(nchar(id) <= 251)
  stopifnot(!any(strsplit(id, '')[[1]] == '/'))
  return (invisible(id))
}

is_unsigned_int <- function (value) {
  all(
    isTRUE(value >= 0 && value < Inf),
    isTRUE(value %% 1 == 0) )
}

is_logical <- function (x) {
  identical(x, TRUE) || identical(x, FALSE)
}
