// [[Rcpp::depends(BH)]]

#include <Rcpp.h>
#include <boost/interprocess/sync/named_semaphore.hpp>
#include <boost/date_time/posix_time/posix_time.hpp>

using namespace boost::interprocess;
namespace pt = boost::posix_time;


// [[Rcpp::export]]
void rcpp_create_semaphore(const char* id, unsigned int value = 0) {
  named_semaphore sem(create_only_t(), id, value);
}


// [[Rcpp::export]]
void rcpp_sem_post(const char* id) {
  named_semaphore sem(open_only_t(), id);
  sem.post();
}


// [[Rcpp::export]]
bool rcpp_wait(const char* id) {
  named_semaphore sem(open_only_t(), id);
  sem.wait(); //void
  return true;
}


// [[Rcpp::export]]
bool rcpp_try_wait(const char* id) {
  named_semaphore sem(open_only_t(), id);
  return sem.try_wait();
}


// [[Rcpp::export]]
bool rcpp_wait_seconds(const char* id, long seconds = 0) {
  named_semaphore sem(open_only_t(), id);
  pt::ptime timeout = pt::second_clock::universal_time() + pt::seconds(seconds);
  return sem.timed_wait(timeout);
}


// [[Rcpp::export]]
bool rcpp_wait_microseconds(const char* id, long microseconds = 0) {
  named_semaphore sem(open_only_t(), id);
  pt::ptime timeout = pt::microsec_clock::universal_time() + pt::microseconds(microseconds);
  return sem.timed_wait(timeout);
}


// [[Rcpp::export]]
bool rcpp_remove_semaphore(const char* id) {
  return named_semaphore::remove(id);
}
