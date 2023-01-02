`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2022 09:56:28
// Design Name: 
// Module Name: test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test();
reg [7:0]a[7:0];
reg clk,reset;
wire [31:0]o;

riscv_r DUT(a,clk,reset,o);
initial
clk=0;
always
#30 clk=~clk;

initial 
begin
reset=0;
 a='{8'b01000000,8'b01010011,8'b00000101,8'b00110011,8'b00000000,8'b01010011,8'b00000100,8'b10110011};
//add x9,x6,x5
// sub x10,x6,x5
#250 $finish;
end

endmodule
