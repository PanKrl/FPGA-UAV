
module nios_security (
	clk_clk,
	duty_1_export,
	duty_2_export,
	duty_3_export,
	duty_4_export,
	i2c_sda_in,
	i2c_scl_in,
	i2c_sda_oe,
	i2c_scl_oe,
	led_export,
	period_export,
	reset_reset_n,
	stop_export,
	uart1_rxd,
	uart1_txd);	

	input		clk_clk;
	output	[31:0]	duty_1_export;
	output	[31:0]	duty_2_export;
	output	[31:0]	duty_3_export;
	output	[31:0]	duty_4_export;
	input		i2c_sda_in;
	input		i2c_scl_in;
	output		i2c_sda_oe;
	output		i2c_scl_oe;
	output	[31:0]	led_export;
	output	[31:0]	period_export;
	input		reset_reset_n;
	output	[31:0]	stop_export;
	input		uart1_rxd;
	output		uart1_txd;
endmodule
