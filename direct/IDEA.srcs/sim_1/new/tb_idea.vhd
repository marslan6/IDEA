----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN 
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    03.05.2026
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    tb_idea - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    Testbench for the top-level IDEA module.
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

entity tb_idea is
end tb_idea;

architecture Behavioral of tb_idea is

    component idea is
        port (
            KEY : in    std_logic_vector(127 downto 0);
            X_1 : in    std_logic_vector(15 downto 0);
            X_2 : in    std_logic_vector(15 downto 0);
            X_3 : in    std_logic_vector(15 downto 0);
            X_4 : in    std_logic_vector(15 downto 0);
            Y_1 : out   std_logic_vector(15 downto 0);
            Y_2 : out   std_logic_vector(15 downto 0);
            Y_3 : out   std_logic_vector(15 downto 0);
            Y_4 : out   std_logic_vector(15 downto 0)
        );
    end component idea;

    constant tb_wait_2_ns : time := 2 ns;
    signal tb_KEY : std_logic_vector(127 downto 0) := (others => '0');
    signal tb_X_1 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_X_2 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_X_3 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_X_4 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Y_1 : std_logic_vector(15 downto 0);
    signal tb_Y_2 : std_logic_vector(15 downto 0);
    signal tb_Y_3 : std_logic_vector(15 downto 0);
    signal tb_Y_4 : std_logic_vector(15 downto 0);

begin

    DUT_IDEA : idea 
    port map (
        KEY => tb_KEY,
        X_1 => tb_X_1,
        X_2 => tb_X_2,
        X_3 => tb_X_3,
        X_4 => tb_X_4,
        Y_1 => tb_Y_1,
        Y_2 => tb_Y_2,
        Y_3 => tb_Y_3,
        Y_4 => tb_Y_4
    );


    P_STIMULUS : process
    begin 

        assert (false) report "IDEA TESTBENCH START" severity note;

        tb_KEY <= x"00010002000300040005000600070008";
        tb_X_1 <= x"1111"; tb_X_2 <= x"2222"; tb_X_3 <= x"4444"; tb_X_4 <= x"8888";
        wait for tb_wait_2_ns; -- Allow combinational logic to settle
        assert (tb_Y_1 = x"8AA9") report "TEST CASE 0-Y1 Failed" severity warning;
        assert (tb_Y_2 = x"0FEF") report "TEST CASE 0-Y2 Failed" severity warning;
        assert (tb_Y_3 = x"C0C9") report "TEST CASE 0-Y3 Failed" severity warning;
        assert (tb_Y_4 = x"56F6") report "TEST CASE 0-Y4 Failed" severity warning;

        tb_KEY <= x"00000000000000000000000000000000";
        tb_X_1 <= x"0000"; tb_X_2 <= x"0000"; tb_X_3 <= x"0000"; tb_X_4 <= x"0000";
        wait for tb_wait_2_ns; -- Allow combinational logic to settle
        assert (tb_Y_1 = x"0001") report "TEST CASE 1-Y1 Failed" severity warning;
        assert (tb_Y_2 = x"0001") report "TEST CASE 1-Y2 Failed" severity warning;
        assert (tb_Y_3 = x"0000") report "TEST CASE 1-Y3 Failed" severity warning;
        assert (tb_Y_4 = x"0000") report "TEST CASE 1-Y4 Failed" severity warning;

        assert (false) report "ALL TESTS PASSED" severity note;
        wait;

    end process P_STIMULUS;

end architecture Behavioral;
