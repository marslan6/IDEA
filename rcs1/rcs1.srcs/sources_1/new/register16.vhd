----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    03.05.2026
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    register16 - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    16-bit register with clock enable.
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

entity register16 is
    port (
        clock  : in    std_logic;
        enable : in    std_logic;
        D      : in    std_logic_vector(15 downto 0);
        Q      : out   std_logic_vector(15 downto 0)
    );
end entity register16;

architecture Behavioral of register16 is

begin

    P_REG : process (clock) is
    begin
        if rising_edge(clock) then
            if (enable = '1') then
                Q <= D;
            end if;
        end if;
    end process P_REG;

end architecture Behavioral;
