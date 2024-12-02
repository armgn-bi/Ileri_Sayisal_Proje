module cpu_pipeline (
   input                clk_i,        
   input                rst_i,        
   input [31:0]         inst_f_i,     // bellekten gelen buyruk sinyali
   output reg [31:0]    inst_d_o      // pşpeline kaydedicisinin çıkışı 
);

   initial begin
      inst_d_o = 32'b0;              // 0 değeri atadım
   end

  
   always @(posedge clk_i or posedge rst_i) begin
      if (rst_i) begin              
         inst_d_o <= 32'b0;          
      end else begin                  
         inst_d_o <= inst_f_i;     // çıkışa ata
      end
   end

endmodule