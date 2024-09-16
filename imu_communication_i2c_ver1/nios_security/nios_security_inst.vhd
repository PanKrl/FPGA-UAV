	component nios_security is
		port (
			clk_clk       : in  std_logic                     := 'X'; -- clk
			duty_1_export : out std_logic_vector(31 downto 0);        -- export
			duty_2_export : out std_logic_vector(31 downto 0);        -- export
			duty_3_export : out std_logic_vector(31 downto 0);        -- export
			duty_4_export : out std_logic_vector(31 downto 0);        -- export
			i2c_sda_in    : in  std_logic                     := 'X'; -- sda_in
			i2c_scl_in    : in  std_logic                     := 'X'; -- scl_in
			i2c_sda_oe    : out std_logic;                            -- sda_oe
			i2c_scl_oe    : out std_logic;                            -- scl_oe
			led_export    : out std_logic_vector(31 downto 0);        -- export
			period_export : out std_logic_vector(31 downto 0);        -- export
			reset_reset_n : in  std_logic                     := 'X'; -- reset_n
			stop_export   : out std_logic_vector(31 downto 0);        -- export
			uart1_rxd     : in  std_logic                     := 'X'; -- rxd
			uart1_txd     : out std_logic                             -- txd
		);
	end component nios_security;

	u0 : component nios_security
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --    clk.clk
			duty_1_export => CONNECTED_TO_duty_1_export, -- duty_1.export
			duty_2_export => CONNECTED_TO_duty_2_export, -- duty_2.export
			duty_3_export => CONNECTED_TO_duty_3_export, -- duty_3.export
			duty_4_export => CONNECTED_TO_duty_4_export, -- duty_4.export
			i2c_sda_in    => CONNECTED_TO_i2c_sda_in,    --    i2c.sda_in
			i2c_scl_in    => CONNECTED_TO_i2c_scl_in,    --       .scl_in
			i2c_sda_oe    => CONNECTED_TO_i2c_sda_oe,    --       .sda_oe
			i2c_scl_oe    => CONNECTED_TO_i2c_scl_oe,    --       .scl_oe
			led_export    => CONNECTED_TO_led_export,    --    led.export
			period_export => CONNECTED_TO_period_export, -- period.export
			reset_reset_n => CONNECTED_TO_reset_reset_n, --  reset.reset_n
			stop_export   => CONNECTED_TO_stop_export,   --   stop.export
			uart1_rxd     => CONNECTED_TO_uart1_rxd,     --  uart1.rxd
			uart1_txd     => CONNECTED_TO_uart1_txd      --       .txd
		);

