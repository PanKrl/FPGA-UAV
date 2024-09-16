	component nios2e is
		port (
			clk_clk       : in  std_logic                     := 'X';             -- clk
			cycle_export  : out std_logic_vector(27 downto 0);                    -- export
			duty_export   : out std_logic_vector(27 downto 0);                    -- export
			reset_reset_n : in  std_logic                     := 'X';             -- reset_n
			sw1_export    : in  std_logic_vector(15 downto 0) := (others => 'X'); -- export
			sw2_export    : in  std_logic_vector(15 downto 0) := (others => 'X'); -- export
			sw3_export    : in  std_logic_vector(15 downto 0) := (others => 'X')  -- export
		);
	end component nios2e;

	u0 : component nios2e
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --   clk.clk
			cycle_export  => CONNECTED_TO_cycle_export,  -- cycle.export
			duty_export   => CONNECTED_TO_duty_export,   --  duty.export
			reset_reset_n => CONNECTED_TO_reset_reset_n, -- reset.reset_n
			sw1_export    => CONNECTED_TO_sw1_export,    --   sw1.export
			sw2_export    => CONNECTED_TO_sw2_export,    --   sw2.export
			sw3_export    => CONNECTED_TO_sw3_export     --   sw3.export
		);

