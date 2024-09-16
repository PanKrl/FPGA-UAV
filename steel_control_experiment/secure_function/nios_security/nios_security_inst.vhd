	component nios_security is
		port (
			clk_clk       : in  std_logic                     := 'X'; -- clk
			duty_export   : out std_logic_vector(31 downto 0);        -- export
			led_export    : out std_logic_vector(31 downto 0);        -- export
			period_export : out std_logic_vector(31 downto 0);        -- export
			reset_reset_n : in  std_logic                     := 'X'; -- reset_n
			stop_export   : out std_logic_vector(31 downto 0);        -- export
			uart_rxd      : in  std_logic                     := 'X'; -- rxd
			uart_txd      : out std_logic;                            -- txd
			sw_export     : in  std_logic                     := 'X'  -- export
		);
	end component nios_security;

	u0 : component nios_security
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --    clk.clk
			duty_export   => CONNECTED_TO_duty_export,   --   duty.export
			led_export    => CONNECTED_TO_led_export,    --    led.export
			period_export => CONNECTED_TO_period_export, -- period.export
			reset_reset_n => CONNECTED_TO_reset_reset_n, --  reset.reset_n
			stop_export   => CONNECTED_TO_stop_export,   --   stop.export
			uart_rxd      => CONNECTED_TO_uart_rxd,      --   uart.rxd
			uart_txd      => CONNECTED_TO_uart_txd,      --       .txd
			sw_export     => CONNECTED_TO_sw_export      --     sw.export
		);

