library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Multiplier_9bit is
end tb_Multiplier_9bit;

architecture behavior of tb_Multiplier_9bit is

    component Multiplier_9bit
        port (
            a : in STD_LOGIC_VECTOR(8 downto 0);
            b : in STD_LOGIC_VECTOR(8 downto 0);
            Sum : out STD_LOGIC_VECTOR(17 downto 0);
            CarryOut : out STD_LOGIC;
            zeroOut : out STD_LOGIC;
            OverFlowOut : out STD_LOGIC
        );
    end component;

    signal a_tb : STD_LOGIC_VECTOR(8 downto 0);
    signal b_tb : STD_LOGIC_VECTOR(8 downto 0);
    signal Sum_tb : STD_LOGIC_VECTOR(17 downto 0);
    signal CarryOut_tb : STD_LOGIC;
    signal zeroOut_tb : STD_LOGIC;
    signal OverFlowOut_tb : STD_LOGIC;

begin

    uut: Multiplier_9bit
        port map (
            a => a_tb,
            b => b_tb,
            Sum => Sum_tb,
            CarryOut => CarryOut_tb,
            zeroOut => zeroOut_tb,
            OverFlowOut => OverFlowOut_tb
        );

    stim_proc: process
    begin
        a_tb <= "000000000"; b_tb <= "000000000";
        wait for 10 ns;

        a_tb <= "000000001"; b_tb <= "000000001";
        wait for 10 ns;

        a_tb <= "000000101"; b_tb <= "000001011";
        wait for 10 ns;

        a_tb <= "111111111"; b_tb <= "000000001";
        wait for 10 ns;

        a_tb <= "000000001"; b_tb <= "111111111";
        wait for 10 ns;

        a_tb <= "111111111"; b_tb <= "111111111";
        wait for 10 ns;

        a_tb <= "100000000"; b_tb <= "000000010";
        wait for 10 ns;

        a_tb <= "011111111"; b_tb <= "000000010";
        wait for 10 ns;

        wait;
    end process;

end behavior;
