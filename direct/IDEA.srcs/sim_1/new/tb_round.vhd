----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN 
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    03.05.2026
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    tb_round - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    Testbench for the round module.
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

entity tb_round is
end tb_round;

architecture Behavioral of tb_round is

    component round is
        port (
            X1 : in    std_logic_vector(15 downto 0);
            X2 : in    std_logic_vector(15 downto 0);
            X3 : in    std_logic_vector(15 downto 0);
            X4 : in    std_logic_vector(15 downto 0);
            Z1 : in    std_logic_vector(15 downto 0);
            Z2 : in    std_logic_vector(15 downto 0);
            Z3 : in    std_logic_vector(15 downto 0);
            Z4 : in    std_logic_vector(15 downto 0);
            Z5 : in    std_logic_vector(15 downto 0);
            Z6 : in    std_logic_vector(15 downto 0);
            Y1 : out   std_logic_vector(15 downto 0);
            Y2 : out   std_logic_vector(15 downto 0);
            Y3 : out   std_logic_vector(15 downto 0);
            Y4 : out   std_logic_vector(15 downto 0)
        );
    end component round;

    constant tb_wait_2_ns : time := 2 ns;
    signal tb_X1 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_X2 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_X3 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_X4 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Z1 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Z2 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Z3 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Z4 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Z5 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Z6 : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Y1 : std_logic_vector(15 downto 0);
    signal tb_Y2 : std_logic_vector(15 downto 0);
    signal tb_Y3 : std_logic_vector(15 downto 0);
    signal tb_Y4 : std_logic_vector(15 downto 0);

