----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN 
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    03.05.2026
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    xorop - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    Xor for the IDEA algorithm. 
--                 Xor two 16-bit inputs.
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

entity xorop is
    port (
        XOR_IN0_I : in    std_logic_vector(15 downto 0);
        XOR_IN1_I : in    std_logic_vector(15 downto 0);
        XOR_OUT_O : out   std_logic_vector(15 downto 0)
    );
end entity xorop;

architecture Behavioral of xorop is

--

begin

    XOR_OP_P : process(XOR_IN0_I, XOR_IN1_I) 
    begin
        XOR_OUT_O <= (XOR_IN0_I xor XOR_IN1_I);
    end process XOR_OP_P;

end architecture Behavioral;
