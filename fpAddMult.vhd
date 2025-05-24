
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fpAddMult IS
	PORT (
		GClock, GReset, SignIn, selAB, startOpr : IN STD_LOGIC;
		MantissaIn : IN STD_LOGIC_VECTOR(7 downto 0);
		ExponentIn : IN STD_LOGIC_VECTOR(6 downto 0);   
		SignOut, Overflow, SignsOpposite : OUT STD_LOGIC;
		MantissaOut : OUT STD_LOGIC_VECTOR(7 downto 0);
		ExponentOut : OUT STD_LOGIC_VECTOR(6 downto 0)
	);
END fpAddMult; 
	
architecture basic of fpAddMult is
	
	
	component fpAdd is
		PORT (
			GClock, GReset, SignA, SignB : IN STD_LOGIC;
			MantissaA, MantissaB : IN STD_LOGIC_VECTOR(7 downto 0);
			ExponentA, ExponentB : IN STD_LOGIC_VECTOR(6 downto 0);
			SignOut, Overflow : OUT STD_LOGIC;
			MantissaOut : OUT STD_LOGIC_VECTOR(7 downto 0);
			ExponentOut : OUT STD_LOGIC_VECTOR(6 downto 0)
		);
	end component;
	
	component fpMult is
		PORT (
			GClock, GReset, SignA, SignB : IN STD_LOGIC;
			MantissaA, MantissaB : IN STD_LOGIC_VECTOR(7 downto 0);
			ExponentA, ExponentB : IN STD_LOGIC_VECTOR(6 downto 0);
			SignOut, Overflow : OUT STD_LOGIC;
			MantissaOut : OUT STD_LOGIC_VECTOR(7 downto 0);
			ExponentOut : OUT STD_LOGIC_VECTOR(6 downto 0)
		);
	end component;
	
	component mux_2to1_8bit IS
		PORT (
			sel     : IN  STD_LOGIC;                             -- Select input
         d_in1   : IN  STD_LOGIC_VECTOR(7 downto 0);        -- 8-bit Data input 1
         d_in2   : IN  STD_LOGIC_VECTOR(7 downto 0);        -- 8-bit Data input 2                         -- Reset input
         d_out   : OUT STD_LOGIC_VECTOR(7 downto 0)          -- 8-bit Data output
		);
	end component;
	
	component enardFF_2 is
      port (
         i_resetBar : in  std_logic;
         i_d        : in  std_logic;
         i_enable   : in  std_logic;
         i_clock    : in  std_logic;
         o_q        : out std_logic;
         o_qBar     : out std_logic
      );
   end component;
		
	SIGNAL transientManA, transientManB : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL transientExpA, transientExpB : STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL enableManB, transSignA, transSignB, sticky, dff_in, startCondition : STD_LOGIC;
begin

	
	enableManB <= NOT selAB;
	
	
	dff_signa: enardFF_2 port map(
            i_resetBar => GReset,
            i_d        => SignIn,
            i_enable   => selAB,
            i_clock    => GClock,
            o_q        => transSignA,
            o_qBar     => open
        );
		  
	dff_signb: enardFF_2 port map(
            i_resetBar => GReset,
            i_d        => SignIn,
            i_enable   => enableManB,
            i_clock    => GClock,
            o_q        => transSignB,
            o_qBar     => open
        );
	
	gen_manA: for i in 0 to 7 generate
        dff_mana: enardFF_2 port map(
            i_resetBar => GReset,
            i_d        => MantissaIn(i),
            i_enable   => selAB,
            i_clock    => GClock,
            o_q        => transientManA(i),
            o_qBar     => open
        );
    end generate;
	 
	 gen_expA: for i in 0 to 6 generate
        dff_expa: enardFF_2 port map(
            i_resetBar => GReset,
            i_d        => ExponentIn(i),
            i_enable   => selAB,
            i_clock    => GClock,
            o_q        => transientExpA(i),
            o_qBar     => open
        );
    end generate;
	 
	 gen_manB: for i in 0 to 7 generate
        dff_manb: enardFF_2 port map(
            i_resetBar => GReset,
            i_d        => MantissaIn(i),
            i_enable   => enableManB,
            i_clock    => GClock,
            o_q        => transientManB(i),
            o_qBar     => open
        );
    end generate;
	 
	 gen_expB: for i in 0 to 6 generate
        dff_expb: enardFF_2 port map(
            i_resetBar => GReset,
            i_d        => ExponentIn(i),
            i_enable   => enableManB,
            i_clock    => GClock,
            o_q        => transientExpB(i),
            o_qBar     => open
        );
    end generate;
	 
	 dff_in <= startOpr or sticky;
	 
	 dff_sticky: enardFF_2 port map(
            i_resetBar => GReset,
            i_d        => dff_in,
            i_enable   => '1',
            i_clock    => GClock,
            o_q        => sticky,
            o_qBar     => open
        );
	 
	 startCondition <= GReset AND NOT sticky;
	 
	 
	 doAdd: fpAdd
		PORT MAP (
			GClock => GClock,
			GReset => startCondition,
			SignA => transSignA,
			SignB => transSignB,
			MantissaA => transientManA,
			MantissaB => transientManB,
			ExponentA => transientExpA,
			EXponentB => transientExpB,
			SignOut => SignOut,
			MantissaOut => MantissaOut,
			ExponentOut => ExponentOut,
			Overflow => Overflow
		);
	 
	
end basic;