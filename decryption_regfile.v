`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:13:49 11/23/2020 
// Design Name: 
// Module Name:    decryption_regfile 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module decryption_regfile #(
			parameter addr_witdth = 8,
			parameter reg_width 	 = 16
		)(
			// Clock and reset interface
			input clk, 
			input rst_n,
			
			// Register access interface
			input[addr_witdth - 1:0] addr,
			input read,
			input write,
			input [reg_width -1 : 0] wdata,
			output reg [reg_width -1 : 0] rdata,
			output reg done,
			output reg error,
			
			// Output wires
			output reg[reg_width - 1 : 0] select,
			output reg[reg_width - 1 : 0] caesar_key,
			output reg[reg_width - 1 : 0] scytale_key,
			output reg[reg_width - 1 : 0] zigzag_key
    );


	


	
	always @(posedge clk) begin
		
			if (rst_n == 0) begin
			select <= 'h00;
			caesar_key <= 'h00;
			scytale_key <= 'hFFFF;
			zigzag_key  <= 'h02;
			done <= 0;
			error <= 0;
			rdata <= 'h00;
			end
			
			else begin
			
			error <= 0;
			done <= 0;
				
				case(addr) 
				'h00: begin
							if(write == 1 && read==0) begin
							select <= {14'b0,wdata[1:0]};
							done <= 1;
							end
							else if(write == 0 && read == 1) begin
							rdata <= select; 
							done <= 1;
							end
						end
							
				'h10:	begin
							if(write == 1 && read==0) begin
							caesar_key <= wdata;
							done <= 1;
							end
							else if(write == 0 && read == 1) begin
							rdata <= caesar_key; 
							done <= 1;
							end	
						end
						
				'h12:	begin
							if(write == 1 && read==0) begin
							scytale_key <= wdata;
							done <= 1;
							end
							else if( write == 0 && read == 1) begin
							rdata <= scytale_key; 
							done <= 1;
							end	
						end
						
				'h14:	begin
							if(write == 1 && read==0) begin
							zigzag_key <= wdata;
							done <= 1;
							end
							else if(write == 0 && read == 1) begin
							rdata <= zigzag_key; 
							done <= 1;
							end		
						end
				default: begin
								error <= 1;
								done <= 1;
							end
	
			endcase			
		end
				
				
				
			
	end


	
endmodule
