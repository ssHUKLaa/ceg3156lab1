LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity Multiplier_4bit IS
	PORT (
		a,b : IN STD_LOGIC_VECTOR(3 downto 0);
		GClock, GReset : IN STD_LOGIC;
		Sum : OUT STD_LOGIC_VECTOR(7 downto 0);
		CarryOut, zeroOut, OverFlowOut : OUT STD_LOGIC
	);	
end Multiplier_4bit;

architecture basic of Multiplier_4bit is
	
	COMPONENT lshift_8bit
        PORT(
			  data_in  : IN  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit input data
			  i_clock    : IN  STD_LOGIC;
			  n        : IN  INTEGER RANGE 0 TO 7; 
			  data_out : OUT STD_LOGIC_VECTOR(7 downto 0)   -- 8-bit output data
		 );
    END COMPONENT;
	 
	COMPONENT CLA_8bit
			PORT (
				a, b         : IN  STD_LOGIC_VECTOR(7 downto 0);
				cin, GClock, GReset : IN  STD_LOGIC;
				Sum          : OUT STD_LOGIC_VECTOR(7 downto 0);
				CarryOut, zeroOut, OverFlowOut : OUT STD_LOGIC
			);
	END COMPONENT;

	signal transitoryMultiplicand, transitoryMultiplier : STD_LOGIC_VECTOR(7 downto 0);
	signal partialProduct0,partialProduct1,partialProduct2,partialProduct3,partialProduct4,partialProduct5,partialProduct6,partialProduct7 : STD_LOGIC_VECTOR(7 downto 0);
	signal shiftedProduct0,shiftedProduct1,shiftedProduct2,shiftedProduct3,shiftedProduct4,shiftedProduct5,shiftedProduct6,shiftedProduct7 : STD_LOGIC_VECTOR(7 downto 0);
	signal finalSum0,finalSum1, finalSum2, finalSum3,finalSum4,finalSum5, finalSum6, check_if_zero : STD_LOGIC_VECTOR(7 downto 0);

