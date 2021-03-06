#include <Rcpp.h>
#include "barry.hpp"
#include "defm.hpp"

using namespace Rcpp;

//' Model specification for DEFM
//'
//' @param m An object of class [DEFM].
//' @param idx Integer. When greater than -1, index (starting from 0) of a covariate
//' used to weight the term.
//' @export
//'
//' @returns Invisible 0.
//'
//' @name defm_terms
//' @aliases terms_defm
// [[Rcpp::export(invisible = true, rng = false)]]
int term_defm_ones(SEXP m, int idx = -1, std::string vname = "")
{

  Rcpp::XPtr< DEFM > ptr(m);
  defmcounters::counter_ones(ptr->get_model().get_counters(), idx, vname);

  return 0;
}


//' @rdname defm_terms
//' @export
//' @param k Numeric scalar. Exponent used in the term.
// [[Rcpp::export(invisible = true, rng = false)]]
int term_defm_fe(SEXP m, int idx = -1, double k = 1.0, std::string vname = "")
{

  Rcpp::XPtr< DEFM > ptr(m);
  defmcounters::counter_fixed_effect(ptr->get_model().get_counters(), idx, k, vname);

  return 0;
}

//' @param mat Integer matrix. The matrix specifies the type of motif to capture
//' (see details.)
//' @details
//' In `term_defm_transition`, users can specify a particular motif to model. Motifs
//' are represented by cells with values equal to 1, for example, the matrix:
//'
//' ```  y0 y1 y2
//' t0:   1 NA NA
//' t1:   1  1 NA
//' ```
//'
//' represents a transition `y0 -> (y1, y2)`. If 0 is a motif of interest, then
//' the matrix should include 0 to mark zero values.
//' @export
//' @rdname defm_terms
// [[Rcpp::export(invisible = true, rng = false)]]
int term_defm_transition(
    SEXP m,
    IntegerMatrix & mat,
    int covar_idx = -1,
    std::string vname = ""
)
{

  Rcpp::XPtr< DEFM > ptr(m);

  if (static_cast<size_t>(mat.nrow()) != (ptr->get_m_order() + 1u))
    stop("The number of rows in -mat- must be equal to the Markov order of the model + 1.");

  if (static_cast<size_t>(mat.ncol()) != ptr->get_n_y())
    stop("The number of columns in -mat- must be equal to the number of y-columns in the model.");

  // Converting coordinates
  std::vector< size_t > coords(0u);
  std::vector< bool > signs(0u);
  int loc = -1;
  for (int j = 0; j < static_cast<int>(mat.ncol()); ++j)
  {

    for (int i = 0; i < static_cast<int>(mat.nrow()); ++i)
    {

      loc++;

      // Only 1 or -1 make something
      if (mat(i,j) == R_NaInt)
        continue;

      if ((mat(i,j) != 1) & (mat(i,j) != 0))
        stop("Valid values for -mat- are NA, 0, or 1");

      coords.push_back(static_cast< size_t >(loc));
      signs.push_back(
        mat(i,j) == 1 ? true : false
      );

    }

  }

    defmcounters::counter_transition(
      ptr->get_model().get_counters(), coords, signs,
      ptr->get_m_order(), ptr->get_n_y(),
      covar_idx, vname
    );

  return 0;

}


//' @details The function `term_defm_transition_formula`,
//' will take the formula and generate the corresponding
//' input for defm::counter_transition(). Formulas can be specified in the
//' following ways:
//'
//' - Intercept effect: {...} No transition, only including the current state.
//' - Transition effect: {...} > {...} Includes current and previous states.
//'
//' The general notation is `[0]y[column id]_[row id]`. A preceeding zero
//' means that the value of the cell is considered to be zero. The column
//' id goes between 0 and the number of columns in the array - 1 (so it
//' is indexed from 0,) and the row id goes from 0 to m_order.
//'
//' ## Intercept effects
//'
//' Intercept effects only involve a single set of curly brackets. Using the
//' 'greater-than' symbol (i.e., '<') is only for transition effects. When
//' specifying intercept effects, users can skip the `row_id`, e.g.,
//' `y0_0` is equivalent to `y0`. If the passed `row id` is different from
//' the Markov order, i.e., `row_id != m_order`, then the function returns
//' with an error.
//'
//' Examples:
//'
//' - `"{y0, 0y1}"` is equivalent to set a motif with the first element equal
//' to one and the second to zero.
//'
//' ## Transition effects
//'
//' Transition effects can be specified using two sets of curly brackets and
//' an greater-than symbol, i.e., `{...} > {...}`. The first set of brackets,
//' which we call LHS, can only hold `row id` that are less than `m_order`.
//' @export
//' @rdname defm_terms
// [[Rcpp::export(invisible = true, rng = false)]]
int term_defm_transition_formula(
    SEXP m,
    std::string formula,
    int covar_idx = -1,
    std::string vname = ""
)
{

  Rcpp::XPtr< DEFM > ptr(m);

  defmcounters::counter_transition_formula(
    ptr->get_model().get_counters(), formula,
    ptr->get_m_order(), ptr->get_n_y(),
    covar_idx, vname
  );

  return 0;

}

//' @export
//' @rdname defm_terms
//' @details The term `term_defm_logit_intercept` will add what is equivalent to an
//' intercept in a logistic regression. When `coords` is specified, then the
//' function will add one intercept per outcome. These can be weighted by
//' a covariate.
// [[Rcpp::export(invisible = true, rng = false)]]
int term_defm_logit_intercept(
  SEXP m,
  IntegerVector coords = IntegerVector::create(),
  int covar_idx = -1,
  std::string vname = ""
) {

  Rcpp::XPtr< DEFM > ptr(m);

  std::vector< size_t > coords_;
  for (auto c : coords)
  {
    if (c < 0)
      stop("Element in coords is negative. Only zero or positive are allowed");
    coords_.push_back(c);
  }

  defmcounters::counter_logit_intercept(
    ptr->get_model().get_counters(),
    ptr->get_n_y(),
    coords_,
    covar_idx,
    vname
  );

  return 0;

}
