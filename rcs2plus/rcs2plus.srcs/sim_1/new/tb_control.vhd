----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    07/04/2026 10:26:22 PM
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    tb_control - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool Versions:  Xilinx ISE WebPack
-- Description:    Testbench for the control module of rcs2.
-- 
-- Dependencies:   IEEE.STD_LOGIC_1164.ALL, IEEE.NUMERIC_STD.ALL
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_control is
end tb_control;

architecture Behavioral of tb_control is
    
    component control is
        port ( 
            CLK    : in    std_logic;
            INIT   : in    std_logic;
            TRAFO  : in    std_logic;
            EN125  : out   std_logic;
            EN346  : out   std_logic;
            EN78   : out   std_logic;
            RESULT : out   std_logic;
            S      : out   std_logic_vector(1 downto 0);
            S_T    : out   std_logic_vector(1 downto 0)
        );	
    end component control;

    constant clk_period : time := 10 ns;

    signal tb_CLK    : std_logic := '0';
    signal tb_INIT   : std_logic := '0';
    signal tb_TRAFO  : std_logic := '0';
    signal tb_EN125  : std_logic;
    signal tb_EN346  : std_logic;
    signal tb_EN78   : std_logic;
    signal tb_RESULT : std_logic;
    signal tb_S      : std_logic_vector(1 downto 0);
    signal tb_S_T    : std_logic_vector(1 downto 0);

