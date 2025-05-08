LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY lshift_8bit IS
    PORT(
        data_in  : IN  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit input data
        GClock, i_enable, GReset, i_load : IN  STD_LOGIC;  -- load control added
        data_out : OUT STD_LOGIC_VECTOR(7 downto 0)   -- 8-bit output data
    );
END lshift_8bit;

ARCHITECTURE structural OF lshift_8bit IS

    SIGNAL regData     : STD_LOGIC_VECTOR(7 downto 0);  -- holds current shift register state
    SIGNAL transData, shiftedData   : STD_LOGIC_VECTOR(7 downto 0);  -- next state input to flip-flops

    component enardFF_2 is
      port (
         i_resetBar : in  std_logic;
         i_d        : in  std_logic;
         i_enable   : in  std_logic;
         i_clock    : in  std_logic;
         o_q        : out std_logic;
         o_qBar     : out std_logic
      );
   end component;
	
	component mux_2to1_8bit IS
		PORT (
			sel     : IN  STD_LOGIC;                             -- Select input
         d_in1   : IN  STD_LOGIC_VECTOR(7 downto 0);        -- 8-bit Data input 1
         d_in2   : IN  STD_LOGIC_VECTOR(7 downto 0);        -- 8-bit Data input 2                         -- Reset input
         d_out   : OUT STD_LOGIC_VECTOR(7 downto 0)          -- 8-bit Data output
		);
	end component;

BEGIN
	 
	 shiftedData <= regData(6 downto 0) & '0';
	 selmux: mux_2to1_8bit
		PORT MAP (
			sel => i_load,
			d_in1 => shiftedData,
			d_in2 => data_in,
			d_out => transData
		);

    gen_ff: for i in 0 to 7 generate
        dff: enardFF_2 port map(
            i_resetBar => GReset,
            i_d        => transData(i),
            i_enable   => i_enable,
            i_clock    => GClock,
            o_q        => regData(i),
            o_qBar     => open
        );
    end generate;

    -- Assign internal register to output
    data_out <= regData;

END structural;
