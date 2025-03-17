// [[Rcpp::depends(BH)]]

#include <Rcpp.h>
#include <boost/interprocess/sync/named_semaphore.hpp>
#include <boost/date_time/posix_time/posix_time.hpp>

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
bool rcpp_decrement_semaphore(const char* id, bool wait = true, long seconds = 0) {
  
  named_semaphore sem(open_only_t(), id);
  
  if (wait) {
    
    if (seconds == 0) {
      
      sem.wait();
      return true;
      
    } else {
      boost::posix_time::ptime timeout = boost::posix_time::second_clock::universal_time() + boost::posix_time::seconds(seconds);
      return sem.timed_wait(timeout);
    }
    
  } else {
    return sem.try_wait();
  }
  
}


// [[Rcpp::export]]
bool rcpp_remove_semaphore(const char* id) {
  return named_semaphore::remove(id);
}
