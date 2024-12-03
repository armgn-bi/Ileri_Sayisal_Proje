module writeback (
   input  [31:0]              alu_out_o,  // Giriş olarak ALU çıkışı
   output [31:0]              result_o
);

   assign result_o = alu_out_o; // ALU çıkışını sonuç olarak atar

endmodule