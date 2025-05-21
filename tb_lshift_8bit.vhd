library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_lshift_8bit is
end tb_lshift_8bit;

architecture behavior of tb_lshift_8bit is

    component lshift_8bit
        port(
            data_in  : in  std_logic_vector(7 downto 0);
            GClock   : in  std_logic;
            i_enable : in  std_logic;
            GReset   : in  std_logic;
            i_load   : in  std_logic;
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;

    signal data_in_tb  : std_logic_vector(7 downto 0);
    signal GClock_tb   : std_logic := '0';
    signal i_enable_tb : std_logic := '0';
    signal GReset_tb   : std_logic := '0';
    signal i_load_tb   : std_logic := '0';
    signal data_out_tb : std_logic_vector(7 downto 0);

    constant clk_period : time := 10 ns;

begin

    uut: lshift_8bit
        port map (
            data_in  => data_in_tb,
            GClock   => GClock_tb,
            i_enable => i_enable_tb,
            GReset   => GReset_tb,
            i_load   => i_load_tb,
            data_out => data_out_tb
        );

    clk_process : process
    begin
        while now < 200 ns loop
            GClock_tb <= '0';
            wait for clk_period / 2;
            GClock_tb <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    stim_proc: process
    begin
        GReset_tb <= '1';
        wait for clk_period;
        GReset_tb <= '0';
        wait for clk_period;

        data_in_tb <= "00001111";
        i_load_tb <= '1';
        wait for clk_period;
        i_load_tb <= '0';

        i_enable_tb <= '1';
        wait for 5 * clk_period;

        i_enable_tb <= '0';
        wait for clk_period;

        data_in_tb <= "10000000";
        i_load_tb <= '1';
        wait for clk_period;
        i_load_tb <= '0';

        i_enable_tb <= '1';
        wait for 3 * clk_period;

        wait;
    end process;

end behavior;