begin

    DUT_CONTROLLER : control 
    port map (
        CLK    => tb_CLK,
        INIT   => tb_INIT,
        TRAFO  => tb_TRAFO,
        EN125  => tb_EN125,
        EN346  => tb_EN346,
        EN78   => tb_EN78,
        RESULT => tb_RESULT,
        S      => tb_S,
        S_T    => tb_S_T
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

        assert (false) report "CONTROL TESTBENCH START" severity note;

        step := 0;
        tb_INIT  <= '0';
        tb_TRAFO <= '0';
        wait for clk_period * 5;

        -- State S6_RCS2 (Idle, TRAFO=0)
        assert (tb_EN125 = '0')  report "TEST CASE " & integer'image(step) & " EN125 FAILED" severity warning;
        assert (tb_EN346 = '0')  report "TEST CASE " & integer'image(step) & " EN346 FAILED" severity warning;
        assert (tb_EN78 = '0')   report "TEST CASE " & integer'image(step) & " EN78 FAILED" severity warning;
        assert (tb_RESULT = '0') report "TEST CASE " & integer'image(step) & " RESULT FAILED" severity warning;
        assert (tb_S = "11")     report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (tb_S_T = "11")   report "TEST CASE " & integer'image(step) & " S_T FAILED" severity warning;
        step := step + 1;

        wait until rising_edge(tb_CLK);
        tb_INIT  <= '1';
        tb_TRAFO <= '0';
        wait until rising_edge(tb_CLK);
        tb_INIT  <= '0';

        -- State S0_RCS2
        wait until falling_edge(tb_CLK);
        assert (tb_EN125 = '1')  report "TEST CASE " & integer'image(step) & " EN125 FAILED" severity warning;
        assert (tb_EN346 = '0')  report "TEST CASE " & integer'image(step) & " EN346 FAILED" severity warning;
        assert (tb_EN78 = '0')   report "TEST CASE " & integer'image(step) & " EN78 FAILED" severity warning;
        assert (tb_RESULT = '0') report "TEST CASE " & integer'image(step) & " RESULT FAILED" severity warning;
        assert (tb_S = "00")     report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (tb_S_T = "00")   report "TEST CASE " & integer'image(step) & " S_T FAILED" severity warning;
        step := step + 1;

        -- State S2_RCS2
        wait until falling_edge(tb_CLK);
        assert (tb_EN125 = '0')  report "TEST CASE " & integer'image(step) & " EN125 FAILED" severity warning;
        assert (tb_EN346 = '1')  report "TEST CASE " & integer'image(step) & " EN346 FAILED" severity warning;
        assert (tb_EN78 = '0')   report "TEST CASE " & integer'image(step) & " EN78 FAILED" severity warning;
        assert (tb_RESULT = '0') report "TEST CASE " & integer'image(step) & " RESULT FAILED" severity warning;
        assert (tb_S = "01")     report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (tb_S_T = "01")   report "TEST CASE " & integer'image(step) & " S_T FAILED" severity warning;
        step := step + 1;

        -- State S4_RCS2
        wait until falling_edge(tb_CLK);
        assert (tb_EN125 = '0')  report "TEST CASE " & integer'image(step) & " EN125 FAILED" severity warning;
        assert (tb_EN346 = '0')  report "TEST CASE " & integer'image(step) & " EN346 FAILED" severity warning;
        assert (tb_EN78 = '1')   report "TEST CASE " & integer'image(step) & " EN78 FAILED" severity warning;
        assert (tb_RESULT = '0') report "TEST CASE " & integer'image(step) & " RESULT FAILED" severity warning;
        assert (tb_S = "10")     report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (tb_S_T = "10")   report "TEST CASE " & integer'image(step) & " S_T FAILED" severity warning;
        step := step + 1;

        -- State S6_RCS2
        wait until falling_edge(tb_CLK);
        assert (tb_EN125 = '0')  report "TEST CASE " & integer'image(step) & " EN125 FAILED" severity warning;
        assert (tb_EN346 = '0')  report "TEST CASE " & integer'image(step) & " EN346 FAILED" severity warning;
        assert (tb_EN78 = '0')   report "TEST CASE " & integer'image(step) & " EN78 FAILED" severity warning;
        assert (tb_RESULT = '1') report "TEST CASE " & integer'image(step) & " RESULT FAILED" severity warning;
        assert (tb_S = "11")     report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (tb_S_T = "11")   report "TEST CASE " & integer'image(step) & " S_T FAILED" severity warning;
        step := step + 1;

        -- State S7_RCS2
        wait until falling_edge(tb_CLK);
        assert (tb_EN125 = '0')  report "TEST CASE " & integer'image(step) & " EN125 FAILED" severity warning;
        assert (tb_EN346 = '0')  report "TEST CASE " & integer'image(step) & " EN346 FAILED" severity warning;
        assert (tb_EN78 = '0')   report "TEST CASE " & integer'image(step) & " EN78 FAILED" severity warning;
        assert (tb_RESULT = '0') report "TEST CASE " & integer'image(step) & " RESULT FAILED" severity warning;
        assert (tb_S = "11")     report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (tb_S_T = "11")   report "TEST CASE " & integer'image(step) & " S_T FAILED" severity warning;
        step := step + 1;

        -- Wait a bit before starting the TRAFO round
        wait for clk_period * 5;
        
        -- Pulse INIT to start extended round (TRAFO=1)
        wait until rising_edge(tb_CLK);
        tb_INIT  <= '1';
        tb_TRAFO <= '1';
        wait until rising_edge(tb_CLK);
        tb_INIT  <= '0';

        -- State S0 (TRAFO=1)
        wait until falling_edge(tb_CLK);
        assert (tb_EN125 = '1')  report "TEST CASE " & integer'image(step) & " EN125 FAILED" severity warning;
        assert (tb_EN346 = '0')  report "TEST CASE " & integer'image(step) & " EN346 FAILED" severity warning;
        assert (tb_EN78 = '0')   report "TEST CASE " & integer'image(step) & " EN78 FAILED" severity warning;
        assert (tb_RESULT = '0') report "TEST CASE " & integer'image(step) & " RESULT FAILED" severity warning;
        assert (tb_S = "00")     report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (tb_S_T = "01")   report "TEST CASE " & integer'image(step) & " S_T FAILED" severity warning;
        step := step + 1;

        -- State S2 (TRAFO=1)
        wait until falling_edge(tb_CLK);
        assert (tb_EN125 = '0')  report "TEST CASE " & integer'image(step) & " EN125 FAILED" severity warning;
        assert (tb_EN346 = '1')  report "TEST CASE " & integer'image(step) & " EN346 FAILED" severity warning;
        assert (tb_EN78 = '0')   report "TEST CASE " & integer'image(step) & " EN78 FAILED" severity warning;
        assert (tb_RESULT = '0') report "TEST CASE " & integer'image(step) & " RESULT FAILED" severity warning;
        assert (tb_S = "01")     report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (tb_S_T = "00")   report "TEST CASE " & integer'image(step) & " S_T FAILED" severity warning;
        step := step + 1;

        -- State S6_RCS2 (TRAFO=1)
        wait until falling_edge(tb_CLK);
        assert (tb_EN125 = '0')  report "TEST CASE " & integer'image(step) & " EN125 FAILED" severity warning;
        assert (tb_EN346 = '0')  report "TEST CASE " & integer'image(step) & " EN346 FAILED" severity warning;
        assert (tb_EN78 = '0')   report "TEST CASE " & integer'image(step) & " EN78 FAILED" severity warning;
        assert (tb_RESULT = '1') report "TEST CASE " & integer'image(step) & " RESULT FAILED" severity warning;
        assert (tb_S = "11")     report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (tb_S_T = "10")   report "TEST CASE " & integer'image(step) & " S_T FAILED" severity warning;
        step := step + 1;

        -- State S7_RCS2 (TRAFO=1)
        wait until falling_edge(tb_CLK);
        assert (tb_EN125 = '0')  report "TEST CASE " & integer'image(step) & " EN125 FAILED" severity warning;
        assert (tb_EN346 = '0')  report "TEST CASE " & integer'image(step) & " EN346 FAILED" severity warning;
        assert (tb_EN78 = '0')   report "TEST CASE " & integer'image(step) & " EN78 FAILED" severity warning;
        assert (tb_RESULT = '0') report "TEST CASE " & integer'image(step) & " RESULT FAILED" severity warning;
        assert (tb_S = "11")     report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (tb_S_T = "10")   report "TEST CASE " & integer'image(step) & " S_T FAILED" severity warning;
        step := step + 1;

        assert (false) report "ALL TESTS PASSED" severity note;
        wait;
    end process;

end Behavioral;
