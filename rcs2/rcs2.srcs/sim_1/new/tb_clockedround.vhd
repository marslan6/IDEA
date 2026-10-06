----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    07/04/2026 10:26:51 PM
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    tb_clockedround - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool Versions:  Xilinx ISE WebPack
-- Description:    Testbench for the clocked round module of rcs2.
-- 
-- Dependencies:   IEEE.STD_LOGIC_1164.ALL, IEEE.NUMERIC_STD.ALL
-- 
-- Revision:
-- Revision 0.02 - Added all step vectors from design validation tables.
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_clockedround is
end tb_clockedround;

architecture Behavioral of tb_clockedround is
    
    component clockedround is
        port (
            CLK      : in    std_logic;
            INIT     : in    std_logic;
            TRAFO    : in    std_logic;
            X1       : in    std_logic_vector(15 downto 0);
            X2       : in    std_logic_vector(15 downto 0);
            X3       : in    std_logic_vector(15 downto 0);
            X4       : in    std_logic_vector(15 downto 0);
            Z1       : in    std_logic_vector(15 downto 0);
            Z2       : in    std_logic_vector(15 downto 0);
            Z3       : in    std_logic_vector(15 downto 0);
            Z4       : in    std_logic_vector(15 downto 0);
            Z5       : in    std_logic_vector(15 downto 0);
            Z6       : in    std_logic_vector(15 downto 0);
            Y1       : out   std_logic_vector(15 downto 0);
            Y2       : out   std_logic_vector(15 downto 0);
            Y3       : out   std_logic_vector(15 downto 0);
            Y4       : out   std_logic_vector(15 downto 0);
            RESULT   : out   std_logic;
            Y1_TRAFO : out   std_logic_vector(15 downto 0);
            Y2_TRAFO : out   std_logic_vector(15 downto 0);
            Y3_TRAFO : out   std_logic_vector(15 downto 0);
            Y4_TRAFO : out   std_logic_vector(15 downto 0)
        );
    end component clockedround;

    constant clk_period : time := 10 ns;

    signal tb_CLK      : std_logic := '0';
    signal tb_INIT     : std_logic := '0';
    signal tb_TRAFO    : std_logic := '0';
    signal tb_X1       : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_X2       : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_X3       : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_X4       : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Z1       : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Z2       : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Z3       : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Z4       : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Z5       : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Z6       : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Y1       : std_logic_vector(15 downto 0);
    signal tb_Y2       : std_logic_vector(15 downto 0);
    signal tb_Y3       : std_logic_vector(15 downto 0);
    signal tb_Y4       : std_logic_vector(15 downto 0);
    signal tb_RESULT   : std_logic;
    signal tb_Y1_TRAFO : std_logic_vector(15 downto 0);
    signal tb_Y2_TRAFO : std_logic_vector(15 downto 0);
    signal tb_Y3_TRAFO : std_logic_vector(15 downto 0);
    signal tb_Y4_TRAFO : std_logic_vector(15 downto 0);

