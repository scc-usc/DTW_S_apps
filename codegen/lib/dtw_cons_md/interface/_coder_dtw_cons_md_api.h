/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: _coder_dtw_cons_md_api.h
 *
 * MATLAB Coder version            : 5.6
 * C/C++ source code generated on  : 06-Sep-2023 17:36:05
 */

#ifndef _CODER_DTW_CONS_MD_API_H
#define _CODER_DTW_CONS_MD_API_H

/* Include Files */
#include "emlrt.h"
#include "tmwtypes.h"
#include <string.h>

/* Type Definitions */
#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T
struct emxArray_real_T {
  real_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};
#endif /* struct_emxArray_real_T */
#ifndef typedef_emxArray_real_T
#define typedef_emxArray_real_T
typedef struct emxArray_real_T emxArray_real_T;
#endif /* typedef_emxArray_real_T */

#ifndef struct_emxArray_char_T
#define struct_emxArray_char_T
struct emxArray_char_T {
  char_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};
#endif /* struct_emxArray_char_T */
#ifndef typedef_emxArray_char_T
#define typedef_emxArray_char_T
typedef struct emxArray_char_T emxArray_char_T;
#endif /* typedef_emxArray_char_T */

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
void dtw_cons_md(emxArray_real_T *t, emxArray_real_T *r, emxArray_real_T *win,
                 emxArray_char_T *dist_metric, real_T *Dist,
                 emxArray_real_T *w1, emxArray_real_T *w2);

void dtw_cons_md_api(const mxArray *const prhs[4], int32_T nlhs,
                     const mxArray *plhs[3]);

void dtw_cons_md_atexit(void);

void dtw_cons_md_initialize(void);

void dtw_cons_md_terminate(void);

void dtw_cons_md_xil_shutdown(void);

void dtw_cons_md_xil_terminate(void);

#ifdef __cplusplus
}
#endif

#endif
/*
 * File trailer for _coder_dtw_cons_md_api.h
 *
 * [EOF]
 */
