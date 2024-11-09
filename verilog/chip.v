module chip(
    input           clk_i,
    input           res_i,
    input    [31:0] instr_i,
    output   [31:0] instr_o
    );

    fetch f1 (
      .clk_i(clk_i),
      .rst_i(res_i),
      .pc_o(inst_o)
    );

    wire [31:0] fd2d_inst;

    fd_regs r1 (
      .clk_i(clk_i),
      .rst_i(res_i),
      .inst_f_i(inst_i),
      .inst_d_o(fd2d_inst)
    );

    // modüller arası kablolar eklenip aşağıda bağlantılar yapılacak.

    decode d1( //placeholder olarak yazdım içeriği değiştirilcek
        .instr_i(instr_i),
        .alu_ctrl_o(alu_ctrl),
        .decode_ctrl_i(decode_ctrl_o),
        .mux_sel_o(mux_sel)
    );

    alu a1( //placeholder olarak yazdım içeriği değiştirilcek
        .alu_i(alu_i),
        .alu_ctrl_i(alu_ctrl_o), //decode modülünden gelen alu_ctrl_o sinyalini alu modülünün girişi olan alu_ctrl sinyaline bağladım.
        .reg_a(reg_a),
        .reg_b(reg_b),
        .rd_i(rd),
        .rs1_i(rs1),
        .rs2_i(rs2),
        .imm_i(imm),
        .alu_o(alu_o)
    );

    controller c1( //placeholder olarak yazdım içeriği değiştirilcek
        .instr_i(instr_i),
        .alu_ctrl_o(alu_ctrl_o),
        .mux_sel_o(mux_sel_o)
        .alu_ctrl(funct3)
    );

    writeback w1( //placeholder olarak yazdım içeriği değiştirilcek
        .alu_out_i(alu_o),
        .result_o(result)
    );

endmodule

// moduller arası bağlantı yapılacak ve chip ile memory arasında bağlantı yapılacak.

module fetch (
   input                clk_i,
   input                rst_i,
   output reg [31:0]    pc_o
);

   always @(posedge clk_i, posedge rst_i) begin
      if (rst_i) begin // Sıfırlama sinyali geldiyse program sayacına başlangıç adresini ata
         pc_o <= 32'h0000_0000;
      end else begin // Saat sinyali geldiyse program sayacına 4 ekle
         pc_o <= pc_o + 4;
      end
   end

endmodule


module fd_regs (
   input                clk_i,
   input                rst_i,
   input [31:0]         inst_f_i, // Buyruk sinyali (bellekten geliyor)
   output reg [31:0]    inst_d_o  // Boru hattı kaydedicisinin çıkışı 
);

   always @(posedge clk_i, posedge rst_i) begin
      if (rst_i) begin
         inst_d_o <= 32'b0;
      end else begin
         inst_d_o <= inst_f_i;
      end
   end

endmodule


// decode modülü controllerdan aldığı sinyale göre gelen instructionu ayrıştırır.

module decode(
    input    [31:0] instr_i,
    input    [3:0]  decode_ctrl_i,
    output   [4:0]  rd,
    output   [2:0]  funct3,
    output   [4:0]  rs1,
    output   [4:0]  rs2,
    output   [6:0]  funct7,
    output   [11:0] imm
    );

    always @(*) begin
        case(decode_ctrl_i)
            4'b0000 : begin   // R-Type (Register)
                wire  [4:0]   rd = instr_i[11:7];
                wire  [2:0]   funct3 = instr_i[14:12];
                wire  [4:0]   rs1 = instr_i[19:15];
                wire  [4:0]   rs2 = instr_i[24:20];
                wire  [6:0]   funct7 = instr_i[31:25];
            end
            4'b0001 : begin   // I-Type (Immediate)
                wire  [4:0]   rd = instr_i[11:7];
                wire  [2:0]   funct3 = instr_i[14:12];
                wire  [4:0]   rs1 = instr_i[19:15];
                wire  [11:0]  imm = instr_i[31:20];
            end
            4'b0010 : begin   // I-Type (Load)
                wire  [4:0]   rd = instr_i[11:7];
                wire  [2:0]   funct3 = instr_i[14:12];
                wire  [4:0]   rs1 = instr_i[19:15];
                wire  [11:0]  imm = instr_i[31:20];
            end
            4'b0011 : begin   // S-Type (Store)
                wire [4:0] rs1 = instr_i[19:15];
                wire [4:0] rs2 = instr_i[24:20];
                wire [2:0] funct3 = instr_i[14:12];
                wire [11:0] imm = {instr_i[31:25], instr_i[11:7]}; // imm[11:5|4:0]
            end
            4'b0100 : begin   // B-Type (Branch)
                wire  [4:0]   rs1 = instr_i[19:15];
                wire  [4:0]   rs2 = instr_i[24:20];
                wire  [2:0]   funct3 = instr_i[14:12];
                wire  [12:0]  imm = {instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0}; // imm[12|10:5|4:1|11|0]
            end
            4'b0101 : begin   // J-Type (Jump)
                wire [4:0] rd = instr_i[11:7];
                wire [20:0] imm = {instr_i[31], instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0}; // imm[20|10:1|11|19:12|0]
            end
            4'b0110 : begin   // I-Type (Jump Register)
                wire  [4:0]   rd = instr_i[11:7];
                wire  [2:0]   funct3 = instr_i[14:12];
                wire  [4:0]   rs1 = instr_i[19:15];
                wire  [11:0]  imm = instr_i[31:20];
            end
            4'b0111 : begin   // U-Type (LUI)
                wire [4:0] rd = instr_i[11:7];
                wire [19:0] imm = instr_i[31:12]; // imm[31:12]
            end
            4'b1000 : begin   // U-Type (AUIPC)
                wire [4:0] rd = instr_i[11:7];
                wire [19:0] imm = instr_i[31:12]; // imm[31:12]
            end
            4'b1001 : begin   // I-Type (CSR)
                wire  [4:0]   rd = instr_i[11:7];
                wire  [2:0]   funct3 = instr_i[14:12];
                wire  [4:0]   rs1 = instr_i[19:15];
                wire  [11:0]  imm = instr_i[31:20];
            end
            default : begin   // Default
                wire  [4:0]   rd = 5'bxxxxx;
                wire  [2:0]   funct3 = 3'bxxx;
                wire  [4:0]   rs1 = 5'bxxxxx;
                wire  [4:0]   rs2 = 5'bxxxxx;
                wire  [6:0]   funct7 = 7'bxxxxxxx;
                wire  [11:0]  imm = 12'bxxxxxxxxxxxx;
            end
        endcase
    end   
