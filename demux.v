`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:12:00 11/23/2020 
// Design Name: 
// Module Name:    demux 
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

module demux #(
		parameter MST_DWIDTH = 32,
		parameter SYS_DWIDTH = 8
	)(
		// Clock and reset interface
		input clk_sys,
		input clk_mst,
		input rst_n,
		
		//Select interface
		input[1:0] select,
		
		// Input interface
		input [MST_DWIDTH -1  : 0]	 data_i,
		input 						 	 valid_i,
		
		//output interfaces
		output reg [SYS_DWIDTH - 1 : 0] 	data0_o,
		output reg     						valid0_o,
		
		output reg [SYS_DWIDTH - 1 : 0] 	data1_o,
		output reg     						valid1_o,
		
		output reg [SYS_DWIDTH - 1 : 0] 	data2_o,
		output reg     						valid2_o
    );
	//daca crapa, reset in always
	
	reg [SYS_DWIDTH - 1 : 0] data0_o_next, data1_o_next, data2_o_next;
	reg [5:0] i;
	reg valid0_o_next, valid1_o_next, valid2_o_next, valid_i_next;
	
	

	always@(posedge clk_mst) begin
	
		if(!rst_n)begin
				data0_o <= 0;
				data1_o <= 0;
				data2_o <= 0;
				
				valid0_o <= 0;
				valid1_o <= 0;
				valid2_o <= 0;
			end
			
			else begin
			
			valid_i_next <= valid_i;
	
			end
	end
	
	always@(posedge clk_sys) begin
	
		if(!rst_n)begin
				data0_o <= 0;
				data1_o <= 0;
				data2_o <= 0;
				
				valid0_o <= 0;
				valid1_o <= 0;
				valid2_o <= 0;
			end
			
			else begin
			
			data0_o <= data0_o_next;
			data1_o <= data1_o_next;
			data2_o <= data2_o_next;
			
			valid0_o <= valid0_o_next;
			valid1_o <= valid1_o_next;
			valid2_o <= valid2_o_next;
			end
	end
	
	
	always @(*)begin
	
	
	for(i=0; i<4; i=i+1)begin
		case(select)
				2'b00: begin
					if(valid_i_next)begin
						data0_o_next <= data_i[(3-i)*8 +: 8];
						valid0_o_next <= 1;
					end
				end
				
				2'b01: begin
					if(valid_i_next)begin
						data1_o_next <= data_i[(3-i)*8 +: 8];
						valid1_o_next <= 1;
					end
				end
				
				2'b10: begin
					if(valid_i_next)begin
						data2_o_next <= data_i[(3-i)*8 +: 8];
						valid2_o_next <= 1;
					end
				end
				
				/*default: begin
					valid_o <= 0;
					data_o <= 0;
				end*/
			endcase
	
	end
	
	
	
	
	end
	
	
	
endmodule
