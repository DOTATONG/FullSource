/*
 * Copyright (c) 1997-1999, 2003 Massachusetts Institute of Technology
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

/* This file was automatically generated --- DO NOT EDIT */
/* Generated on Mon Mar 24 02:06:56 EST 2003 */

#include "fftw-int.h"
#include "fftw.h"

/* Generated by: /homee/stevenj/cvs/fftw/gensrc/genfft -magic-alignment-check -magic-twiddle-load-all -magic-variables 4 -magic-loopi -hc2real 3 */

/*
 * This function contains 4 FP additions, 2 FP multiplications,
 * (or, 3 additions, 1 multiplications, 1 fused multiply/add),
 * 5 stack variables, and 6 memory accesses
 */
static const fftw_real K2_000000000 =
FFTW_KONST(+2.000000000000000000000000000000000000000000000);
static const fftw_real K1_732050807 =
FFTW_KONST(+1.732050807568877293527446341505872366942805254);

/*
 * Generator Id's : 
 * $Id: fcr_3.c,v 1.2 2008/04/08 01:23:34 yanglin Exp $
 * $Id: fcr_3.c,v 1.2 2008/04/08 01:23:34 yanglin Exp $
 * $Id: fcr_3.c,v 1.2 2008/04/08 01:23:34 yanglin Exp $
 */

void fftw_hc2real_3(const fftw_real *real_input,
		    const fftw_real *imag_input, fftw_real *output,
		    int real_istride, int imag_istride, int ostride)
{
     fftw_real tmp5;
     fftw_real tmp1;
     fftw_real tmp2;
     fftw_real tmp3;
     fftw_real tmp4;
     ASSERT_ALIGNED_DOUBLE;
     tmp4 = imag_input[imag_istride];
     tmp5 = K1_732050807 * tmp4;
     tmp1 = real_input[0];
     tmp2 = real_input[real_istride];
     tmp3 = tmp1 - tmp2;
     output[0] = tmp1 + (K2_000000000 * tmp2);
     output[2 * ostride] = tmp3 + tmp5;
     output[ostride] = tmp3 - tmp5;
}

fftw_codelet_desc fftw_hc2real_3_desc = {
     "fftw_hc2real_3",
     (void (*)()) fftw_hc2real_3,
     3,
     FFTW_BACKWARD,
     FFTW_HC2REAL,
     81,
     0,
     (const int *) 0,
};
