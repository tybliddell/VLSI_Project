/*
* Expects serial_in to be sent in starting with the least significant bit
*/
module input_collector
#(parameter OUTPUT_WIDTH = 16)
(
    input serial_in,
    input fast_clk,
    input ready,
    input reset,
    output reg [OUTPUT_WIDTH-1:0] data
);

    always @(posedge fast_clk) begin
        if(!reset) begin
            data <= {OUTPUT_WIDTH{1'd0}};
        end
        else if(!ready) begin
            data <= { serial_in, data[OUTPUT_WIDTH-1:1] };
        end
    end
endmodule