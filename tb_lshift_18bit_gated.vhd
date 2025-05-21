library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_lshift_18bit_gated is
end tb_lshift_18bit_gated;

architecture behavior of tb_lshift_18bit_gated is

    component lshift_18bit_gated
        port (
            data_in  : in  STD_LOGIC_VECTOR(17 downto 0);
            GClock   : in  STD_LOGIC;
            i_enable : in  STD_LOGIC;
            GReset   : in  STD_LOGIC;
            i_load   : in  STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR(17 downto 0)
        );
    end component;

    signal data_in_tb  : STD_LOGIC_VECTOR(17 downto 0);
    signal GClock_tb   : STD_LOGIC := '0';
    signal i_enable_tb : STD_LOGIC := '0';
    signal GReset_tb   : STD_LOGIC := '0';
    signal i_load_tb   : STD_LOGIC := '0';
    signal data_out_tb : STD_LOGIC_VECTOR(17 downto 0);

    constant clk_period : time := 10 ns;

begin

    uut: lshift_18bit_gated
        port map (
            data_in  => data_in_tb,
            GClock   => GClock_tb,
            i_enable => i_enable_tb,
            GReset   => GReset_tb,
            i_load   => i_load_tb,
            data_out => data_out_tb
        );

    clk_process: process
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

        data_in_tb <= x"0001";
        i_load_tb <= '1';
        wait for clk_period;
        i_load_tb <= '0';

        i_enable_tb <= '1';
        wait for 5 * clk_period;

        i_enable_tb <= '0';
        wait for 2 * clk_period;

        data_in_tb <= x"4000";
        i_load_tb <= '1';
        wait for clk_period;
        i_load_tb <= '0';

        i_enable_tb <= '1';
        wait for 3 * clk_period;

        wait;
    end process;

end behavior;
