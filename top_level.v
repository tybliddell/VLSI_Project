module top_level(
    input clock, reset,
    input [24:0] cpu_request_0, cpu_request_1,
    input cpu_request_ready_0, cpu_request_ready_1,
    input [15:0] memory_response_0, memory_response_1,
    input memory_response_ready_0, memory_response_ready_1,

    output [7:0] data_out_0, data_out_1,
    output data_out_ready_0, data_out_ready_1,
    output [24:0] memory_request_0, memory_request_1,
    output memory_request_ready_0, memory_request_ready_1
);
    wire [15:0] invalidate_address_0, invalidate_address_1;

    cache cache_0(.cpu_request(cpu_request_0), .cpu_request_ready(cpu_request_ready_0), .clock(clock), .reset(reset),
    .invalidate_address(invalidate_address_0), .memory_response(memory_response_0), .memory_response_ready(memory_response_ready_0),
    .memory_request(memory_request_0), .memory_request_ready(memory_request_ready_0), .data_out(data_out_0), .data_out_ready(data_out_ready_0));
    cache cache_1(.cpu_request(cpu_request_1), .cpu_request_ready(cpu_request_ready_1), .clock(clock), .reset(reset),
    .invalidate_address(invalidate_address_1), .memory_response(memory_response_1), .memory_response_ready(memory_response_ready_1),
    .memory_request(memory_request_1), .memory_request_ready(memory_request_ready_1), .data_out(data_out_1), .data_out_ready(data_out_ready_1));
    
    cache_coherenter coherenter(.cache_change_0(memory_request_0), .cache_change_1(memory_request_1), .cache_invalidate_0(invalidate_address_0), .cache_invalidate_1(invalidate_address_1),
                                .clock(clock), .reset(reset));

endmodule