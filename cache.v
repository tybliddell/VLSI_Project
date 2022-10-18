`define CACHE_BITS_PER_BLOCK 16
`define CACHE_BLOCK_COUNT 128
`define NUM_TAG_BITS 8
`define NUM_INDEX_BITS 7
`define NUM_OFFSET_BITS 1
`define NUM_VALIDITY_BITS 1

//write-through cache policy - 

module cache(
    input [32:0] cpu_request, /* 1 bit for r/w, 16 bits for data, 16 bits for address */
    input clock, input reset,
    input [15:0] invalidate_address, /* coming from controller, invalidate that entry */
    output reg [15:0] to_cache_controller, 
    output reg [7:0] data_out, /* return data to cpu */
);
// An entry becomes invalid when another cache writes to an address stored in multiple caches or
// a write overwrites a current valid entry 

reg [`NUM_VALIDITY_BITS + `NUM_TAG_BITS + `CACHE_BITS_PER_BLOCK - 1:0] cache_mem[`CACHE_BLOCK_COUNT-1:0]; 

/*
* Receive request on cpu_bus (read/write?)
* Decode the cpu_request into r/w, data, address
*   -Read:
*       Hit - in cache, return to cpu
*       Miss - not in cache, fetch from main memory
*   -Write:
*       write data to address
*   yes - put the data on to_cpu
*   no - put request on memory_bus
*/

endmodule