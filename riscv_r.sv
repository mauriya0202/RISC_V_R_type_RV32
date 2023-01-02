`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2022 09:17:02
// Design Name: 
// Module Name: riscv_r
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

module riscv_r(input bit [7:0]a[7:0],input bit clk, input bit reset,output bit [31:0]o);


bit [7:0]pc_out;
bit [7:0]pc_in;

bit [31:0]machine_code;
bit [6:0]opcode,funct7;
bit [2:0]funct3;
bit [1:0]ALUOp;
bit [3:0]ALUOperation;
bit RegWrite;
bit [4:0]rs1,rs2,rd;
int k=0;

bit [31:0]read_data_1,read_data_2,write_data;


bit [7:0]Imemory[7:0];

reg [31:0]reg_file[31:0];
assign reg_file[5]=3'b11;
assign reg_file[6]=3'b111;
assign reg_file[1]=2'b10;

always@(posedge clk or posedge reset)
begin
o<=write_data;
if (reset)
		begin
		  pc_out<=0;
		  
			for (k=0; k<32; k=k+1) 
			begin
				reg_file[k] = 32'b0;
			end
		end 
else
    begin
    if(RegWrite)
    begin
    reg_file[rd]<=write_data;
    end
    pc_out<=pc_in;
    end
end

always_comb
begin
//program counter
pc_in=pc_out+4;

//instruction fetch
Imemory=a;
machine_code[31:24]=Imemory[pc_out+3];
machine_code[23:16]=Imemory[pc_out+2];
machine_code[15:8]=Imemory[pc_out+1];
machine_code[7:0]=Imemory[pc_out];

//instruction decode
opcode=machine_code[6:0];
rd=machine_code[11:7];
rs2=machine_code[24:20];
rs1=machine_code[19:15];
funct7=machine_code[31:25];
funct3=machine_code[14:12];

//control unit
  begin
  if(opcode==7'b0110011)
    begin
      ALUOp[0]=opcode[2];
      ALUOp[1]=opcode[4];
      RegWrite=1;
    end
  else
    begin
    RegWrite=0;
    end
	end
      
       //for ALU
  begin
    if(ALUOp==2'b10)
      begin
      if(~funct7[5] && ~funct3)
        ALUOperation=4'b0010;
      else if(funct7[5] && ~funct3)
   		ALUOperation=4'b0110;
      else
        
        ALUOperation=4'b0;
      end
    else
      
      ALUOperation=4'b0;
  end
  
 //ALU
 read_data_1=reg_file[rs1];
 read_data_2=reg_file[rs2];
 
if(ALUOperation==4'b0010)
write_data=read_data_1+read_data_2;
else if(ALUOperation==4'b0110)
write_data=read_data_1-read_data_2;
else 
write_data=32'b0;




end



endmodule
