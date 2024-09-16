
module nios_security (
	clk_clk,
	duty_export,
	led_export,
	period_export,
	reset_reset_n,
	stop_export,
	uart_rxd,
	uart_txd,
	sw_export);	

	input		clk_clk;
	output	[31:0]	duty_export;
	output	[31:0]	led_export;
	output	[31:0]	period_export;
	input		reset_reset_n;
	output	[31:0]	stop_export;
	input		uart_rxd;
	output		uart_txd;
	input		sw_export;
endmodule
