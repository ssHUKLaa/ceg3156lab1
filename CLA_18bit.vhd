LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY CLA_18bit IS
    PORT (
        a, b      : IN STD_LOGIC_VECTOR(17 downto 0);  -- 18-bit input
        cin       : IN STD_LOGIC;
        Sum       : OUT STD_LOGIC_VECTOR(17 downto 0);  -- 18-bit output
        CarryOut  : OUT STD_LOGIC;
        zeroOut   : OUT STD_LOGIC;
        OverFlowOut : OUT STD_LOGIC
    );
END CLA_18bit;

ARCHITECTURE basic OF CLA_18bit IS

    -- Intermediate signals for Generate (G), Propagate (P), and Carry (C)
    SIGNAL transitoryG : STD_LOGIC_VECTOR(17 downto 0);
    SIGNAL transitoryP : STD_LOGIC_VECTOR(17 downto 0);
    SIGNAL transitoryC : STD_LOGIC_VECTOR(17 downto 0);
    SIGNAL transitorySignal, check_if_zero : STD_LOGIC_VECTOR(17 downto 0);
    
BEGIN
    -- Generate and Propagate signals for each bit
    transitoryG(0) <= a(0) AND b(0);
    transitoryP(0) <= a(0) OR b(0);
    transitoryC(0) <= transitoryG(0) OR (transitoryP(0) AND cin);
    transitorySignal(0) <= (a(0) XOR b(0)) XOR cin;

    -- From bit 1 to 17, extend the logic for each bit
    gen_loop: FOR i IN 1 TO 17 GENERATE
        transitoryG(i) <= a(i) AND b(i);
        transitoryP(i) <= a(i) OR b(i);
        transitoryC(i) <= transitoryG(i-1) OR (transitoryP(i-1) AND transitoryC(i-1));
        transitorySignal(i) <= (a(i) XOR b(i)) XOR transitoryC(i);
    END GENERATE;

    -- Carry out is the carry of the most significant bit (bit 17)
    CarryOut <= transitoryG(17) OR (transitoryP(17) AND transitoryC(17));

    -- Overflow occurs when the carry-in and carry-out of the MSB differ
    OverFlowOut <= (transitoryG(17) OR (transitoryP(17) AND transitoryC(17))) XOR transitoryC(17);

    -- Zero check: If all sum bits are zero
    check_if_zero <= NOT transitorySignal;
    zeroOut <= check_if_zero(0) AND check_if_zero(1) AND check_if_zero(2) AND check_if_zero(3) AND 
               check_if_zero(4) AND check_if_zero(5) AND check_if_zero(6) AND check_if_zero(7) AND
               check_if_zero(8) AND check_if_zero(9) AND check_if_zero(10) AND check_if_zero(11) AND
               check_if_zero(12) AND check_if_zero(13) AND check_if_zero(14) AND check_if_zero(15) AND
               check_if_zero(16) AND check_if_zero(17);

    -- Sum output
    Sum <= transitorySignal;

END basic;
