----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    07/04/2026 10:25:48 PM
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    tb_mux4x1 - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool Versions:  Xilinx ISE WebPack
-- Description:    Testbench for the 4-to-1 multiplexer.
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


entity tb_mux4x1 is
--  Port ( );
end tb_mux4x1;

architecture Behavioral of tb_mux4x1 is

    constant tb_wait_2_ns : time := 2 ns;

    signal tb_S  : std_logic_vector(1 downto 0)  := (others => '0');
    signal tb_D0 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_D1 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_D2 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_D3 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_O  : std_logic_vector(15 downto 0);

    component mux4x1 is
        port (
            S  : in    std_logic_vector(1 downto 0);
            D0 : in    std_logic_vector(15 downto 0);
            D1 : in    std_logic_vector(15 downto 0);
            D2 : in    std_logic_vector(15 downto 0);
            D3 : in    std_logic_vector(15 downto 0);
            O  : out   std_logic_vector(15 downto 0)
        );
    end component mux4x1;

begin

    DUT_MUX4X1 : mux4x1
    port map (
        S  => tb_S,
        D0 => tb_D0,
        D1 => tb_D1,
        D2 => tb_D2,
        D3 => tb_D3,
        O  => tb_O
    );

     -- Stimulus Process
    P_STIMULUS : process
        variable step : integer range 0 to 30 := 0;
    begin

        assert (false) report "MUX4X1 TESTBENCH START" severity note;

        -- Initial state
        step  := 0;
        tb_S  <= "00";
        tb_D0 <= x"1111";
        tb_D1 <= x"2222";
        tb_D2 <= x"3333";
        tb_D3 <= x"4444";
        wait for tb_wait_2_ns * 50;
        assert (tb_O = x"1111") report "TEST " & integer'image(step) & " FAILED" severity warning;
        step  := step + 1;

        -- Test Case 1
        tb_S  <= "01";
        wait for tb_wait_2_ns * 50;
        assert (tb_O = x"2222") report "TEST " & integer'image(step) & " FAILED" severity warning;
        step  := step + 1;

        -- Test Case 2
        tb_S  <= "10";
        wait for tb_wait_2_ns * 50;
        assert (tb_O = x"3333") report "TEST " & integer'image(step) & " FAILED" severity warning;
        step  := step + 1;

        -- Test Case 3
        tb_S  <= "11";
        wait for tb_wait_2_ns * 50;
        assert (tb_O = x"4444") report "TEST " & integer'image(step) & " FAILED" severity warning;
        step  := step + 1;

        -- Test Case 4
        tb_D3 <= x"5555";
        wait for tb_wait_2_ns * 50;
        assert (tb_O = x"5555") report "TEST " & integer'image(step) & " FAILED" severity warning;
        step  := step + 1;

        assert (false) report "ALL TESTS PASSED" severity note;
        wait;

    end process P_STIMULUS;


end Behavioral;
