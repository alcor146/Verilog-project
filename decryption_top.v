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

module decryption_top#(
			parameter addr_witdth = 8,
			parameter reg_width 	 = 16,
			parameter MST_DWIDTH = 32,
			parameter SYS_DWIDTH = 8
		)(
		// Clock and reset interface
		input clk_sys,
		input clk_mst,
		input rst_n,
		
		// Input interface
		input [MST_DWIDTH -1 : 0] data_i,
		input 						  valid_i,
		output busy,
		
		//output interface
		output [SYS_DWIDTH - 1 : 0] data_o,
		output      					 valid_o,
		
		// Register access interface
		input[addr_witdth - 1:0] addr,
		input read,
		input write,
		input [reg_width - 1 : 0] wdata,
		output[reg_width - 1 : 0] rdata,
		output done,
		output error
		
    );
	 
	 reg busy0, busy1, busy2, valid0, valid1, valid2;
	 reg [SYS_DWIDTH - 1 : 0] data0, data1, data2;
	 reg [reg_width - 1 : 0] select, caesar_key, scytale_key, zigzag_key;
	 reg [SYS_DWIDTH - 1 : 0] datao_caesar, datao_scy, datao_zig;
	 
	 decryption_regfile DR(clk_sys, rst_n, addr, read, write, wdata, rdata, done, error, select, caesar_key, scytale_key, zigzag_key);
	 demux D(clk_sys, clk_mst, rst_n, select[1:0], data_i, valid_i, data0, valid0, data1, valid1, data2, valid2);
	 caesar_decryption C(clk_sys, rst_n, data0, valid0, caesar_key, datao_caesar,  valid0, busy0);
	 scytale_decryption S(clk_sys, rst_n, data1, valid1, scytale_key[15:8], scytale_key[7:0], datao_scytale,  valid1, busy1);
	 zigzag_decryption Z(clk_sys, rst_n, data2, valid2, zigzag_key[7:0], datao_zigzig, valid2, busy2);
	 mux M(clk_sys, rst_n, select[1:0], data_o, valid_o, datao_caesar, valid0, datao_scytale,  valid1, datao_zigzig, valid2);
	
	 or(busy, busy0, busy1, busy2);
	

endmodule
