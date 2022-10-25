`timescale 1 ns/10 ps

module cache_tb;
    localparam period = 20;
    localparam half_period = period / 2;

    reg[32:0] cpu_request;
    reg[15:0] invalidate_address, memory_response;
    reg clock, reset, cpu_request_ready, memory_response_ready;

    wire [32:0] memory_request;
    wire [7:0] data_out;
    wire data_out_ready, memory_request_ready;

    cache uut(.cpu_request(cpu_request), .cpu_request_ready(cpu_request_ready), .clock(clock), .reset(reset),
    .invalidate_address(invalidate_address), .memory_response(memory_response), .memory_response_ready(memory_response_ready), 
    .memory_request(memory_request), .memory_request_ready(memory_request_ready), .data_out(data_out), .data_out_ready(data_out_ready));

    always #half_period begin
        clock = ~clock;
    end

    task reset_cache;
        begin
            clock = 1'b0;
            reset = 1'b1;
            cpu_request_ready = 1'd0;
            memory_response_ready = 1'd0;
            cpu_request = 33'd0;
            invalidate_address = 16'd0;
            memory_response = 16'd0;

            #period;
            reset = 1'd0;
            #period;
            reset = 1'd1;
            #period;
            $display("Cache reset");
        end
    endtask

    task write_value;
        input [15:0] data, address;
        begin
            cpu_request = { 1'd1, data, address };
            cpu_request_ready = 1'd1;

            while(data_out_ready == 1'd0 && memory_request_ready == 1'd0) begin
                #period;
            end
            // simulate memory
            if(memory_request_ready == 1'd1) begin
                memory_response = data;
                memory_response_ready = 1'd1;
                // wait for data
                while(data_out_ready == 1'd0) begin
                    #period;
                end
            end

            cpu_request = 33'd0;
            cpu_request_ready = 1'd0;
            memory_response = 16'd0;
            memory_response_ready = 1'd0;
        end
    endtask

    task read_value;
        input [15:0] expected_data, address;
        begin
            cpu_request = { 1'd0, 16'd0, address };
            cpu_request_ready = 1'd1;
            while(data_out_ready == 1'd0 && memory_request_ready == 1'd0) begin
                #period;
            end
            // simulate memory
            if(memory_request_ready == 1'd1) begin
                memory_response = expected_data;
                memory_response_ready = 1'd1;
                // wait for data
                while(data_out_ready == 1'd0) begin
                    #period;
                end
            end

            cpu_request = 33'd0;
            cpu_request_ready = 1'd0;
            memory_response = 16'd0;
            memory_response_ready = 1'd0;
        end
    endtask

    task check_data;
        input [7:0] expected;
        begin
            if(data_out != expected) begin
                $display("[error] result:%b expected:%b\nError on Line Number = %0d",data_out,55,`__LINE__);
                $stop;
            end
        end
    endtask

    initial begin
        reset_cache();

        $display("Beginning tests");
        write_value(16'd55, 16'd13);
        check_data(8'd55);

        read_value(16'd55, 16'd13);
        check_data(8'd55);
            
        $display("All tests passed :)");
        $stop;
    end
endmodule