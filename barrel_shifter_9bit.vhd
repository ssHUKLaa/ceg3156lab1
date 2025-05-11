library ieee;
use ieee.std_logic_1164.all;

entity barrel_shifter_9bit is
   port (
      A  : in  std_logic_vector(8 downto 0);
		shiftIn : IN STD_LOGIC;
      S  : in  std_logic_vector(3 downto 0);
      Y  : out std_logic_vector(8 downto 0)
   );
end entity;

architecture rtl of barrel_shifter_9bit is

   component mux_16to1_9bit is
      port (
         sel   : in  std_logic_vector(3 downto 0);
         d_in0 : in  std_logic_vector(8 downto 0);
         d_in1 : in  std_logic_vector(8 downto 0);
         d_in2 : in  std_logic_vector(8 downto 0);
         d_in3 : in  std_logic_vector(8 downto 0);
         d_in4 : in  std_logic_vector(8 downto 0);
         d_in5 : in  std_logic_vector(8 downto 0);
         d_in6 : in  std_logic_vector(8 downto 0);
         d_in7 : in  std_logic_vector(8 downto 0);
         d_in8 : in  std_logic_vector(8 downto 0);
         d_in9 : in  std_logic_vector(8 downto 0) := (others => '0');
         d_in10: in  std_logic_vector(8 downto 0) := (others => '0');
         d_in11: in  std_logic_vector(8 downto 0) := (others => '0');
         d_in12: in  std_logic_vector(8 downto 0) := (others => '0');
         d_in13: in  std_logic_vector(8 downto 0) := (others => '0');
         d_in14: in  std_logic_vector(8 downto 0) := (others => '0');
         d_in15: in  std_logic_vector(8 downto 0) := (others => '0');
         d_out : out std_logic_vector(8 downto 0)
      );
   end component;

   signal shift1, shift2, shift3, shift4, shift5, shift6, shift7, shift8, shift9 : std_logic_vector(8 downto 0);
   signal stage_out : std_logic_vector(8 downto 0);

begin
   shift1 <= A;
   shift2 <= shiftIn & A(8 downto 1);
   shift3 <= shiftIn & shiftIn & A(8 downto 2);
   shift4 <= shiftIn & shiftIn & shiftIn & A(8 downto 3);
   shift5 <= shiftIn & shiftIn & shiftIn & shiftIn & A(8 downto 4);
   shift6 <= shiftIn & shiftIn & shiftIn & shiftIn & shiftIn & A(8 downto 5);
   shift7 <= shiftIn & shiftIn & shiftIn & shiftIn & shiftIn & shiftIn & A(8 downto 6);
   shift8 <= shiftIn & shiftIn & shiftIn & shiftIn & shiftIn & shiftIn & shiftIn & A(8 downto 7);
   shift9 <= shiftIn & shiftIn & shiftIn & shiftIn & shiftIn & shiftIn & shiftIn & shiftIn & A(8);

   mux: mux_16to1_9bit
      port map (
         sel    => S,
         d_in0  => shift1,
         d_in1  => shift2,
         d_in2  => shift3,
         d_in3  => shift4,
         d_in4  => shift5,
         d_in5  => shift6,
         d_in6  => shift7,
         d_in7  => shift8,
         d_in8  => shift9,
         d_out  => stage_out
      );

   Y <= stage_out;

end architecture;