endmodule

// controller modülü gelen instructiona göre decode kontrol sinyalini belirler.

module controller(
    input    [31:0] instr_i,
    input    [3:0]  alu_ctrl,
    output   [3:0]  alu_ctrl_o,
    output   [3:0]  decode_ctrl_o,
    output          alu_r,
    output   [2:0]  mux_sel_o
    );

    wire  [6:0]   opcode = instr_i[6:0];

    // gelen sinyalin opcode değerine göre decode bölümünden sinyalin nasıl ayrılması geretiğini belirleyen case yapısı.
    always @(*) begin
        case(opcode)
            7'b0110011 : begin // R-Type (Register)
                alu_r = 1'b1;
                decode_ctrl_o = 4'b0000;
            end            
            7'b0010011 : begin // I-Type (Immediate)
                alu_r = 1'b0;
                decode_ctrl_o = 4'b0001;
            end
            7'b0000011 : begin // I-Type (Load)
                alu_r = 1'b0;
                decode_ctrl_o = 4'b0010;
            end
            7'b0100011 : begin // S-Type (Store)
                alu_r = 1'b0;
                decode_ctrl_o = 4'b0011;
            end
            7'b1100011 : begin // B-Type (Branch)
                alu_r = 1'b0;
                decode_ctrl_o = 4'b0100;
            end
            7'b1101111 : begin // J-Type (Jump)
                alu_r = 1'b0;
                decode_ctrl_o = 4'b0101;
            end
            7'b1100111 : begin // I-Type (Jump Register)
                alu_r = 1'b0;
                decode_ctrl_o = 4'b0110;
            end
            7'b0110111 : begin // U-Type (LUI)
                alu_r = 1'b0;
                decode_ctrl_o = 4'b0111;
            end
            7'b0010111 : begin // U-Type (AUIPC)
                alu_r = 1'b0;
                decode_ctrl_o = 4'b1000;
            end
            7'b1110011 : begin // I-Type (CSR)
                alu_r = 1'b0;
                decode_ctrl_o = 4'b1001;
            end
            default : begin
                alu_r = 1'bx;
                decode_ctrl_o = 4'bxxxx; // Default
            end
        endcase
    end

    // 4 bit ALU kontrol sinyali    
    always @(*) begin
        case(alu_ctrl)
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
    end
endmodule


module alu(
    input      [31:0] alu_i,
    input       [3:0] alu_ctrl_i,
    input      [31:0] reg_a,
    input      [31:0] reg_b,
    input       [4:0] rd_i,
    input       [4:0] rs1_i,
    input       [4:0] rs2_i,
    input      [11:0] imm_i,
    output     [31:0] alu_o
    );

    assign   reg_a = rs1_i;
    assign   reg_b = alu_r ? rs2_i : imm_i;

    // alu girişini reg_a gibi değerlere ata
    // r ve i type veri için or tarzı bir şeyle atama yapsın

    always @(*) begin
        case(alu_ctrl_i)        
            4'b0000 : begin
                    always @(*) begin
                        if(alu_r) begin
                            if(funct7 == 7'b0100000) begin
                                alu_o = reg_a - reg_b;
                            end else begin
                                alu_o = reg_a + reg_b;
                            end                                
                        end else begin
                            alu_o = reg_a + reg_b;
                        end
                    end
            end
            4'b0001 : alu_o = reg_a << imm[4:0];
            4'b0010 : if (reg_a < reg_b) alu_o = 32'b1; else alu_o = 32'b0;
            4'b0011 : if (reg_a < reg_b) alu_o = 32'b1; else alu_o = 32'b0;
            4'b0100 : alu_o = reg_a ^ reg_b;
            4'b0101 : begin
                    always @(*) begin                        
                        if(funct7 == 7'b0100000) begin
                            alu_o = reg_a >>> imm[4:0];
                        end else begin
                            alu_o = reg_a >> imm[4:0];
                        end                                
                    end
            end
            4'b0110 : alu_o = reg_a | reg_b;
            4'b0111 : alu_o = reg_a & reg_b;
            default : alu_o = 32'b0;
        endcase    
    end
endmodule

module writeback (
   input  [31:0]              alu_out_i,
   output [31:0]              result_o
);

   assign result_o = alu_out_i;
   
endmodule

// deneme