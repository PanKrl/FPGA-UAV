	component nios_security is
		port (
			clk_clk       : in  std_logic                     := 'X'; -- clk
			led_export    : out std_logic_vector(31 downto 0);        -- export
			reset_reset_n : in  std_logic                     := 'X'; -- reset_n
			stop_export   : out std_logic_vector(31 downto 0);        -- export
			uart1_rxd     : in  std_logic                     := 'X'; -- rxd
			uart1_txd     : out std_logic                             -- txd
		);
	end component nios_security;

	u0 : component nios_security
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --   clk.clk
			led_export    => CONNECTED_TO_led_export,    --   led.export
			reset_reset_n => CONNECTED_TO_reset_reset_n, -- reset.reset_n
			stop_export   => CONNECTED_TO_stop_export,   --  stop.export
			uart1_rxd     => CONNECTED_TO_uart1_rxd,     -- uart1.rxd
			uart1_txd     => CONNECTED_TO_uart1_txd      --      .txd
		);

