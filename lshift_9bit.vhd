LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY lshift_9bit IS
    PORT(
        data_in  : IN  STD_LOGIC_VECTOR(8 downto 0);  -- 9-bit input data
        GClock, i_enable, GReset, i_load : IN  STD_LOGIC;  -- load control added
        data_out : OUT STD_LOGIC_VECTOR(8 downto 0)   -- 9-bit output data
    );
END lshift_9bit;

ARCHITECTURE structural OF lshift_9bit IS

    SIGNAL regData     : STD_LOGIC_VECTOR(8 downto 0);  -- holds current shift register state
    SIGNAL transData, shiftedData   : STD_LOGIC_VECTOR(8 downto 0);  -- next state input to flip-flops

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

	component mux_2to1_9bit IS
		PORT (
			sel     : IN  STD_LOGIC;                             -- Select input
            d_in1   : IN  STD_LOGIC_VECTOR(8 downto 0);        -- 9-bit Data input 1
            d_in2   : IN  STD_LOGIC_VECTOR(8 downto 0);        -- 9-bit Data input 2
            d_out   : OUT STD_LOGIC_VECTOR(8 downto 0)          -- 9-bit Data output
		);
	end component;

BEGIN
	 
    -- Left shift the register data by 1 bit, append '0' to the least significant bit
    shiftedData <= regData(7 downto 0) & '0';
    
    -- Use the 2-to-1 multiplexer to either load new data or shift the register data
    selmux: mux_2to1_9bit
		PORT MAP (
			sel => i_load,
			d_in1 => shiftedData,  -- shifted data
			d_in2 => data_in,     -- new input data
			d_out => transData    -- next state input
		);

    -- Generate flip-flops for each bit
    gen_ff: for i in 0 to 8 generate
        dff: enardFF_2 port map(
            i_resetBar => GReset,
            i_d        => transData(i),
            i_enable   => i_enable,
            i_clock    => GClock,
            o_q        => regData(i),
            o_qBar     => open
        );
    end generate;

    -- Assign the internal register to output
    data_out <= regData;

END structural;
