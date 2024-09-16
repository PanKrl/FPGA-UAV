	component nios_security is
		port (
			clk_clk       : in  std_logic                     := 'X'; -- clk
			duty_export   : out std_logic_vector(31 downto 0);        -- export
			led0_export   : out std_logic_vector(31 downto 0);        -- export
			led1_export   : out std_logic;                            -- export
			led2_export   : out std_logic;                            -- export
			led3_export   : out std_logic;                            -- export
			led4_export   : out std_logic;                            -- export
			led5_export   : out std_logic;                            -- export
			led6_export   : out std_logic;                            -- export
			led7_export   : out std_logic;                            -- export
			led8_export   : out std_logic;                            -- export
			led9_export   : out std_logic;                            -- export
			period_export : out std_logic_vector(31 downto 0);        -- export
			reset_reset_n : in  std_logic                     := 'X'; -- reset_n
			stop_export   : out std_logic_vector(31 downto 0);        -- export
			sw_export     : in  std_logic                     := 'X'; -- export
			uart_rxd      : in  std_logic                     := 'X'; -- rxd
			uart_txd      : out std_logic                             -- txd
		);
	end component nios_security;

	u0 : component nios_security
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --    clk.clk
			duty_export   => CONNECTED_TO_duty_export,   --   duty.export
			led0_export   => CONNECTED_TO_led0_export,   --   led0.export
			led1_export   => CONNECTED_TO_led1_export,   --   led1.export
			led2_export   => CONNECTED_TO_led2_export,   --   led2.export
			led3_export   => CONNECTED_TO_led3_export,   --   led3.export
			led4_export   => CONNECTED_TO_led4_export,   --   led4.export
			led5_export   => CONNECTED_TO_led5_export,   --   led5.export
			led6_export   => CONNECTED_TO_led6_export,   --   led6.export
			led7_export   => CONNECTED_TO_led7_export,   --   led7.export
			led8_export   => CONNECTED_TO_led8_export,   --   led8.export
			led9_export   => CONNECTED_TO_led9_export,   --   led9.export
			period_export => CONNECTED_TO_period_export, -- period.export
			reset_reset_n => CONNECTED_TO_reset_reset_n, --  reset.reset_n
			stop_export   => CONNECTED_TO_stop_export,   --   stop.export
			sw_export     => CONNECTED_TO_sw_export,     --     sw.export
			uart_rxd      => CONNECTED_TO_uart_rxd,      --   uart.rxd
			uart_txd      => CONNECTED_TO_uart_txd       --       .txd
		);

