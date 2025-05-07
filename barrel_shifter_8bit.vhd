library ieee;
use ieee.std_logic_1164.all;

entity barrel_shifter_8bit is
   port (
      GReset, GClock : in  std_logic;
      A  : in  std_logic_vector(7 downto 0);
      S  : in  std_logic_vector(2 downto 0);
      Y  : out std_logic_vector(7 downto 0)
   );
end entity;

architecture rtl of barrel_shifter_8bit is

   component mux_8to1_8bit is
      port (
			sel   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0); -- 3-bit selector
			d_in0 : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			d_in1 : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			d_in2 : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			d_in3 : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			d_in4 : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			d_in5 : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			d_in6 : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			d_in7 : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			d_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
   end component;

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
	signal shift0, shift1, shift2, shift3, shift4, shift5, shift6, shift7 : std_logic_vector(7 downto 0);
   signal stage2 : std_logic_vector(7 downto 0);

begin

	shift0 <= A;
   shift1 <= '0'     & A(7 downto 1);
   shift2 <= "00"    & A(7 downto 2);
   shift3 <= "000"   & A(7 downto 3);
   shift4 <= "0000"  & A(7 downto 4);
   shift5 <= "00000" & A(7 downto 5);
   shift6 <= "000000" & A(7 downto 6);
   shift7 <= "0000000" & A(7 downto 7);

   -- Mux instantiation using signal names
   mux: mux_8to1_8bit
      port map (
         sel    => S,
         d_in0  => shift0,
         d_in1  => shift1,
         d_in2  => shift2,
         d_in3  => shift3,
         d_in4  => shift4,
         d_in5  => shift5,
         d_in6  => shift6,
         d_in7  => shift7,
         d_out  => stage2
      );
	

   -- register the result bits
   gen_ff: for i in 0 to 7 generate
      dff: enardFF_2 port map(
         i_resetBar => GReset,
         i_d        => stage2(i),
         i_enable   => '1',
         i_clock    => GClock,
         o_q        => Y(i),
         o_qBar     => open
      );
   end generate;

end architecture;
