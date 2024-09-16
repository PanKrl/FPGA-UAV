
module nios2e (
	clk_clk,
	cycle_export,
	duty_export,
	reset_reset_n,
	sw1_export,
	sw2_export,
	sw3_export);	

	input		clk_clk;
	output	[27:0]	cycle_export;
	output	[27:0]	duty_export;
	input		reset_reset_n;
	input	[15:0]	sw1_export;
	input	[15:0]	sw2_export;
	input	[15:0]	sw3_export;
endmodule
