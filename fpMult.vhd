
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fpMult IS
	PORT (
		GClock, GReset, SignA, SignB : IN STD_LOGIC;
		MantissaA, MantissaB : IN STD_LOGIC_VECTOR(7 downto 0);
		ExponentA, ExponentB : IN STD_LOGIC_VECTOR(6 downto 0);
		SignOut, Overflow : OUT STD_LOGIC;
		MantissaOut : OUT STD_LOGIC_VECTOR(7 downto 0);
		ExponentOut : OUT STD_LOGIC_VECTOR(6 downto 0)
	);
END fpMult;

architecture basic OF fpMult IS
	SIGNAL tempExpA, tempExpB, expSum, unbiasedexp : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL leadingManA, leadingManB : STD_LOGIC_VECTOR(8 downto 0);
	SIGNAL multedMan, normalizedMantissa, lshiftinput : STD_LOGIC_VECTOR(17 downto 0);
	SIGNAL stopnorm, dff1_out, dff2_out, oneclkpulse : STD_LOGIC;
	
	component CLA_8bit IS 
		PORT (
			a : IN STD_LOGIC_VECTOR(7 downto 0);
			b : IN STD_LOGIC_VECTOR(7 downto 0);
			cin : IN STD_LOGIC;
			Sum : OUT STD_LOGIC_VECTOR(7 downto 0);
			CarryOut, zeroOut, OverFlowOut : OUT STD_LOGIC
		);
	end component;
	
	component mux_2to1_1bit IS
		PORT (
			d0 : IN STD_LOGIC;
			d1 : IN STD_LOGIC;
			sel : IN STD_LOGIC;
			d_out : OUT STD_LOGIC
		);
	end component;
	
	component Multiplier_9bit IS 
		PORT (
			a, b        : IN  STD_LOGIC_VECTOR(8 downto 0);  
         Sum         : OUT STD_LOGIC_VECTOR(17 downto 0); 
         CarryOut, zeroOut, OverFlowOut : OUT STD_LOGIC
		);
	end COMponent;
	
	component lshift_18bit_gated IS
		PORT(
        data_in  : IN  STD_LOGIC_VECTOR(17 downto 0);  
        GClock, i_enable, GReset, i_load : IN  STD_LOGIC;  
        data_out : OUT STD_LOGIC_VECTOR(17 downto 0)   
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

begin 


	tempExpA <= '0' & ExponentA;
	tempExpB <= '0' & ExponentB;
	addexp: CLA_8bit
		PORT MAP (
			a => tempExpA,
			b => tempExpB,
			cin => '0',
			Sum => expSum,
			CarryOut => open,
			zeroOut => open,
			OverFlowOut => open
		);
		
	sub63: CLA_8bit
		PORT MAP (
			a => expSum,
			b => "11000000",
			cin => '1',
			Sum => unbiasedexp,
			CarryOut => open,
			zeroOut => open,
			OverFlowOut => open
		);
		
	leadingManA <= '1' & MantissaA;
	leadingManB <= '1' & MantissaB;
	
	MultMan: Multiplier_9bit
		PORT MAP (
			a => leadingManA,
			b => leadingManB,
			Sum => multedMan,
			CarryOut => open,
			ZeroOut => open,
			OverFlowOut => open
		);
		
	DFF1 : enardFF_2 
		port map(
			i_resetBar => GReset,
			i_d        => '1',
			i_enable   => '1',
			i_clock    => GClock,
			o_q        => dff1_out,
			o_qBar     => open
		);
		
	DFF2 : enardFF_2 
		port map(
			i_resetBar => GReset,
			i_d        => dff1_out,
			i_enable   => '1',
			i_clock    => GClock,
			o_q        => open,
			o_qBar     => dff2_out
		);
		
	oneclkpulse <= dff1_out and dff2_out;
		
		
	stopnorm <= NOT normalizedMantissa(17);
	
	normman: lshift_18bit_gated
		PORT MAP (
			data_in => multedMan,
			GClock =>  GClock,
			i_load => oneclkpulse,
			i_enable => stopnorm,
			GReset => GReset,
			data_out => normalizedMantissa
		);
	ExponentOut <= unbiasedexp(6 downto 0);
	
	MantissaOut <= normalizedMantissa(16 downto 9);
	SignOut <= SignA XOR SignB;
	
	

end basic;