	nios_security u0 (
		.clk_clk       (<connected-to-clk_clk>),       //    clk.clk
		.duty_export   (<connected-to-duty_export>),   //   duty.export
		.led_export    (<connected-to-led_export>),    //    led.export
		.period_export (<connected-to-period_export>), // period.export
		.reset_reset_n (<connected-to-reset_reset_n>), //  reset.reset_n
		.stop_export   (<connected-to-stop_export>),   //   stop.export
		.uart_rxd      (<connected-to-uart_rxd>),      //   uart.rxd
		.uart_txd      (<connected-to-uart_txd>),      //       .txd
		.sw_export     (<connected-to-sw_export>)      //     sw.export
	);

