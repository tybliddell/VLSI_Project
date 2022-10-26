`timescale 1 ns/10 ps

module cache_tb;
    localparam period = 20;
    localparam half_period = period / 2;

    reg[65_534 * 8:0] sim_memory;

    reg[24:0] cpu_request;
    reg[15:0] invalidate_address, memory_response;
    reg clock, reset, cpu_request_ready, memory_response_ready;

    wire [24:0] memory_request;
    wire [7:0] data_out;
    wire data_out_ready, memory_request_ready;

    cache uut(.cpu_request(cpu_request), .cpu_request_ready(cpu_request_ready), .clock(clock), .reset(reset),
    .invalidate_address(invalidate_address), .memory_response(memory_response), .memory_response_ready(memory_response_ready), 
    .memory_request(memory_request), .memory_request_ready(memory_request_ready), .data_out(data_out), .data_out_ready(data_out_ready));

    always #half_period begin
        clock = ~clock;
    end

    /* reset the cache to all invalid, inputs to 0, and sim_memory to 0 */
    task reset_cache;
        begin
            clock = 1'b0;
            reset = 1'b1;
            cpu_request_ready = 1'd0;
            memory_response_ready = 1'd0;
            cpu_request = 25'd0;
            invalidate_address = 16'd0;
            memory_response = 16'd0;
            sim_memory = 65_535'd0;
            #period;
            reset = 1'd0;
            #period;
            reset = 1'd1;
            #period;
            $display("[status] cache reset");
        end
    endtask

    /* Write data to address. */
    task write_value;
        input [7:0] data;
        input [15:0] address;
        begin
            #period;
            cpu_request = { 1'd1, data, address };
            cpu_request_ready = 1'd1;

            while(data_out_ready == 1'd0 && memory_request_ready == 1'd0) begin
                #period;
            end
            // simulate memory
            if(memory_request_ready == 1'd1) begin
                sim_memory[address * 8+:8] = data;
                // starting at address * 8 bits going to address * 8 + 16 bits
                if(address[0] == 1'b0)
                    memory_response = sim_memory[address * 8+:16];
                // starting at (address - 1) * 8 bits going to (address - 1) * 8 + 16 bits
                else
                    memory_response = sim_memory[(address - 1) * 8+:16];
                memory_response_ready = 1'd1;
                // wait for data
                while(data_out_ready == 1'd0) begin
                    #period;
                end
            end

            cpu_request = 25'd0;
            cpu_request_ready = 1'd0;
            memory_response = 16'd0;
            memory_response_ready = 1'd0;
        end
    endtask

    /* Read data from address */
    task read_value;
        input [15:0] address;
        begin
            #period;
            cpu_request = { 1'd0, 8'd0, address };
            cpu_request_ready = 1'd1;
            while(data_out_ready == 1'd0 && memory_request_ready == 1'd0) begin
                #period;
            end
            // simulate memory
            if(memory_request_ready == 1'd1) begin
                // starting at address * 8 bits going to address * 8 + 16 bits
                if(address[0] == 1'b0)
                    memory_response = sim_memory[address * 8+:16];
                // starting at (address - 1) * 8 bits going to (address - 1) * 8 + 16 bits
                else
                    memory_response = sim_memory[(address - 1) * 8+:16];
                memory_response_ready = 1'd1;
                // wait for data
                while(data_out_ready == 1'd0) begin
                    #period;
                end
            end

            cpu_request = 25'd0;
            cpu_request_ready = 1'd0;
            memory_response = 16'd0;
            memory_response_ready = 1'd0;
        end
    endtask

    /* Makes sure that data_out is the expected 8 bit value */
    task check_data;
        input [7:0] expected;
        begin
            if(data_out != expected) begin
                $display("[ERROR] result:%b expected:%b\nError on Line Number = %0d",data_out,55,`__LINE__);
                $stop;
            end
        end
    endtask

    initial begin
        reset_cache();

        $display("[status] beginning tests");
        write_value(8'd55, 16'd12);
        check_data(8'd55);

        write_value(8'd56, 16'd13);
        check_data(8'd56);
        read_value(16'd12);
        check_data(8'd55);

        read_value(16'd13);
        check_data(8'd56);

        write_value(8'd34, 16'd13);
        check_data(8'd34);
        read_value(16'd13);
        check_data(8'd34);

        write_value(8'd21, 16'd12);
        check_data(8'd21);
        read_value(16'd12);
        check_data(8'd21);
        read_value(16'd13);
        check_data(8'd34);
        read_value(16'd12);
        check_data(8'd21);
        $display("[status] all tests passed :)");
        $stop;
    end
endmodule