module chip(
    input           clk_i,
    input           res_i,
    input    [31:0] instr_i,
    output   [31:0] instr_o
    );



    decode d1( //placeholder olarak yazdım içeriği değiştirilcek
        .instr_i(instr_i),
        .alu_ctrl_o(alu_ctrl),
        .mux_sel_o(mux_sel)
    );

    alu a1( //placeholder olarak yazdım içeriği değiştirilcek
        .alu_i(alu_i),
        .alu_ctrl(alu_ctrl_o), //decode modülünden gelen alu_ctrl_o sinyalini alu modülünün girişi olan alu_ctrl sinyaline bağladım.
        .reg_a(reg_a),
        .reg_b(reg_b),
        .alu_o(alu_o)
    );

    controller c1( //placeholder olarak yazdım içeriği değiştirilcek
        .instr_i(instr_i),
        .alu_ctrl_o(alu_ctrl_o),
        .mux_sel_o(mux_sel_o)
        .alu_ctrl(funct3)
    );

endmodule


// Decode modülünde rv32i ve rv32r için ayrılmış sinyalleri controller müdülüne getirip orada yapılacak işlemin olacağı modüle sinyal gönderilecek.


module decode(
    input    [31:0] instr_i,
    output   [3:0]  alu_ctrl_o,
    output   [2:0]  mux_sel_o
    );

    // rv32i için ayrılmış sinyaller
    wire  [6:0]   opcode = instr_i[6:0];
    wire  [4:0]   rd = instr_i[11:7];
    wire  [2:0]   funct3 = instr_i[14:12];
    wire  [4:0]   rs1 = instr_i[19:15];
    wire  [11:0]  imm = instr_i[31:20];

    // rv32r için ayrılmış sinyaller

    wire  [4:0]   rs2 = instr_i[24:20];
    wire  [6:0]   funct7 = instr_i[31:25];
    
endmodule


module controller(
    input    [31:0] instr_i,
    input    [3:0]  alu_ctrl,
    output   [3:0]  alu_ctrl_o,
    output   [2:0]  mux_sel_o
    );

    // 4 bit ALU kontrol sinyali    
    always @(*) begin
        case(alu_ctrl[3:0])
            3'b000 : alu_ctrl_o = 4'b0000;
            3'b001 : alu_ctrl_o = 4'b0001;
            3'b010 : alu_ctrl_o = 4'b0010;
            3'b011 : alu_ctrl_o = 4'b0011;
            3'b100 : alu_ctrl_o = 4'b0100;
            3'b101 : alu_ctrl_o = 4'b0101;
            3'b110 : alu_ctrl_o = 4'b0110;
            3'b111 : alu_ctrl_o = 4'b0111;
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
            4'b0001 : alu_o = reg_a << imm[4:0];
            4'b0010 : if (reg_a < reg_b) alu_o = 32'b1; else alu_o = 32'b0;
            4'b0011 : if (reg_a < reg_b) alu_o = 32'b1; else alu_o = 32'b0;
            4'b0100 : alu_o = reg_a ^ reg_b;
            4'b0101 : alu_o = reg_a >> imm[4:0];
            4'b0110 : alu_o = reg_a | reg_b;
            4'b0111 : alu_o = reg_a & reg_b;
            default : alu_o = 32'b0;
        endcase    
    end
endmodule
