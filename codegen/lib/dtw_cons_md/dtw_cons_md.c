/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: dtw_cons_md.c
 *
 * MATLAB Coder version            : 5.6
 * C/C++ source code generated on  : 06-Sep-2023 17:36:05
 */

/* Include Files */
#include "dtw_cons_md.h"
#include "dtw_cons_md_data.h"
#include "dtw_cons_md_emxutil.h"
#include "dtw_cons_md_initialize.h"
#include "dtw_cons_md_types.h"
#include "rt_nonfinite.h"
#include "sum.h"
#include "unsafeSxfun.h"
#include "rt_nonfinite.h"
#include <math.h>

/* Function Definitions */
/*
 * Dynamic Time Warping Algorithm
 * Dist is the DTW distance between t and r
 * w is the optimal path
 * t is the vector you are testing against
 * r is the vector you are testing
 *
 * Arguments    : const emxArray_real_T *t
 *                const emxArray_real_T *r
 *                emxArray_real_T *win
 *                const emxArray_char_T *dist_metric
 *                double *Dist
 *                emxArray_real_T *w1
 *                emxArray_real_T *w2
 * Return Type  : void
 */
void dtw_cons_md(const emxArray_real_T *t, const emxArray_real_T *r,
                 emxArray_real_T *win, const emxArray_char_T *dist_metric,
                 double *Dist, emxArray_real_T *w1, emxArray_real_T *w2)
{
  static const char cv[3] = {'c', 'o', 's'};
  emxArray_boolean_T *b;
  emxArray_int32_T *idx;
  emxArray_real_T *D;
  emxArray_real_T *d;
  emxArray_real_T *r_norm;
  emxArray_real_T *t_norm;
  emxArray_real_T *w;
  emxArray_real_T *y;
  double varargin_1[3];
  double x_data[3];
  const double *r_data;
  const double *t_data;
  double b_d;
  double b_k;
  double bsum;
  double ex;
  double win_idx_0;
  double *D_data;
  double *d_data;
  double *r_norm_data;
  double *t_norm_data;
  double *win_data;
  int M_tmp;
  int b_i;
  int exitg1;
  int firstBlockLength;
  int i;
  int i1;
  int j;
  int k;
  unsigned int k_tmp;
  int m;
  int n;
  int nblocks;
  int xblockoffset;
  int *idx_data;
  const char *dist_metric_data;
  boolean_T exitg2;
  boolean_T guard1;
  boolean_T *b_data;
  if (!isInitialized_dtw_cons_md) {
    dtw_cons_md_initialize();
  }
  dist_metric_data = dist_metric->data;
  win_data = win->data;
  r_data = r->data;
  t_data = t->data;
  /*  If single source/dest */
  M_tmp = r->size[1] - 1;
  /*  If single source/dest */
  if ((win->size[0] == 0) || (win->size[1] == 0)) {
    xblockoffset = 0;
  } else {
    firstBlockLength = win->size[0];
    xblockoffset = win->size[1];
    if (firstBlockLength >= xblockoffset) {
      xblockoffset = firstBlockLength;
    }
  }
  if (xblockoffset == 1) {
    win_idx_0 = win_data[0];
    bsum = win_data[0];
    i = win->size[0] * win->size[1];
    win->size[0] = 1;
    win->size[1] = 2;
    emxEnsureCapacity_real_T(win, i);
    win_data = win->data;
    win_data[0] = win_idx_0;
    win_data[1] = bsum;
  }
  emxInit_real_T(&d, 2);
  i = d->size[0] * d->size[1];
  d->size[0] = t->size[1];
  d->size[1] = r->size[1];
  emxEnsureCapacity_real_T(d, i);
  d_data = d->data;
  firstBlockLength = t->size[1] * r->size[1];
  for (i = 0; i < firstBlockLength; i++) {
    d_data[i] = rtInf;
  }
  if (dist_metric->size[1] <= 3) {
    xblockoffset = dist_metric->size[1] - 3;
  } else {
    xblockoffset = 0;
  }
  b_i = 0;
  emxInit_real_T(&t_norm, 2);
  emxInit_real_T(&r_norm, 2);
  emxInit_real_T(&D, 2);
  emxInit_real_T(&y, 1);
  guard1 = false;
  do {
    exitg1 = 0;
    if (b_i <= xblockoffset) {
      j = 1;
      while ((j <= 3) && (dist_metric_data[j - 1] == cv[j - 1])) {
        j++;
      }
      if (j > 3) {
        if (t->size[0] > 1) {
          i = D->size[0] * D->size[1];
          D->size[0] = t->size[0];
          D->size[1] = t->size[1];
          emxEnsureCapacity_real_T(D, i);
          D_data = D->data;
          firstBlockLength = t->size[0] * t->size[1];
          for (i = 0; i < firstBlockLength; i++) {
            win_idx_0 = t_data[i];
            D_data[i] = win_idx_0 * win_idx_0;
          }
          sum(D, t_norm);
          t_norm_data = t_norm->data;
          firstBlockLength = t_norm->size[1];
          for (k = 0; k < firstBlockLength; k++) {
            t_norm_data[k] = sqrt(t_norm_data[k]);
          }
          i = D->size[0] * D->size[1];
          D->size[0] = r->size[0];
          D->size[1] = r->size[1];
          emxEnsureCapacity_real_T(D, i);
          D_data = D->data;
          firstBlockLength = r->size[0] * r->size[1];
          for (i = 0; i < firstBlockLength; i++) {
            win_idx_0 = r_data[i];
            D_data[i] = win_idx_0 * win_idx_0;
          }
          sum(D, r_norm);
          r_norm_data = r_norm->data;
          firstBlockLength = r_norm->size[1];
          for (k = 0; k < firstBlockLength; k++) {
            r_norm_data[k] = sqrt(r_norm_data[k]);
          }
          i = t->size[1];
          for (n = 0; n < i; n++) {
            for (m = 0; m <= M_tmp; m++) {
              xblockoffset = n - m;
              if ((xblockoffset > -win_data[0]) &&
                  (xblockoffset < win_data[1])) {
                win_idx_0 = 0.0;
                xblockoffset = t->size[0];
                for (k = 0; k < xblockoffset; k++) {
                  win_idx_0 +=
                      t_data[k + t->size[0] * n] * r_data[k + r->size[0] * m];
                }
                d_data[n + d->size[0] * m] =
                    1.0 - win_idx_0 / (t_norm_data[n] * r_norm_data[m]);
              }
            }
          }
        } else {
          guard1 = true;
        }
        exitg1 = 1;
      } else {
        b_i = 1;
        guard1 = false;
      }
    } else {
      guard1 = true;
      exitg1 = 1;
    }
  } while (exitg1 == 0);
  if (guard1) {
    i = t->size[1];
    for (n = 0; n < i; n++) {
      for (m = 0; m <= M_tmp; m++) {
        xblockoffset = n - m;
        if ((xblockoffset > -win_data[0]) && (xblockoffset < win_data[1])) {
          firstBlockLength = t->size[0];
          if (t->size[0] == r->size[0]) {
            xblockoffset = y->size[0];
            y->size[0] = t->size[0];
            emxEnsureCapacity_real_T(y, xblockoffset);
            r_norm_data = y->data;
            for (xblockoffset = 0; xblockoffset < firstBlockLength;
                 xblockoffset++) {
              win_idx_0 = t_data[xblockoffset + t->size[0] * n] -
                          r_data[xblockoffset + r->size[0] * m];
              r_norm_data[xblockoffset] = win_idx_0 * win_idx_0;
            }
          } else {
            binary_expand_op(y, t, n, r, m);
            r_norm_data = y->data;
          }
          if (y->size[0] == 0) {
            win_idx_0 = 0.0;
          } else {
            if (y->size[0] <= 1024) {
              firstBlockLength = y->size[0];
              j = 0;
              nblocks = 1;
            } else {
              firstBlockLength = 1024;
              nblocks = (int)((unsigned int)y->size[0] >> 10);
              j = y->size[0] - (nblocks << 10);
              if (j > 0) {
                nblocks++;
              } else {
                j = 1024;
              }
            }
            win_idx_0 = r_norm_data[0];
            for (k = 2; k <= firstBlockLength; k++) {
              win_idx_0 += r_norm_data[k - 1];
            }
            for (b_i = 2; b_i <= nblocks; b_i++) {
              xblockoffset = (b_i - 1) << 10;
              bsum = r_norm_data[xblockoffset];
              if (b_i == nblocks) {
                firstBlockLength = j;
              } else {
                firstBlockLength = 1024;
              }
              for (k = 2; k <= firstBlockLength; k++) {
                bsum += r_norm_data[(xblockoffset + k) - 1];
              }
              win_idx_0 += bsum;
            }
          }
          d_data[n + d->size[0] * m] = win_idx_0;
        }
      }
    }
  }
  emxFree_real_T(&y);
  emxFree_real_T(&r_norm);
  emxFree_real_T(&t_norm);
  i = D->size[0] * D->size[1];
  D->size[0] = d->size[0];
  D->size[1] = d->size[1];
  emxEnsureCapacity_real_T(D, i);
  D_data = D->data;
  firstBlockLength = d->size[0] * d->size[1];
  for (i = 0; i < firstBlockLength; i++) {
    D_data[i] = 0.0;
  }
  D_data[0] = d_data[0];
  i = t->size[1];
  for (n = 0; n <= i - 2; n++) {
    D_data[n + 1] = d_data[n + 1] + D_data[n];
  }
  i = r->size[1];
  for (m = 0; m <= i - 2; m++) {
    D_data[D->size[0] * (m + 1)] =
        d_data[d->size[0] * (m + 1)] + D_data[D->size[0] * m];
  }
  i = t->size[1];
  if (t->size[1] - 2 >= 0) {
    i1 = r->size[1] - 1;
  }
  for (n = 0; n <= i - 2; n++) {
    for (m = 0; m < i1; m++) {
      ex = D_data[n + D->size[0] * (m + 1)];
      varargin_1[0] = ex;
      b_d = D_data[n + D->size[0] * m];
      varargin_1[1] = b_d;
      win_idx_0 = D_data[(n + D->size[0] * m) + 1];
      varargin_1[2] = win_idx_0;
      x_data[0] = ex;
      x_data[1] = b_d;
      x_data[2] = win_idx_0;
      if (!rtIsNaN(ex)) {
        firstBlockLength = 1;
      } else {
        firstBlockLength = 0;
        k = 2;
        exitg2 = false;
        while ((!exitg2) && (k < 4)) {
          if (!rtIsNaN(x_data[k - 1])) {
            firstBlockLength = k;
            exitg2 = true;
          } else {
            k++;
          }
        }
      }
      if (firstBlockLength != 0) {
        ex = varargin_1[firstBlockLength - 1];
        xblockoffset = firstBlockLength + 1;
        for (k = xblockoffset; k < 4; k++) {
          b_d = varargin_1[k - 1];
          if (ex > b_d) {
            ex = b_d;
          }
        }
      }
      D_data[(n + D->size[0] * (m + 1)) + 1] =
          d_data[(n + d->size[0] * (m + 1)) + 1] + ex;
    }
  }
  emxFree_real_T(&d);
  *Dist = D_data[(t->size[1] + D->size[0] * (r->size[1] - 1)) - 1];
  win_idx_0 = t->size[1];
  bsum = r->size[1];
  k_tmp = (unsigned int)t->size[1] + (unsigned int)r->size[1];
  b_k = k_tmp;
  emxInit_real_T(&w, 2);
  i = w->size[0] * w->size[1];
  w->size[0] = (int)k_tmp;
  w->size[1] = 2;
  emxEnsureCapacity_real_T(w, i);
  t_norm_data = w->data;
  firstBlockLength = (int)k_tmp << 1;
  for (i = 0; i < firstBlockLength; i++) {
    t_norm_data[i] = 0.0;
  }
  nblocks = (int)k_tmp - 1;
  t_norm_data[(int)k_tmp - 1] = t->size[1];
  t_norm_data[((int)k_tmp + w->size[0]) - 1] = r->size[1];
  while (win_idx_0 + bsum != 2.0) {
    if (win_idx_0 - 1.0 == 0.0) {
      bsum--;
    } else if (bsum - 1.0 == 0.0) {
      win_idx_0--;
    } else {
      varargin_1[0] =
          D_data[((int)win_idx_0 + D->size[0] * ((int)bsum - 1)) - 2];
      varargin_1[1] =
          D_data[((int)win_idx_0 + D->size[0] * ((int)bsum - 2)) - 1];
      varargin_1[2] =
          D_data[((int)win_idx_0 + D->size[0] * ((int)bsum - 2)) - 2];
      if (!rtIsNaN(varargin_1[0])) {
        firstBlockLength = 1;
      } else {
        firstBlockLength = 0;
        k = 2;
        exitg2 = false;
        while ((!exitg2) && (k < 4)) {
          if (!rtIsNaN(varargin_1[k - 1])) {
            firstBlockLength = k;
            exitg2 = true;
          } else {
            k++;
          }
        }
      }
      if (firstBlockLength == 0) {
        firstBlockLength = 1;
      } else {
        ex = varargin_1[firstBlockLength - 1];
        i = firstBlockLength + 1;
        for (k = i; k < 4; k++) {
          b_d = varargin_1[k - 1];
          if (ex > b_d) {
            ex = b_d;
            firstBlockLength = k;
          }
        }
      }
      switch (firstBlockLength) {
      case 1:
        win_idx_0--;
        break;
      case 2:
        bsum--;
        break;
      default:
        win_idx_0--;
        bsum--;
        break;
      }
    }
    b_k--;
    t_norm_data[(int)b_k - 1] = win_idx_0;
    t_norm_data[((int)b_k + w->size[0]) - 1] = bsum;
  }
  emxFree_real_T(&D);
  emxInit_int32_T(&idx);
  i = idx->size[0] * idx->size[1];
  idx->size[0] = 1;
  idx->size[1] = (int)((b_k - 1.0) - 1.0) + 1;
  emxEnsureCapacity_int32_T(idx, i);
  idx_data = idx->data;
  firstBlockLength = (int)((b_k - 1.0) - 1.0);
  for (i = 0; i <= firstBlockLength; i++) {
    idx_data[i] = i + 1;
  }
  xblockoffset = w->size[0];
  if (idx->size[1] == 1) {
    firstBlockLength = (int)k_tmp - 1;
    i = idx_data[0];
    for (j = 0; j < 2; j++) {
      for (b_i = i; b_i <= nblocks; b_i++) {
        t_norm_data[(b_i + w->size[0] * j) - 1] =
            t_norm_data[b_i + w->size[0] * j];
      }
    }
  } else {
    emxInit_boolean_T(&b);
    i = b->size[0] * b->size[1];
    b->size[0] = 1;
    b->size[1] = w->size[0];
    emxEnsureCapacity_boolean_T(b, i);
    b_data = b->data;
    firstBlockLength = w->size[0];
    for (i = 0; i < firstBlockLength; i++) {
      b_data[i] = false;
    }
    i = idx->size[1];
    for (k = 0; k < i; k++) {
      b_data[idx_data[k] - 1] = true;
    }
    n = 0;
    i = b->size[1];
    for (k = 0; k < i; k++) {
      n += b_data[k];
    }
    firstBlockLength = w->size[0] - n;
    b_i = 0;
    for (k = 0; k < xblockoffset; k++) {
      if ((k + 1 > b->size[1]) || (!b_data[k])) {
        t_norm_data[b_i] = t_norm_data[k];
        t_norm_data[b_i + w->size[0]] = t_norm_data[k + w->size[0]];
        b_i++;
      }
    }
    emxFree_boolean_T(&b);
  }
  emxFree_int32_T(&idx);
  if (firstBlockLength < 1) {
    firstBlockLength = 0;
  }
  for (i = 0; i < 2; i++) {
    for (xblockoffset = 0; xblockoffset < firstBlockLength; xblockoffset++) {
      t_norm_data[xblockoffset + firstBlockLength * i] =
          t_norm_data[xblockoffset + w->size[0] * i];
    }
  }
  i = w->size[0] * w->size[1];
  w->size[0] = firstBlockLength;
  w->size[1] = 2;
  emxEnsureCapacity_real_T(w, i);
  t_norm_data = w->data;
  i = w1->size[0];
  w1->size[0] = firstBlockLength;
  emxEnsureCapacity_real_T(w1, i);
  r_norm_data = w1->data;
  i = w2->size[0];
  w2->size[0] = firstBlockLength;
  emxEnsureCapacity_real_T(w2, i);
  D_data = w2->data;
  for (i = 0; i < firstBlockLength; i++) {
    r_norm_data[i] = t_norm_data[i];
    D_data[i] = t_norm_data[i + w->size[0]];
  }
  emxFree_real_T(&w);
}

/*
 * File trailer for dtw_cons_md.c
 *
 * [EOF]
 */
