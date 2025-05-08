LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY equality_Comparator_9bit IS
    PORT (
        A       : IN STD_LOGIC_VECTOR(8 downto 0);
        B       : IN STD_LOGIC_VECTOR(8 downto 0);
        isEqual : OUT STD_LOGIC
    );
END equality_Comparator_9bit;

ARCHITECTURE basic OF equality_Comparator_9bit IS
    SIGNAL equalcond, greatercond : STD_LOGIC;
BEGIN
    -- Equality condition: All bits of A must equal B
    equalcond <= NOT (A(8) XOR B(8)) AND NOT (A(7) XOR B(7)) AND NOT (A(6) XOR B(6)) AND NOT (A(5) XOR B(5)) AND
                 NOT (A(4) XOR B(4)) AND NOT (A(3) XOR B(3)) AND NOT (A(2) XOR B(2)) AND NOT (A(1) XOR B(1)) AND NOT (A(0) XOR B(0));

    -- Greater than condition: A is greater than B
    greatercond <= (A(8) AND NOT B(8)) OR 
                   (NOT (A(8) XOR B(8)) AND A(7) AND NOT B(7)) OR
                   (NOT (A(8) XOR B(8)) AND NOT (A(7) XOR B(7)) AND A(6) AND NOT B(6)) OR
                   (NOT (A(8) XOR B(8)) AND NOT (A(7) XOR B(7)) AND NOT (A(6) XOR B(6)) AND A(5) AND NOT B(5)) OR
                   (NOT (A(8) XOR B(8)) AND NOT (A(7) XOR B(7)) AND NOT (A(6) XOR B(6)) AND NOT (A(5) XOR B(5)) AND A(4) AND NOT B(4)) OR
                   (NOT (A(8) XOR B(8)) AND NOT (A(7) XOR B(7)) AND NOT (A(6) XOR B(6)) AND NOT (A(5) XOR B(5)) AND NOT (A(4) XOR B(4)) AND A(3) AND NOT B(3)) OR
                   (NOT (A(8) XOR B(8)) AND NOT (A(7) XOR B(7)) AND NOT (A(6) XOR B(6)) AND NOT (A(5) XOR B(5)) AND NOT (A(4) XOR B(4)) AND NOT (A(3) XOR B(3)) AND A(2) AND NOT B(2)) OR
                   (NOT (A(8) XOR B(8)) AND NOT (A(7) XOR B(7)) AND NOT (A(6) XOR B(6)) AND NOT (A(5) XOR B(5)) AND NOT (A(4) XOR B(4)) AND NOT (A(3) XOR B(3)) AND NOT (A(2) XOR B(2)) AND A(1) AND NOT B(1)) OR
                   (NOT (A(8) XOR B(8)) AND NOT (A(7) XOR B(7)) AND NOT (A(6) XOR B(6)) AND NOT (A(5) XOR B(5)) AND NOT (A(4) XOR B(4)) AND NOT (A(3) XOR B(3)) AND NOT (A(2) XOR B(2)) AND NOT (A(1) XOR B(1)) AND A(0) AND NOT B(0));

    -- Final output (A >= B)
    isEqual <= equalcond OR greatercond;
END basic;
