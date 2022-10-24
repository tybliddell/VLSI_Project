`define CACHE_BITS_PER_BLOCK 16
`define CACHE_BLOCK_COUNT 128
`define NUM_TAG_BITS 8
`define NUM_INDEX_BITS 7
`define NUM_OFFSET_BITS 1
`define NUM_VALIDITY_BITS 1

`define READ 1'd0
`define WRITE 1'd1

`define CPU_REQUEST_DATA 31:16
`define CPU_REQUEST_ADDRESS 15:0
`define CPU_REQUEST_TAG 15:8
`define CPU_REQUEST_INDEX 7:1
`define CPU_REQUEST_OFFSET 0
`define CACHE_MEM_VALIDITY (`NUM_VALIDITY_BITS + `NUM_TAG_BITS + `CACHE_BITS_PER_BLOCK - 1)
`define CACHE_MEM_TAG (`NUM_TAG_BITS + `CACHE_BITS_PER_BLOCK - 1):(`CACHE_BITS_PER_BLOCK - 1)
`define CACHE_MEM_DATA (`CACHE_BITS_PER_BLOCK - 1):0
`define CACHE_MEM_DATA_UPPER 15:8
`define CACHE_MEM_DATA_LOWER 7:0
`define MEMORY_RESPONSE_UPPER 15:8
`define MEMORY_RESPONSE_LOWER 7:0
//Just added all the macros because probably will use

module cache_coherenter(
    input clock, reset,
    input [32:0] cache_change,
    /* We should have a bit to see which cahce it is
    * coming from. Or we could have two inputs and
    * separate them by left cahce and right cache.
    */
    input [32:0] left_cache_change, right_cache_change

    output [32:0] right_cache_write, left_cache_write
    /* Another thought: in our cache statemachine, 
    * we should have a state that takes an input from
    * the coherenter that has immediate priority. 
    * So, we don't run into any issues from the CPU
    * making a request to the cache that is not correct
    */

);

//Something like below. THIS WILL CHANGE.
//Probably need an idle so once the output is sent, it goes back to idle

parameter idle = 3'b000;

always @(right_cache_change) begin
    //Send STUFF
    left_cache_write <= right_cache_change;
end

always @(left_cache_change) begin
    //Send STUFF
    right_cache_write <= left_cache_change;
end


endmodule
