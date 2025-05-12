LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY lshift_18bit_gated IS
    PORT(
        data_in  : IN  STD_LOGIC_VECTOR(17 downto 0);  -- 9-bit input data
        GClock, i_enable, GReset, i_load : IN  STD_LOGIC;  -- load control added
        data_out : OUT STD_LOGIC_VECTOR(17 downto 0)   -- 9-bit output data
    );
END lshift_18bit_gated;

ARCHITECTURE structural OF lshift_18bit_gated IS

    SIGNAL shiftedData,regData, transData   : STD_LOGIC_VECTOR(17 downto 0); 

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


BEGIN
	 
    shiftedData <= regData(16 downto 0) & '0';
	 
	 gen_loop: FOR i IN 0 TO 17 GENERATE
		transData(i) <= (data_in(i) AND i_load) OR (regData(i) AND NOT i_load);
	 end genERATE;

    -- Generate flip-flops for each bit
    gen_ff: for i in 0 to 17 generate
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
