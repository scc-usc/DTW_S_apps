/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: dtw_cons_md_initialize.c
 *
 * MATLAB Coder version            : 5.6
 * C/C++ source code generated on  : 06-Sep-2023 17:36:05
 */

/* Include Files */
#include "dtw_cons_md_initialize.h"
#include "dtw_cons_md_data.h"
#include "rt_nonfinite.h"

/* Function Definitions */
/*
 * Arguments    : void
 * Return Type  : void
 */
void dtw_cons_md_initialize(void)
{
  rt_InitInfAndNaN();
  isInitialized_dtw_cons_md = true;
}

/*
 * File trailer for dtw_cons_md_initialize.c
 *
 * [EOF]
 */
