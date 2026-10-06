----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    12.06.2026
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    tb_register16 - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    Testbench for the register16 module.
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

entity tb_register16 is
end tb_register16;

architecture Behavioral of tb_register16 is

    constant tb_wait_2_ns : time := 2 ns;
    constant clock_period : time := 20 ns; -- 50 MHz Clock Frequency

    signal tb_clock  : std_logic                     := '0';
    signal tb_enable : std_logic                     := '0';
    signal tb_D      : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Q      : std_logic_vector(15 downto 0) := (others => '0');

    component register16 is
        port (
            clock    : in    std_logic;
            enable   : in    std_logic;
            D        : in    std_logic_vector(15 downto 0);
            Q        : out   std_logic_vector(15 downto 0)
        );
    end component register16;

begin

    DUT_REG16 : register16
        port map (
            clock    => tb_clock,
            enable   => tb_enable,
            D        => tb_D,
            Q        => tb_Q
        );

    -- Clock Generation Process
    P_CLK : process
    begin
        tb_clock <= '0';
        wait for clock_period/2;
        tb_clock <= '1';
        wait for clock_period/2;
    end process P_CLK;

    -- Stimulus Process
    P_STIMULUS : process
        variable step : integer range 0 to 31 := 0;
    begin

        assert (false) report "REGISTER16 TESTBENCH START" severity note;

        -- Test Case 0
        step      := 0;
        tb_enable <= '1';
        tb_D      <= x"0000";
        wait for clock_period * 20;
        assert (tb_Q = x"0000") report "TEST CASE " & integer'image(step) & "FAILED" severity warning;
        step      := step + 1;

        -- Test Case 1
        tb_enable <= '0';
        tb_D      <= x"DEAD";
        wait for clock_period * 5;
        assert (tb_Q = x"0000") report "TEST CASE " & integer'image(step) & "FAILED" severity warning;
        step      := step + 1;

        -- Test Case 2
        tb_enable <= '1';
        wait until rising_edge(tb_clock);
        wait until falling_edge(tb_clock);
        assert (tb_Q = x"DEAD") report "TEST CASE " & integer'image(step) & "FAILED" severity warning;
        step      := step + 1;

        -- Test Case 3
        tb_D      <= x"AAAA";
        wait for clock_period * 5;
        assert (tb_Q = x"AAAA") report "TEST CASE " & integer'image(step) & "FAILED" severity warning;
        step      := step + 1;

        assert (false) report "ALL TESTS PASSED" severity note;
        wait;

    end process P_STIMULUS;

end architecture Behavioral;
