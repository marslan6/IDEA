----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    07/05/2026 03:32:09 PM
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    tb_idea_rcs2 - behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool Versions:  Xilinx ISE WebPack
-- Description:    Testbench for the idea_rcs2 top level module.
-- 
-- Dependencies:   ieee.std_logic_1164.all, ieee.numeric_std.all
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_idea_rcs2 is
end tb_idea_rcs2;

architecture behavioral of tb_idea_rcs2 is

    component idea_rcs2 is
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
    end component idea_rcs2;

    constant clk_period : time := 10 ns;

    signal tb_CLOCK : std_logic := '0';
    signal tb_START : std_logic := '0';
    signal tb_KEY   : std_logic_vector(127 downto 0) := (others => '0');
    signal tb_X_1   : std_logic_vector(15 downto 0)  := (others => '0');
    signal tb_X_2   : std_logic_vector(15 downto 0)  := (others => '0');
    signal tb_X_3   : std_logic_vector(15 downto 0)  := (others => '0');
    signal tb_X_4   : std_logic_vector(15 downto 0)  := (others => '0');
    signal tb_Y_1   : std_logic_vector(15 downto 0)  := (others => '0');
    signal tb_Y_2   : std_logic_vector(15 downto 0)  := (others => '0');
    signal tb_Y_3   : std_logic_vector(15 downto 0)  := (others => '0');
    signal tb_Y_4   : std_logic_vector(15 downto 0)  := (others => '0');
    signal tb_READY : std_logic := '0';

begin

    DUT_IDEA_RCS2 : idea_rcs2
        port map (
            CLOCK => tb_CLOCK,
            START => tb_START,
            KEY   => tb_KEY,
            X_1   => tb_X_1,
            X_2   => tb_X_2,
            X_3   => tb_X_3,
            X_4   => tb_X_4,
            Y_1   => tb_Y_1,
            Y_2   => tb_Y_2,
            Y_3   => tb_Y_3,
            Y_4   => tb_Y_4,
            READY => tb_READY
        );

    P_CLK : process 
    begin
        tb_CLOCK <= '0';
        wait for clk_period / 2;
        tb_CLOCK <= '1';
        wait for clk_period / 2;
    end process P_CLK;

    P_STIMULUS : process 
    begin 

        assert (false) report "IDEA_RCS2 TESTBENCH START" severity note;

        wait for clk_period * 10;

        -- Insert start signal and input data
        wait until rising_edge(tb_CLOCK);
        tb_START <= '1';
        tb_KEY <= x"00010002000300040005000600070008";
        tb_X_1 <= x"1111"; tb_X_2 <= x"2222"; tb_X_3 <= x"4444"; tb_X_4 <= x"8888";

        -- Deassert start signal after one clock cycle
        wait until rising_edge(tb_CLOCK);
        tb_START <= '0';

        -- Wait for the READY signal to be asserted
        -- Indicates that the encryption process is completed
        wait until tb_READY = '1';

        -- Check outputs after the READY signal is asserted at the falling edge of the clock
        wait until falling_edge(tb_CLOCK);
        assert (tb_Y_1 = x"8AA9") report "TEST CASE 0-Y1 Failed" severity warning;
        assert (tb_Y_2 = x"0FEF") report "TEST CASE 0-Y2 Failed" severity warning;
        assert (tb_Y_3 = x"C0C9") report "TEST CASE 0-Y3 Failed" severity warning;
        assert (tb_Y_4 = x"56F6") report "TEST CASE 0-Y4 Failed" severity warning;


        wait for clk_period * 5;

        -- Insert start signal and input data
        wait until rising_edge(tb_CLOCK);
        tb_START <= '1';
        tb_KEY <= x"00000000000000000000000000000000";
        tb_X_1 <= x"0000"; tb_X_2 <= x"0000"; tb_X_3 <= x"0000"; tb_X_4 <= x"0000";

        -- Deassert start signal after one clock cycle
        wait until rising_edge(tb_CLOCK);
        tb_START <= '0'; 

        -- Wait for the READY signal to be asserted
        -- Indicates that the encryption process is completed
        wait until tb_READY = '1';

        -- Check outputs after the READY signal is asserted at the falling edge of the clock
        wait until falling_edge(tb_CLOCK);
        assert (tb_Y_1 = x"0001") report "TEST CASE 1-Y1 Failed" severity warning;
        assert (tb_Y_2 = x"0001") report "TEST CASE 1-Y2 Failed" severity warning;
        assert (tb_Y_3 = x"0000") report "TEST CASE 1-Y3 Failed" severity warning;
        assert (tb_Y_4 = x"0000") report "TEST CASE 1-Y4 Failed" severity warning;

        assert (false) report "ALL TESTS PASSED" severity note;
        wait;

    end process P_STIMULUS;

end behavioral;
