module cpu_decode (
   input                   clk_i,               
   input                   regfile_wen_i,       // yazma işleminin aktif olup olmadığını belirtir
   input [2:0]             imm_ext_sel_i,       // hangi genişletme yönteminin kullanılacağını belirler
   input [31:0]            inst_i,              // işlem yapmak için gereken talimatı içerir.
   input [31:0]            result_i,           
   output [31:0]           reg_a_o,             //ilk kaynak kaydedicinin çıkışı
   output [31:0]           reg_b_o,             // ikinci kaynak kaydedicinin çıkışı
   output reg [31:0]       imm_ext_o            // genişletilmiş ivedi değer çıkış
);

   reg [31:0] regfile [31:0];

   wire [4:0] reg_a_addr      = inst_i[19:15]; 
   wire [4:0] reg_b_addr      = inst_i[24:20]; 
   wire [4:0] target_reg_addr  = inst_i[11:7];

  //asenkron okuma yapar
   assign reg_a_o = (reg_a_addr == 5'b0) ? 32'b0 : regfile[reg_a_addr]; // olup olmadığını kontrol eder aşağıdaki da öyle
   assign reg_b_o = (reg_b_addr == 5'b0) ? 32'b0 : regfile[reg_b_addr]; //32 bitlik sıfır döner ya da yandakş adrese atar


   always @(posedge clk_i) begin
      if (regfile_wen_i) begin
         regfile[target_reg_addr] <= result_i; // yazma yetkisi varsa hedef kaydediciye sonucu yaz
      end
   end

   // ivedi genişletici işlwm
   always @(*) begin
      case (imm_ext_sel_i)
         3'b000   : imm_ext_o = {{20{inst_i[31]}}, inst_i[31:20]}; // ivedi genişletici işlwm
         default  : imm_ext_o = 32'b0; // diğer koşullar için sıfır 
      endcase
   end

endmodule