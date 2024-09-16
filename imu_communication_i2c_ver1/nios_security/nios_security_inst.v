	nios_security u0 (
		.clk_clk       (<connected-to-clk_clk>),       //    clk.clk
		.duty_1_export (<connected-to-duty_1_export>), // duty_1.export
		.duty_2_export (<connected-to-duty_2_export>), // duty_2.export
		.duty_3_export (<connected-to-duty_3_export>), // duty_3.export
		.duty_4_export (<connected-to-duty_4_export>), // duty_4.export
		.i2c_sda_in    (<connected-to-i2c_sda_in>),    //    i2c.sda_in
		.i2c_scl_in    (<connected-to-i2c_scl_in>),    //       .scl_in
		.i2c_sda_oe    (<connected-to-i2c_sda_oe>),    //       .sda_oe
		.i2c_scl_oe    (<connected-to-i2c_scl_oe>),    //       .scl_oe
		.led_export    (<connected-to-led_export>),    //    led.export
		.period_export (<connected-to-period_export>), // period.export
		.reset_reset_n (<connected-to-reset_reset_n>), //  reset.reset_n
		.stop_export   (<connected-to-stop_export>),   //   stop.export
		.uart1_rxd     (<connected-to-uart1_rxd>),     //  uart1.rxd
		.uart1_txd     (<connected-to-uart1_txd>)      //       .txd
	);

