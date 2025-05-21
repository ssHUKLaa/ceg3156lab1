library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; -- For arithmetic ops on std_logic_vector

entity tb_decrementer_8bit is
end tb_decrementer_8bit;

architecture behavior of tb_decrementer_8bit is

    -- Component declaration
    component decrementer_8bit
        port(
            data_in  : in  std_logic_vector(7 downto 0);
            GClock   : in  std_logic;
            i_enable : in  std_logic;
            GReset   : in  std_logic;
            i_load   : in  std_logic;
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Signals for the testbench
    signal data_in_tb  : std_logic_vector(7 downto 0);
    signal GClock_tb   : std_logic := '0';
    signal i_enable_tb : std_logic := '0';
    signal GReset_tb   : std_logic := '0';
    signal i_load_tb   : std_logic := '0';
    signal data_out_tb : std_logic_vector(7 downto 0);

    -- Clock period constant
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: decrementer_8bit
        port map (
            data_in  => data_in_tb,
            GClock   => GClock_tb,
            i_enable => i_enable_tb,
            GReset   => GReset_tb,
            i_load   => i_load_tb,
            data_out => data_out_tb
        );

    -- Clock process
    clk_process :process
    begin
        while now < 200 ns loop
            GClock_tb <= '0';
            wait for clk_period/2;
            GClock_tb <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Apply reset
        GReset_tb <= '1';
        wait for clk_period;
        GReset_tb <= '0';
        wait for clk_period;

        -- Load initial value
        data_in_tb <= "00001111";  -- 15 in decimal
        i_load_tb <= '1';
        wait for clk_period;
        i_load_tb <= '0';

        -- Enable decrementing
        i_enable_tb <= '1';

        -- Wait several clock cycles to observe decrementing
        wait for 8 * clk_period;

        -- Stop decrementing
        i_enable_tb <= '0';
        wait for 2 * clk_period;

        -- Load new value
        data_in_tb <= "00000101";  -- 5 in decimal
        i_load_tb <= '1';
        wait for clk_period;
        i_load_tb <= '0';

        -- Enable decrement again
        i_enable_tb <= '1';
        wait for 6 * clk_period;

        -- Finish
        wait;
    end process;

end behavior;
