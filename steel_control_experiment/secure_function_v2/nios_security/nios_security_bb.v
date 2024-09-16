
module nios_security (
	clk_clk,
	duty_export,
	led0_export,
	led1_export,
	led2_export,
	led3_export,
	led4_export,
	led5_export,
	led6_export,
	led7_export,
	period_export,
	pwm_in_export,
	pwm_out_export,
	reset_reset_n,
	stop_export,
	sw_export,
	uart_rxd,
	uart_txd,
	led8_export,
	led9_export);	

	input		clk_clk;
	output	[31:0]	duty_export;
	output	[31:0]	led0_export;
	output		led1_export;
	output		led2_export;
	output		led3_export;
	output		led4_export;
	output		led5_export;
	output		led6_export;
	output		led7_export;
	output	[31:0]	period_export;
	input		pwm_in_export;
	output		pwm_out_export;
	input		reset_reset_n;
	output	[31:0]	stop_export;
	input		sw_export;
	input		uart_rxd;
	output		uart_txd;
	output		led8_export;
	output		led9_export;
endmodule
