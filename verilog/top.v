module top (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    output wire [7:0] data_out
);

    // Internal signals
    wire [7:0] internal_signal;

    // Instantiate sub-modules
    chip u1 (
        .clk_i(clk),
        .res_i(reset),
        .data_in(data_in),
        .data_out(internal_signal)
    );

    memory u2 (
        .clk_i(clk),
        .reset(reset),
        .data_in(internal_signal),
        .data_out(data_out)
    );

endmodule