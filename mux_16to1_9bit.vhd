LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux_16to1_9bit IS
    PORT(
        sel   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0); -- 4-bit selector
        d_in0 : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
        d_in1 : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
        d_in2 : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
        d_in3 : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
        d_in4 : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
        d_in5 : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
        d_in6 : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
        d_in7 : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
        d_in8 : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
        d_in9 : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
        d_in10: IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
        d_in11: IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
        d_in12: IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
        d_in13: IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
        d_in14: IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
        d_in15: IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
        d_out : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
    );
END mux_16to1_9bit;

ARCHITECTURE structural OF mux_16to1_9bit IS

    -- Declare selector signals
    SIGNAL sel0, sel1, sel2, sel3 : STD_LOGIC;
    SIGNAL nsel0, nsel1, nsel2, nsel3 : STD_LOGIC;

    -- Declare the enable signals
    SIGNAL enable : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Declare the intermediate AND output signals for each input
    SIGNAL and_out0, and_out1, and_out2, and_out3 : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL and_out4, and_out5, and_out6, and_out7 : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL and_out8, and_out9, and_out10, and_out11 : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL and_out12, and_out13, and_out14, and_out15 : STD_LOGIC_VECTOR(8 DOWNTO 0);

BEGIN
    -- Decode select
    sel0 <= sel(0);
    sel1 <= sel(1);
    sel2 <= sel(2);
    sel3 <= sel(3);
    nsel0 <= NOT sel(0);
    nsel1 <= NOT sel(1);
    nsel2 <= NOT sel(2);
    nsel3 <= NOT sel(3);

    -- 4-to-16 decoder to generate enables
    enable(0) <= nsel3 AND nsel2 AND nsel1 AND nsel0;
    enable(1) <= nsel3 AND nsel2 AND nsel1 AND sel0;
    enable(2) <= nsel3 AND nsel2 AND sel1  AND nsel0;
    enable(3) <= nsel3 AND nsel2 AND sel1  AND sel0;
    enable(4) <= nsel3 AND sel2  AND nsel1 AND nsel0;
    enable(5) <= nsel3 AND sel2  AND nsel1 AND sel0;
    enable(6) <= nsel3 AND sel2  AND sel1  AND nsel0;
    enable(7) <= nsel3 AND sel2  AND sel1  AND sel0;
    enable(8) <= sel3  AND nsel2 AND nsel1 AND nsel0;
    enable(9) <= sel3  AND nsel2 AND nsel1 AND sel0;
    enable(10) <= sel3  AND nsel2 AND sel1  AND nsel0;
    enable(11) <= sel3  AND nsel2 AND sel1  AND sel0;
    enable(12) <= sel3  AND sel2  AND nsel1 AND nsel0;
    enable(13) <= sel3  AND sel2  AND nsel1 AND sel0;
    enable(14) <= sel3  AND sel2  AND sel1  AND nsel0;
    enable(15) <= sel3  AND sel2  AND sel1  AND sel0;

    -- AND each 9-bit input with its enable signal (element-wise AND operation)
    -- Perform the AND operation on each individual bit of the vectors:
    GEN_AND_OUT: FOR i IN 0 TO 8 GENERATE
        and_out0(i) <= d_in0(i) AND enable(0);
        and_out1(i) <= d_in1(i) AND enable(1);
        and_out2(i) <= d_in2(i) AND enable(2);
        and_out3(i) <= d_in3(i) AND enable(3);
        and_out4(i) <= d_in4(i) AND enable(4);
        and_out5(i) <= d_in5(i) AND enable(5);
        and_out6(i) <= d_in6(i) AND enable(6);
        and_out7(i) <= d_in7(i) AND enable(7);
        and_out8(i) <= d_in8(i) AND enable(8);
        and_out9(i) <= d_in9(i) AND enable(9);
        and_out10(i) <= d_in10(i) AND enable(10);
        and_out11(i) <= d_in11(i) AND enable(11);
        and_out12(i) <= d_in12(i) AND enable(12);
        and_out13(i) <= d_in13(i) AND enable(13);
        and_out14(i) <= d_in14(i) AND enable(14);
        and_out15(i) <= d_in15(i) AND enable(15);
    END GENERATE;

    -- OR all the AND outputs together to get the final output
    d_out <= and_out0 OR and_out1 OR and_out2 OR and_out3 OR
             and_out4 OR and_out5 OR and_out6 OR and_out7 OR
             and_out8 OR and_out9 OR and_out10 OR and_out11 OR
             and_out12 OR and_out13 OR and_out14 OR and_out15;

END structural;
