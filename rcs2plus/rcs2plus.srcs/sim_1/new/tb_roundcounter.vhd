----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    07/05/2026 04:54:04 PM
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    tb_roundcounter - behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool Versions:  Xilinx ISE WebPack
-- Description:    Testbench for the roundcounter module of rcs2.
-- 
-- Dependencies:   ieee.std_logic_1164.all
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_roundcounter is
end tb_roundcounter;

architecture behavioral of tb_roundcounter is

    component roundcounter is
        port (
            CLK    : in    std_logic;
            START  : in    std_logic;
            RESULT : in    std_logic;
            READY  : out   std_logic;
            S_i    : out   std_logic;
            INIT   : out   std_logic;
            TRAFO  : out   std_logic;
            ROUND  : out   std_logic_vector(3 downto 0)
        );
    end component roundcounter;

    constant clk_period : time := 10 ns;

    signal tb_CLK    : std_logic := '0';
    signal tb_START  : std_logic := '0';
    signal tb_RESULT : std_logic := '0';
    signal tb_READY  : std_logic;
    signal tb_S_i    : std_logic;
    signal tb_INIT   : std_logic;
    signal tb_TRAFO  : std_logic;
    signal tb_ROUND  : std_logic_vector(3 downto 0);

begin

    P_CLK : process 
    begin
        tb_CLK <= '0';
        wait for clk_period / 2;
        tb_CLK <= '1';
        wait for clk_period / 2;
    end process P_CLK;

    DUT_ROUNDCOUNTER : roundcounter
        port map (
            CLK    => tb_CLK,
            START  => tb_START,
            RESULT => tb_RESULT,
            READY  => tb_READY,
            S_i    => tb_S_i,
            INIT   => tb_INIT,
            TRAFO  => tb_TRAFO,
            ROUND  => tb_ROUND
        );

    P_STIMULUS : process 
        variable step : integer range 0 to 63 := 0;
    begin   
        assert (false) report "ROUNDCOUNTER TESTBENCH START" severity note;

        tb_START  <= '0';
        tb_RESULT <= '0';
        wait for clk_period * 5;

        -- Step 0: Verify initial SLEEP state (idle phase prior to START pulse)
        wait until falling_edge(tb_CLK);
        assert (tb_INIT  = '0')    report "TEST CASE " & integer'image(step) & ": (SLEEP STATE) INIT FAILED" severity warning;
        assert (tb_READY = '1')    report "TEST CASE " & integer'image(step) & ": (SLEEP STATE) READY FAILED" severity warning;
        assert (tb_ROUND = "1000") report "TEST CASE " & integer'image(step) & ": (SLEEP STATE) ROUND FAILED" severity warning;
        step := step + 1;

        -- Step 1: Assert START to trigger state transition from SLEEP to SETUP
        wait until rising_edge(tb_CLK);
        tb_START <= '1';
        wait until rising_edge(tb_CLK);
        tb_START <= '0';

        -- Step 2: Verify SETUP state execution (tb_INIT must pulse high, tb_S_i active, tb_ROUND = "0000")
        wait until falling_edge(tb_CLK);
        assert (tb_INIT  = '1')    report "TEST CASE " & integer'image(step) & ": (SETUP STATE) INIT FAILED" severity warning;
        assert (tb_READY = '0')    report "TEST CASE " & integer'image(step) & ": (SETUP STATE) READY FAILED" severity warning;
        assert (tb_S_i   = '1')    report "TEST CASE " & integer'image(step) & ": (SETUP STATE) S_i FAILED" severity warning;
        assert (tb_TRAFO = '0')    report "TEST CASE " & integer'image(step) & ": (SETUP STATE) TRAFO FAILED" severity warning;
        assert (tb_ROUND = "0000") report "TEST CASE " & integer'image(step) & ": (SETUP STATE) ROUND FAILED" severity warning;
        step := step + 1;

        -- Step 3: Verify unconditional transition from SETUP to CALC state on the next clock cycle
        wait until falling_edge(tb_CLK);
        assert (tb_INIT  = '0')    report "TEST CASE " & integer'image(step) & ": (CALC STATE) INIT FAILED" severity warning;
        assert (tb_READY = '0')    report "TEST CASE " & integer'image(step) & ": (CALC STATE) READY FAILED" severity warning;
        assert (tb_S_i   = '1')    report "TEST CASE " & integer'image(step) & ": (CALC STATE) S_i FAILED" severity warning;
        assert (tb_TRAFO = '0')    report "TEST CASE " & integer'image(step) & ": (CALC STATE) TRAFO FAILED" severity warning;
        assert (tb_ROUND = "0000") report "TEST CASE " & integer'image(step) & ": (CALC STATE) ROUND FAILED" severity warning;
        step := step + 1;

        -- Step 4: Loop through the 8 standard execution rounds (0 to 7) in CALC and SETUP states
        for i in 0 to 7 loop

            -- Verify CALC state behavior during computation (tb_RESULT = '0')
            wait until falling_edge(tb_CLK);
            assert (tb_INIT  = '0')    report "TEST CASE " & integer'image(step) & ": (CALC STATE, round " & integer'image(i) & ") INIT FAILED" severity warning;
            assert (tb_READY = '0')    report "TEST CASE " & integer'image(step) & ": (CALC STATE, round " & integer'image(i) & ") READY FAILED" severity warning;
            assert (tb_TRAFO = '0')    report "TEST CASE " & integer'image(step) & ": (CALC STATE) TRAFO FAILED" severity warning;

            wait until falling_edge(tb_CLK);
            assert (tb_INIT  = '0')    report "TEST CASE " & integer'image(step) & ": (CALC STATE, round " & integer'image(i) & ") INIT FAILED" severity warning;
            assert (tb_READY = '0')    report "TEST CASE " & integer'image(step) & ": (CALC STATE, round " & integer'image(i) & ") READY FAILED" severity warning;
            assert (tb_TRAFO = '0')    report "TEST CASE " & integer'image(step) & ": (CALC STATE) TRAFO FAILED" severity warning;
            assert (tb_ROUND = std_logic_vector(to_unsigned(i, 4))) report "TEST CASE " & integer'image(step) & ": (CALC STATE) ROUND FAILED" severity warning;

            -- Signal that the current round's calculation is completed
            wait until rising_edge(tb_CLK);
            tb_RESULT <= '1';
            wait until rising_edge(tb_CLK);
            tb_RESULT <= '0';
            
            -- Verify transition from CALC to SETUP for the next round
            wait until falling_edge(tb_CLK);
            assert (tb_INIT  = '1')    report "TEST CASE " & integer'image(step) & ": (SETUP STATE, after round " & integer'image(i) & ") INIT FAILED" severity warning;
            assert (tb_READY = '0')    report "TEST CASE " & integer'image(step) & ": (SETUP STATE, after round " & integer'image(i) & ") READY FAILED" severity warning;
            assert (tb_ROUND = std_logic_vector(to_unsigned(i+1, 4))) report "TEST CASE " & integer'image(step) & ": (SETUP STATE) ROUND FAILED" severity warning;

            -- Verify transition from SETUP back to CALC for the subsequent round
            wait until falling_edge(tb_CLK);
            assert (tb_INIT  = '0')    report "TEST CASE " & integer'image(step) & ": (CALC STATE, entering round " & integer'image(i+1) & ") INIT FAILED" severity warning;
            assert (tb_READY = '0')    report "TEST CASE " & integer'image(step) & ": (CALC STATE, entering round " & integer'image(i+1) & ") READY FAILED" severity warning;
            assert (tb_ROUND = std_logic_vector(to_unsigned(i+1, 4))) report "TEST CASE " & integer'image(step) & ": (CALC STATE) ROUND FAILED" severity warning;

            step := step + 1;
        end loop;

        -- Step 5: Verify CALC state behavior for output transformation (round 8, TRAFO = '1') while RESULT remains '0'
        wait until falling_edge(tb_CLK);
        assert (tb_INIT  = '0') report "TEST CASE " & integer'image(step) & ": (CALC STATE, TRAFO) INIT FAILED" severity warning;
        assert (tb_READY = '0') report "TEST CASE " & integer'image(step) & ": (CALC STATE, TRAFO) READY FAILED" severity warning;

        wait until falling_edge(tb_CLK);
        assert (tb_INIT  = '0') report "TEST CASE " & integer'image(step) & ": (CALC STATE, TRAFO) INIT FAILED" severity warning;
        assert (tb_READY = '0') report "TEST CASE " & integer'image(step) & ": (CALC STATE, TRAFO) READY FAILED" severity warning;
        step := step + 1;

        -- Complete output transformation round calculation by pulsing tb_RESULT
        wait until rising_edge(tb_CLK);
        tb_RESULT <= '1';
        wait until rising_edge(tb_CLK);
        tb_RESULT <= '0';

        -- Step 6: Verify transition back to SLEEP state (READY = '1') when final round completes (ROUND = "1000")
        wait until falling_edge(tb_CLK);
        assert (tb_ROUND = "1000") report "TEST CASE " & integer'image(step) & ": (SLEEP STATE, post-enc) ROUND FAILED" severity warning;
        assert (tb_TRAFO = '1')    report "TEST CASE " & integer'image(step) & ": (SLEEP STATE, post-enc) TRAFO FAILED" severity warning;
        assert (tb_INIT  = '0')    report "TEST CASE " & integer'image(step) & ": (SLEEP STATE, post-enc) INIT FAILED" severity warning;
        assert (tb_READY = '1')    report "TEST CASE " & integer'image(step) & ": (SLEEP STATE, post-enc) READY FAILED" severity warning;
        step := step + 1;

        assert (false) report "ALL TESTS PASSED" severity note;

        wait;  -- stop the stimulus process; without this it would loop forever

    end process P_STIMULUS;

end behavioral;