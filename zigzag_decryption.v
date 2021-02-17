`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:33:04 11/23/2020 
// Design Name: 
// Module Name:    zigzag_decryption 
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
module zigzag_decryption #(
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
			input[KEY_WIDTH - 1 : 0] key,
			
			// Output interface
			output reg[D_WIDTH - 1:0] data_o,
			output reg valid_o,
			output reg busy
    );

	reg [D_WIDTH*MAX_NOF_CHARS-1:0] input_tot;
	reg [5:0] i, j, k, x,  counter1, counter2, refj, refk, refx;
	

always @(posedge clk) begin
			
			if(!rst_n) begin
				data_o <= 0;
				valid_o <= 0;
				busy <= 0;
	
				i <= 0;
				j <= 0;
				k <= 0;
				x <= 0;
				
				input_tot <= 0;
				counter1 <= 0;
				counter2 <= 0;
			
			end
			
			if(valid_i) begin
				if(data_i == START_DECRYPTION_TOKEN) begin 	// daca am intalnit caracterul FA
					i <= 0; 
					
					j <= 0; 		//pozitia primului element de pe linia 1 la keia 3
					refj <= 0; 		// referinta la care ne raportam ca sa stim daca am scris deja un element de pe linia respectiva
					
					if((counter1 - (counter1>>2)*4) == 0) begin			//in functie de rest, incrementam sau nu k si x
						k <= (counter1>>2); 							//pozitia primului element de pe linia 1 cand restul este 0
						refk <= (counter1>>2); 							//pozitia lui k anterioara pe care o sa o actualizez dupa fiecare ciclu
							
						x <=((counter1>>2) + (counter1>>1)); 		//pozitia primului element de pe linia 3
						refx <=((counter1>>2) + (counter1>>1));		// pozitia sa anterioara
					end
					
					else if((counter1 - (counter1>>2)*4) == 1) begin	//rest = 1
						k <= ((counter1>>2)+1); 						//inca un element pe prima linie, deci k trebuie incrementat
						refk <= ((counter1>>2)+1);
						
						x <= (((counter1>>2)+1) + ((counter1>>2)*2)); 	// k + elem de pe a doua linie
						refx <= (((counter1>>2)+1) + ((counter1>>2)*2));
					end
					
					else if(counter1[1:0] >= 2) begin 					//restul 2 sau 3 influenteaza in acelasi mod pozitiile
						k <= ((counter1>>2) +1);						//atat nr de elem de pe prima linie cat si de pe a doua sunt increentate
						refk <= ((counter1>>2) +1);
						
						x <=(((counter1>>2)+1) + (((counter1>>2)*2) + 1));
						refx <=(((counter1>>2)+1) + (((counter1>>2)*2) + 1));
					end
					
					busy <= 1;
					
				end
				else begin
					input_tot[i*8 +: 8] <= data_i; 						//daca nu am intalnit caracterul FA, continuam citirea
						i <= i + 1;
						counter1 <= counter1 + 1;
				end
			end
			
			if(busy)begin
				
				if(counter1 == counter2) begin 							// am scris atatea elem cate am citit si ii dam reset
					valid_o <= 0;
					busy <= 0;
					input_tot <= 0;
					
					i <= 0;
					j <= 0;
					k <= 0;
					x <= 0;
					counter1 <= 0;
					counter2 <= 0;
				end
				else begin
					if(key == 2) begin 
						valid_o <= 1;
						data_o <= input_tot[i*8 +: 8];
						if(i+(counter1 - (counter1 >> 1)) > (counter1-1))  		//daca adunam nr de elemente de pe prima linie si iesim din vector elementele nenule ale vectorului
							i <= i - (counter1 - (counter1>>1) - 1); 			//ne intarcem la pozitia anterioara +1
						else
							i <= i+ counter1 - (counter1>>1); 					// altfel adunam numarul de elemente de pe prima linie ca sa ajungem la elementul de pe a doua linie
						
						counter2 <= counter2 +1; 								//mergem la urm elem
						
					end
					
					else if(key == 3) begin
						
						valid_o <= 1;
						
						if(j == refj && k == refk && x == refx) begin 			//daca pozitiile sunt egale cu pozitiile anterioare, punem pe ooutput elementul de pe prima linie
							data_o <= input_tot[j*8 +: 8];
							j <= j + 1;
						end 
						else if(j > refj && k == refk && x == refx)begin 		//daca j este mai mare, am scris deja un elem de pe prima linie si trecem la a doua
							data_o <= input_tot[k*8 +: 8];
							k <= k + 1;
							
						end 
						else if(j > refj && k > refk && x == refx)begin 		//la fel pentru a 3 a linie
							data_o <= input_tot[x*8 +: 8];
							x <= x + 1;
						end 
						else if(j > refj && k > refk && x > refx) begin 		// daca am scris deja cate un elem de pe fiecare linie, scriem inca un elem de pe linia 2 si terminam ciclul
							
							refj <= j;											//setam din nou referintele(valorile anterioare) la valorile actuale
							refk <= k +1;
							refx <= x;
							
							data_o <= input_tot[k*8 +: 8];
							k <= k + 1;
						end
						
						counter2 <= counter2 +1;		
					end
				end
			end
		end
	
endmodule
