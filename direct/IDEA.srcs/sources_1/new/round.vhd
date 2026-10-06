----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN 
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    03.05.2026
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    round - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    Round module for the IDEA algorithm.
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

entity round is
    port (
        X1 : in    std_logic_vector(15 downto 0);
        X2 : in    std_logic_vector(15 downto 0);
        X3 : in    std_logic_vector(15 downto 0);
        X4 : in    std_logic_vector(15 downto 0);
        Z1 : in    std_logic_vector(15 downto 0);
        Z2 : in    std_logic_vector(15 downto 0);
        Z3 : in    std_logic_vector(15 downto 0);
        Z4 : in    std_logic_vector(15 downto 0);
        Z5 : in    std_logic_vector(15 downto 0);
        Z6 : in    std_logic_vector(15 downto 0);
        Y1 : out   std_logic_vector(15 downto 0);
        Y2 : out   std_logic_vector(15 downto 0);
        Y3 : out   std_logic_vector(15 downto 0);
        Y4 : out   std_logic_vector(15 downto 0)
    );
end entity round;

architecture Behavioral of round is

    component addop is
        port (
            ADD_IN0_I : in    std_logic_vector(15 downto 0);
            ADD_IN1_I : in    std_logic_vector(15 downto 0);
            ADD_OUT_O : out   std_logic_vector(15 downto 0)
        );
    end component addop;

    component xorop is
        port (
            XOR_IN0_I : in    std_logic_vector(15 downto 0);
            XOR_IN1_I : in    std_logic_vector(15 downto 0);
            XOR_OUT_O : out   std_logic_vector(15 downto 0)
        );
    end component xorop;

    component mulop is
        port (
            I_1 : in    std_logic_vector(15 downto 0);
            I_2 : in    std_logic_vector(15 downto 0);
            O_1 : out   std_logic_vector(15 downto 0)
        );
    end component mulop;

    signal conn1  : std_logic_vector(15 downto 0);
    signal conn2  : std_logic_vector(15 downto 0);
    signal conn3  : std_logic_vector(15 downto 0);
    signal conn4  : std_logic_vector(15 downto 0);
    signal conn5  : std_logic_vector(15 downto 0);
    signal conn6  : std_logic_vector(15 downto 0);
    signal conn7  : std_logic_vector(15 downto 0);
    signal conn8  : std_logic_vector(15 downto 0);
    signal conn9  : std_logic_vector(15 downto 0);
    signal conn10 : std_logic_vector(15 downto 0);

begin

    -------------------------------------------
    -------- MULOP MODULES & CONNECTIONS ------
    -------------------------------------------
    MULOP1 : mulop
        port map (
            I_1 => X1,
            I_2 => Z1,
            O_1 => conn1
        );

    MULOP2 : mulop
        port map (
            I_1 => X4,
            I_2 => Z4,
            O_1 => conn2
        );

    MULOP3 : mulop
        port map (
            I_1 => conn5,
            I_2 => Z5,
            O_1 => conn6
        );

    MULOP4 : mulop
        port map (
            I_1 => Z6,
            I_2 => conn8,
            O_1 => conn9
        );

    -------------------------------------------
    -------- ADDER MODULES & CONNECTIONS ------
    -------------------------------------------
    ADDOP1 : addop
        port map (
            ADD_IN0_I => X2,
            ADD_IN1_I => Z2,
            ADD_OUT_O => conn3
        );

    ADDOP2 : addop
        port map (
            ADD_IN0_I => X3,
            ADD_IN1_I => Z3,
            ADD_OUT_O => conn4
        );

    ADDOP3 : addop
        port map (
            ADD_IN0_I => conn6,
            ADD_IN1_I => conn9,
            ADD_OUT_O => conn10
        );

    ADDOP4 : addop
        port map (
            ADD_IN0_I => conn7,
            ADD_IN1_I => conn6,
            ADD_OUT_O => conn8
        );

    -------------------------------------------
    -------- XOR MODULES & CONNECTIONS --------
    -------------------------------------------
    XOROP1 : xorop
        port map (
            XOR_IN0_I => conn1,
            XOR_IN1_I => conn4,
            XOR_OUT_O => conn5
        );

    XOROP2 : xorop
        port map (
            XOR_IN0_I => conn2,
            XOR_IN1_I => conn3,
            XOR_OUT_O => conn7
        );

    XOROP3 : xorop
        port map (
            XOR_IN0_I => conn1,
            XOR_IN1_I => conn9,
            XOR_OUT_O => Y1
        );

    XOROP4 : xorop
        port map (
            XOR_IN0_I => conn3,
            XOR_IN1_I => conn10,
            XOR_OUT_O => Y3
        );

    XOROP5 : xorop
        port map (
            XOR_IN0_I => conn4,
            XOR_IN1_I => conn9,
            XOR_OUT_O => Y2
        );

    XOROP6 : xorop
        port map (
            XOR_IN0_I => conn2,
            XOR_IN1_I => conn10,
            XOR_OUT_O => Y4
        );

end architecture Behavioral;
