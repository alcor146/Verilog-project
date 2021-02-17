`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:24:12 11/27/2020 
// Design Name: 
// Module Name:    scytale_decryption 
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
module scytale_decryption#(
			parameter D_WIDTH = 8, 
			parameter KEY_WIDTH = 8, 
			parameter MAX_NOF_CHARS = 50,
			parameter START_DECRYPTION_TOKEN = 8'hFA
		)(
			// Clock and reset interface
			input clk,
			input rst_n,
			
			// Input interface
			input[D_WIDTH - 1:0] data_i,
			input valid_i,
			
			// Decryption Key
			input[KEY_WIDTH - 1 : 0] key_N,
			input[KEY_WIDTH - 1 : 0] key_M,
			
			// Output interface
			output reg[D_WIDTH - 1:0] data_o,
			output reg valid_o,
			
			output reg busy
    );

			reg [D_WIDTH*MAX_NOF_CHARS-1:0] input_tot;
			reg [KEY_WIDTH-1:0] i, counter;
		
always @(posedge clk) begin
			
			if(!rst_n) begin
				data_o <= 0;
				valid_o <= 0;
				busy <= 0;
				i <= 0;
				input_tot <= 0;
			end
			
		
			if(valid_i) begin
				if(data_i == START_DECRYPTION_TOKEN) begin //daca intalnesc FA, nu mai citesc
					i <= 0;
					busy <= 1;	
				end
				else begin
					input_tot[i*8 +: 8] <= data_i;		//citesc datele
					if((i + key_M) > (key_M*key_N-1))	//daca urm element citind pe coloane e in afara matricii
						i <= i-(key_M*key_N-1) + key_M;	//ma duc la elementul de pe coloana urmatoare, linia 0
					else
						i <= i + key_M;		//altfel ma duc la elementul de dedesubt
					
				end
				
			end
			
			if(busy)begin
				if(i >= key_M*key_N) begin 	//am terminat de scris si reinitializez semnalele
					valid_o <= 0;
					busy <= 0;
					i <= 0;
					input_tot <= 0;
				end
				else begin 					//scriu elementele in ordine din matrice (visual vorbind, am datele intr un vector)
					valid_o <= 1;
					data_o <= input_tot[i*8 +: 8];
					i <= i+1;
				end
			end
				
end



endmodule
