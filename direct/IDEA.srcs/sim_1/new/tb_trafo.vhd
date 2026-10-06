----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN 
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    03.05.2026
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    tb_trafo - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    Testbench for the trafo module.
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

entity tb_trafo is
end tb_trafo;

architecture Behavioral of tb_trafo is

    component trafo is
        port (
            X1 : in    std_logic_vector(15 downto 0);
            X2 : in    std_logic_vector(15 downto 0);
            X3 : in    std_logic_vector(15 downto 0);
            X4 : in    std_logic_vector(15 downto 0);
            Z1 : in    std_logic_vector(15 downto 0);
            Z2 : in    std_logic_vector(15 downto 0);
            Z3 : in    std_logic_vector(15 downto 0);
            Z4 : in    std_logic_vector(15 downto 0);
            Y1 : out   std_logic_vector(15 downto 0);
            Y2 : out   std_logic_vector(15 downto 0);
            Y3 : out   std_logic_vector(15 downto 0);
            Y4 : out   std_logic_vector(15 downto 0)
        );
    end component trafo;

    constant tb_wait_2_ns : time := 2 ns;
    signal tb_X1 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_X2 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_X3 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_X4 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Z1 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Z2 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Z3 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Z4 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Y1 : std_logic_vector(15 downto 0);
    signal tb_Y2 : std_logic_vector(15 downto 0);
    signal tb_Y3 : std_logic_vector(15 downto 0);
    signal tb_Y4 : std_logic_vector(15 downto 0);

begin

    DUT_TRAFO : trafo
        port map (
            X1 => tb_X1,
            X2 => tb_X2,
            X3 => tb_X3,
            X4 => tb_X4,
            Z1 => tb_Z1,
            Z2 => tb_Z2,
            Z3 => tb_Z3,
            Z4 => tb_Z4,
            Y1 => tb_Y1,
            Y2 => tb_Y2,
            Y3 => tb_Y3,
            Y4 => tb_Y4
        );

    P_STIMULUS : process is
    begin
        
        assert (false) report "TRAFO TESTBENCH START" severity note;

        -- STEP 1: All zeros
        tb_X1 <= x"0000"; tb_X2 <= x"0000"; tb_X3 <= x"0000"; tb_X4 <= x"0000";
        tb_Z1 <= x"0000"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000";
        wait for tb_wait_2_ns; -- Allow combinational logic to settle
        assert (tb_Y1 = x"0001") report "TEST CASE 1-Y1 Failed" severity warning;
        assert (tb_Y2 = x"0000") report "TEST CASE 1-Y2 Failed" severity warning;
        assert (tb_Y3 = x"0000") report "TEST CASE 1-Y3 Failed" severity warning;
        assert (tb_Y4 = x"0001") report "TEST CASE 1-Y4 Failed" severity warning;

        -- STEP 2
        tb_X1 <= x"ffff"; tb_X2 <= x"0000"; tb_X3 <= x"0000"; tb_X4 <= x"0000";
        tb_Z1 <= x"0000"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_Y1 = x"0002") report "TEST CASE 2-Y1 Failed" severity warning;
        assert (tb_Y2 = x"0000") report "TEST CASE 2-Y2 Failed" severity warning;
        assert (tb_Y3 = x"0000") report "TEST CASE 2-Y3 Failed" severity warning;
        assert (tb_Y4 = x"0001") report "TEST CASE 2-Y4 Failed" severity warning;

        -- STEP 3
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"0000"; tb_X4 <= x"0000";
        tb_Z1 <= x"0000"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_Y1 = x"0002") report "TEST CASE 3-Y1 Failed" severity warning;
        assert (tb_Y2 = x"0000") report "TEST CASE 3-Y2 Failed" severity warning;
        assert (tb_Y3 = x"AAAA") report "TEST CASE 3-Y3 Failed" severity warning;
        assert (tb_Y4 = x"0001") report "TEST CASE 3-Y4 Failed" severity warning;

        -- STEP 4
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"5555"; tb_X4 <= x"0000";
        tb_Z1 <= x"0000"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_Y1 = x"0002") report "TEST CASE 4-Y1 Failed" severity warning;
        assert (tb_Y2 = x"5555") report "TEST CASE 4-Y2 Failed" severity warning;
        assert (tb_Y3 = x"AAAA") report "TEST CASE 4-Y3 Failed" severity warning;
        assert (tb_Y4 = x"0001") report "TEST CASE 4-Y4 Failed" severity warning;

        -- STEP 5
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"0000"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_Y1 = x"0002") report "TEST CASE 5-Y1 Failed" severity warning;
        assert (tb_Y2 = x"5555") report "TEST CASE 5-Y2 Failed" severity warning;
        assert (tb_Y3 = x"AAAA") report "TEST CASE 5-Y3 Failed" severity warning;
        assert (tb_Y4 = x"DB6F") report "TEST CASE 5-Y4 Failed" severity warning;

        -- STEP 6
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"db6d"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_Y1 = x"4928") report "TEST CASE 6-Y1 Failed" severity warning;
        assert (tb_Y2 = x"5555") report "TEST CASE 6-Y2 Failed" severity warning;
        assert (tb_Y3 = x"AAAA") report "TEST CASE 6-Y3 Failed" severity warning;
        assert (tb_Y4 = x"DB6F") report "TEST CASE 6-Y4 Failed" severity warning;

        -- STEP 7
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"db6d"; tb_Z2 <= x"1c71"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_Y1 = x"4928") report "TEST CASE 7-Y1 Failed" severity warning;
        assert (tb_Y2 = x"71C6") report "TEST CASE 7-Y2 Failed" severity warning;
        assert (tb_Y3 = x"AAAA") report "TEST CASE 7-Y3 Failed" severity warning;
        assert (tb_Y4 = x"DB6F") report "TEST CASE 7-Y4 Failed" severity warning;

        -- STEP 8
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"db6d"; tb_Z2 <= x"1c71"; tb_Z3 <= x"cccc"; tb_Z4 <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_Y1 = x"4928") report "TEST CASE 8-Y1 Failed" severity warning;
        assert (tb_Y2 = x"71C6") report "TEST CASE 8-Y2 Failed" severity warning;
        assert (tb_Y3 = x"7776") report "TEST CASE 8-Y3 Failed" severity warning;
        assert (tb_Y4 = x"DB6F") report "TEST CASE 8-Y4 Failed" severity warning;

        -- STEP 9
        tb_X1 <= x"ffff"; tb_X2 <= x"aaaa"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"db6d"; tb_Z2 <= x"1c71"; tb_Z3 <= x"cccc"; tb_Z4 <= x"0002";
        wait for tb_wait_2_ns;
        assert (tb_Y1 = x"4928") report "TEST CASE 9-Y1 Failed" severity warning;
        assert (tb_Y2 = x"71C6") report "TEST CASE 9-Y2 Failed" severity warning;
        assert (tb_Y3 = x"7776") report "TEST CASE 9-Y3 Failed" severity warning;
        assert (tb_Y4 = x"4924") report "TEST CASE 9-Y4 Failed" severity warning;

        assert (false) report "ALL TESTS PASSED" severity note;
        wait;

    end process P_STIMULUS;

end architecture Behavioral;
