module alu (
   input                      alu_sel_i,   //rs veya imm
   input [3:0]                alu_fun_i,   // işlem seçim sinyali
   input [31:0]               reg_a_i,    //rs1
   input [31:0]               reg_b_i,     //rs2
   input [31:0]               imm_ext_i,   //imm
   output reg [31:0]          alu_out_o   
);

   wire signed [31:0] alu_a = reg_a_i; //iki yerde de aynı 
   wire signed [31:0] alu_b = alu_sel_i ? imm_ext_i : reg_b_i; // seçim sinyaline göre imm veya rs2 değeri olur


   always @(*) begin
      alu_out_o = 32'b0; //varsayılan değer 

      case (alu_fun_i)
         4'b0000: alu_out_o = alu_a + alu_b;  // oplama 
         4'b0001: alu_out_o = alu_a - alu_b;  // çıkarma
         4'b0010: alu_out_o = alu_a & alu_b;  // ve
         4'b0011: alu_out_o = alu_a ^ alu_b;  // XOR
         4'b0100: alu_out_o = alu_a | alu_b;  // veya
         default: alu_out_o = 32'bx;
      endcase
   end

endmodule