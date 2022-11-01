`include "macros.vh"

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