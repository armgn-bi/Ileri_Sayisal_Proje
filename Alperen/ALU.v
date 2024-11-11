`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////


module ALU(
    input   alu_sel_i,  // Ikinci islenenin secim sinyali (rs2 veya imm)
    input[3:0]   alu_fun_i,  //Islem secim sinyali
    input[31:0]  reg_a_i,    //rs1 degeri   
    input[31:0]  reg_b_i,    //rs2 degeri
    input[31:0]  imm_ext_i,  //imm degeri
    output reg[31:0] alu_out_o  //sonuc degerimiz, reg_file'da rd olarak yazilacak!
    );
    
    
    wire signed [31:0] alu_a = reg_a_i; //Birinci islenen (rs1) hem R type hem I type'da aynidir
    
    wire signed [31:0] alu_b = alu_sel_i ? imm_ext_i : reg_b_i; //alu_sel_i 1 ise imm okunacak, 0 ise reg_b yani rs2 okunacak.
                                                                //imm I-TYPE Buyruklarda var,   rs2 ise R-TYPE buyruklarda var.
    always @(*) begin
    
        case(alu_fun_i)
            4'b0000: alu_out_o = alu_a + alu_b; //toplama
            4'b0001: alu_out_o = alu_a - alu_b; //cikarma
            4'b0010: alu_out_o = alu_a &  alu_b; //ve
            4'b0011: alu_out_o = alu_a ^ alu_b; //xor
            4'b0100: alu_out_o = alu_a |  alu_b;    //veya
            default: alu_out_o = 32'bx; //gecersiz sinyal
         endcase
    end
    
endmodule
