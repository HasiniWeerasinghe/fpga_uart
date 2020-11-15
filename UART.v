/* Module - UART Module (Tested upto 1M baudrate)
	Note - Non parity Version
	Author - Sandaru Jayawardana
*/
module UART 
	#(parameter clock_divider = 11'd25) // -------->    baud rate = 9600  d1302<- 12.5MHz
	(
	input	data_ready,//inform uart that the sending data is ready and it can read them
	input rx,// rx physical pin
	input uart_clk,// input clock
	input read_uart,// default 25MHz
	input [7:0]data_in,// data bus
	output [7:0]data_out,// data bus
	output reg transmit_end = 1'b1,// high when tx idle
	output reg rx_available,// receive data ready
	output reg tx= 1'b1// tx physical 
	);
	
	// Both Rx and Tx in this module
	
	parameter idle= 4'd0, start= 4'd1, data0= 4'd2, data1= 4'd3, data2= 4'd4, data3= 4'd5, data4= 4'd6, data5= 4'd7, data6= 4'd8, data7= 4'd9, end1= 4'd10;

	reg [10:0]count=11'd1;
	reg tx_ready= 1'b0;
	reg [3:0]tx_state=idle; // 0<- idle, 1<- start, 2<- data0, 3<- data1, 4<- data2, 5<- data3, 6<- data4, 7<- data5, 8<- data6, 9<- data7, 2<- end1, 11<- end2
	reg [7:0] tx_buffer;// tx register
	reg [7:0] rx_buffer;// rx register
	assign data_out=(rx_available==1'b1)? rx_buffer:8'b0;
	
//______________________________________ Tx_________________________________________//	

	always@ (negedge uart_clk)
		begin
			if (transmit_end==1'b1 && data_ready==1'b1 && tx_ready==1'b0)
				begin
					tx_ready<=1'b1;
					tx_buffer<=data_in;
				end
			else
				begin
					if (transmit_end==1'b0)
						begin
							tx_ready<=1'b0;
						end
				end
		end
		
	always@ (posedge uart_clk)
		begin
			case (tx_state)
					idle:
						begin
							tx<=1'b1;
							if (tx_ready ==1'b1)
								begin
									tx_state<= start;
									transmit_end <= 1'b0;
								end
						end
					start:
							begin
								tx<=1'b0;
								//count=count+10'd1;
								if (count==clock_divider)
									begin
										count<=11'd1;
										tx_state<= data0;
									end
								else
									begin
										count<=count+11'd1;
									end
							end
					data0:
							begin
								if (tx_buffer[0] ==1'b1)
									begin
										tx<=1'b1;
									end
								//count=count+10'd1;
								if (count==clock_divider)
									begin
										count<=11'd1;
										tx_state<= data1;
									end
								else
									begin
										count<=count+11'd1;
									end
							end
					data1:
							begin
								if (tx_buffer[1] ==1'b1)
									begin
										tx<=1'b1;
									end
								else
									begin
										tx<=1'b0;
									end
								//count=count+10'd1;
								if (count==clock_divider)
									begin
										count<=11'd1;
										tx_state<= data2;
									end
								else
									begin
										count<=count+11'd1;
									end
							end
					data2:
							begin
								if (tx_buffer[2] ==1'b1)
									begin
										tx<=1'b1;
									end
								else
									begin
										tx<=1'b0;
									end
								//count=count+10'd1;
								if (count==clock_divider)
									begin
										count<=11'd1;
										tx_state<= data3;
									end
								else
									begin
										count<=count+11'd1;
									end
							end
					data3:
							begin
								if (tx_buffer[3] ==1'b1)
									begin
										tx<=1'b1;
									end
								else
									begin
										tx<=1'b0;
									end
								//count=count+10'd1;
								if (count==clock_divider)
									begin
										count<=11'd1;
										tx_state<= data4;
									end
								else
									begin
										count<=count+11'd1;
									end
							end
					data4:
							begin
								if (tx_buffer[4] ==1'b1)
									begin
										tx<=1'b1;
									end
								else
									begin
										tx<=1'b0;
									end
								//count=count+10'd1;
								if (count==clock_divider)
									begin
										count<=11'd1;
										tx_state<= data5;
									end
								else
									begin
										count<=count+11'd1;
									end
							end
					data5:
							begin
								if (tx_buffer[5] ==1'b1)
									begin
										tx<=1'b1;
									end
								else
									begin
										tx<=1'b0;
									end
								//count=count+10'd1;
								if (count==clock_divider)
									begin
										count<=10'd1;
										tx_state<= data6;
									end
								else
									begin
										count<=count+10'd1;
									end
							end
					data6:
							begin
								if (tx_buffer[6] ==1'b1)
									begin
										tx<=1'b1;
									end
								else
									begin
										tx<=1'b0;
									end
								//count=count+10'd1;
								if (count==clock_divider)
									begin
										count<=11'd1;
										tx_state<= data7;
									end
								else
									begin
										count<=count+11'd1;
									end
							end
					data7:
							begin
								if (tx_buffer[7] ==1'b1)
									begin
										tx<=1'b1;
									end
								else
									begin
										tx<=1'b0;
									end
								//count=count+10'd1;
								if (count==clock_divider)
									begin
										count<=11'd1;
										tx_state<= end1;
									end
								else
									begin
										count<=count+11'd1;
									end
							end
					
					end1:
							begin
								tx<=1'b1;
								//count=count+10'd1;
								if (count==clock_divider)
									begin
										count<=11'd1;
										tx_state<= idle;
										transmit_end <= 1'b1;
									end
								else
									begin
										count<=count+11'd1;
									end
							end
				endcase
		end	

//______________________________________ Rx_________________________________________//

	reg [3:0]rx_state = idle; // 0<- idle, 1<- start, 2<- data0, 3<- data1, 4<- data2, 5<- data3, 6<- data4, 7<- data5, 8<- data6, 9<- data7, 2<- end1, 11<- end2
	reg receive_end = 1'b0;
	reg [10:0]count2 = 11'b1;
	parameter clock_divider_half = 11'd12; // baud rate = 9600 d651<-12.5MHz
	
	reg read_data=1'b0;
	reg last_receive_end=1'b0;
	always@ (negedge uart_clk)
		begin
			if (receive_end == 1'b1 && last_receive_end==1'b0)
				begin
					read_data=1'b0;
				end
			else
				begin
					if (read_uart==1'b1)
						begin
							read_data=1'b1;
						end
				end
			if (receive_end == 1'b0 || read_data == 1'b1)
				begin
					rx_available=1'b0;
				end
			else
				begin
					rx_available=1'b1;
				end
			last_receive_end=receive_end;
		end
	

			
	always@ (posedge uart_clk)
		begin
			case (rx_state)
					idle:
							if (rx==1'b0)
								begin
									rx_state<=start;
								end
					start:
							begin
								//count2 = count2+ 11'b1;
								if (count2 ==clock_divider_half)
									begin
										receive_end <= 1'b0;
										rx_state<= data0;
										count2 <= 11'b1;
									end
								else
									begin
										if (rx ==1'b0)
											begin
												count2<=count2+11'd1;
											end
										else
											begin
												rx_state<= idle;
												count2 <= 11'b1;
											end
									end
							end
					data0:
							begin
								//count2 = count2+ 5'b1;
								if (count2 ==clock_divider)
									begin
										if (rx ==1'b1)
											begin
												rx_buffer[0]<=1'b1;
											end
										else
											begin
												rx_buffer[0]<=1'b0;
											end
										
										rx_state<= data1;
										count2 <= 11'b1;
									end
								else
									begin
										count2<=count2+11'd1;
									end
							end
					data1:
							begin
								//count2 = count2+ 5'b1;
								if (count2 ==clock_divider)
									begin
										if (rx ==1'b1)
											begin
												rx_buffer[1]<=1'b1;
											end
										else
											begin
												rx_buffer[1]<=1'b0;
											end
										
										rx_state<= data2;
										count2 <= 11'b1;
									end
								else
									begin
										count2<=count2+11'd1;
									end
							end
					data2:
							begin
								//count2 = count2+ 5'b1;
								if (count2 ==clock_divider)
									begin
										if (rx ==1'b1)
											begin
												rx_buffer[2]<=1'b1;
											end
										else
											begin
												rx_buffer[2]<=1'b0;
											end
										
										rx_state<= data3;
										count2 <= 11'b1;
									end
								else
									begin
										count2<=count2+11'd1;
									end
							end
					data3:
							begin
								//count2 = count2+ 5'b1;
								if (count2 ==clock_divider)
									begin
										if (rx ==1'b1)
											begin
												rx_buffer[3]<=1'b1;
											end
										else
											begin
												rx_buffer[3]<=1'b0;
											end
										
										rx_state<= data4;
										count2 <= 11'b1;
									end
								else
									begin
										count2<=count2+11'd1;
									end
							end
					data4:
							begin
								//count2 = count2+ 5'b1;
								if (count2 ==clock_divider)
									begin
										if (rx ==1'b1)
											begin
												rx_buffer[4]<=1'b1;
											end
										else
											begin
												rx_buffer[4]<=1'b0;
											end
										
										rx_state<= data5;
										count2 <= 11'b1;
									end
								else
									begin
										count2<=count2+11'd1;
									end
							end
					data5:
							begin
								//count2 = count2+ 5'b1;
								if (count2 ==clock_divider)
									begin
										if (rx ==1'b1)
											begin
												rx_buffer[5]<=1'b1;
											end
										else
											begin
												rx_buffer[5]<=1'b0;
											end
										
										rx_state<= data6;
										count2 <= 11'b1;
									end
								else
									begin
										count2<=count2+11'd1;
									end
							end
					data6:
							begin
								//count2 = count2+ 5'b1;
								if (count2 ==clock_divider)
									begin
										if (rx ==1'b1)
											begin
												rx_buffer[6]<=1'b1;
											end
										else
											begin
												rx_buffer[6]<=1'b0;
											end
										
										rx_state<= data7;
										count2 <= 11'b1;
									end
								else
									begin
										count2<=count2+11'd1;
									end
							end
					data7:
							begin
								//count2 = count2+ 5'b1;
								if (count2 ==clock_divider)
									begin
										if (rx ==1'b1)
											begin
												rx_buffer[7]<=1'b1;
											end
										else
											begin
												rx_buffer[7]<=1'b0;
											end
										
										rx_state<= end1;
										count2 <= 1'b1;
									end
								else
									begin
										count2<=count2+11'd1;
									end
							end
					end1:
							begin
								//count2 = count2+ 5'b1;
								if (count2 ==clock_divider)
									begin
										rx_state<= idle;
										count2 <= 11'b1;
										receive_end <= 1'b1;
									end
								else
									begin
										count2<=count2+11'd1;
									end
							end
				endcase
	end
endmodule 

