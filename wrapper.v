module cbsl

#flag -lzstd
#flag -I @VMODROOT/include
#flag @VMODROOT/src/buffer.o
#flag @VMODROOT/src/file.o
#flag @VMODROOT/src/flush.o
#flag @VMODROOT/src/read.o
#flag @VMODROOT/src/record.o
#flag @VMODROOT/src/utils.o
#flag @VMODROOT/src/write.o

#include "cbsl.h"

pub enum CBSL_MODE {
	cbsl_load_mode = 1
	cbsl_store_mode = 2
	cbsl_unknown_mode = -1
}

pub enum CBSL_ERRORS {
	cbsl_success = 0
	cbsl_end = 1
	cbsl_error = -1
}

struct C.cbsl_ctx {
}

fn C.cbsl_open(mode CBSL_MODE, filename &char) &C.cbsl_ctx
fn C.cbsl_readline(ctx voidptr, linebuf &char, size int) CBSL_ERRORS
fn C.cbsl_read(ctx voidptr, data voidptr, size u64) CBSL_ERRORS
fn C.cbsl_write(ctx voidptr, data voidptr, size u64) CBSL_ERRORS
fn C.cbsl_close(ctx voidptr) CBSL_ERRORS

pub fn cbsl_open(mod CBSL_MODE, filename string) voidptr {
	return C.cbsl_open(mod, filename.str)
}

[inline]
pub fn cbsl_write(ctx voidptr, data voidptr, size u64) CBSL_ERRORS {
	return C.cbsl_write(ctx, data, size)
}

[inline]
pub fn cbsl_readline(ctx voidptr, linebuf &char, size u64) CBSL_ERRORS {
	return C.cbsl_readline(ctx, linebuf, size)
}

[inline]
pub fn cbsl_read(ctx voidptr, data voidptr, size u64) CBSL_ERRORS {
	return C.cbsl_read(ctx, data, size)
}

[inline]
pub fn cbsl_close(ctx voidptr) CBSL_ERRORS {
	return C.cbsl_close(ctx)
}
