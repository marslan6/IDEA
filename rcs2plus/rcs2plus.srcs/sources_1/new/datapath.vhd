----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    06/14/2026 09:40:45 PM
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    datapath - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool Versions:  Xilinx ISE WebPack
-- Description:    Datapath module for rcs2plus.
-- 
-- Dependencies:   IEEE.STD_LOGIC_1164.ALL
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity datapath is
    port ( 
        CLK       : in    std_logic;
        EN125     : in    std_logic;
        EN346     : in    std_logic;
        EN78      : in    std_logic;
        S         : in    std_logic_vector(1 downto 0);
        S_T       : in    std_logic_vector(1 downto 0);
        X_1       : in    std_logic_vector(15 downto 0);
        X_2       : in    std_logic_vector(15 downto 0);
        X_3       : in    std_logic_vector(15 downto 0);
        X_4       : in    std_logic_vector(15 downto 0);
        Z1        : in    std_logic_vector(15 downto 0);
        Z2        : in    std_logic_vector(15 downto 0);
        Z3        : in    std_logic_vector(15 downto 0);
        Z4        : in    std_logic_vector(15 downto 0);
        Z5        : in    std_logic_vector(15 downto 0);
        Z6        : in    std_logic_vector(15 downto 0);
        Y_1       : out   std_logic_vector(15 downto 0);
        Y_2       : out   std_logic_vector(15 downto 0);
        Y_3       : out   std_logic_vector(15 downto 0);
        Y_4       : out   std_logic_vector(15 downto 0);
        Y_1_TRAFO : out   std_logic_vector(15 downto 0);
        Y_2_TRAFO : out   std_logic_vector(15 downto 0);
        Y_3_TRAFO : out   std_logic_vector(15 downto 0);
        Y_4_TRAFO : out   std_logic_vector(15 downto 0)
    );
end entity datapath;

architecture behavioral of datapath is

    component mux4x1 is
        port (
            S  : in    std_logic_vector(1 downto 0);
            D0 : in    std_logic_vector(15 downto 0);
            D1 : in    std_logic_vector(15 downto 0);
            D2 : in    std_logic_vector(15 downto 0);
            D3 : in    std_logic_vector(15 downto 0);
            O  : out   std_logic_vector(15 downto 0)
        );
    end component mux4x1;

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

    component xorop is
        port (
            XOR_IN0_I : in    std_logic_vector(15 downto 0);
            XOR_IN1_I : in    std_logic_vector(15 downto 0);
            XOR_OUT_O : out   std_logic_vector(15 downto 0)
        );
    end component xorop;

    component register16 is
        port (
            clock  : in    std_logic;
            enable : in    std_logic;
            D      : in    std_logic_vector(15 downto 0);
            Q      : out   std_logic_vector(15 downto 0)
        );
    end component register16;

    signal MUX1_o, MUX2_o, MUX3_o, MUX4_o : std_logic_vector(15 downto 0);
    signal ADD1_o                         : std_logic_vector(15 downto 0);
    signal MUL1_o                         : std_logic_vector(15 downto 0);
    signal XOR1_o                         : std_logic_vector(15 downto 0);
    signal REG1_o, REG2_o, REG5_o         : std_logic_vector(15 downto 0);
    signal REG3_o, REG4_o, REG6_o         : std_logic_vector(15 downto 0);
    signal REG7_o, REG8_o                 : std_logic_vector(15 downto 0);

begin

    Y_1_TRAFO <= REG1_o;
    Y_2_TRAFO <= REG2_o;
    Y_3_TRAFO <= REG3_o;
    Y_4_TRAFO <= REG4_o;

    -- REG125
    R1 : register16
        port map (
            clock  => CLK,
            enable => EN125,
            D      => MUL1_o,
            Q      => REG1_o
        );

    R2 : register16
        port map (
            clock  => CLK,
            enable => EN125,
            D      => ADD1_o,
            Q      => REG2_o
        );

    R5 : register16
        port map (
            clock  => CLK,
            enable => EN125,
            D      => XOR1_o,
            Q      => REG5_o
        );

    -- REG346
    R3 : register16
        port map (
            clock  => CLK,
            enable => EN346,
            D      => ADD1_o,
            Q      => REG3_o
        );

    R4 : register16
        port map (
            clock  => CLK,
            enable => EN346,
            D      => MUL1_o,
            Q      => REG4_o
        );

    R6 : register16
        port map (
            clock  => CLK,
            enable => EN346,
            D      => XOR1_o,
            Q      => REG6_o
        );

    -- REG78
    R7 : register16
        port map (
            clock  => CLK,
            enable => EN78,
            D      => MUL1_o,
            Q      => REG7_o
        );

    R8 : register16
        port map (
            clock  => CLK,
            enable => EN78,
            D      => ADD1_o,
            Q      => REG8_o
        );

    -- MUX1234
    MUX1 : mux4x1 
        port map (
            S  => S,
            D0 => X_1,
            D1 => X_4,
            D2 => Z5,
            D3 => Z6,
            O  => MUX1_o
        );

    MUX2 : mux4x1 
        port map (
            S  => S,
            D0 => Z1,
            D1 => Z4,
            D2 => REG5_o,
            D3 => REG8_o,
            O  => MUX2_o
        );

    MUX3 : mux4x1 
        port map (
            S  => S,
            D0 => X_3,
            D1 => X_2,
            D2 => REG6_o,
            D3 => REG7_o,
            O  => MUX3_o
        );

    MUX4 : mux4x1 
        port map (
            S  => S_T,
            D0 => Z3,
            D1 => Z2,
            D2 => MUL1_o,
            D3 => MUL1_o,
            O  => MUX4_o
        );

    -- MUL1
    MUL1 : mulop 
        port map (
            I_1 => MUX1_o,
            I_2 => MUX2_o,
            O_1 => MUL1_o
        );

    -- XOR1
    XOR1 : xorop 
        port map (
            XOR_IN0_I => MUL1_o, 
            XOR_IN1_I => ADD1_o,
            XOR_OUT_O => XOR1_o
        );

    XOR2 : xorop 
        port map (
            XOR_IN0_I => REG3_o, 
            XOR_IN1_I => ADD1_o,
            XOR_OUT_O => Y_3
        );

    XOR3 : xorop 
        port map (
            XOR_IN0_I => REG2_o, 
            XOR_IN1_I => MUL1_o,
            XOR_OUT_O => Y_2
        );

    XOR4 : xorop 
        port map (
            XOR_IN0_I => REG4_o, 
            XOR_IN1_I => ADD1_o,
            XOR_OUT_O => Y_4
        );

    XOR5 : xorop 
        port map (
            XOR_IN0_I => REG1_o, 
            XOR_IN1_I => MUL1_o,
            XOR_OUT_O => Y_1
        );

    -- ADD1
    ADD1 : addop 
        port map (
            ADD_IN0_I => MUX3_o,
            ADD_IN1_I => MUX4_o,
            ADD_OUT_O => ADD1_o
        );

end architecture behavioral;
