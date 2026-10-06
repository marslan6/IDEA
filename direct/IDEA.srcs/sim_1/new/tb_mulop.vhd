----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN 
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    03.05.2026
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    tb_mulop - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    Testbench for the mulop module.
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

entity tb_mulop is
end tb_mulop;

architecture Behavioral of tb_mulop is

    constant tb_wait_2_ns : time := 2 ns;

    signal tb_i_1         : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_i_2         : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_o_1         : std_logic_vector(15 downto 0);

    component mulop is
        port (
            I_1 : in    std_logic_vector(15 downto 0);
            I_2 : in    std_logic_vector(15 downto 0);
            O_1 : out   std_logic_vector(15 downto 0)
        );
    end component mulop;

begin

    DUT_MULOP : mulop
        port map (
            I_1 => tb_i_1,
            I_2 => tb_i_2,
            O_1 => tb_o_1
        );

    -- Stimulus Process
    P_STIMULUS : process is

        variable step : integer range 0 to 127;

    begin

        assert (false) report "MULOP TESTBENCH START" severity note;

        step := 0;

        -- TEST CASE 0
        tb_i_1 <= x"0000";
        tb_i_2 <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_o_1 = x"0001") report "TEST CASE " & integer'image(step) & "FAILED" severity warning;
        step   := step + 1;

        -- TEST CASE 1
        tb_i_1 <= x"0001";
        tb_i_2 <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_o_1 = x"0000") report "TEST CASE " & integer'image(step) & "FAILED" severity warning;
        step   := step + 1;

        -- TEST CASE 2
        tb_i_1 <= x"0001";
        tb_i_2 <= x"0001";
        wait for tb_wait_2_ns;
        assert (tb_o_1 = x"0001") report "TEST CASE " & integer'image(step) & "FAILED" severity warning;
        step   := step + 1;

        -- TEST CASE 3
        tb_i_1 <= x"0003";
        tb_i_2 <= x"0001";
        wait for tb_wait_2_ns;
        assert (tb_o_1 = x"0003") report "TEST CASE " & integer'image(step) & "FAILED" severity warning;
        step   := step + 1;

        -- TEST CASE 4
        tb_i_1 <= x"0003";
        tb_i_2 <= x"0003";
        wait for tb_wait_2_ns;
        assert (tb_o_1 = x"0009") report "TEST CASE " & integer'image(step) & "FAILED" severity warning;
        step   := step + 1;

        -- TEST CASE 5
        tb_i_1 <= x"7FFF";
        tb_i_2 <= x"0003";
        wait for tb_wait_2_ns;
        assert (tb_o_1 = x"7FFC") report "TEST CASE " & integer'image(step) & "FAILED" severity warning;
        step   := step + 1;

        -- TEST CASE 6
        tb_i_1 <= x"7FFF";
        tb_i_2 <= x"7FFF";
        wait for tb_wait_2_ns;
        assert (tb_o_1 = x"C003") report "TEST CASE " & integer'image(step) & "FAILED" severity warning;
        step   := step + 1;

        -- TEST CASE 7
        tb_i_1 <= x"FFFF";
        tb_i_2 <= x"7FFF";
        wait for tb_wait_2_ns;
        assert (tb_o_1 = x"0003") report "TEST CASE " & integer'image(step) & "FAILED" severity warning;
        step   := step + 1;

        -- TEST CASE 8
        tb_i_1 <= x"FFFF";
        tb_i_2 <= x"FFFF";
        wait for tb_wait_2_ns;
        assert (tb_o_1 = x"0004") report "TEST CASE " & integer'image(step) & "FAILED" severity warning;
        step   := step + 1;

        -- TEST CASE 9
        tb_i_1 <= x"8000";
        tb_i_2 <= x"FFFF";
        wait for tb_wait_2_ns;
        assert (tb_o_1 = x"0001") report "TEST CASE " & integer'image(step) & "FAILED" severity warning;
        step   := step + 1;

        -- TEST CASE 10
        tb_i_1 <= x"8000";
        tb_i_2 <= x"8000";
        wait for tb_wait_2_ns;
        assert (tb_o_1 = x"C001") report "TEST CASE " & integer'image(step) & "FAILED" severity warning;
        step   := step + 1;

        assert (false) report "ALL TESTS PASSED" severity note;
        wait;

    end process P_STIMULUS;

end architecture Behavioral;
