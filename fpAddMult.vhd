
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fpAddMult IS
	PORT (
		GClock, GReset, SignA, SignB : IN STD_LOGIC;
		MantissaA, MantissaB : IN STD_LOGIC_VECTOR(7 downto 0);
		ExponentA, ExponentB : IN STD_LOGIC_VECTOR(6 downto 0);   
		SignOut, Overflow, SignsOpposite : OUT STD_LOGIC;
		MantissaOut : OUT STD_LOGIC_VECTOR(7 downto 0);
		ExponentOut : OUT STD_LOGIC_VECTOR(6 downto 0)
	);
END fpAddMult; 
	
architecture basic of fpAddMult is
	signal int_isNegative : STD_LOGIC;
	signal shiftRightOneMaybe : STD_LOGIC_VECTOR (2 downto 0);
	signal negative127 : STD_LOGIC_VECTOR (8 downto 0) := "10000001";

	component enardFF_2 is
		port(
			i_resetBar	: in std_logic;
			i_d		   	: in std_logic;
			i_enable   	: in std_logic;
			i_clock	   	: in std_logic;
			o_q,o_qBar	: out std_logic;
		);
	end component;

	component decrementer_8bit IS
		PORT (
			data_in  	: IN  STD_LOGIC_VECTOR(7 downto 0);  	-- 8-bit input data
			GClock 		: IN  STD_LOGIC; 
			i_enable 	: IN  STD_LOGIC; 
			GReset 		: IN  STD_LOGIC; 
			i_load 		: IN  STD_LOGIC;  						-- load control added
			data_out 	: OUT STD_LOGIC_VECTOR(7 downto 0)   	-- 8-bit output data
		);
	end component;

begin
	tempExpA <= '0' & ExponentA;
	tempExpB <= '0' & ExponentB;

	exponentSum: CLA_8bit
		PORT MAP (
			a => tempExpA,
			b => tempExpB,
			cin => open,
			Sum => tempSum,
			CarryOut => open,
			zeroOut => open,
			OverFlowOut => open
		);
	
	subExponent: CLA_8bit
		PORT MAP (
			a => tempSum,
			b => negative127,
			cin => open,
			Sum => tempSum,
			CarryOut => open,
			zeroOut => open,
			OverFlowOut => open
		);
	
	multiplyMantissas: CLA_8bit
		PORT MAP(
			a => tempManSum,
			b => MantissaA,
			cin => open,
			Sum => tempManSum,
			CarryOut => open,
			zeroOut => open,
			OverFlowOut => open
		);
	
	signsOpposite <= MantissaA[7] XOR MantissaB[7];

	barrel_shifter_shift_right_one: barrel_shifter_8bit
		PORT MAP (
			A => tempManSum,
			S => shiftrightonemaybe,
			Y => rightshiftedMantissa
		);

	dec: decrementer_8bit
		PORT MAP (
			data_in => tempExp,
			GClock => GClock,
			i_enable => shouldStop,
			GReset => GReset,
			i_load => startShifting,
			data_out => intExponentOut
		);
	
	ExponentOut <= intExponentOut;
	MantissaOut <= rightshiftedMantissa;