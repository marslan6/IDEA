----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN 
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    03.05.2026
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    tb_addop - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    Testbench for the addop module.
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

entity tb_addop is
end tb_addop;

architecture Behavioral of tb_addop is

    constant tb_wait_2_ns : time := 2 ns;

    signal tb_add_in0_i   : std_logic_vector(15 downto 0);
    signal tb_add_in1_i   : std_logic_vector(15 downto 0);
    signal tb_add_out_o   : std_logic_vector(15 downto 0);

    component addop is
        port (
            ADD_IN0_I : in    std_logic_vector(15 downto 0);
            ADD_IN1_I : in    std_logic_vector(15 downto 0);
            ADD_OUT_O : out   std_logic_vector(15 downto 0)
        );
    end component addop;

begin

    DUT_ADD : addop
        port map (
            ADD_IN0_I => tb_add_in0_i,
            ADD_IN1_I => tb_add_in1_i,
            ADD_OUT_O => tb_add_out_o
        );

    -- Stimulus Process
    P_STIMULUS : process is

        variable step : integer range 0 to 1023;

        -- ADD MANUAL TEST FUNCTION
        function adder (in0 : std_logic_vector(15 downto 0); in1 : std_logic_vector(15 downto 0)) return std_logic_vector is
            variable out0 : std_logic_vector(15 downto 0);
        begin
            -- Performs unsigned addition
            -- VHDL naturally performs Modulo 2^16 here since numbers are 16 bits long.
            out0 := std_logic_vector(unsigned(in0) + unsigned(in1));
            return out0;
        end function adder;
        -- ADD MANUAL TEST FUNCTION END

    begin

        assert (false) report "ADDOP TESTBENCH START" severity note;

        -- TEST CASE 0
        step         := 0;
        tb_add_in0_i <= x"0000";
        tb_add_in1_i <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_add_out_o = x"0000") report "TEST CASE " & integer'image(step) & " FAILED" severity warning;
        step         := step + 1;

        -- TEST CASE 1: Overflow/Modulo Check (FFFF + 0001 = 0000)
        tb_add_in0_i <= x"FFFF";
        tb_add_in1_i <= x"0001";
        wait for tb_wait_2_ns;
        assert (tb_add_out_o = x"0000") report "TEST CASE " & integer'image(step) & " FAILED" severity warning;
        step         := step + 1;

        -- TEST CASE 2: Arbitrary Value Check (AAAA + BBBB = 6665)
        tb_add_in0_i <= x"AAAA";
        tb_add_in1_i <= x"BBBB";
        wait for tb_wait_2_ns;
        assert (tb_add_out_o = x"6665") report "TEST CASE " & integer'image(step) & " FAILED" severity warning;
        step         := step + 1;

        -- TEST CASE 3: Reference Test Vector 0 Check 
        tb_add_in0_i <= x"0000";
        tb_add_in1_i <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_add_out_o = x"0000") report "TEST CASE " & integer'image(step) & " FAILED" severity warning;
        step         := step + 1;

        -- TEST CASE 4: Reference Test Vector 1 Check
        tb_add_in0_i <= x"7CE3";
        tb_add_in1_i <= x"0000";
        wait for tb_wait_2_ns;
        assert (tb_add_out_o = x"7CE3") report "TEST CASE " & integer'image(step) & " FAILED" severity warning;
        step         := step + 1;

        -- TEST CASE 5: Reference Test Vector 2 Check
        tb_add_in0_i <= x"7CE3";
        tb_add_in1_i <= x"2DB6";
        wait for tb_wait_2_ns;
        assert (tb_add_out_o = x"AA99") report "TEST CASE " & integer'image(step) & " FAILED" severity warning;
        step         := step + 1;

        -- TEST CASE 6: Reference Test Vector 3 Check
        tb_add_in0_i <= x"FCE3";
        tb_add_in1_i <= x"2DB6";
        wait for tb_wait_2_ns;
        assert (tb_add_out_o = x"2A99") report "TEST CASE " & integer'image(step) & " FAILED" severity warning;
        step         := step + 1;

        -- TEST CASE 5: Reference Test Vector 4 Check
        tb_add_in0_i <= x"FCE3";
        tb_add_in1_i <= x"EDB6";
        wait for tb_wait_2_ns;
        assert (tb_add_out_o = x"EA99") report "TEST CASE " & integer'image(step) & " FAILED" severity warning;
        step         := step + 1;

        -- TEST CASE 6: Reference Test Vector 5 Check
        tb_add_in0_i <= x"7CE3";
        tb_add_in1_i <= x"EDB6";
        wait for tb_wait_2_ns;
        assert (tb_add_out_o = x"6A99") report "TEST CASE " & integer'image(step) & " FAILED" severity warning;
        step         := step + 1;

        -- AUTOMATED LOOP: Stress test with 200 different value combinations
        for i in 1 to 200 loop
            -- Increment inputs: Total sum grows by 12 (5+7) every iteration
            tb_add_in0_i <= std_logic_vector(unsigned(tb_add_in0_i) + x"0005");
            tb_add_in1_i <= std_logic_vector(unsigned(tb_add_in1_i) + x"0007");
            wait for tb_wait_2_ns;
            
            -- Check 1: Comparison against the 'adder' function result
            assert (tb_add_out_o = adder(tb_add_in0_i, tb_add_in1_i)) report "TEST CASE " & integer'image(step) & " FAILED (Function mismatch)" severity warning;

            wait for tb_wait_2_ns;
            step := step + 1;
        end loop;

        assert false report "ALL TESTS PASSED" severity note;
        wait;

    end process P_STIMULUS;

end architecture Behavioral;
