`define CACHE_BITS_PER_BLOCK 16
`define CACHE_BLOCK_COUNT 128
`define NUM_TAG_BITS 8
`define NUM_INDEX_BITS 7
`define NUM_OFFSET_BITS 1
`define NUM_VALIDITY_BITS 1

`define READ 1'd0
`define WRITE 1'd1

`define CPU_REQUEST_COMMAND 24
`define CPU_REQUEST_DATA 23:16
`define CPU_REQUEST_ADDRESS 15:0
`define CPU_REQUEST_TAG 15:8
`define CPU_REQUEST_INDEX 7:1
`define CPU_REQUEST_OFFSET 0
`define CACHE_MEM_VALIDITY (`NUM_VALIDITY_BITS + `NUM_TAG_BITS + `CACHE_BITS_PER_BLOCK - 1)
`define CACHE_MEM_TAG (`NUM_TAG_BITS + `CACHE_BITS_PER_BLOCK - 1):(`CACHE_BITS_PER_BLOCK)
`define CACHE_MEM_DATA (`CACHE_BITS_PER_BLOCK - 1):0
`define CACHE_MEM_DATA_UPPER 15:8
`define CACHE_MEM_DATA_LOWER 7:0
`define MEMORY_RESPONSE_UPPER 15:8
`define MEMORY_RESPONSE_LOWER 7:0
`define INVALIDATE_ADDRESS 15:0
`define INVALIDATE_ADDRESS_TAG 15:8
`define INVALIDATE_ADDRESS_INDEX 7:1