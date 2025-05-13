LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Multiplier_9bit IS
    PORT (
        a, b        : IN  STD_LOGIC_VECTOR(8 downto 0);  -- 9-bit signed inputs
        Sum         : OUT STD_LOGIC_VECTOR(17 downto 0);  -- 18-bit output
        CarryOut, zeroOut, OverFlowOut : OUT STD_LOGIC
    );    
END Multiplier_9bit;

ARCHITECTURE basic OF Multiplier_9bit IS

    COMPONENT lshift_18bit
        PORT(
            data_in  : IN  STD_LOGIC_VECTOR(17 downto 0);
            n        : IN  INTEGER RANGE 0 TO 8;
            data_out : OUT STD_LOGIC_VECTOR(17 downto 0)
        );
    END COMPONENT;

    COMPONENT CLA_18bit
        PORT (
            a, b         : IN  STD_LOGIC_VECTOR(17 downto 0);
            cin : IN  STD_LOGIC;
            Sum          : OUT STD_LOGIC_VECTOR(17 downto 0);
            CarryOut, zeroOut, OverFlowOut : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL transitoryMultiplicand, transitoryMultiplier : STD_LOGIC_VECTOR(17 downto 0);
	 type PartialProductArray is array(0 to 8) of STD_LOGIC_VECTOR(17 downto 0);
	
	 signal partialProducts, shiftedProducts, sums : PartialProductArray;
    SIGNAL check_if_zero : STD_LOGIC_VECTOR(17 downto 0);
BEGIN
    transitoryMultiplicand <= "000000000" & a;  
    transitoryMultiplier <= "000000000" & b; 
	 

	 GEN_PARTIAL_PRODUCTS: FOR i IN 0 TO 8 GENERATE
		  partialProducts(i) <= transitoryMultiplicand AND (transitoryMultiplier(i) & transitoryMultiplier(i) & transitoryMultiplier(i) & transitoryMultiplier(i) & 
                                                      transitoryMultiplier(i) & transitoryMultiplier(i) & transitoryMultiplier(i) & transitoryMultiplier(i) & 
                                                      transitoryMultiplier(i) & transitoryMultiplier(i) & transitoryMultiplier(i) & transitoryMultiplier(i) & 
                                                      transitoryMultiplier(i) & transitoryMultiplier(i) & transitoryMultiplier(i) & transitoryMultiplier(i) & 
                                                      transitoryMultiplier(i) & transitoryMultiplier(i));
	 END GENERATE;


    -- Shift each partial product
    GEN_SHIFT: FOR i IN 0 TO 8 GENERATE
        SHIFT_INST: lshift_18bit
            PORT MAP (
                data_in => partialProducts(i),
                n => i,
                data_out => shiftedProducts(i)
            );
    END GENERATE;

    -- Add all shifted partial products
    sums(0) <= shiftedProducts(0);

    GEN_SUMS: FOR i IN 1 TO 8 GENERATE
        ADDER: CLA_18bit
            PORT MAP (
                a => sums(i - 1),
                b => shiftedProducts(i),
                cin => '0',
                Sum => sums(i),
                CarryOut => OPEN,
                zeroOut => OPEN,
                OverFlowOut => OPEN
            );
    END GENERATE;

    Sum <= sums(8);
    CarryOut <= '0';
    OverFlowOut <= '0';

    check_if_zero <= sums(8);
    zeroOut <=  (NOT check_if_zero(17) AND NOT check_if_zero(16) AND NOT check_if_zero(15) AND NOT check_if_zero(14) AND NOT check_if_zero(13) AND
	 NOT check_if_zero(12) AND NOT check_if_zero(11) AND NOT check_if_zero(10) AND NOT check_if_zero(9) AND NOT check_if_zero(8) AND NOT check_if_zero(7) AND
	 NOT check_if_zero(6) AND NOT check_if_zero(5) AND NOT check_if_zero(4) AND NOT check_if_zero(3) AND NOT check_if_zero(2) AND NOT check_if_zero(1) AND NOT check_if_zero(0));

END basic;
