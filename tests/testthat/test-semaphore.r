

test_that("create/remove", {
  
  s <- expect_silent(create_semaphore())
  expect_true(remove_semaphore(s))
  
  # `id` parameter
  expect_error(create_semaphore(id = 22))
  expect_error(remove_semaphore(id = 22))
  expect_silent(create_semaphore(id = 'u234c4330518a'))
  expect_error(create_semaphore(id = 'u234c4330518a'))
  expect_true(remove_semaphore(id = 'u234c4330518a'))
  expect_false(remove_semaphore(id = 'u234c4330518a'))
  
  # `value` parameter
  expect_error(create_semaphore(value = -1))
  expect_error(create_semaphore(value = 2.5))
  s1 <- expect_silent(create_semaphore(value = 2))
  
  # `cleanup` parameter
  expect_error(create_semaphore(cleanup = "yes"))
  s2 <- expect_silent(create_semaphore(cleanup = FALSE))
  
  res <- expect_silent(as.vector(remove_semaphore(c(s1, s2))))
  expect_identical(res, c(TRUE, TRUE))
})


test_that("inc/decrement", {
  
  s <- expect_silent(create_semaphore(value = 3))
  
  expect_true(increment_semaphore(s))
  
  expect_true(  decrement_semaphore(s, wait = Inf) )
  expect_true(  decrement_semaphore(s, wait = 1)   )
  expect_true(  decrement_semaphore(s, wait = 1.1) )
  expect_true(  decrement_semaphore(s, wait = 0)   )
  expect_false( decrement_semaphore(s, wait = 0)   )
  expect_error( decrement_semaphore(s, wait = NA)  )
  
  expect_true(remove_semaphore(s))
})
