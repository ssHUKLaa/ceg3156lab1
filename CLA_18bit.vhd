LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY CLA_18bit IS
    PORT (
        a, b         : IN STD_LOGIC_VECTOR(17 downto 0);
        cin          : IN STD_LOGIC;
        Sum          : OUT STD_LOGIC_VECTOR(17 downto 0);
        CarryOut     : OUT STD_LOGIC;
        zeroOut      : OUT STD_LOGIC;
        OverFlowOut  : OUT STD_LOGIC
    );
END CLA_18bit;

ARCHITECTURE basic OF CLA_18bit IS
    SIGNAL G, P, S, check_if_zero : STD_LOGIC_VECTOR(17 DOWNTO 0);
	 SIGNAL C : STD_LOGIC_VECTOR(18 downto 0);
BEGIN

    -- First carry is the input carry
    C(0) <= cin;

    -- Generate and Propagate logic
    GEN_CLA: FOR i IN 0 TO 17 GENERATE
        G(i) <= a(i) AND b(i);       -- Generate
        P(i) <= a(i) OR b(i);        -- Propagate


        C(i+1) <= G(i) OR (P(i) AND C(i));

        -- Compute sum bit
        S(i) <= a(i) XOR b(i) XOR C(i);
    END GENERATE;

    -- Output sum
    Sum <= S;

    -- Carry out is carry into bit 18
    CarryOut <= C(18);

    -- Overflow: XOR of carry into and out of MSB
    OverFlowOut <= C(17) XOR C(18);

    -- Zero detection: all bits of S must be 0
    check_if_zero <= NOT S;
    zeroOut <= check_if_zero(0) AND check_if_zero(1) AND check_if_zero(2) AND check_if_zero(3) AND 
               check_if_zero(4) AND check_if_zero(5) AND check_if_zero(6) AND check_if_zero(7) AND
               check_if_zero(8) AND check_if_zero(9) AND check_if_zero(10) AND check_if_zero(11) AND
               check_if_zero(12) AND check_if_zero(13) AND check_if_zero(14) AND check_if_zero(15) AND
               check_if_zero(16) AND check_if_zero(17);

END basic;
