module top (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    output wire [7:0] data_out
);

    // Internal signals
    wire [31:0] inst;
    wire [31:0] inst_addr;

    // Instantiate sub-modules
    chip c1 (
        .clk_i(clk),
        .res_i(reset),
        .inst_i(inst),
        .inst_addr_o(inst_addr)
        .data_in(data_in),
        .data_out(internal_signal)
    );

    memory m1 (
        .clk_i(clk),
        .reset(reset),
        .wen_i(1'b0),
        .addr_i(inst_addr),
        .data_i(32'b0),
        .data_out(inst)
    );

endmodule