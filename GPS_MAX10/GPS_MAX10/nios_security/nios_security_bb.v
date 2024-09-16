
module nios_security (
	clk_clk,
	gps_export,
	reset_reset_n,
	stop_export,
	uart1_rxd,
	uart1_txd);	

	input		clk_clk;
	input	[15:0]	gps_export;
	input		reset_reset_n;
	output	[31:0]	stop_export;
	input		uart1_rxd;
	output		uart1_txd;
endmodule
