#include <Rcpp.h>
#include <random>
#include <boost/interprocess/sync/named_semaphore.hpp>

using namespace boost::interprocess;


// [[Rcpp::export]]
Rcpp::String rcpp_create_semaphore(unsigned int value = 0) {
  
  using namespace std;
  
  static random_device dev;
  static mt19937 rng(dev());
  
  const char *v = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  uniform_int_distribution<int> dist(0, 61);
  
  string semaphore = "u";
  for (int i = 0; i < 19; i++) {
    semaphore += v[dist(rng)];
  }
  
  named_semaphore sem(create_only_t(), semaphore.c_str(), value);
  return semaphore;
}


// [[Rcpp::export]]
void rcpp_increment_semaphore(const char* semaphore) {
  named_semaphore sem(open_only_t(), semaphore);
  sem.post();
}


// [[Rcpp::export]]
bool rcpp_decrement_semaphore(const char* semaphore, bool wait = true) {
  
  named_semaphore sem(open_only_t(), semaphore);
  
  if (wait) {
    sem.wait();
    return true;
    
  } else {
    return sem.try_wait();
  }
  
}


// [[Rcpp::export]]
bool rcpp_remove_semaphore(const char* semaphore) {
  return named_semaphore::remove(semaphore);
}
