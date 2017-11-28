#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME: 
   Check these declarations against the C/Fortran source code.
*/

/* .Call calls */
extern SEXP _sftest_rcpp_test();

static const R_CallMethodDef CallEntries[] = {
    {"_sftest_rcpp_test", (DL_FUNC) &_sftest_rcpp_test, 0},
    {NULL, NULL, 0}
};

void R_init_sftest(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
