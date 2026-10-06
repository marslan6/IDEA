----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    13.06.2026
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    tb_control - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    Testbench for the control module.
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

    constant clock_period : time := 20 ns; -- 50 MHz Clock Frequency

    signal tb_CLK   : std_logic                    := '0';
    signal tb_START : std_logic                    := '0';
    signal tb_ROUND : std_logic_vector(3 downto 0);
    signal tb_READY : std_logic;
    signal tb_EN    : std_logic;
    signal tb_S     : std_logic;

    component control is
        port (
            CLK   : in    std_logic;
            START : in    std_logic;
            ROUND : out   std_logic_vector(3 downto 0);
            READY : out   std_logic;
            EN    : out   std_logic;
            S     : out   std_logic
        );
    end component control;

begin

    DUT_CTRL : control
        port map (
            CLK   => tb_CLK,
            START => tb_START,
            ROUND => tb_ROUND,
            READY => tb_READY,
            EN    => tb_EN,
            S     => tb_S
        );

    P_CLK : process
    begin
        tb_CLK <= '0';
        wait for clock_period/2;
        tb_CLK <= '1';
        wait for clock_period/2;
    end process P_CLK;

    P_STIMULUS : process
        variable step : integer range 0 to 63 :=0;
    begin

        assert (false) report "CONTROL TESTBENCH START" severity note;

        step := 0;
        tb_START <= '0';
        wait for clock_period * 10;
        assert (tb_READY = '1')    report "TEST CASE " & integer'image(step) & " READY FAILED" severity warning;
        assert (tb_EN = '0')       report "TEST CASE " & integer'image(step) & " EN FAILED" severity warning;
        assert (tb_ROUND = "1000") report "TEST CASE " & integer'image(step) & " ROUND FAILED" severity warning;
        assert (tb_S = '1')        report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (false) report "TEST CASE " & integer'image(step) & " PASSED" severity note;
        step := step + 1;

        wait until rising_edge(tb_CLK);
        tb_START <= '1';
        wait until rising_edge(tb_CLK);
        wait until falling_edge(tb_CLK);
        
        -- State S0
        assert (tb_READY = '0')    report "TEST CASE " & integer'image(step) & " READY FAILED" severity warning;
        assert (tb_EN = '1')       report "TEST CASE " & integer'image(step) & " EN FAILED" severity warning;
        assert (tb_ROUND = "0000") report "TEST CASE " & integer'image(step) & " ROUND FAILED" severity warning;
        assert (tb_S = '0')        report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (false) report "TEST CASE " & integer'image(step) & " PASSED" severity note;
        step     := step + 1;

        wait until rising_edge(tb_CLK);
        tb_START <= '0';

        -- State S1
        wait until falling_edge(tb_CLK);
        assert (tb_READY = '0')    report "TEST CASE " & integer'image(step) & " READY FAILED" severity warning;
        assert (tb_EN = '1')       report "TEST CASE " & integer'image(step) & " EN FAILED" severity warning;
        assert (tb_ROUND = "0001") report "TEST CASE " & integer'image(step) & " ROUND FAILED" severity warning;
        assert (tb_S = '1')        report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (false) report "TEST CASE " & integer'image(step) & " PASSED" severity note;
        step     := step + 1;

        -- State S2
        wait until falling_edge(tb_CLK);
        assert (tb_READY = '0')    report "TEST CASE " & integer'image(step) & " READY FAILED" severity warning;
        assert (tb_EN = '1')       report "TEST CASE " & integer'image(step) & " EN FAILED" severity warning;
        assert (tb_ROUND = "0010") report "TEST CASE " & integer'image(step) & " ROUND FAILED" severity warning;
        assert (tb_S = '1')        report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (false) report "TEST CASE " & integer'image(step) & " PASSED" severity note;
        step     := step + 1;

        -- State S3
        wait until falling_edge(tb_CLK);
        assert (tb_READY = '0')    report "TEST CASE " & integer'image(step) & " READY FAILED" severity warning;
        assert (tb_EN = '1')       report "TEST CASE " & integer'image(step) & " EN FAILED" severity warning;
        assert (tb_ROUND = "0011") report "TEST CASE " & integer'image(step) & " ROUND FAILED" severity warning;
        assert (tb_S = '1')        report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (false) report "TEST CASE " & integer'image(step) & " PASSED" severity note;
        step     := step + 1;

        -- State S4
        wait until falling_edge(tb_CLK);
        assert (tb_READY = '0')    report "TEST CASE " & integer'image(step) & " READY FAILED" severity warning;
        assert (tb_EN = '1')       report "TEST CASE " & integer'image(step) & " EN FAILED" severity warning;
        assert (tb_ROUND = "0100") report "TEST CASE " & integer'image(step) & " ROUND FAILED" severity warning;
        assert (tb_S = '1')        report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (false) report "TEST CASE " & integer'image(step) & " PASSED" severity note;
        step     := step + 1;

        -- State S5
        wait until falling_edge(tb_CLK);
        assert (tb_READY = '0')    report "TEST CASE " & integer'image(step) & " READY FAILED" severity warning;
        assert (tb_EN = '1')       report "TEST CASE " & integer'image(step) & " EN FAILED" severity warning;
        assert (tb_ROUND = "0101") report "TEST CASE " & integer'image(step) & " ROUND FAILED" severity warning;
        assert (tb_S = '1')        report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (false) report "TEST CASE " & integer'image(step) & " PASSED" severity note;
        step     := step + 1;

        -- State S6
        wait until falling_edge(tb_CLK);
        assert (tb_READY = '0')    report "TEST CASE " & integer'image(step) & " READY FAILED" severity warning;
        assert (tb_EN = '1')       report "TEST CASE " & integer'image(step) & " EN FAILED" severity warning;
        assert (tb_ROUND = "0110") report "TEST CASE " & integer'image(step) & " ROUND FAILED" severity warning;
        assert (tb_S = '1')        report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (false) report "TEST CASE " & integer'image(step) & " PASSED" severity note;
        step     := step + 1;

        -- State S7
        wait until falling_edge(tb_CLK);
        assert (tb_READY = '0')    report "TEST CASE " & integer'image(step) & " READY FAILED" severity warning;
        assert (tb_EN = '1')       report "TEST CASE " & integer'image(step) & " EN FAILED" severity warning;
        assert (tb_ROUND = "0111") report "TEST CASE " & integer'image(step) & " ROUND FAILED" severity warning;
        assert (tb_S = '1')        report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (false) report "TEST CASE " & integer'image(step) & " PASSED" severity note;
        step     := step + 1;

        -- State STRAFO (Output Transformation)
        wait until falling_edge(tb_CLK);
        assert (tb_READY = '1')    report "TEST CASE " & integer'image(step) & " READY FAILED" severity warning;
        assert (tb_EN = '0')       report "TEST CASE " & integer'image(step) & " EN FAILED" severity warning;
        assert (tb_ROUND = "1000") report "TEST CASE " & integer'image(step) & " ROUND FAILED" severity warning;
        assert (tb_S = '1')        report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (false) report "TEST CASE " & integer'image(step) & " PASSED" severity note;
        step     := step + 1;

        -- State SIDLE (Idle)
        wait until falling_edge(tb_CLK);
        assert (tb_READY = '1')    report "TEST CASE " & integer'image(step) & " READY FAILED" severity warning;
        assert (tb_EN = '0')       report "TEST CASE " & integer'image(step) & " EN FAILED" severity warning;
        assert (tb_ROUND = "1000") report "TEST CASE " & integer'image(step) & " ROUND FAILED" severity warning;
        assert (tb_S = '1')        report "TEST CASE " & integer'image(step) & " S FAILED" severity warning;
        assert (false) report "TEST CASE " & integer'image(step) & " PASSED" severity note;
        step     := step + 1;

        assert (false) report "ALL TESTS PASSED" severity note;
        wait;

    end process P_STIMULUS;

end architecture Behavioral;
