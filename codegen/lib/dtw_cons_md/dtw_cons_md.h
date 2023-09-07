/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: dtw_cons_md.h
 *
 * MATLAB Coder version            : 5.6
 * C/C++ source code generated on  : 06-Sep-2023 17:36:05
 */

#ifndef DTW_CONS_MD_H
#define DTW_CONS_MD_H

/* Include Files */
#include "dtw_cons_md_types.h"
#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
extern void dtw_cons_md(const emxArray_real_T *t, const emxArray_real_T *r,
                        emxArray_real_T *win,
                        const emxArray_char_T *dist_metric, double *Dist,
                        emxArray_real_T *w1, emxArray_real_T *w2);

#ifdef __cplusplus
}
#endif

#endif
/*
 * File trailer for dtw_cons_md.h
 *
 * [EOF]
 */