begin

    DUT_ROUND : round
    port map (
        X1 => tb_X1,
        X2 => tb_X2,
        X3 => tb_X3,
        X4 => tb_X4,
        Z1 => tb_Z1,
        Z2 => tb_Z2,
        Z3 => tb_Z3,
        Z4 => tb_Z4,
        Z5 => tb_Z5,
        Z6 => tb_Z6,
        Y1 => tb_Y1,
        Y2 => tb_Y2,
        Y3 => tb_Y3,
        Y4 => tb_Y4
    );

    P_STIMULUS : process 

    begin

        assert (false) report "ROUND TESTBENCH START" severity note;

        -- STEP 0: All zeros
        tb_X1 <= x"0000"; tb_X2 <= x"0000"; tb_X3 <= x"0000"; tb_X4 <= x"0000";
        tb_Z1 <= x"0000"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000"; tb_Z5 <= x"0000"; tb_Z6 <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_Y1 = x"0001") report "TEST CASE 0-Y1 FAILED" severity warning;
        assert (tb_Y2 = x"0000") report "TEST CASE 0-Y2 FAILED" severity warning;
        assert (tb_Y3 = x"0000") report "TEST CASE 0-Y3 FAILED" severity warning;
        assert (tb_Y4 = x"0001") report "TEST CASE 0-Y4 FAILED" severity warning;

        -- STEP 1
        tb_X1 <= x"FFFF"; tb_X2 <= x"0000"; tb_X3 <= x"0000"; tb_X4 <= x"0000";
        tb_Z1 <= x"0000"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000"; tb_Z5 <= x"0000"; tb_Z6 <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_Y1 = x"0003") report "TEST CASE 1-Y1 FAILED" severity warning;
        assert (tb_Y2 = x"0001") report "TEST CASE 1-Y2 FAILED" severity warning;
        assert (tb_Y3 = x"0000") report "TEST CASE 1-Y3 FAILED" severity warning;
        assert (tb_Y4 = x"0001") report "TEST CASE 1-Y4 FAILED" severity warning;

        -- STEP 2
        tb_X1 <= x"FFFF"; tb_X2 <= x"AAAA"; tb_X3 <= x"0000"; tb_X4 <= x"0000";
        tb_Z1 <= x"0000"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000"; tb_Z5 <= x"0000"; tb_Z6 <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_Y1 = x"5555") report "TEST CASE 2-Y1 FAILED" severity warning;
        assert (tb_Y2 = x"5557") report "TEST CASE 2-Y2 FAILED" severity warning;
        assert (tb_Y3 = x"FFFC") report "TEST CASE 2-Y3 FAILED" severity warning;
        assert (tb_Y4 = x"5557") report "TEST CASE 2-Y4 FAILED" severity warning;

        -- STEP 3
        tb_X1 <= x"FFFF"; tb_X2 <= x"AAAA"; tb_X3 <= x"5555"; tb_X4 <= x"0000";
        tb_Z1 <= x"0000"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000"; tb_Z5 <= x"0000"; tb_Z6 <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_Y1 = x"AAAE") report "TEST CASE 3-Y1 FAILED" severity warning;
        assert (tb_Y2 = x"FFF9") report "TEST CASE 3-Y2 FAILED" severity warning;
        assert (tb_Y3 = x"FFFC") report "TEST CASE 3-Y3 FAILED" severity warning;
        assert (tb_Y4 = x"5557") report "TEST CASE 3-Y4 FAILED" severity warning;

        -- STEP 4
        tb_X1 <= x"FFFF"; tb_X2 <= x"AAAA"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"0000"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000"; tb_Z5 <= x"0000"; tb_Z6 <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_Y1 = x"E390") report "TEST CASE 4-Y1 FAILED" severity warning;
        assert (tb_Y2 = x"B6C7") report "TEST CASE 4-Y2 FAILED" severity warning;
        assert (tb_Y3 = x"2496") report "TEST CASE 4-Y3 FAILED" severity warning;
        assert (tb_Y4 = x"5553") report "TEST CASE 4-Y4 FAILED" severity warning;

        -- STEP 5
        tb_X1 <= x"FFFF"; tb_X2 <= x"AAAA"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"DB6D"; tb_Z2 <= x"0000"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000"; tb_Z5 <= x"0000"; tb_Z6 <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_Y1 = x"E390") report "TEST CASE 5-Y1 FAILED" severity warning;
        assert (tb_Y2 = x"FFED") report "TEST CASE 5-Y2 FAILED" severity warning;
        assert (tb_Y3 = x"2496") report "TEST CASE 5-Y3 FAILED" severity warning;
        assert (tb_Y4 = x"5553") report "TEST CASE 5-Y4 FAILED" severity warning;

        -- STEP 6
        tb_X1 <= x"FFFF"; tb_X2 <= x"AAAA"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"DB6D"; tb_Z2 <= x"1C71"; tb_Z3 <= x"0000"; tb_Z4 <= x"0000"; tb_Z5 <= x"0000"; tb_Z6 <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_Y1 = x"4921") report "TEST CASE 6-Y1 FAILED" severity warning;
        assert (tb_Y2 = x"555C") report "TEST CASE 6-Y2 FAILED" severity warning;
        assert (tb_Y3 = x"2496") report "TEST CASE 6-Y3 FAILED" severity warning;
        assert (tb_Y4 = x"38E2") report "TEST CASE 6-Y4 FAILED" severity warning;

        -- STEP 7
        tb_X1 <= x"FFFF"; tb_X2 <= x"AAAA"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"DB6D"; tb_Z2 <= x"1C71"; tb_Z3 <= x"CCCC"; tb_Z4 <= x"0000"; tb_Z5 <= x"0000"; tb_Z6 <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_Y1 = x"07BD") report "TEST CASE 7-Y1 FAILED" severity warning;
        assert (tb_Y2 = x"6CB4") report "TEST CASE 7-Y2 FAILED" severity warning;
        assert (tb_Y3 = x"2496") report "TEST CASE 7-Y3 FAILED" severity warning;
        assert (tb_Y4 = x"38E2") report "TEST CASE 7-Y4 FAILED" severity warning;

        -- STEP 8
        tb_X1 <= x"FFFF"; tb_X2 <= x"AAAA"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"DB6D"; tb_Z2 <= x"1C71"; tb_Z3 <= x"CCCC"; tb_Z4 <= x"0002"; tb_Z5 <= x"0000"; tb_Z6 <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_Y1 = x"95E2") report "TEST CASE 8-Y1 FAILED" severity warning;
        assert (tb_Y2 = x"FEEB") report "TEST CASE 8-Y2 FAILED" severity warning;
        assert (tb_Y3 = x"B6D9") report "TEST CASE 8-Y3 FAILED" severity warning;
        assert (tb_Y4 = x"38E6") report "TEST CASE 8-Y4 FAILED" severity warning;

        -- STEP 9
        tb_X1 <= x"FFFF"; tb_X2 <= x"AAAA"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"DB6D"; tb_Z2 <= x"1C71"; tb_Z3 <= x"CCCC"; tb_Z4 <= x"0002"; tb_Z5 <= x"EEEE"; tb_Z6 <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_Y1 = x"BC61") report "TEST CASE 9-Y1 FAILED" severity warning;
        assert (tb_Y2 = x"D768") report "TEST CASE 9-Y2 FAILED" severity warning;
        assert (tb_Y3 = x"B6D9") report "TEST CASE 9-Y3 FAILED" severity warning;
        assert (tb_Y4 = x"38E6") report "TEST CASE 9-Y4 FAILED" severity warning;

        -- STEP 10: Final set
        tb_X1 <= x"FFFF"; tb_X2 <= x"AAAA"; tb_X3 <= x"5555"; tb_X4 <= x"2492";
        tb_Z1 <= x"DB6D"; tb_Z2 <= x"1C71"; tb_Z3 <= x"CCCC"; tb_Z4 <= x"0002"; tb_Z5 <= x"EEEE"; tb_Z6 <= x"8888";
        wait for tb_wait_2_ns;
        assert (tb_Y1 = x"2521") report "TEST CASE 10-Y1 FAILED" severity warning;
        assert (tb_Y2 = x"4E28") report "TEST CASE 10-Y2 FAILED" severity warning;
        assert (tb_Y3 = x"2F99") report "TEST CASE 10-Y3 FAILED" severity warning;
        assert (tb_Y4 = x"A1A6") report "TEST CASE 10-Y4 FAILED" severity warning;


        assert (false) report "ALL TESTS PASSED" severity note;
        wait; -- Terminate simulation process

    end process P_STIMULUS;

end architecture Behavioral;
