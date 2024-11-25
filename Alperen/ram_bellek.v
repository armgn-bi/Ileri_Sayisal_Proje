`timescale 1ns / 1ps


module ram_bellek(
    input clk_i,    //saat sinyalimiz
    input wen_i,    //yazma yetkilendirme girisi
    input [31:0] addr_i,    // okunacak ya da yazilacak verinin adresi geliyor
    input [31:0] data_i,    // bellege yazilacak veri buradan girer
    input [31:0] data_o     // bellekten okunan veriyi buradan cikariyoruz
    );
    
    reg [31:0] mem [511:0]; // mem adinda 32 bit 512 satirlik bir memory blok olusturduk. 
    
    assign data_o = mem[addr_i[31:2]]; //asenkron bir sekilde addr_i degistikce data okuyor.
    
    always @(posedge clk_i) begin
        if(wen_i) begin  //her clk basina yetkilendirme aciksa iceri giriyor
            mem[addr_i[31:2]] <= data_i;
        end
    end
    

    
endmodule
