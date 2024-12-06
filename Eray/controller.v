module controller (
   input [31:0]               inst_i,        // 32 bitlik bir giriş, boru hattından gelen komut
   output                     regfile_wen_o, // Kaydedici dosyasına yazma yetkisini kontrol eden bir sinyal
   output [2:0]               imm_ext_sel_o, // İvedi genişletici formatını seçen 3 bitlik bir sinyal
   output                     alu_sel_o,     // ALU ikinci işlenen seçim sinyali
   output reg [3:0]           alu_fun_o      // ALU da hangi işlemin yapılacağını belirten 4 bitlik bir sinyal
);
    wire [6:0] opcode = inst_i[6:0]; // Komutun ilk 7 biti
    wire [2:0] funct3 = inst_i[14:12]; // Komutun 12. ile 14. bitleri arasındaki 3 bitlik alan
    wire [6:0] funct7 = inst_i[31:25]; // Komutun 25. ile 31. bitleri arasındaki 7 bitlik alan
    wire [1:0] alu_dec; // ALU nun hangi işlemi yapacağını belirleyen 2 bitlik wire

    reg [6:0] control_signals; // 7 bitlik bir register kontrol sinyallerini saklayacak
    assign {regfile_wen_o, imm_ext_sel_o, alu_sel_o, alu_dec} = control_signals;

    always @(*) begin
      case (opcode)  
         7'b0110011  : control_signals = 7'b1_xxx_0_11; // R-type buyruk
         7'b0010011  : control_signals = 7'b1_000_1_11; // I-type buyruk
         7'b0000000  : control_signals = 7'b0_000_0_00; // Sıfırlama durumu
         default     : control_signals = 7'bx_xxx_x_xx; // Geçersiz buyruk
      endcase
   end

   
   wire sub = opcode[5] & funct7[5]; //Çıkarma işlemi olup olmadığını kontrol eder

   
   always @(*) begin
      case (alu_dec)
         2'b11    : // R-tipindeki veya I-tipindeki komutlar
            case (funct3)
               3'b000   : // add, addi veya sub komutları. Eğer sub sinyali aktifse, alu_fun_o çıkarma işlemi olarak ayarlanır aksi halde toplama işlemi.
                  if (sub) begin
                     alu_fun_o = 4'b0001; // sub
                  end else begin
                     alu_fun_o = 4'b0000; // add, addi
                  end
               3'b100   : alu_fun_o = 4'b0011; // xor, xori
               3'b110   : alu_fun_o = 4'b0100; // or, ori
               3'b111   : alu_fun_o = 4'b0010; // and, andi
               default  : alu_fun_o = 4'b0000;
            endcase
         default  : alu_fun_o = 4'b0000; // toplama işlemi
      endcase
   end