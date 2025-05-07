
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fpAddMult IS
	PORT (
		GClock, GReset, SignA, SignB : IN STD_LOGIC;
		MantissaA, MantissaB : IN STD_LOGIC_VECTOR(7 downto 0);
		ExponentA, ExponentB : IN STD_LOGIC_VECTOR(6 downto 0);
		SignOut, Overflow : OUT STD_LOGIC;
		MantissaOut : OUT STD_LOGIC_VECTOR(7 downto 0);
		ExponentOut : OUT STD_LOGIC_VECTOR(6 downto 0)
	);
END fpAddMult;
	