`define REG_SIZE $clog2(OUTPUT_WIDTH)
/*
* Populate data, pull ready to be high, and then wait at least
* OUTPUT_WIDTH + 1 clock cylces
* 
*/
module output_emitter
#(parameter OUTPUT_WIDTH = 16)
(
    input [OUTPUT_WIDTH-1:0] data,
    input fast_clk,
    input ready,
    input reset,
    output reg serial_out,
    output reg serial_done
);

    reg [`REG_SIZE:0] counter;

    always @(posedge fast_clk) begin
        if(!reset) begin
            serial_out <= 1'd0;
            serial_done <= 1'd0;
            counter <= {`REG_SIZE{'d0}};
        end
        else if(ready) begin
            serial_out <= data[counter];
            if(counter < OUTPUT_WIDTH) begin
                counter <= counter + 1'd1;
                serial_out <= 1'd0;
            end
            else begin
                serial_out <= 1'd0;
            end
        end
        else if(!ready) begin
            counter <= {`REG_SIZE{'d0}};
            serial_out <= 1'd0;
            serial_done <= 1'd0;
        end
    end
endmodule