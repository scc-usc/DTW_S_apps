/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: unsafeSxfun.c
 *
 * MATLAB Coder version            : 5.6
 * C/C++ source code generated on  : 06-Sep-2023 17:36:05
 */

/* Include Files */
#include "unsafeSxfun.h"
#include "dtw_cons_md_emxutil.h"
#include "dtw_cons_md_types.h"
#include "rt_nonfinite.h"

/* Function Definitions */
/*
 * Arguments    : emxArray_real_T *in1
 *                const emxArray_real_T *in3
 *                int in4
 *                const emxArray_real_T *in5
 *                int in6
 * Return Type  : void
 */
void binary_expand_op(emxArray_real_T *in1, const emxArray_real_T *in3, int in4,
                      const emxArray_real_T *in5, int in6)
{
  emxArray_real_T *b_in3;
  const double *in3_data;
  const double *in5_data;
  double varargin_1;
  double *b_in3_data;
  double *in1_data;
  int i;
  int loop_ub;
  int stride_0_0;
  int stride_1_0;
  in5_data = in5->data;
  in3_data = in3->data;
  emxInit_real_T(&b_in3, 1);
  if (in5->size[0] == 1) {
    loop_ub = in3->size[0];
  } else {
    loop_ub = in5->size[0];
  }
  i = b_in3->size[0];
  b_in3->size[0] = loop_ub;
  emxEnsureCapacity_real_T(b_in3, i);
  b_in3_data = b_in3->data;
  stride_0_0 = (in3->size[0] != 1);
  stride_1_0 = (in5->size[0] != 1);
  for (i = 0; i < loop_ub; i++) {
    b_in3_data[i] = in3_data[i * stride_0_0 + in3->size[0] * in4] -
                    in5_data[i * stride_1_0 + in5->size[0] * in6];
  }
  i = in1->size[0];
  in1->size[0] = b_in3->size[0];
  emxEnsureCapacity_real_T(in1, i);
  in1_data = in1->data;
  loop_ub = b_in3->size[0];
  for (i = 0; i < loop_ub; i++) {
    varargin_1 = b_in3_data[i];
    in1_data[i] = varargin_1 * varargin_1;
  }
  emxFree_real_T(&b_in3);
}

/*
 * File trailer for unsafeSxfun.c
 *
 * [EOF]
 */
