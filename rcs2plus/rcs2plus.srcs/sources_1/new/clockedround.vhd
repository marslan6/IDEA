----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    11:15:47 04/19/2016 
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    clockedround - Structural 
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    Clocked round module for rcs2plus.
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

entity clockedround is
    port (
        CLK      : in    std_logic;
        INIT     : in    std_logic;
        TRAFO    : in    std_logic;
        X1       : in    std_logic_vector(15 downto 0);
        X2       : in    std_logic_vector(15 downto 0);
        X3       : in    std_logic_vector(15 downto 0);
        X4       : in    std_logic_vector(15 downto 0);
        Z1       : in    std_logic_vector(15 downto 0);
        Z2       : in    std_logic_vector(15 downto 0);
        Z3       : in    std_logic_vector(15 downto 0);
        Z4       : in    std_logic_vector(15 downto 0);
        Z5       : in    std_logic_vector(15 downto 0);
        Z6       : in    std_logic_vector(15 downto 0);
        Y1       : out   std_logic_vector(15 downto 0);
        Y2       : out   std_logic_vector(15 downto 0);
        Y3       : out   std_logic_vector(15 downto 0);
        Y4       : out   std_logic_vector(15 downto 0);
        RESULT   : out   std_logic;
        Y1_TRAFO : out   std_logic_vector(15 downto 0);
        Y2_TRAFO : out   std_logic_vector(15 downto 0);
        Y3_TRAFO : out   std_logic_vector(15 downto 0);
        Y4_TRAFO : out   std_logic_vector(15 downto 0)
    );
end entity clockedround;

architecture structural of clockedround is

    component datapath is
        port ( 
            CLK       : in  std_logic;
            EN125     : in  std_logic;
            EN346     : in  std_logic;
            EN78      : in  std_logic;
            S         : in  std_logic_vector(1 downto 0);
            S_T       : in  std_logic_vector(1 downto 0);
            X_1       : in  std_logic_vector(15 downto 0);
            X_2       : in  std_logic_vector(15 downto 0);
            X_3       : in  std_logic_vector(15 downto 0);
            X_4       : in  std_logic_vector(15 downto 0);
            Z1        : in  std_logic_vector(15 downto 0);
            Z2        : in  std_logic_vector(15 downto 0);
            Z3        : in  std_logic_vector(15 downto 0);
            Z4        : in  std_logic_vector(15 downto 0);
            Z5        : in  std_logic_vector(15 downto 0);
            Z6        : in  std_logic_vector(15 downto 0);
            Y_1       : out std_logic_vector(15 downto 0);
            Y_2       : out std_logic_vector(15 downto 0);
            Y_3       : out std_logic_vector(15 downto 0);
            Y_4       : out std_logic_vector(15 downto 0);
            Y_1_TRAFO : out std_logic_vector(15 downto 0);
            Y_2_TRAFO : out std_logic_vector(15 downto 0);
            Y_3_TRAFO : out std_logic_vector(15 downto 0);
            Y_4_TRAFO : out std_logic_vector(15 downto 0)
        );
    end component datapath;

    component control is
        port ( 
            CLK    : in    std_logic;
            INIT   : in    std_logic;
            TRAFO  : in    std_logic;
            EN125  : out   std_logic;
            EN346  : out   std_logic;
            EN78   : out   std_logic;
            RESULT : out   std_logic;
            S      : out   std_logic_vector(1 downto 0);
            S_T    : out   std_logic_vector(1 downto 0)
        );	
    end component control;

    signal EN125, EN346, EN78 : std_logic;
    signal S, S_T : std_logic_vector(1 downto 0);

begin

    U_CONTROLLER : control
    port map(
        CLK    => CLK,
        INIT   => INIT,
        TRAFO  => TRAFO,
        EN125  => EN125,
        EN346  => EN346,
        EN78   => EN78,
        RESULT => RESULT,
        S      => S,
        S_T    => S_T
    );	

    U_DATAPATH : datapath 
    port map (
        CLK   => CLK,
        EN125 => EN125,
        EN346 => EN346,
        EN78  => EN78,
        S     => S,
        S_T   => S_T,
        X_1   => X1,
        X_2   => X2,
        X_3   => X3,
        X_4   => X4,
        Z1    => Z1,
        Z2    => Z2,
        Z3    => Z3,
        Z4    => Z4,
        Z5    => Z5,
        Z6    => Z6,
        Y_1   => Y1,
        Y_2   => Y2,
        Y_3   => Y3,
        Y_4   => Y4,
        Y_1_TRAFO => Y1_TRAFO,
        Y_2_TRAFO => Y2_TRAFO,
        Y_3_TRAFO => Y3_TRAFO,
        Y_4_TRAFO => Y4_TRAFO
    );



end architecture structural;
