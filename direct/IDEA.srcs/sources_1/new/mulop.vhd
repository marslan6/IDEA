----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN 
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    03.05.2026
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    mulop - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    Modulo-Multiplier for the IDEA algorithm. 
--                 Multiplies two 16-bit inputs modulo (2^16 + 1).
--                 Input 0 is treated as 2^16.
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

entity mulop is
    port (
        I_1 : in    std_logic_vector(15 downto 0);
        I_2 : in    std_logic_vector(15 downto 0);
        O_1 : out   std_logic_vector(15 downto 0)
    );
end entity mulop;

architecture Behavioral of mulop is

begin

    P_MULOP : process (I_1, I_2) is

        variable temp_i1     : unsigned(16 downto 0); -- Treated as 2^16 if I_1 is 0 which is 17-bits
        variable temp_i2     : unsigned(16 downto 0); -- Treated as 2^16 if I_2 is 0 which is 17-bits

        variable i1i2        : unsigned(33 downto 0);
        variable i1i2_div_2n : unsigned(16 downto 0);
        variable i1i2_mod_2n : unsigned(15 downto 0);
        variable result      : unsigned(16 downto 0);

    begin

        if (I_1 = x"0000") then
            temp_i1 := '1' & x"0000";
        else
            temp_i1 := '0' & unsigned(I_1);
        end if;

        if (I_2 = x"0000") then
            temp_i2 := '1' & x"0000";
        else
            temp_i2 := '0' & unsigned(I_2);
        end if;

        i1i2        := temp_i1 * temp_i2;
        i1i2_div_2n := i1i2(32 downto 16); -- Higher part
        i1i2_mod_2n := i1i2(15 downto 0); -- Lower part

        if (i1i2_mod_2n >= i1i2_div_2n) then
            result := ('0' & i1i2_mod_2n) - (i1i2_div_2n);
        else
            result := ('0' & i1i2_mod_2n) - (i1i2_div_2n) + to_unsigned((2 ** 16) + 1, 17);
        end if;

        O_1 <= std_logic_vector(result(15 downto 0));

    end process P_MULOP;

end architecture Behavioral;
