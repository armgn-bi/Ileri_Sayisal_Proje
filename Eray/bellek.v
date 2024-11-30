module memory (
   input          clk_i,        // saat sinyal girişi
   input          wen_i,        // write enable
   input [31:0]   addr_i,       // bellek adresi girişi
   input [31:0]   data_i,       // yazılcak veri girişi
   output [31:0]  data_o        // okunacak veri çıkışı
); 
   reg [31:0] mem [511:0];       

   assign data_o = mem[addr_i[31:2]]; // adresin en üst 30 bitini kullanarak veri okur

   always @(posedge clk_i) begin  // saat sinyalinin pozitif kenarında tetiklen
      if (wen_i) begin            
         mem[addr_i[31:2]] <= data_i; 
      end
   end

endmodule