#include <Rcpp.h>


//' rcpp_test
//' @noRd 
// [[Rcpp::export]]
Rcpp::NumericVector rcpp_test ()
{
    Rcpp::NumericVector res (10);
    return res;
}
