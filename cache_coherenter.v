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

/* Cache Coherenter (Yes that is a word, don't even)
* Takes in an adress of one cache that is change and sends it to the other 
* to have the validity bit set to 0
*/

//Just added all the macros because probably will use

module cache_coherenter(
    input clock, reset,
    /* We should have a bit to see which cahce it is
    * coming from. Or we could have two inputs and
    * separate them by left cahce and right cache.
    */
    input [24:0] cache_change_0, cache_change_1,

    output reg [15:0] cache_invalidate_0, cache_invalidate_1

);

    always @(cache_change_0) begin
        if(cache_change_0[`CPU_REQUEST_COMMAND] == `WRITE) begin
            cache_invalidate_1 <= cache_change_0[`INVALIDATE_ADDRESS];
        end
    end

    always @(cache_change_1) begin
        if(cache_change_1[`CPU_REQUEST_COMMAND] == `WRITE) begin
            cache_invalidate_0 <= cache_change_1[`INVALIDATE_ADDRESS];
        end
    end
//Something like below. THIS WILL CHANGE.
//Probably need an idle so once the output is sent, it goes back to idle
endmodule