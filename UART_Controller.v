/* Module - UART Controller Module
	Author - Sandaru Jayawardana
*/ 

module UART_Controller(tx_finish_led,rx_availble_led,tx_led, rx_led, tx_signal_btn, clk, tx_btn, rx_btn, tx_pin, rx_pin);
	output [7:0]tx_led; // Transmit data indication leds (optional)
	output [7:0]rx_led; // Receive data indication leds (optional)
	output tx_pin; // Tx pin in UART
	input rx_pin; // Rx pin in UART
	
	output tx_finish_led; // indicate End of the data trasnmission 
	output rx_availble_led;
	input  [7:0]tx_signal_btn; // Transmit data set using switches (Dip switches). This can be done using another module
	input clk; // 50 MHZ clock (if the input clock is different then new_clk signal should be mapped accordingly)
	input tx_btn; // transmission start signal (active low)
	input rx_btn; // Clear receive data buffer (active low)
	
	
	wire data_ready_btn, read_rx_btn;
	reg new_clk=1'b0;
	
	//reg count =1'b0; // This can be used to mapped the 'new_clk' clock signal to the 25 MHz depending on the 'clk' clock input (current 50MHz)
	always@ (posedge clk)
		begin
			//if (count == 1'b1)
				//begin
					//count=1'b0;
			new_clk=~new_clk;
				//end
//			else
//				begin
//					count=count+1'b1;
//				end
		end

	
	assign data_ready_btn=~tx_btn;
	assign read_rx_btn=~rx_btn;
	assign tx_led=tx_signal_btn;
	UART uart_module(.uart_clk(new_clk), .tx(tx_pin), .rx(rx_pin), .data_in(tx_signal_btn), .data_out(rx_led), .data_ready(data_ready_btn), .transmit_end(tx_finish_led), .read_uart(read_rx_btn), .rx_available(rx_availble_led));//(uart_clk, tx, rx, data_in, data_out, data_ready, transmit_end, read_uart, rx_available)
	
endmodule 