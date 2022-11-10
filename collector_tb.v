`timescale 1 ns/10 ps

module collector_tb;
    localparam period = 20;
    localparam half_period = period / 2;
    reg clock, reset, serial_in, ready;
    wire [24:0] data;

    input_collector #(.OUTPUT_WIDTH(25)) collector(.serial_in(serial_in), .fast_clk(clock), .ready(ready), .data(data), .reset(reset));

    integer i;

    always #half_period begin
        clock = ~clock;
    end
 
    task reset_collector;
        begin
            clock = 1'b0;
            reset = 1'b1;
            serial_in = 1'd0;
            ready = 1'd0;
            #period;
            reset = 1'd0;
            #period;
            reset = 1'd1;
            #period;
            $display("[status] reset collector");
        end
    endtask

    task check_data;
        input [24:0] expected;
        begin
            if(data != expected) begin
                $display("[ERROR] result:%d expected:%d\nError on Line Number = %0d",data,expected,`__LINE__);
                $stop;
            end
        end
    endtask

    task write_data;
        input [24:0] wdata;
        begin
            ready = 1'd0;
            for(i = 0; i < 25; i=i+1) begin
                serial_in = wdata[i];
                #period;
            end
            ready = 1'd1;
        end
    endtask

    initial begin
        reset_collector();
        $display("[status] beginning tests");
        check_data(25'd0);
        write_data(25'd3461);
        check_data(25'd3461);

        write_data(25'd69);
        check_data(25'd69);
        
        reset_collector();
        write_data(25'd1111111111111111111111111);
        check_data(25'd1111111111111111111111111);
        
        reset_collector();
        write_data(25'd0000000000000000000000000);
        check_data(25'd0000000000000000000000000);

        $display("[status] all tests passed :)");
        $stop;
    end
endmodule