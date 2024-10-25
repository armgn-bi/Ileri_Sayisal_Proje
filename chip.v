module chip(
    input           clk_i,
    input           res_i,
    input    [31:0] instr_i,
    output   [31:0] instr_o
    );

    decode d1(
        .instr_i(instr_i),
        .alu_ctrl_o(alu_ctrl),
        .mux_sel_o(mux_sel)
    );

    alu a1(
        .alu_i(alu_i),
        .alu_ctrl(alu_ctrl_o),
        .reg_a(reg_a),
        .reg_b(reg_b),
        .alu_o(alu_o)
    );

endmodule


module decode(
    input    [31:0] instr_i,
    output   [3:0]  alu_ctrl_o,
    output   [2:0]  mux_sel_o
    );

    // verilen sinyali rv32i komutlarına göre çözümleyecek kod yazılacak
    // çözümlenmiş sinyali oppcode res rd1 gibi şeylere ayırıp kaydedicek 

    // 4 bit ALU kontrol sinyali    
    always @(*) begin
        case(instr_i[31:28])
            4'b0000 : alu_ctrl_o = 4'b0000;
            4'b0001 : alu_ctrl_o = 4'b0001;
            4'b0010 : alu_ctrl_o = 4'b0010;
            4'b0011 : alu_ctrl_o = 4'b0011;
            4'b0100 : alu_ctrl_o = 4'b0100;
            4'b0101 : alu_ctrl_o = 4'b0101;
            default : alu_ctrl_o = 4'bxxxx;
        endcase
        case(instr_i[27:25])
            3'b000 : mux_sel_o = 3'b000;
            default : mux_sel_o = 3'b000;
        endcase
    end
endmodule


module alu(
    input      [31:0] alu_i,
    input       [3:0] alu_ctrl,
    input      [31:0] reg_a,
    input      [31:0] reg_b,
    output     [31:0] alu_o
    );

    always @(*) begin
        case(alu_ctrl)
            4'b0000 : alu_o = reg_a + reg_b;
            default : alu_o = 32'b0;
        endcase    
    end
endmodule