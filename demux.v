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
	
	
	// TODO: Implement DEMUX logic
	
	reg [3:0] state = 0;
	
	reg [SYS_DWIDTH - 1 : 0] 	dataPart1;
	reg [SYS_DWIDTH - 1 : 0] 	dataPart2;
	reg [SYS_DWIDTH - 1 : 0] 	dataPart3;
	reg [SYS_DWIDTH - 1 : 0] 	dataPart4;
	// folosite pentru a imparti data_i in 4
	
	always @(posedge clk_sys) begin
		if(!rst_n) begin
			state <= 0;
			
			data0_o <= 0;
			data1_o <= 0;
			data2_o <= 0;
			
			valid0_o <= 0;
			valid1_o <= 0;
			valid2_o <= 0;
			
			// eventual si dataParts <= 0
		end
		
		case(state)
			'd0: begin
				if(valid_i) 
				// daca primim date, intram in ciclul de stari
					state <= 1;
			end
			
			'd1: begin
			// spargem chunk-ul de date in 4
			
				dataPart1 <= data_i[MST_DWIDTH-1 : MST_DWIDTH-SYS_DWIDTH];
				dataPart2 <= data_i[MST_DWIDTH-SYS_DWIDTH-1 : MST_DWIDTH-2*SYS_DWIDTH];
				dataPart3 <= data_i[MST_DWIDTH-2*SYS_DWIDTH-1 : MST_DWIDTH-3*SYS_DWIDTH];
				dataPart4 <= data_i[MST_DWIDTH-3*SYS_DWIDTH-1 : MST_DWIDTH-4*SYS_DWIDTH];
				state <= 2;
			end
			
			'd2: begin
			// mai asteptam in ciclu de ceas
			
				state <= 3;
			end
			
			'd3: begin
			// incepem afisarea deodata cu urmatorul ciclu de ceas
			
				state <= 4;
				case(select)
					'd0: begin
						valid0_o <= 1;
						data0_o <= dataPart1;
					end
					
					'd1: begin
						valid1_o <= 1;
						data1_o <= dataPart1;
					end
					
					'd2: begin
						valid2_o <= 1;
						data2_o <= dataPart1;
					end
				endcase
			end
			
			'd4: begin
			// continuam afisarea 
			
				state <= 5;
				case(select)
					'd0: begin
						data0_o <= dataPart2;
					end
					
					'd1: begin
						data1_o <= dataPart2;
					end
					
					'd2: begin
						data2_o <= dataPart2;
					end
				endcase
			end
			
			'd5: begin
			// continuam afisarea (a 3-a parte din datele de intrare)
			
				state <= 6;
				case(select)
					'd0: begin
						data0_o <= dataPart3;
					end
					
					'd1: begin
						data1_o <= dataPart3;
					end
					
					'd2: begin
						data2_o <= dataPart3;
					end
				endcase
			end
			
			'd6: begin
			// afisam ultima parte din datele primite
			
				case(select)
					'd0: begin
						data0_o <= dataPart4;
					end
					
					'd1: begin
						data1_o <= dataPart4;
					end
					
					'd2: begin
						data2_o <= dataPart4;
					end
				endcase
				
				if(valid_i) begin
				// daca intre timp am primit alte date, ne intoarcem in starea in care incepem afisarea lor
				
					dataPart1 <= data_i[MST_DWIDTH-1 : MST_DWIDTH-SYS_DWIDTH];
					dataPart2 <= data_i[MST_DWIDTH-SYS_DWIDTH-1 : MST_DWIDTH-2*SYS_DWIDTH];
					dataPart3 <= data_i[MST_DWIDTH-2*SYS_DWIDTH-1 : MST_DWIDTH-3*SYS_DWIDTH];
					dataPart4 <= data_i[MST_DWIDTH-3*SYS_DWIDTH-1 : MST_DWIDTH-4*SYS_DWIDTH];
					state <= 3;
				end
				else begin
				// nu am primit alte date de intrare
				
					state <= 7;
				end
				
			end
			
			'd7: begin
			// stopam orice afisare
			
				state <= 0;
				case(select)
					'd0: begin
						valid0_o <= 0;
						data0_o <= 0;
					end
					
					'd1: begin
						valid1_o <= 0;
						data1_o <= 0;
					end
					
					'd2: begin
						valid2_o <= 0;
						data2_o <= 0;
					end
				endcase
				
				
				
			end
			
			
		endcase
		
	end
	
	

endmodule
