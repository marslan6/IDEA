----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    12.06.2026
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    tb_mux2x1 - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    Testbench for the mux2x1 module.
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

entity tb_mux2x1 is
end tb_mux2x1;

architecture Behavioral of tb_mux2x1 is

    constant tb_wait_2_ns : time := 2 ns;

    signal tb_S  : std_logic                     := '0';
    signal tb_D0 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_D1 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_O  : std_logic_vector(15 downto 0);

    component mux2x1 is
        port (
            S  : in    std_logic;
            D0 : in    std_logic_vector(15 downto 0);
            D1 : in    std_logic_vector(15 downto 0);
            O  : out   std_logic_vector(15 downto 0)
        );
    end component mux2x1;

begin

    DUT_MUX2X1 : mux2x1
        port map (
            S  => tb_S,
            D0 => tb_D0,
            D1 => tb_D1,
            O  => tb_O
        );

    -- Stimulus Process
    P_STIMULUS : process
        variable step : integer range 0 to 30 := 0;
    begin

        assert (false) report "MUX2X1 TESTBENCH START" severity note;

        -- Initial state
        step  := 0;
        tb_S  <= '0';
        tb_D0 <= x"DEAD";
        tb_D1 <= x"BEEF";
        wait for tb_wait_2_ns;
        assert (tb_O = x"DEAD") report "TEST " & integer'image(step) & " FAILED" severity warning;
        step  := step + 1;

        -- Test Case 1
        tb_S  <= '1';
        wait for tb_wait_2_ns;
        assert (tb_O = x"BEEF") report "TEST " & integer'image(step) & " FAILED" severity warning;
        step  := step + 1;

        -- Test Case 2
        tb_D0 <= x"CCCC";
        wait for tb_wait_2_ns;
        assert (tb_O = x"BEEF") report "TEST " & integer'image(step) & " FAILED" severity warning;
        step  := step + 1;

        -- Test Case 3
        tb_S  <= '0';
        wait for tb_wait_2_ns;
        assert (tb_O = x"CCCC") report "TEST " & integer'image(step) & " FAILED" severity warning;
        step  := step + 1;

        -- Test Case 4
        tb_S  <= 'U';
        wait for tb_wait_2_ns;
        assert (tb_O = "XXXXXXXXXXXXXXXX") report "TEST " & integer'image(step) & " FAILED" severity warning;
        step  := step + 1;

        assert (false) report "ALL TESTS PASSED" severity note;
        wait;

    end process P_STIMULUS;

end architecture Behavioral;
