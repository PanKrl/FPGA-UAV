
module nios2e (
	clk_clk,
	cycle_export,
	dip0_export,
	dip1_export,
	dip2_export,
	dip3_export,
	duty_export,
	led0_export,
	led1_export,
	led2_export,
	led3_export,
	led4_export,
	reset_reset_n,
	sw0_export,
	sw1_export,
	led5_export,
	led6_export,
	led7_export);	

	input		clk_clk;
	output	[27:0]	cycle_export;
	input		dip0_export;
	input	[15:0]	dip1_export;
	input		dip2_export;
	input		dip3_export;
	output	[27:0]	duty_export;
	output		led0_export;
	output		led1_export;
	output		led2_export;
	output		led3_export;
	output		led4_export;
	input		reset_reset_n;
	input	[15:0]	sw0_export;
	input	[15:0]	sw1_export;
	output		led5_export;
	output		led6_export;
	output		led7_export;
endmodule
