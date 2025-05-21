library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_CLA_8bit is
end tb_CLA_8bit;

architecture behavior of tb_CLA_8bit is

    component CLA_8bit
        port (
            a : in STD_LOGIC_VECTOR(7 downto 0);
            b : in STD_LOGIC_VECTOR(7 downto 0);
            cin : in STD_LOGIC;
            Sum : out STD_LOGIC_VECTOR(7 downto 0);
            CarryOut : out STD_LOGIC;
            zeroOut : out STD_LOGIC;
            OverFlowOut : out STD_LOGIC
        );
    end component;

    signal a_tb : STD_LOGIC_VECTOR(7 downto 0);
    signal b_tb : STD_LOGIC_VECTOR(7 downto 0);
    signal cin_tb : STD_LOGIC;
    signal Sum_tb : STD_LOGIC_VECTOR(7 downto 0);
    signal CarryOut_tb : STD_LOGIC;
    signal zeroOut_tb : STD_LOGIC;
    signal OverFlowOut_tb : STD_LOGIC;

begin

    uut: CLA_8bit
        port map (
            a => a_tb,
            b => b_tb,
            cin => cin_tb,
            Sum => Sum_tb,
            CarryOut => CarryOut_tb,
            zeroOut => zeroOut_tb,
            OverFlowOut => OverFlowOut_tb
        );

    stim_proc: process
    begin
        a_tb <= "00000000"; b_tb <= "00000000"; cin_tb <= '0';
        wait for 10 ns;

        a_tb <= "00000001"; b_tb <= "00000001"; cin_tb <= '0';
        wait for 10 ns;

        a_tb <= "11111111"; b_tb <= "00000001"; cin_tb <= '0';
        wait for 10 ns;

        a_tb <= "11110000"; b_tb <= "00001111"; cin_tb <= '0';
        wait for 10 ns;

        a_tb <= "01111111"; b_tb <= "00000001"; cin_tb <= '0';
        wait for 10 ns;

        a_tb <= "10000000"; b_tb <= "10000000"; cin_tb <= '0';
        wait for 10 ns;

        a_tb <= "01010101"; b_tb <= "10101010"; cin_tb <= '1';
        wait for 10 ns;

        a_tb <= "11111111"; b_tb <= "11111111"; cin_tb <= '1';
        wait for 10 ns;

        wait;
    end process;

end behavior;
