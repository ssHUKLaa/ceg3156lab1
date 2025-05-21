
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
	SIGNAL tempExpA, tempExpB, expSum, unbiasedexp, incedexp, intExponentOut, incExpCond, incExpCond2, intExponentOutReNorm : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL leadingManA, leadingManB : STD_LOGIC_VECTOR(8 downto 0);
	SIGNAL multedMan, normalizedMantissa, lshiftinput, rshiftmantissa, msbmask, roundedMantissa, msbmask2, rshiftmantissa2 : STD_LOGIC_VECTOR(17 downto 0);
	SIGNAL stopnorm, dff1_out, dff2_out, oneclkpulse, Guard, Round, Sticky, roundCond : STD_LOGIC;
	
	component CLA_8bit IS 
		PORT (
			a : IN STD_LOGIC_VECTOR(7 downto 0);
			b : IN STD_LOGIC_VECTOR(7 downto 0);
			cin : IN STD_LOGIC;
			Sum : OUT STD_LOGIC_VECTOR(7 downto 0);
			CarryOut, zeroOut, OverFlowOut : OUT STD_LOGIC
		);
	end component;
	
	component CLA_18bit IS 
		PORT (
			a : IN STD_LOGIC_VECTOR(17 downto 0);
			b : IN STD_LOGIC_VECTOR(17 downto 0);
			cin : IN STD_LOGIC;
			Sum : OUT STD_LOGIC_VECTOR(17 downto 0);
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
	
	component decrementer_8bit IS
		PORT (
			data_in  : IN  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit input data
			GClock : IN  STD_LOGIC; 
			i_enable : IN  STD_LOGIC; 
			GReset : IN  STD_LOGIC; 
			i_load : IN  STD_LOGIC;  -- load control added
			data_out : OUT STD_LOGIC_VECTOR(7 downto 0)   -- 8-bit output data
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
	msbmask <= multedMan(17) & multedMan(17) & multedMan(17) & multedMan(17) & multedMan(17) & multedMan(17) & multedMan(17) & multedMan(17) & multedMan(17) & multedMan(17) & multedMan(17) & multedMan(17) & multedMan(17) & multedMan(17) & multedMan(17) & multedMan(17) & multedMan(17) & multedMan(17);
	incExpCond <= "0000000" & multedMan(17);
	rshiftmantissa <= (multedMan and NOT msbmask) OR (('0' & MultedMan(17 downto 1)) and msbmask);
	
	incexp: CLA_8bit
		PORT MAP (
			a => unbiasedexp,
			b => incExpCond,
			cin => '0',
			Sum => incedexp,
			CarryOut => open,
			zeroOut => open,
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
		
		
	stopnorm <= NOT normalizedMantissa(16);
	
	normman: lshift_18bit_gated
		PORT MAP (
			data_in => rshiftmantissa,
			GClock =>  GClock,
			i_load => oneclkpulse,
			i_enable => stopnorm,
			GReset => GReset,
			data_out => normalizedMantissa
		);
	
	decexp: decrementer_8bit
		PORT MAP (
			data_in => incedexp,
			GClock => GClock,
			i_enable => stopnorm,
			GReset => GReset,
			i_load => oneclkpulse,
			data_out => intExponentOut
		);
		
	Guard <= normalizedMantissa(7);
	Round <= normalizedMantissa(6);
	Sticky <= normalizedMantissa(5) OR normalizedMantissa(4) OR normalizedMantissa(3) OR normalizedMantissa(2) OR normalizedMantissa(1) OR normalizedMantissa(0);
	
	roundCond <= Guard AND (Round OR Sticky OR normalizedMantissa(8));
	
	addCond: CLA_18bit
		PORT MAP (
			a => normalizedMantissa,
			b => roundCond,
			cin => '0',
			Sum => roundedMantissa,
			CarryOut => rmanCarry,
			zeroOut => open,
			OverFlowOut => open
		);
	
	
	msbmask2 <= roundedMantissa(17) & roundedMantissa(17) & roundedMantissa(17) & roundedMantissa(17) & roundedMantissa(17) & roundedMantissa(17) & roundedMantissa(17) & roundedMantissa(17) & roundedMantissa(17) & roundedMantissa(17) & roundedMantissa(17) & roundedMantissa(17) & roundedMantissa(17) & roundedMantissa(17) & roundedMantissa(17) & roundedMantissa(17) & roundedMantissa(17) & roundedMantissa(17);
	rshiftmantissa2 <= (roundedMantissa and NOT msbmask2) OR (('0' & roundedMantissa(17 downto 1)) and msbmask2);
	incExpCond2 <= "0000000" & roundedMantissa(17);
	incexp2: CLA_8bit
		PORT MAP (
			a => intExponentOut,
			b => incExpCond2,
			cin => '0',
			Sum => intExponentOutReNorm,
			CarryOut => open,
			zeroOut => open,
			OverFlowOut => open
		);
	
	ExponentOut <= intExponentOutReNorm(6 downto 0);
	Overflow <= intExponentOutReNorm(7);
	MantissaOut <= normalizedMantissa(15 downto 8);
	SignOut <= SignA XOR SignB;
	
	

end basic;