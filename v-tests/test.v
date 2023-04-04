module main

import cbsl

struct MemoryTrace {
	operation u8
	address   u64
	size      u8
}

fn cbsl_error_check(msg cbsl.CBSL_ERRORS) {
	if msg != cbsl.CBSL_ERRORS.cbsl_success && msg != cbsl.CBSL_ERRORS.cbsl_end {
		println('cbsl error: ' + msg.str())
	}
}

fn write_test() {
	mut ctx := unsafe { nil }

	ctx = cbsl.cbsl_open(cbsl.CBSL_MODE.cbsl_store_mode, 'test.zst')

	if isnil(ctx) {
		println("Can't open test.zst for writting.")
		return
	}

	// Create a big array for test
	mut memory_trace := []MemoryTrace{}

	for i in 0 .. 10000 {
		tmp := MemoryTrace{
			operation: `L`
			address: u64(i)
			size: u8(i % 8)
		}
		memory_trace << tmp
	}
	println('sizeof(MemoryTrace)==${sizeof(MemoryTrace)}')

	// Write the array.data !
	cbsl.cbsl_write(ctx, memory_trace.data, 10000 * sizeof(MemoryTrace))

	cbsl_error_check(cbsl.cbsl_close(ctx))
}

fn read_test() {
	mut ctx := unsafe { nil }

	ctx = cbsl.cbsl_open(cbsl.CBSL_MODE.cbsl_load_mode, 'test.zst')

	if isnil(ctx) {
		println("Can't open test.zst for reading.")
		return
	}

	mut memory_trace := []MemoryTrace{len: 10000}

	println('sizeof(MemoryTrace)==${sizeof(MemoryTrace)}')

	// Read into the array.data
	cbsl.cbsl_read(ctx, memory_trace.data, 10000 * sizeof(MemoryTrace))

	cbsl_error_check(cbsl.cbsl_close(ctx))
	for i in 0 .. 10000 {
		if i % 100 == 0 {
			println('${i} : address = ${memory_trace[i].address}')
		}
	}
}

fn main() {
	write_test()
	read_test()
}
