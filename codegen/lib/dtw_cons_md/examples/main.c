/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: main.c
 *
 * MATLAB Coder version            : 5.6
 * C/C++ source code generated on  : 06-Sep-2023 17:36:05
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/

/* Include Files */
#include "main.h"
#include "dtw_cons_md.h"
#include "dtw_cons_md_emxAPI.h"
#include "dtw_cons_md_terminate.h"
#include "dtw_cons_md_types.h"
#include "rt_nonfinite.h"

/* Function Declarations */
static emxArray_char_T *argInit_1xUnbounded_char_T(void);

static char argInit_char_T(void);

static double argInit_real_T(void);

static emxArray_real_T *c_argInit_UnboundedxUnbounded_r(void);

/* Function Definitions */
/*
 * Arguments    : void
 * Return Type  : emxArray_char_T *
 */
static emxArray_char_T *argInit_1xUnbounded_char_T(void)
{
  emxArray_char_T *result;
  int idx0;
  int idx1;
  char *result_data;
  /* Set the size of the array.
Change this size to the value that the application requires. */
  result = emxCreate_char_T(1, 2);
  result_data = result->data;
  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 1; idx0++) {
    for (idx1 = 0; idx1 < result->size[1U]; idx1++) {
      /* Set the value of the array element.
Change this value to the value that the application requires. */
      result_data[idx1] = argInit_char_T();
    }
  }
  return result;
}

/*
 * Arguments    : void
 * Return Type  : char
 */
static char argInit_char_T(void)
{
  return '?';
}

/*
 * Arguments    : void
 * Return Type  : double
 */
static double argInit_real_T(void)
{
  return 0.0;
}

/*
 * Arguments    : void
 * Return Type  : emxArray_real_T *
 */
static emxArray_real_T *c_argInit_UnboundedxUnbounded_r(void)
{
  emxArray_real_T *result;
  double *result_data;
  int idx0;
  int idx1;
  /* Set the size of the array.
Change this size to the value that the application requires. */
  result = emxCreate_real_T(2, 2);
  result_data = result->data;
  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < result->size[0U]; idx0++) {
    for (idx1 = 0; idx1 < result->size[1U]; idx1++) {
      /* Set the value of the array element.
Change this value to the value that the application requires. */
      result_data[idx0 + result->size[0] * idx1] = argInit_real_T();
    }
  }
  return result;
}

/*
 * Arguments    : int argc
 *                char **argv
 * Return Type  : int
 */
int main(int argc, char **argv)
{
  (void)argc;
  (void)argv;
  /* The initialize function is being called automatically from your entry-point
   * function. So, a call to initialize is not included here. */
  /* Invoke the entry-point functions.
You can call entry-point functions multiple times. */
  main_dtw_cons_md();
  /* Terminate the application.
You do not need to do this more than one time. */
  dtw_cons_md_terminate();
  return 0;
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void main_dtw_cons_md(void)
{
  emxArray_char_T *dist_metric;
  emxArray_real_T *r;
  emxArray_real_T *t;
  emxArray_real_T *w1;
  emxArray_real_T *w2;
  emxArray_real_T *win;
  double Dist;
  /* Initialize function 'dtw_cons_md' input arguments. */
  /* Initialize function input argument 't'. */
  t = c_argInit_UnboundedxUnbounded_r();
  /* Initialize function input argument 'r'. */
  r = c_argInit_UnboundedxUnbounded_r();
  /* Initialize function input argument 'win'. */
  win = c_argInit_UnboundedxUnbounded_r();
  /* Initialize function input argument 'dist_metric'. */
  dist_metric = argInit_1xUnbounded_char_T();
  /* Call the entry-point 'dtw_cons_md'. */
  emxInitArray_real_T(&w1, 1);
  emxInitArray_real_T(&w2, 1);
  dtw_cons_md(t, r, win, dist_metric, &Dist, w1, w2);
  emxDestroyArray_char_T(dist_metric);
  emxDestroyArray_real_T(win);
  emxDestroyArray_real_T(r);
  emxDestroyArray_real_T(t);
  emxDestroyArray_real_T(w1);
  emxDestroyArray_real_T(w2);
}

/*
 * File trailer for main.c
 *
 * [EOF]
 */
