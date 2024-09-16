	component nios2e is
		port (
			clk_clk       : in  std_logic                     := 'X';             -- clk
			cycle_export  : out std_logic_vector(27 downto 0);                    -- export
			dip0_export   : in  std_logic                     := 'X';             -- export
			dip1_export   : in  std_logic_vector(15 downto 0) := (others => 'X'); -- export
			dip2_export   : in  std_logic                     := 'X';             -- export
			dip3_export   : in  std_logic                     := 'X';             -- export
			duty_export   : out std_logic_vector(27 downto 0);                    -- export
			led0_export   : out std_logic;                                        -- export
			led1_export   : out std_logic;                                        -- export
			led2_export   : out std_logic;                                        -- export
			led3_export   : out std_logic;                                        -- export
			led4_export   : out std_logic;                                        -- export
			reset_reset_n : in  std_logic                     := 'X';             -- reset_n
			sw0_export    : in  std_logic_vector(15 downto 0) := (others => 'X'); -- export
			sw1_export    : in  std_logic_vector(15 downto 0) := (others => 'X'); -- export
			led5_export   : out std_logic;                                        -- export
			led6_export   : out std_logic;                                        -- export
			led7_export   : out std_logic                                         -- export
		);
	end component nios2e;

	u0 : component nios2e
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --   clk.clk
			cycle_export  => CONNECTED_TO_cycle_export,  -- cycle.export
			dip0_export   => CONNECTED_TO_dip0_export,   --  dip0.export
			dip1_export   => CONNECTED_TO_dip1_export,   --  dip1.export
			dip2_export   => CONNECTED_TO_dip2_export,   --  dip2.export
			dip3_export   => CONNECTED_TO_dip3_export,   --  dip3.export
			duty_export   => CONNECTED_TO_duty_export,   --  duty.export
			led0_export   => CONNECTED_TO_led0_export,   --  led0.export
			led1_export   => CONNECTED_TO_led1_export,   --  led1.export
			led2_export   => CONNECTED_TO_led2_export,   --  led2.export
			led3_export   => CONNECTED_TO_led3_export,   --  led3.export
			led4_export   => CONNECTED_TO_led4_export,   --  led4.export
			reset_reset_n => CONNECTED_TO_reset_reset_n, -- reset.reset_n
			sw0_export    => CONNECTED_TO_sw0_export,    --   sw0.export
			sw1_export    => CONNECTED_TO_sw1_export,    --   sw1.export
			led5_export   => CONNECTED_TO_led5_export,   --  led5.export
			led6_export   => CONNECTED_TO_led6_export,   --  led6.export
			led7_export   => CONNECTED_TO_led7_export    --  led7.export
		);

