LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY lshift_18bit IS
    PORT(
        data_in  : IN  STD_LOGIC_VECTOR(17 downto 0); 
        n : IN  INTEGER RANGE 0 To 8; 
        data_out : OUT STD_LOGIC_VECTOR(17 downto 0)  
    );
END lshift_18bit;

ARCHITECTURE structural OF lshift_18bit IS

    SIGNAL regData     : STD_LOGIC_VECTOR(17 downto 0);  
    SIGNAL transData, shiftedData   : STD_LOGIC_VECTOR(17 downto 0);  
	 SIGNAL zeroes : STD_LOGIC_VECTOR(17 downto 0);

BEGIN
    zeroes <= (others => '0');
    shiftedData <= data_in(17-n downto 0) & zeroes(n-1 downto 0);

    
    data_out <= shiftedData;

END structural;
