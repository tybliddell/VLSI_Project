`define CACHE_SIZE_BYTES 256
`define CACHE_BYTES_PER_BLOCK 2
`define CACHE_BLOCK_COUNT 128
`define NUM_OFFSET_BITS 1
`define NUM_INDEX_BITS 7
`define NUM_TAG_BITS 8

module cache(
    input [15:0] cpu_bus, input clock,
    output reg [15:0] memory_bus
);
    


endmodule