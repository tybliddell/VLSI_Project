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

    initial begin
        reset_cache();

        $display("Beginning tests");
        cpu_request = { 1'd1, 16'd55, 16'd13 };
        cpu_request_ready = 1'd1;
        while(memory_request_ready == 1'd0)
            #period;
        memory_response = 16'd55;
        memory_response_ready = 1'd1;
        while(data_out == 1'd0)
            #period;
        $display(data_out);
        cpu_request_ready = 1'd0;
        cpu_request = 33'd0;
        #period;
        cpu_request = { 1'd0, 16'd128, 16'd13 };
        cpu_request_ready = 1'd1;
        while(data_out_ready == 1'd0)
            #period;
        $display(data_out);
        

        $stop;
    end
endmodule