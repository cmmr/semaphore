// [[Rcpp::depends(BH)]]

#include <Rcpp.h>
#include <boost/interprocess/sync/named_semaphore.hpp>

using namespace boost::interprocess;


// [[Rcpp::export]]
void rcpp_create_semaphore(const char* id, unsigned int value = 0) {
  named_semaphore sem(create_only_t(), id, value);
}


// [[Rcpp::export]]
void rcpp_increment_semaphore(const char* id) {
  named_semaphore sem(open_only_t(), id);
  sem.post();
}


// [[Rcpp::export]]
bool rcpp_decrement_semaphore(const char* id, bool wait = true) {
  
  named_semaphore sem(open_only_t(), id);
  
  if (wait) {
    sem.wait();
    return true;
    
  } else {
    return sem.try_wait();
  }
  
}


// [[Rcpp::export]]
bool rcpp_remove_semaphore(const char* id) {
  return named_semaphore::remove(id);
}
