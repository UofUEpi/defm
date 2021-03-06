# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#' Discrete Exponential Family Model (DEFM)
#'
#' Discrete Exponential Family Models (DEFMs) are models from the exponential
#' family that deal with discrete data. Here, we deal with binary arrays which
#' can be used to represent, among other things, networks and multinomial binary
#' Markov processes.
#'
#' @param id Integer vector of length `n`. Observation ids, for example, person id.
#' @param Y 0/1 matrix of responses of `n_y` columns and `n` rows.
#' @param X Numeric matrix of covariates of size `n_x` by `n`.
#' @param order Integer. Order of the markov process, by default, 1.
#'
#' @return An external pointer of class `DEFM.`
#'
#' @export
#' @name DEFM
#' @aliases new_defm defm
new_defm <- function(id, Y, X, order = 1L) {
    .Call(`_defm_new_defm`, id, Y, X, order)
}

#' @rdname DEFM
#' @param m An object of class `DEFM`.
#' @export
init_defm <- function(m) {
    invisible(.Call(`_defm_init_defm`, m))
}

#' @export
#' @rdname defm_terms
print.DEFM <- function(x) {
    invisible(.Call(`_defm_print_defm`, x))
}

#' Log-Likelihood of DEFM
#'
#' @param m An object of class [DEFM]
#' @param par A vector of parameters of length `nterms_defm(m)`.
#' @param as_log Logical scalar. When `TRUE` (default) returns the log-likelihood,
#' otherwise it returns the likelihood.
#' @return
#' Numeric, the computed likelihood or log-likelihood of the model.
#' @export
#'
loglike_defm <- function(m, par, as_log = TRUE) {
    .Call(`_defm_loglike_defm`, m, par, as_log)
}

#' Simulate data using a DEFM
#'
#' @param m An object of class [DEFM]. The baseline model.
#' @param par Numeric vector of model parameters.
#' @param fill_t0 Logical scalar. When `TRUE` (default) will fill-in the baseline
#' value of each observation (i.e., the starting condition) (see details.)
#'
#' @details
#' Each observation in the simulation must have initial condition. In practice,
#' this means we start the markov process with a matrix of size
#' `morder_defm(m) x ncol_defm_y(m)`, i.e., order of the Markov process times
#' the number of output variables. when `fill_t0 = TRUE`, the function return
#' the rows corresponding to baseline states with the original value, otherwise
#' it replaces them with -1. This option is mostly for testing purposes.
#'
#' @returns An integer vector of size `nrows_defm(m) x ncol_defm_y(m)`.
#' @export
sim_defm <- function(m, par, fill_t0 = TRUE) {
    .Call(`_defm_sim_defm`, m, par, fill_t0)
}

#' @export
#' @rdname DEFM
print_stats <- function(m, i = 0L) {
    invisible(.Call(`_defm_print_stats`, m, i))
}

#' @export
#' @rdname DEFM
nterms_defm <- function(m) {
    .Call(`_defm_nterms_defm`, m)
}

#' @export
#' @rdname DEFM
names.DEFM <- function(m) {
    .Call(`_defm_names_defm`, m)
}

#' @export
#' @rdname DEFM
nrow_defm <- function(m) {
    .Call(`_defm_nrow_defm`, m)
}

#' @export
#' @rdname DEFM
ncol_defm_y <- function(m) {
    .Call(`_defm_ncol_defm_y`, m)
}

#' @export
#' @rdname DEFM
ncol_defm_x <- function(m) {
    .Call(`_defm_ncol_defm_x`, m)
}

#' @export
#' @rdname DEFM
nobs_defm <- function(m) {
    .Call(`_defm_nobs_defm`, m)
}

#' @export
#' @rdname DEFM
morder_defm <- function(m) {
    .Call(`_defm_morder_defm`, m)
}

#' Get sufficient statistics counts
#' @param m An object of class [DEFM].
#' @export
get_stats <- function(m) {
    .Call(`_defm_get_stats`, m)
}

