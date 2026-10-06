----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    03.05.2026
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    mux2x1 - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    2-to-1 multiplexer for 16-bit signals.
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

entity mux2x1 is
    port (
        S  : in    std_logic;
        D0 : in    std_logic_vector(15 downto 0);
        D1 : in    std_logic_vector(15 downto 0);
        O  : out   std_logic_vector(15 downto 0)
    );
end entity mux2x1;

architecture Behavioral of mux2x1 is

begin

    P_MUX2X1 : process (S, D0, D1) is
    begin
        case S is
            when '0' =>
                O <= D0;
            when '1' =>
                O <= D1;
            when others =>
                O <= (others => 'X');
        end case;
    end process P_MUX2X1;

end architecture Behavioral;