begin

    DUT_CLOCKEDROUND : clockedround 
    port map (
        CLK      => tb_CLK,
        INIT     => tb_INIT,
        TRAFO    => tb_TRAFO,
        X1       => tb_X1,
        X2       => tb_X2,
        X3       => tb_X3,
        X4       => tb_X4,
        Z1       => tb_Z1,
        Z2       => tb_Z2,
        Z3       => tb_Z3,
        Z4       => tb_Z4,
        Z5       => tb_Z5,
        Z6       => tb_Z6,
        Y1       => tb_Y1,
        Y2       => tb_Y2,
        Y3       => tb_Y3,
        Y4       => tb_Y4,
        RESULT   => tb_RESULT,
        Y1_TRAFO => tb_Y1_TRAFO,
        Y2_TRAFO => tb_Y2_TRAFO,
        Y3_TRAFO => tb_Y3_TRAFO,
        Y4_TRAFO => tb_Y4_TRAFO
    );

    P_CLK : process 
    begin
        tb_CLK <= '0';
        wait for clk_period / 2;
        tb_CLK <= '1';
        wait for clk_period / 2;
    end process P_CLK;

    P_STIMULUS : process 
        variable step : integer range 0 to 63 := 0;
    begin   

        assert (false) report "CLOCKEDROUND TESTBENCH START" severity note;

        step := 0;
        tb_INIT  <= '0';
        tb_TRAFO <= '0';
        wait for clk_period * 5;

        -------------------------------------------------------------
        -- PART 1: ROUND MODULE TESTS (11 Steps, TRAFO = 0)
        -------------------------------------------------------------
        -- Step 0
        tb_X1 <= x"0000"; tb_X2 <= x"0000"; tb_X3 <= x"0000"; tb_X4 <= x"0000";
        tb_Z1 <= x"0000"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000"; tb_Z5 <= x"0000"; tb_Z6 <= x"0000";
        
        wait until rising_edge(tb_CLK);
        tb_INIT <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT <= '0';
        
        wait until tb_RESULT = '1';
        wait until falling_edge(tb_CLK);
        
        assert (tb_Y1 = x"0001") report "TEST " & integer'image(step) & " Y1 FAILED" severity warning;
        assert (tb_Y2 = x"0000") report "TEST " & integer'image(step) & " Y2 FAILED" severity warning;
        assert (tb_Y3 = x"0000") report "TEST " & integer'image(step) & " Y3 FAILED" severity warning;
        assert (tb_Y4 = x"0001") report "TEST " & integer'image(step) & " Y4 FAILED" severity warning;
        step := step + 1; 
        wait for clk_period * 3;

        -- Step 1
        tb_X1 <= x"ffff"; tb_X2 <= x"0000"; tb_X3 <= x"0000"; tb_X4 <= x"0000";
        tb_Z1 <= x"0000"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000"; tb_Z5 <= x"0000"; tb_Z6 <= x"0000";
        
        wait until rising_edge(tb_CLK);
        tb_INIT <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT <= '0';
        
        wait until tb_RESULT = '1';
        wait until falling_edge(tb_CLK);
        
        assert (tb_Y1 = x"0003") report "TEST " & integer'image(step) & " Y1 FAILED" severity warning;
        assert (tb_Y2 = x"0001") report "TEST " & integer'image(step) & " Y2 FAILED" severity warning;
        assert (tb_Y3 = x"0000") report "TEST " & integer'image(step) & " Y3 FAILED" severity warning;
        assert (tb_Y4 = x"0001") report "TEST " & integer'image(step) & " Y4 FAILED" severity warning;
        step := step + 1; 
        wait for clk_period * 3;

        -- Step 2
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"0000"; tb_X4 <= x"0000";
        tb_Z1 <= x"0000"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000"; tb_Z5 <= x"0000"; tb_Z6 <= x"0000";
        
        wait until rising_edge(tb_CLK);
        tb_INIT <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT <= '0';
        
        wait until tb_RESULT = '1';
        wait until falling_edge(tb_CLK);
        
        assert (tb_Y1 = x"5555") report "TEST " & integer'image(step) & " Y1 FAILED" severity warning;
        assert (tb_Y2 = x"5557") report "TEST " & integer'image(step) & " Y2 FAILED" severity warning;
        assert (tb_Y3 = x"fffc") report "TEST " & integer'image(step) & " Y3 FAILED" severity warning;
        assert (tb_Y4 = x"5557") report "TEST " & integer'image(step) & " Y4 FAILED" severity warning;
        step := step + 1; 
        wait for clk_period * 3;

        -- Step 3
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"5555"; tb_X4 <= x"0000";
        tb_Z1 <= x"0000"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000"; tb_Z5 <= x"0000"; tb_Z6 <= x"0000";
        
        wait until rising_edge(tb_CLK);
        tb_INIT <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT <= '0';
        
        wait until tb_RESULT = '1';
        wait until falling_edge(tb_CLK);
        
        assert (tb_Y1 = x"aaae") report "TEST " & integer'image(step) & " Y1 FAILED" severity warning;
        assert (tb_Y2 = x"fff9") report "TEST " & integer'image(step) & " Y2 FAILED" severity warning;
        assert (tb_Y3 = x"fffc") report "TEST " & integer'image(step) & " Y3 FAILED" severity warning;
        assert (tb_Y4 = x"5557") report "TEST " & integer'image(step) & " Y4 FAILED" severity warning;
        step := step + 1; 
        wait for clk_period * 3;

        -- Step 4
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"0000"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000"; tb_Z5 <= x"0000"; tb_Z6 <= x"0000";
        
        wait until rising_edge(tb_CLK);
        tb_INIT <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT <= '0';
        
        wait until tb_RESULT = '1';
        wait until falling_edge(tb_CLK);
        
        assert (tb_Y1 = x"e390") report "TEST " & integer'image(step) & " Y1 FAILED" severity warning;
        assert (tb_Y2 = x"b6c7") report "TEST " & integer'image(step) & " Y2 FAILED" severity warning;
        assert (tb_Y3 = x"2496") report "TEST " & integer'image(step) & " Y3 FAILED" severity warning;
        assert (tb_Y4 = x"5553") report "TEST " & integer'image(step) & " Y4 FAILED" severity warning;
        step := step + 1; 
        wait for clk_period * 3;

        -- Step 5
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"db6d"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000"; tb_Z5 <= x"0000"; tb_Z6 <= x"0000";
        
        wait until rising_edge(tb_CLK);
        tb_INIT <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT <= '0';
        
        wait until tb_RESULT = '1';
        wait until falling_edge(tb_CLK);
        
        assert (tb_Y1 = x"e390") report "TEST " & integer'image(step) & " Y1 FAILED" severity warning;
        assert (tb_Y2 = x"ffed") report "TEST " & integer'image(step) & " Y2 FAILED" severity warning;
        assert (tb_Y3 = x"2496") report "TEST " & integer'image(step) & " Y3 FAILED" severity warning;
        assert (tb_Y4 = x"5553") report "TEST " & integer'image(step) & " Y4 FAILED" severity warning;
        step := step + 1; 
        wait for clk_period * 3;

        -- Step 6
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"db6d"; tb_Z2 <= x"1c71"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000"; tb_Z5 <= x"0000"; tb_Z6 <= x"0000";
        
        wait until rising_edge(tb_CLK);
        tb_INIT <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT <= '0';
        
        wait until tb_RESULT = '1';
        wait until falling_edge(tb_CLK);
        
        assert (tb_Y1 = x"4921") report "TEST " & integer'image(step) & " Y1 FAILED" severity warning;
        assert (tb_Y2 = x"555c") report "TEST " & integer'image(step) & " Y2 FAILED" severity warning;
        assert (tb_Y3 = x"2496") report "TEST " & integer'image(step) & " Y3 FAILED" severity warning;
        assert (tb_Y4 = x"38e2") report "TEST " & integer'image(step) & " Y4 FAILED" severity warning;
        step := step + 1; 
        wait for clk_period * 3;

        -- Step 7
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"db6d"; tb_Z2 <= x"1c71"; tb_Z3 <= x"cccc"; tb_Z4 <= x"0000"; tb_Z5 <= x"0000"; tb_Z6 <= x"0000";
        
        wait until rising_edge(tb_CLK);
        tb_INIT <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT <= '0';
        
        wait until tb_RESULT = '1';
        wait until falling_edge(tb_CLK);
        
        assert (tb_Y1 = x"07bd") report "TEST " & integer'image(step) & " Y1 FAILED" severity warning;
        assert (tb_Y2 = x"6cb4") report "TEST " & integer'image(step) & " Y2 FAILED" severity warning;
        assert (tb_Y3 = x"2496") report "TEST " & integer'image(step) & " Y3 FAILED" severity warning;
        assert (tb_Y4 = x"38e2") report "TEST " & integer'image(step) & " Y4 FAILED" severity warning;
        step := step + 1; 
        wait for clk_period * 3;

        -- Step 8
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"db6d"; tb_Z2 <= x"1c71"; tb_Z3 <= x"cccc"; tb_Z4 <= x"0002"; tb_Z5 <= x"0000"; tb_Z6 <= x"0000";
        
        wait until rising_edge(tb_CLK);
        tb_INIT <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT <= '0';
        
        wait until tb_RESULT = '1';
        wait until falling_edge(tb_CLK);
        
        assert (tb_Y1 = x"95e2") report "TEST " & integer'image(step) & " Y1 FAILED" severity warning;
        assert (tb_Y2 = x"feeb") report "TEST " & integer'image(step) & " Y2 FAILED" severity warning;
        assert (tb_Y3 = x"b6d9") report "TEST " & integer'image(step) & " Y3 FAILED" severity warning;
        assert (tb_Y4 = x"38e6") report "TEST " & integer'image(step) & " Y4 FAILED" severity warning;
        step := step + 1; 
        wait for clk_period * 3;

        -- Step 9
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"db6d"; tb_Z2 <= x"1c71"; tb_Z3 <= x"cccc"; tb_Z4 <= x"0002"; tb_Z5 <= x"eeee"; tb_Z6 <= x"0000";
        
        wait until rising_edge(tb_CLK);
        tb_INIT <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT <= '0';
        
        wait until tb_RESULT = '1';
        wait until falling_edge(tb_CLK);
        
        assert (tb_Y1 = x"bc61") report "TEST " & integer'image(step) & " Y1 FAILED" severity warning;
        assert (tb_Y2 = x"d768") report "TEST " & integer'image(step) & " Y2 FAILED" severity warning;
        assert (tb_Y3 = x"b6d9") report "TEST " & integer'image(step) & " Y3 FAILED" severity warning;
        assert (tb_Y4 = x"38e6") report "TEST " & integer'image(step) & " Y4 FAILED" severity warning;
        step := step + 1; 
        wait for clk_period * 3;

        -- Step 10
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"db6d"; tb_Z2 <= x"1c71"; tb_Z3 <= x"cccc"; tb_Z4 <= x"0002"; tb_Z5 <= x"eeee"; tb_Z6 <= x"8888";
        
        wait until rising_edge(tb_CLK);
        tb_INIT <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT <= '0';
        
        wait until tb_RESULT = '1';
        wait until falling_edge(tb_CLK);
        
        assert (tb_Y1 = x"2521") report "TEST " & integer'image(step) & " Y1 FAILED" severity warning;
        assert (tb_Y2 = x"4e28") report "TEST " & integer'image(step) & " Y2 FAILED" severity warning;
        assert (tb_Y3 = x"2f99") report "TEST " & integer'image(step) & " Y3 FAILED" severity warning;
        assert (tb_Y4 = x"a1a6") report "TEST " & integer'image(step) & " Y4 FAILED" severity warning;
        step := step + 1; 
        wait for clk_period * 5;

        -------------------------------------------------------------
        -- PART 2: TRANSFORMATION MODULE TESTS (9 Steps, TRAFO = 1)
        -------------------------------------------------------------
        tb_TRAFO <= '1';

        -- Step 0
        tb_X1 <= x"0000"; tb_X2 <= x"0000"; tb_X3 <= x"0000"; tb_X4 <= x"0000";
        tb_Z1 <= x"0000"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000";
        
        wait until rising_edge(tb_CLK);
        tb_INIT <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT <= '0';
        
        wait until tb_RESULT = '1';
        wait until falling_edge(tb_CLK);
        
        assert (tb_Y1_TRAFO = x"0001") report "TEST " & integer'image(step) & " Y1_TRAFO FAILED" severity warning;
        assert (tb_Y2_TRAFO = x"0000") report "TEST " & integer'image(step) & " Y2_TRAFO FAILED" severity warning;
        assert (tb_Y3_TRAFO = x"0000") report "TEST " & integer'image(step) & " Y3_TRAFO FAILED" severity warning;
        assert (tb_Y4_TRAFO = x"0001") report "TEST " & integer'image(step) & " Y4_TRAFO FAILED" severity warning;
        step := step + 1; 
        wait for clk_period * 3;

        -- Step 1
        tb_X1 <= x"ffff"; tb_X2 <= x"0000"; tb_X3 <= x"0000"; tb_X4 <= x"0000";
        tb_Z1 <= x"0000"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000";
        
        wait until rising_edge(tb_CLK);
        tb_INIT <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT <= '0';
        
        wait until tb_RESULT = '1';
        wait until falling_edge(tb_CLK);
        
        assert (tb_Y1_TRAFO = x"0002") report "TEST " & integer'image(step) & " Y1_TRAFO FAILED" severity warning;
        assert (tb_Y2_TRAFO = x"0000") report "TEST " & integer'image(step) & " Y2_TRAFO FAILED" severity warning;
        assert (tb_Y3_TRAFO = x"0000") report "TEST " & integer'image(step) & " Y3_TRAFO FAILED" severity warning;
        assert (tb_Y4_TRAFO = x"0001") report "TEST " & integer'image(step) & " Y4_TRAFO FAILED" severity warning;
        step := step + 1; 
        wait for clk_period * 3;

        -- Step 2
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"0000"; tb_X4 <= x"0000";
        tb_Z1 <= x"0000"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000";
        
        wait until rising_edge(tb_CLK);
        tb_INIT <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT <= '0';
        
        wait until tb_RESULT = '1';
        wait until falling_edge(tb_CLK);
        
        assert (tb_Y1_TRAFO = x"0002") report "TEST " & integer'image(step) & " Y1_TRAFO FAILED" severity warning;
        assert (tb_Y2_TRAFO = x"0000") report "TEST " & integer'image(step) & " Y2_TRAFO FAILED" severity warning;
        assert (tb_Y3_TRAFO = x"aaaa") report "TEST " & integer'image(step) & " Y3_TRAFO FAILED" severity warning;
        assert (tb_Y4_TRAFO = x"0001") report "TEST " & integer'image(step) & " Y4_TRAFO FAILED" severity warning;
        step := step + 1; 
        wait for clk_period * 3;

        -- Step 3
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"5555"; tb_X4 <= x"0000";
        tb_Z1 <= x"0000"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000";
        
        wait until rising_edge(tb_CLK);
        tb_INIT <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT <= '0';
        
        wait until tb_RESULT = '1';
        wait until falling_edge(tb_CLK);
        
        assert (tb_Y1_TRAFO = x"0002") report "TEST " & integer'image(step) & " Y1_TRAFO FAILED" severity warning;
        assert (tb_Y2_TRAFO = x"5555") report "TEST " & integer'image(step) & " Y2_TRAFO FAILED" severity warning;
        assert (tb_Y3_TRAFO = x"aaaa") report "TEST " & integer'image(step) & " Y3_TRAFO FAILED" severity warning;
        assert (tb_Y4_TRAFO = x"0001") report "TEST " & integer'image(step) & " Y4_TRAFO FAILED" severity warning;
        step := step + 1; 
        wait for clk_period * 3;

        -- Step 4
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"0000"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000";
        
        wait until rising_edge(tb_CLK);
        tb_INIT <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT <= '0';
        
        wait until tb_RESULT = '1';
        wait until falling_edge(tb_CLK);
        
        assert (tb_Y1_TRAFO = x"0002") report "TEST " & integer'image(step) & " Y1_TRAFO FAILED" severity warning;
        assert (tb_Y2_TRAFO = x"5555") report "TEST " & integer'image(step) & " Y2_TRAFO FAILED" severity warning;
        assert (tb_Y3_TRAFO = x"aaaa") report "TEST " & integer'image(step) & " Y3_TRAFO FAILED" severity warning;
        assert (tb_Y4_TRAFO = x"db6f") report "TEST " & integer'image(step) & " Y4_TRAFO FAILED" severity warning;
        step := step + 1; 
        wait for clk_period * 3;

        -- Step 5
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"db6d"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000";
        
        wait until rising_edge(tb_CLK);
        tb_INIT <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT <= '0';
        
        wait until tb_RESULT = '1';
        wait until falling_edge(tb_CLK);
        
        assert (tb_Y1_TRAFO = x"4928") report "TEST " & integer'image(step) & " Y1_TRAFO FAILED" severity warning;
        assert (tb_Y2_TRAFO = x"5555") report "TEST " & integer'image(step) & " Y2_TRAFO FAILED" severity warning;
        assert (tb_Y3_TRAFO = x"aaaa") report "TEST " & integer'image(step) & " Y3_TRAFO FAILED" severity warning;
        assert (tb_Y4_TRAFO = x"db6f") report "TEST " & integer'image(step) & " Y4_TRAFO FAILED" severity warning;
        step := step + 1; 
        wait for clk_period * 3;

        -- Step 6
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"db6d"; tb_Z2 <= x"1c71"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000";
        
        wait until rising_edge(tb_CLK);
        tb_INIT <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT <= '0';
        
        wait until tb_RESULT = '1';
        wait until falling_edge(tb_CLK);
        
        assert (tb_Y1_TRAFO = x"4928") report "TEST " & integer'image(step) & " Y1_TRAFO FAILED" severity warning;
        assert (tb_Y2_TRAFO = x"71c6") report "TEST " & integer'image(step) & " Y2_TRAFO FAILED" severity warning;
        assert (tb_Y3_TRAFO = x"aaaa") report "TEST " & integer'image(step) & " Y3_TRAFO FAILED" severity warning;
        assert (tb_Y4_TRAFO = x"db6f") report "TEST " & integer'image(step) & " Y4_TRAFO FAILED" severity warning;
        step := step + 1; 
        wait for clk_period * 3;

        -- Step 7
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"db6d"; tb_Z2 <= x"1c71"; tb_Z3 <= x"cccc"; tb_Z4 <= x"0000";
        
        wait until rising_edge(tb_CLK);
        tb_INIT <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT <= '0';
        
        wait until tb_RESULT = '1';
        wait until falling_edge(tb_CLK);
        
        assert (tb_Y1_TRAFO = x"4928") report "TEST " & integer'image(step) & " Y1_TRAFO FAILED" severity warning;
        assert (tb_Y2_TRAFO = x"71c6") report "TEST " & integer'image(step) & " Y2_TRAFO FAILED" severity warning;
        assert (tb_Y3_TRAFO = x"7776") report "TEST " & integer'image(step) & " Y3_TRAFO FAILED" severity warning;
        assert (tb_Y4_TRAFO = x"db6f") report "TEST " & integer'image(step) & " Y4_TRAFO FAILED" severity warning;
        step := step + 1; 
        wait for clk_period * 3;

        -- Step 8
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"db6d"; tb_Z2 <= x"1c71"; tb_Z3 <= x"cccc"; tb_Z4 <= x"0002";
        
        wait until rising_edge(tb_CLK);
        tb_INIT <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT <= '0';
        
        wait until tb_RESULT = '1';
        wait until falling_edge(tb_CLK);
        
        assert (tb_Y1_TRAFO = x"4928") report "TEST " & integer'image(step) & " Y1_TRAFO FAILED" severity warning;
        assert (tb_Y2_TRAFO = x"71c6") report "TEST " & integer'image(step) & " Y2_TRAFO FAILED" severity warning;
        assert (tb_Y3_TRAFO = x"7776") report "TEST " & integer'image(step) & " Y3_TRAFO FAILED" severity warning;
        assert (tb_Y4_TRAFO = x"4924") report "TEST " & integer'image(step) & " Y4_TRAFO FAILED" severity warning;
        step := step + 1;

        assert (false) report "ALL TESTS PASSED" severity note;
        wait;
    end process;

end Behavioral;
