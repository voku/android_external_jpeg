#define JPEG_INTERNALS
#include "jinclude.h"
#include "jpeglib.h"
#include "jdct.h"

void idct_8x8_armv6(INT16 *block, UINT8 **out, int col, INT16 *qtab);

void
jpeg_idct_islow(j_decompress_ptr cinfo, jpeg_component_info *compptr,
                JCOEFPTR coef_block,
                JSAMPARRAY output_buf, JDIMENSION output_col)
{
  idct_8x8_armv6(coef_block, output_buf, output_col, compptr->dct_table);
}
