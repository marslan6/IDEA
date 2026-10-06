----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/14/2026 12:43:55 AM
-- Design Name: 
-- Module Name: tb_idea_single - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity tb_idea_single is
end tb_idea_single;

architecture Behavioral of tb_idea_single is

    constant clock_period : time := 20 ns; -- 50 MHz Clock Frequency

    signal tb_CLOCK : std_logic;
    signal tb_START : std_logic;
    signal tb_KEY   : std_logic_vector(127 downto 0);
    signal tb_X_1   : std_logic_vector(15 downto 0);
    signal tb_X_2   : std_logic_vector(15 downto 0);
    signal tb_X_3   : std_logic_vector(15 downto 0);
    signal tb_X_4   : std_logic_vector(15 downto 0);
    signal tb_Y_1   : std_logic_vector(15 downto 0);
    signal tb_Y_2   : std_logic_vector(15 downto 0);
    signal tb_Y_3   : std_logic_vector(15 downto 0);
    signal tb_Y_4   : std_logic_vector(15 downto 0);
    signal tb_READY : std_logic;

    component idea_single is
        port (
            CLOCK : in    std_logic;
            START : in    std_logic;
            KEY   : in    std_logic_vector(127 downto 0);
            X_1   : in    std_logic_vector(15 downto 0);
            X_2   : in    std_logic_vector(15 downto 0);
            X_3   : in    std_logic_vector(15 downto 0);
            X_4   : in    std_logic_vector(15 downto 0);
            Y_1   : out   std_logic_vector(15 downto 0);
            Y_2   : out   std_logic_vector(15 downto 0);
            Y_3   : out   std_logic_vector(15 downto 0);
            Y_4   : out   std_logic_vector(15 downto 0);
            READY : out   std_logic
        );
    end component idea_single;

begin

    DUT_IDEA_SINGLE : idea_single 
    port map (
        CLOCK   =>  tb_CLOCK,
        START   =>  tb_START,
        READY   =>  tb_READY,
        KEY     =>  tb_KEY,
        X_1     =>  tb_X_1,
        X_2     =>  tb_X_2,
        X_3     =>  tb_X_3,
        X_4     =>  tb_X_4,
        Y_1     =>  tb_Y_1,
        Y_2     =>  tb_Y_2,
        Y_3     =>  tb_Y_3,
        Y_4     =>  tb_Y_4
    );

    P_CLK : process     
    begin 
        tb_CLOCK <= '0' ;
        wait for clock_period/2;
        tb_CLOCK <= '1';
        wait for clock_period/2;
    end process; 

    P_STIMULUS : process
    begin 

        assert (false) report "IDEA TESTBENCH START" severity note;

        wait until rising_edge(tb_CLOCK);
        tb_START <= '1';
        tb_KEY <= x"00010002000300040005000600070008";
        tb_X_1 <= x"1111"; tb_X_2 <= x"2222"; tb_X_3 <= x"4444"; tb_X_4 <= x"8888";
        wait for clock_period * 2;
        tb_START <= '0';
        wait for clock_period * 20;

        assert (tb_Y_1 = x"8AA9") report "TEST CASE 0-Y1 Failed" severity warning;
        assert (tb_Y_2 = x"0FEF") report "TEST CASE 0-Y2 Failed" severity warning;
        assert (tb_Y_3 = x"C0C9") report "TEST CASE 0-Y3 Failed" severity warning;
        assert (tb_Y_4 = x"56F6") report "TEST CASE 0-Y4 Failed" severity warning;

        -------------------------------------------------------------------------------------
        -------------------------------------------------------------------------------------

        wait until rising_edge(tb_CLOCK);
        tb_START <= '1';
        tb_KEY <= x"00000000000000000000000000000000";
        tb_X_1 <= x"0000"; tb_X_2 <= x"0000"; tb_X_3 <= x"0000"; tb_X_4 <= x"0000";
        wait for clock_period * 2;
        tb_START <= '0';
        wait for clock_period * 20;

        assert (tb_Y_1 = x"0001") report "TEST CASE 1-Y1 Failed" severity warning;
        assert (tb_Y_2 = x"0001") report "TEST CASE 1-Y2 Failed" severity warning;
        assert (tb_Y_3 = x"0000") report "TEST CASE 1-Y3 Failed" severity warning;
        assert (tb_Y_4 = x"0000") report "TEST CASE 1-Y4 Failed" severity warning;

        assert (false) report "ALL TESTS PASSED" severity note;
        wait;

    end process;

end Behavioral;
