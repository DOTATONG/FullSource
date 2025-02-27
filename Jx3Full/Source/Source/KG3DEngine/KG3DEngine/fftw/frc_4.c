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
/* Generated on Mon Mar 24 02:05:52 EST 2003 */

#include "fftw-int.h"
#include "fftw.h"

/* Generated by: /homee/stevenj/cvs/fftw/gensrc/genfft -magic-alignment-check -magic-twiddle-load-all -magic-variables 4 -magic-loopi -real2hc 4 */

/*
 * This function contains 6 FP additions, 0 FP multiplications,
 * (or, 6 additions, 0 multiplications, 0 fused multiply/add),
 * 6 stack variables, and 8 memory accesses
 */

/*
 * Generator Id's : 
 * $Id: frc_4.c,v 1.2 2008/04/08 01:23:34 yanglin Exp $
 * $Id: frc_4.c,v 1.2 2008/04/08 01:23:34 yanglin Exp $
 * $Id: frc_4.c,v 1.2 2008/04/08 01:23:34 yanglin Exp $
 */

void fftw_real2hc_4(const fftw_real *input, fftw_real *real_output,
		    fftw_real *imag_output, int istride, int real_ostride,
		    int imag_ostride)
{
     fftw_real tmp1;
     fftw_real tmp2;
     fftw_real tmp3;
     fftw_real tmp4;
     fftw_real tmp5;
     fftw_real tmp6;
     ASSERT_ALIGNED_DOUBLE;
     tmp1 = input[0];
     tmp2 = input[2 * istride];
     tmp3 = tmp1 + tmp2;
     tmp4 = input[istride];
     tmp5 = input[3 * istride];
     tmp6 = tmp4 + tmp5;
     real_output[real_ostride] = tmp1 - tmp2;
     imag_output[imag_ostride] = -(tmp4 - tmp5);
     real_output[2 * real_ostride] = tmp3 - tmp6;
     real_output[0] = tmp3 + tmp6;
}

fftw_codelet_desc fftw_real2hc_4_desc = {
     "fftw_real2hc_4",
     (void (*)()) fftw_real2hc_4,
     4,
     FFTW_FORWARD,
     FFTW_REAL2HC,
     90,
     0,
     (const int *) 0,
};
