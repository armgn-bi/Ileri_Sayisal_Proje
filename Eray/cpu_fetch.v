module cpu_fetch (
   input                clk_i,  
   input                rst_i,        // reset
   output reg [31:0]    pc_o          // 32 bit program sayaç çıkışı
);

   
   parameter INITIAL_PC = 32'h0000_0000; //0 değerine atadım

   always @(posedge clk_i or posedge rst_i) begin
      if (rst_i) begin                
         pc_o <= INITIAL_PC;         // 0' atadım
      end else begin
         pc_o <= pc_o + 4;           // Program sayacını 4'er artır
      end
   end

endmodule