# UART RTL
## Introduction
> This design controls the standard uart protocol (non-parity, 8bits). uart_controller is the top module and it can be matched to Avalon MM inteface (To read and write data to UART) and Avalon Conduit interface (TX and RX pins) with a fewer modufications. Further rx buffer size can change accordingly with fewr modifications. Baudrate can be simply set using parameter 'clock_divider' with mapping the module input clock and required baudrate as shown in below. 

* clock_divider = clk / (baudrate*4)
