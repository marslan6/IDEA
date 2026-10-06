----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN 
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    03.05.2026
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    tb_xorop - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    Testbench for the xorop module.
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

entity tb_xorop is
end tb_xorop;

architecture Behavioral of tb_xorop is

    constant tb_wait_2_ns : time := 2 ns;

    signal tb_xor_in0_i       : std_logic_vector(15 downto 0);
    signal tb_xor_in1_i       : std_logic_vector(15 downto 0);
    signal tb_xor_out_o       : std_logic_vector(15 downto 0);

    component xorop is
        port (
            XOR_IN0_I : in    std_logic_vector(15 downto 0);
            XOR_IN1_I : in    std_logic_vector(15 downto 0);
            XOR_OUT_O : out   std_logic_vector(15 downto 0)
        );
    end component xorop;

begin

    DUT_XOR : xorop
        port map (
            XOR_IN0_I => tb_xor_in0_i,
            XOR_IN1_I => tb_xor_in1_i,
            XOR_OUT_O => tb_xor_out_o
        );

    -- Stimulus Process
    P_STIMULUS : process is

        variable step : integer range 0 to 1000;
        
        -- XOR MANUAL TEST FUNCTION
        function xorer (in0 : std_logic_vector(15 downto 0); in1 : std_logic_vector(15 downto 0)) return std_logic_vector is
            -- Declare variable for XOR result
            variable out0 : std_logic_vector(15 downto 0);
        begin
             out0 := in0 xor in1;
            return out0;
        end function xorer;
        -- XOR MANUAL TEST FUNCTION END

    begin
        
        assert (false) report "XOROP TESTBENCH START" severity note;

        -- Initial state
        step         := 0;
        tb_xor_in0_i <= x"0000";
        tb_xor_in1_i <= x"FFFF";

        -- Test Case 0
        tb_xor_in0_i <= x"0000";
        tb_xor_in1_i <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_xor_out_o = xorer(tb_xor_in0_i, tb_xor_in1_i)) report "TEST " & integer'image(step) & " FAILED" severity warning;
        step         := step + 1;

        -- Test Case 1
        tb_xor_in0_i <= x"FFEE";
        tb_xor_in1_i <= x"DDEE";
        wait for tb_wait_2_ns;
        assert (tb_xor_out_o = xorer(tb_xor_in0_i, tb_xor_in1_i)) report "TEST " & integer'image(step) & " FAILED" severity warning;
        step         := step + 1;

        -- Test Case 2
        wait for tb_wait_2_ns;
        tb_xor_in0_i <= x"1111";
        tb_xor_in1_i <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_xor_out_o = xorer(tb_xor_in0_i, tb_xor_in1_i)) report "TEST " & integer'image(step) & " FAILED" severity warning;
        step         := step + 1;

        -- Test Case 3
        wait for tb_wait_2_ns;
        tb_xor_in0_i <= x"FFFF";
        tb_xor_in1_i <= x"1111";
        wait for tb_wait_2_ns;
        assert (tb_xor_out_o = xorer(tb_xor_in0_i, tb_xor_in1_i)) report "TEST " & integer'image(step) & " FAILED" severity warning;
        step         := step + 1;

        -- Test Case 4
        wait for tb_wait_2_ns;
        tb_xor_in0_i <= x"ABCD";
        tb_xor_in1_i <= x"FFFF";
        wait for tb_wait_2_ns;
        assert (tb_xor_out_o = x"5432") report "TEST " & integer'image(step) & " FAILED" severity warning;
        step         := step + 1;

        -- Test Case 5
        wait for tb_wait_2_ns;
        tb_xor_in0_i <= x"FFFF";
        tb_xor_in1_i <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_xor_out_o = xorer(tb_xor_in0_i, tb_xor_in1_i)) report "TEST " & integer'image(step) & " FAILED" severity warning;
        step         := step + 1;

        -- Reference Test Vector 0 Check
        wait for tb_wait_2_ns;
        tb_xor_in0_i <= x"0000";
        tb_xor_in1_i <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_xor_out_o = x"0000") report "TEST " & integer'image(step) & " FAILED" severity warning;
        step         := step + 1;

        -- Reference Test Vector 1 Check
        wait for tb_wait_2_ns;
        tb_xor_in0_i <= x"1234";
        tb_xor_in1_i <= x"5678";
        wait for tb_wait_2_ns;
        assert (tb_xor_out_o = x"444C") report "TEST " & integer'image(step) & " FAILED" severity warning;
        step         := step + 1;

        -- Reference Test Vector 2 Check
        wait for tb_wait_2_ns;
        tb_xor_in0_i <= x"1234";
        tb_xor_in1_i <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_xor_out_o = x"1234") report "TEST " & integer'image(step) & " FAILED" severity warning;
        step         := step + 1;

        assert (false) report "ALL TESTS PASSED" severity note;
        wait;

    end process P_STIMULUS;

end architecture Behavioral;
