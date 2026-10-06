----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN 
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    03.05.2026
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    trafo - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    Transformation module for the IDEA algorithm.
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

entity trafo is
    port (
        X1 : in    std_logic_vector(15 downto 0);
        X2 : in    std_logic_vector(15 downto 0);
        X3 : in    std_logic_vector(15 downto 0);
        X4 : in    std_logic_vector(15 downto 0);
        Z1 : in    std_logic_vector(15 downto 0);
        Z2 : in    std_logic_vector(15 downto 0);
        Z3 : in    std_logic_vector(15 downto 0);
        Z4 : in    std_logic_vector(15 downto 0);
        Y1 : out   std_logic_vector(15 downto 0);
        Y2 : out   std_logic_vector(15 downto 0);
        Y3 : out   std_logic_vector(15 downto 0);
        Y4 : out   std_logic_vector(15 downto 0)
    );
end entity trafo;

architecture Behavioral of trafo is

    component mulop is
        port (
            I_1 : in    std_logic_vector(15 downto 0);
            I_2 : in    std_logic_vector(15 downto 0);
            O_1 : out   std_logic_vector(15 downto 0)
        );
    end component mulop;

    component addop is
        port (
            ADD_IN0_I : in    std_logic_vector(15 downto 0);
            ADD_IN1_I : in    std_logic_vector(15 downto 0);
            ADD_OUT_O : out   std_logic_vector(15 downto 0)
        );
    end component addop;

begin

    MULOP1 : mulop
        port map (
            I_1 => X1,
            I_2 => Z1,
            O_1 => Y1
        );

    MULOP2 : mulop
        port map (
            I_1 => X4,
            I_2 => Z4,
            O_1 => Y4
        );

    ADDOP1 : addop
        port map (
            ADD_IN0_I => X3,
            ADD_IN1_I => Z2,
            ADD_OUT_O => Y2
        );

    ADDOP2 : addop
        port map (
            ADD_IN0_I => X2,
            ADD_IN1_I => Z3,
            ADD_OUT_O => Y3
        );

end architecture Behavioral;
