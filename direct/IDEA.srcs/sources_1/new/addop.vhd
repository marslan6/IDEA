----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN 
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    03.05.2026
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    addop - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    Adder for the IDEA algorithm. 
--                 Adds two 16-bit inputs modulo (2^16).
--
-- Dependencies:   IEEE.STD_LOGIC_1164.ALL, IEEE.NUMERIC_STD.ALL
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: Implemented using the Low-High Algorithm.
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity addop is
    port (
        ADD_IN0_I : in    std_logic_vector(15 downto 0);
        ADD_IN1_I : in    std_logic_vector(15 downto 0);
        ADD_OUT_O : out   std_logic_vector(15 downto 0)
    );
end entity addop;

architecture Behavioral of addop is
begin

    ADD_OP_P : process(ADD_IN0_I, ADD_IN1_I)
    begin
        -- Performs 16-bit addition modulo 2^16.
        -- Hence the carry bit is discarded.
        ADD_OUT_O <= (std_logic_vector(unsigned(ADD_IN0_I) + unsigned(ADD_IN1_I)));
    end process ADD_OP_P;

end architecture Behavioral;