begin
	transitoryMultiplicand(7 downto 4) <= (others => a(3));
	transitoryMultiplicand(3 downto 0) <= a;
	
	transitoryMultiplier(7 downto 4) <= (others => b(3));
	transitoryMultiplier(3 downto 0) <= b;
	
	partialProduct0 <= (
	7=>transitoryMultiplicand(7) AND transitoryMultiplier(0),
	6=>transitoryMultiplicand(6) AND transitoryMultiplier(0),
	5=>transitoryMultiplicand(5) AND transitoryMultiplier(0),
	4=>transitoryMultiplicand(4) AND transitoryMultiplier(0),
	3=>transitoryMultiplicand(3) AND transitoryMultiplier(0),
	2=>transitoryMultiplicand(2) AND transitoryMultiplier(0),
	1=>transitoryMultiplicand(1) AND transitoryMultiplier(0),
	0=>transitoryMultiplicand(0) AND transitoryMultiplier(0)
	);
	
	partialProduct1 <= (
	7=>transitoryMultiplicand(7) AND transitoryMultiplier(1),
	6=>transitoryMultiplicand(6) AND transitoryMultiplier(1),
	5=>transitoryMultiplicand(5) AND transitoryMultiplier(1),
	4=>transitoryMultiplicand(4) AND transitoryMultiplier(1),
	3=>transitoryMultiplicand(3) AND transitoryMultiplier(1),
	2=>transitoryMultiplicand(2) AND transitoryMultiplier(1),
	1=>transitoryMultiplicand(1) AND transitoryMultiplier(1),
	0=>transitoryMultiplicand(0) AND transitoryMultiplier(1)
	);
	
	partialProduct2 <= (
	7=>transitoryMultiplicand(7) AND transitoryMultiplier(2),
	6=>transitoryMultiplicand(6) AND transitoryMultiplier(2),
	5=>transitoryMultiplicand(5) AND transitoryMultiplier(2),
	4=>transitoryMultiplicand(4) AND transitoryMultiplier(2),
	3=>transitoryMultiplicand(3) AND transitoryMultiplier(2),
	2=>transitoryMultiplicand(2) AND transitoryMultiplier(2),
	1=>transitoryMultiplicand(1) AND transitoryMultiplier(2),
	0=>transitoryMultiplicand(0) AND transitoryMultiplier(2)
	);
	
	partialProduct3 <= (
	7=>transitoryMultiplicand(7) AND transitoryMultiplier(3),
	6=>transitoryMultiplicand(6) AND transitoryMultiplier(3),
	5=>transitoryMultiplicand(5) AND transitoryMultiplier(3),
	4=>transitoryMultiplicand(4) AND transitoryMultiplier(3),
	3=>transitoryMultiplicand(3) AND transitoryMultiplier(3),
	2=>transitoryMultiplicand(2) AND transitoryMultiplier(3),
	1=>transitoryMultiplicand(1) AND transitoryMultiplier(3),
	0=>transitoryMultiplicand(0) AND transitoryMultiplier(3)
	);
	
	partialProduct4 <= (
	7=>transitoryMultiplicand(7) AND transitoryMultiplier(4),
	6=>transitoryMultiplicand(6) AND transitoryMultiplier(4),
	5=>transitoryMultiplicand(5) AND transitoryMultiplier(4),
	4=>transitoryMultiplicand(4) AND transitoryMultiplier(4),
	3=>transitoryMultiplicand(3) AND transitoryMultiplier(4),
	2=>transitoryMultiplicand(2) AND transitoryMultiplier(4),
	1=>transitoryMultiplicand(1) AND transitoryMultiplier(4),
	0=>transitoryMultiplicand(0) AND transitoryMultiplier(4)
	);
	
	partialProduct5 <= (
	7=>transitoryMultiplicand(7) AND transitoryMultiplier(5),
	6=>transitoryMultiplicand(6) AND transitoryMultiplier(5),
	5=>transitoryMultiplicand(5) AND transitoryMultiplier(5),
	4=>transitoryMultiplicand(4) AND transitoryMultiplier(5),
	3=>transitoryMultiplicand(3) AND transitoryMultiplier(5),
	2=>transitoryMultiplicand(2) AND transitoryMultiplier(5),
	1=>transitoryMultiplicand(1) AND transitoryMultiplier(5),
	0=>transitoryMultiplicand(0) AND transitoryMultiplier(5)
	);
	
	partialProduct6 <= (
	7=>transitoryMultiplicand(7) AND transitoryMultiplier(6),
	6=>transitoryMultiplicand(6) AND transitoryMultiplier(6),
	5=>transitoryMultiplicand(5) AND transitoryMultiplier(6),
	4=>transitoryMultiplicand(4) AND transitoryMultiplier(6),
	3=>transitoryMultiplicand(3) AND transitoryMultiplier(6),
	2=>transitoryMultiplicand(2) AND transitoryMultiplier(6),
	1=>transitoryMultiplicand(1) AND transitoryMultiplier(6),
	0=>transitoryMultiplicand(0) AND transitoryMultiplier(6)
	);
	
	partialProduct7 <= (
	7=>transitoryMultiplicand(7) AND transitoryMultiplier(7),
	6=>transitoryMultiplicand(6) AND transitoryMultiplier(7),
	5=>transitoryMultiplicand(5) AND transitoryMultiplier(7),
	4=>transitoryMultiplicand(4) AND transitoryMultiplier(7),
	3=>transitoryMultiplicand(3) AND transitoryMultiplier(7),
	2=>transitoryMultiplicand(2) AND transitoryMultiplier(7),
	1=>transitoryMultiplicand(1) AND transitoryMultiplier(7),
	0=>transitoryMultiplicand(0) AND transitoryMultiplier(7)
	);
	
	shiftedProduct0 <= partialProduct0;
	
	lshift_8bit1 : lshift_8bit
		PORT MAP (
			data_in => partialProduct1,
			i_clock => GClock,
			n => 1,
			data_out => shiftedProduct1
		);
		
	lshift_8bit2 : lshift_8bit
		PORT MAP (
			data_in => partialProduct2,
			i_clock => GClock,
			n => 2,
			data_out => shiftedProduct2
		);
		
	lshift_8bit3 : lshift_8bit
		PORT MAP (
			data_in => partialProduct3,
			i_clock => GClock,
			n => 3,
			data_out => shiftedProduct3
		);
		
	lshift_8bit4 : lshift_8bit
		PORT MAP (
			data_in => partialProduct4,
			i_clock => GClock,
			n => 4,
			data_out => shiftedProduct4
		);
		
	lshift_8bit5 : lshift_8bit
		PORT MAP (
			data_in => partialProduct5,
			i_clock => GClock,
			n => 5,
			data_out => shiftedProduct5
		);
		
	lshift_8bit6 : lshift_8bit
		PORT MAP (
			data_in => partialProduct6,
			i_clock => GClock,
			n => 6,
			data_out => shiftedProduct6
		);
		
	lshift_8bit7 : lshift_8bit
		PORT MAP (
			data_in => partialProduct7,
			i_clock => GClock,
			n => 7,
			data_out => shiftedProduct7
		);
		
	CLA_8bit_inst1: CLA_8bit
		PORT MAP (
			  a => shiftedProduct0,
			  b => shiftedProduct1,
			  cin => '0',  
			  GClock => GClock,
			  GReset => GReset,
			  Sum => finalSum0,
			  CarryOut => open,  
			  zeroOut => open,
			  OverFlowOut => open
		 );
	 
	CLA_8bit_inst2: CLA_8bit
		PORT MAP (
			  a => finalSum0,
			  b => shiftedProduct2,
			  cin => '0',  
			  GClock => GClock,
			  GReset => GReset,
			  Sum => finalSum1,
			  CarryOut => open,  
			  zeroOut => open,
			  OverFlowOut => open
		);
		
	CLA_8bit_inst3: CLA_8bit
		PORT MAP (
			  a => finalSum1,
			  b => shiftedProduct3,
			  cin => '0',  
			  GClock => GClock,
			  GReset => GReset,
			  Sum => finalSum2,
			  CarryOut => open,  
			  zeroOut => open,
			  OverFlowOut => open
		);
		
	CLA_8bit_inst4: CLA_8bit
		PORT MAP (
			  a => finalSum2,
			  b => shiftedProduct4,
			  cin => '0',  
			  GClock => GClock,
			  GReset => GReset,
			  Sum => finalSum3,
			  CarryOut => open,  
			  zeroOut => open,
			  OverFlowOut => open
		);
		
	CLA_8bit_inst5: CLA_8bit
		PORT MAP (
			  a => finalSum3,
			  b => shiftedProduct5,
			  cin => '0',  
			  GClock => GClock,
			  GReset => GReset,
			  Sum => finalSum4,
			  CarryOut => open,  
			  zeroOut => open,
			  OverFlowOut => open
		);
		
	CLA_8bit_inst6: CLA_8bit
		PORT MAP (
			  a => finalSum4,
			  b => shiftedProduct6,
			  cin => '0',  
			  GClock => GClock,
			  GReset => GReset,
			  Sum => finalSum5,
			  CarryOut => open,  
			  zeroOut => open,
			  OverFlowOut => open
		);
		
	CLA_8bit_inst7: CLA_8bit
		PORT MAP (
			  a => finalSum5,
			  b => shiftedProduct7,
			  cin => '0',  
			  GClock => GClock,
			  GReset => GReset,
			  Sum => finalSum6,
			  CarryOut => open,  
			  zeroOut => open,
			  OverFlowOut => open
		);
	
	Sum <= finalSum6;
	CarryOut <= '0';
	OverFlowOut <= '0';
	
	check_if_zero <= NOT finalSum6;

	zeroOut <= check_if_zero(0) AND check_if_zero(1) AND check_if_zero(2) AND check_if_zero(3) AND check_if_zero(4) AND check_if_zero(5) AND check_if_zero(6) AND check_if_zero(7);
	
	
end basic;