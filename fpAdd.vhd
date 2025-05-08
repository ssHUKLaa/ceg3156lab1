
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fpAdd IS
	PORT (
		GClock, GReset, SignA, SignB : IN STD_LOGIC;
		MantissaA, MantissaB : IN STD_LOGIC_VECTOR(7 downto 0);
		ExponentA, ExponentB : IN STD_LOGIC_VECTOR(6 downto 0);
		SignOut, Overflow : OUT STD_LOGIC;
		MantissaOut : OUT STD_LOGIC_VECTOR(7 downto 0);
		ExponentOut : OUT STD_LOGIC_VECTOR(6 downto 0)
	);
END fpAdd;
	
architecture basic OF fpAdd IS
	SIGNAL startShifting, dff1_out, dff2_out, shouldStop, temptriggerShift, otherBigger, eq, lt, ignoreLesser, signsOpposite, shiftedMantissaSign, otherMantissaSign, tempGetSigned, isMantissaA, coutres, coutres2, coutresfinal : STD_LOGIC;
	SIGNAL shiftrightonemaybe : STD_LOGIC_VECTOR(2 downto 0);
	SIGNAL tempExponentOut : STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL intExponentOut, intMantissaOut, smallerMan, largerMan, tempincExp, expInc, MantissaToShift, tempExpA,tempExpB, lesserExp,greaterExp, invertedlesserExp, tempdiff, shiftedMantissa, otherMantissa, subMantissaOne, mantissaToInverse, inversedMantissa, addManA, addManB, subManRes, subManRes2, unnormalizedMantissa, rightshiftedMantissa : STD_LOGIC_VECTOR(7 downto 0);
	
	
	component mux_2to1_8bit IS
		PORT (
			sel     : IN  STD_LOGIC;                             -- Select input
         d_in1   : IN  STD_LOGIC_VECTOR(7 downto 0);        -- 8-bit Data input 1
         d_in2   : IN  STD_LOGIC_VECTOR(7 downto 0);        -- 8-bit Data input 2                         -- Reset input
         d_out   : OUT STD_LOGIC_VECTOR(7 downto 0)          -- 8-bit Data output
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
	
	component equality_comparator_8bit IS
		PORT (
			A       : IN STD_LOGIC_VECTOR(7 downto 0);
			B       : IN STD_LOGIC_VECTOR(7 downto 0);
			isEqual : OUT STD_LOGIC
		);
	end component;
	
	component CLA_8bit IS 
		PORT (
			a : IN STD_LOGIC_VECTOR(7 downto 0);
			b : IN STD_LOGIC_VECTOR(7 downto 0);
			cin : IN STD_LOGIC;
			Sum : OUT STD_LOGIC_VECTOR(7 downto 0);
			CarryOut, zeroOut, OverFlowOut : OUT STD_LOGIC
		);
	end component;
	
	component barrel_shifter_8bit IS
		PORT (
			A  : in  std_logic_vector(7 downto 0);
			S  : in  std_logic_vector(2 downto 0);
			Y  : out std_logic_vector(7 downto 0)
		);
	end component;
	
	component lshift_8bit IS
		PORT (
			data_in  : IN  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit input data
			GClock : IN  STD_LOGIC;
			i_enable : IN  STD_LOGIC; 
			GReset    : IN  STD_LOGIC; 
			i_load : IN STD_LOGIC;
			data_out : OUT STD_LOGIC_VECTOR(7 downto 0) 
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

	eq_comp1: equality_comparator_8bit
		PORT MAP (
			A => tempExpA,
			B => tempExpB,
			isEqual => eq
		);
	lt <= NOT eq;
	
	muxmansel: mux_2to1_8bit
		PORT MAP (
			sel => lt,
			d_in1 => MantissaB,
			d_in2 => MantissaA,
			d_out => MantissaToShift
		);
	muxmansel_2: mux_2to1_8bit
		PORT MAP (
			sel => eq,
			d_in1 => MantissaB,
			d_in2 => MantissaA,
			d_out => otherMantissa
		);
	
	
	muxmansign: mux_2to1_1bit
		PORT MAP (
			d0 => SignB,
			d1 => SignA,
			sel => lt,
			d_out => shiftedMantissaSign
		);
	muxmansign_2: mux_2to1_1bit
		PORT MAP (
			d0 => SignB,
			d1 => SignA,
			sel => eq,
			d_out => otherMantissaSign
		);
	muxlesserexp : mux_2to1_8bit
		PORT MAP (
			sel => lt,
			d_in1 => tempExpB,
			d_in2 => tempExpA,
			d_out => lesserExp
		);
	muxgreaterexp : mux_2to1_8bit
		PORT MAP (
			sel => eq,
			d_in1 => tempExpB,
			d_in2 => tempExpA,
			d_out => greaterExp
		);
	
	invertedlesserExp <= lesserExp XOR "11111111";
	
	expdiff: CLA_8bit
		PORT MAP (
			a => greaterExp,
			b => invertedlesserExp,
			cin => '1',
			Sum => tempdiff,
			CarryOut => open,
			zeroOut => open,
			OverFlowOut => open
		);
	
	eq_comp2: equality_comparator_8bit
		PORT MAP (
			A => tempdiff,
			B => "00001000",
			isEqual => ignoreLesser
		);
		
	
	barrel_shifter_shift_diff: barrel_shifter_8bit
		PORT MAP (
			A => MantissaToShift,
			S => tempdiff(2 downto 0),
			Y => shiftedMantissa
		);
	tempExponentOut <= greaterExp(6 downto 0);
	
	signsOpposite <= shiftedMantissaSign XOR otherMantissaSign;
	
	comp_shifted_other: equality_comparator_8bit
		PORT MAP (
			A => otherMantissa,
			B => shiftedMantissa,
			isEqual => otherBigger
		);	
		
	muxordersublarge : mux_2to1_8bit
		PORT MAP (
			sel => otherBigger,
			d_in1 => shiftedMantissa,
			d_in2 => otherMantissa,
			d_out => largerMan
		);
	muxordersubsign: mux_2to1_1bit
		PORT MAP (
			d0 => shiftedMantissaSign,
			d1 => otherMantissaSign,
			sel => otherBigger,
			d_out => SignOut
		);
		
	muxordersub : mux_2to1_8bit
		PORT MAP (
			sel => otherBigger,
			d_in1 => otherMantissa,
			d_in2 => shiftedMantissa,
			d_out => smallerMan
		);
	
	inversedMantissa <= smallerMan XOR "11111111";
	sub_mantissa: CLA_8bit
		PORT MAP (
			a => largerMan,
			b => inversedMantissa,
			cin => '1',
			Sum => subManRes,
			CarryOut => coutres,
			zeroOut => open,
			OverFlowOut => open
		);
	
	add_man: CLA_8bit
		PORT MAP (
			a => shiftedMantissa,
			b => otherMantissa,
			cin => '0',
			Sum => subManRes2,
			CarryOut => coutres2,
			zeroOut => open,
			OverFlowOut => open
		);
	
	
	finalman : mux_2to1_8bit
		PORT MAP (
			sel => signsOpposite,
			d_in1 => subManRes2,
			d_in2 => subManRes,
			d_out => unnormalizedMantissa
		);
	finalcout : mux_2to1_1bit
		PORT MAP (
			d0 => coutres2,
			d1 => coutres,
			sel => signsOpposite,
			d_out => coutresfinal
		);
	
	
	shiftrightonemaybe <= "00" & coutresfinal;
	barrel_shifter_shift_right_one: barrel_shifter_8bit
		PORT MAP (
			A => unnormalizedMantissa,
			S => shiftrightonemaybe,
			Y => rightshiftedMantissa
		);
		
	tempincExp <= "0000000" & coutresfinal;
	
	inc_exp: CLA_8bit
		PORT MAP (
			a => greaterExp,
			b => tempincExp,
			cin => '0',
			Sum => expInc,
			CarryOut => open,
			zeroOut => open,
			OverFlowOut => open
		);
		
	
	
	temptriggerShift <= NOT (rightshiftedMantissa(0) AND '0');
	shouldStop <= NOT intMantissaOut(7);
	
	DFF1 : enardFF_2 
		port map(
			i_resetBar => GReset,
			i_d        => temptriggerShift,
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
	startShifting <= dff1_out and dff2_out;
	
	startshift: lshift_8bit
		PORT MAP (
			data_in => rightshiftedMantissa,
			GClock => GClock,
			i_enable => shouldStop,
			GReset => GReset,
			i_load => startShifting,
			data_out => intMantissaOut
		);
		
	dec: decrementer_8bit
		PORT MAP (
			data_in => expInc,
			GClock => GClock,
			i_enable => shouldStop,
			GReset => GReset,
			i_load => startShifting,
			data_out => intExponentOut
		);
	ExponentOut <= intExponentOut(6 downto 0);
	MantissaOut <= intMantissaOut;
	
	

	

end basic;