#' Motif census
#' @param m An object of class [DEFM].
#' @param locs Idx (starting from zero) with the variables that will be
#' included in the census.
#' @export
motif_census <- function(m, locs) {
    .Call(`_defm_motif_census`, m, locs)
}

#' Log odds (aka conditional prob, aka gibbs sampler)
#' @export
logodds <- function(m, par, i, j) {
    .Call(`_defm_logodds`, m, par, i, j)
}

#' Model specification for DEFM
#'
#' @param m An object of class [DEFM].
#' @param idx Integer. When greater than -1, index (starting from 0) of a covariate
#' used to weight the term.
#' @export
#'
#' @returns Invisible 0.
#'
#' @name defm_terms
#' @aliases terms_defm
term_defm_ones <- function(m, idx = -1L, vname = "") {
    invisible(.Call(`_defm_term_defm_ones`, m, idx, vname))
}

#' @rdname defm_terms
#' @export
#' @param k Numeric scalar. Exponent used in the term.
term_defm_fe <- function(m, idx = -1L, k = 1.0, vname = "") {
    invisible(.Call(`_defm_term_defm_fe`, m, idx, k, vname))
}

#' @param mat Integer matrix. The matrix specifies the type of motif to capture
#' (see details.)
#' @details
#' In `term_defm_transition`, users can specify a particular motif to model. Motifs
#' are represented by cells with values equal to 1, for example, the matrix:
#'
#' ```  y0 y1 y2
#' t0:   1 NA NA
#' t1:   1  1 NA
#' ```
#'
#' represents a transition `y0 -> (y1, y2)`. If 0 is a motif of interest, then
#' the matrix should include 0 to mark zero values.
#' @export
#' @rdname defm_terms
term_defm_transition <- function(m, mat, covar_idx = -1L, vname = "") {
    invisible(.Call(`_defm_term_defm_transition`, m, mat, covar_idx, vname))
}

#' @details The function `term_defm_transition_formula`,
#' will take the formula and generate the corresponding
#' input for defm::counter_transition(). Formulas can be specified in the
#' following ways:
#'
#' - Intercept effect: {...} No transition, only including the current state.
#' - Transition effect: {...} > {...} Includes current and previous states.
#'
#' The general notation is `[0]y[column id]_[row id]`. A preceeding zero
#' means that the value of the cell is considered to be zero. The column
#' id goes between 0 and the number of columns in the array - 1 (so it
#' is indexed from 0,) and the row id goes from 0 to m_order.
#'
#' ## Intercept effects
#'
#' Intercept effects only involve a single set of curly brackets. Using the
#' 'greater-than' symbol (i.e., '<') is only for transition effects. When
#' specifying intercept effects, users can skip the `row_id`, e.g.,
#' `y0_0` is equivalent to `y0`. If the passed `row id` is different from
#' the Markov order, i.e., `row_id != m_order`, then the function returns
#' with an error.
#'
#' Examples:
#'
#' - `"{y0, 0y1}"` is equivalent to set a motif with the first element equal
#' to one and the second to zero.
#'
#' ## Transition effects
#'
#' Transition effects can be specified using two sets of curly brackets and
#' an greater-than symbol, i.e., `{...} > {...}`. The first set of brackets,
#' which we call LHS, can only hold `row id` that are less than `m_order`.
#' @export
#' @rdname defm_terms
term_defm_transition_formula <- function(m, formula, covar_idx = -1L, vname = "") {
    invisible(.Call(`_defm_term_defm_transition_formula`, m, formula, covar_idx, vname))
}

#' @export
#' @rdname defm_terms
#' @details The term `term_defm_logit_intercept` will add what is equivalent to an
#' intercept in a logistic regression. When `coords` is specified, then the
#' function will add one intercept per outcome. These can be weighted by
#' a covariate.
term_defm_logit_intercept <- function(m, coords = as.integer( c()), covar_idx = -1L, vname = "") {
    invisible(.Call(`_defm_term_defm_logit_intercept`, m, coords, covar_idx, vname))
}

