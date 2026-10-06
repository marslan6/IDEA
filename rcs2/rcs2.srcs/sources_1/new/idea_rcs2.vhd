----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    idea_rcs2 - Structural 
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    Top-level structural VHDL for rcs2.
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

entity idea_rcs2 is
    port (
        CLOCK : in    std_logic;
        START : in    std_logic;
        KEY   : in    std_logic_vector(127 downto 0);
        X_1   : in    std_logic_vector(15 downto 0);
        X_2   : in    std_logic_vector(15 downto 0);
        X_3   : in    std_logic_vector(15 downto 0);
        X_4   : in    std_logic_vector(15 downto 0);
        Y_1   : out   std_logic_vector(15 downto 0);
        Y_2   : out   std_logic_vector(15 downto 0);
        Y_3   : out   std_logic_vector(15 downto 0);
        Y_4   : out   std_logic_vector(15 downto 0);
        READY : out   std_logic
    );
end entity idea_rcs2;

architecture structural of idea_rcs2 is
    
    component roundcounter is
        port (
            CLK    : in    std_logic;
            START  : in    std_logic;
            RESULT : in    std_logic;
            READY  : out   std_logic;
            S_i    : out   std_logic;
            INIT   : out   std_logic;
            TRAFO  : out   std_logic;
            ROUND  : out   std_logic_vector(3 downto 0)
        );
    end component roundcounter;

    component keygenerator is
        port ( 
            key : in std_logic_vector(127 downto 0);
            round_counter : in std_logic_vector(3 downto 0);
            key1 : out std_logic_vector(15 downto 0);
            key2 : out std_logic_vector(15 downto 0);
            key3 : out std_logic_vector(15 downto 0);
            key4 : out std_logic_vector(15 downto 0);
            key5 : out std_logic_vector(15 downto 0);
            key6 : out std_logic_vector(15 downto 0)
        );
    end component keygenerator;

    component clockedround is
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
    end component clockedround;

    component register16 is
        port (
            clock  : in    std_logic;
            enable : in    std_logic;
            D      : in    std_logic_vector(15 downto 0);
            Q      : out   std_logic_vector(15 downto 0)
        );
    end component register16;

    component mux2x1 is
        port (
            S  : in    std_logic;
            D0 : in    std_logic_vector(15 downto 0);
            D1 : in    std_logic_vector(15 downto 0);
            O  : out   std_logic_vector(15 downto 0)
        );
    end component mux2x1;

    -- Feedback register outputs (R1-R4 in Fig. 5.16)
    signal R1_Q, R2_Q, R3_Q, R4_Q : std_logic_vector(15 downto 0);
    signal X1_r, X2_r, X3_r, X4_r : std_logic_vector(15 downto 0);
    signal Y1_r, Y2_r, Y3_r, Y4_r : std_logic_vector(15 downto 0);
    signal Z1_r, Z2_r, Z3_r, Z4_r, Z5_r, Z6_r : std_logic_vector(15 downto 0);

    signal S_i, INIT, TRAFO, RESULT : std_logic;
    signal ROUND_CNT : std_logic_vector(3 downto 0);

begin

    P_MUX2X1_1 : mux2x1
    port map (
        S  => S_i,
        D0 => R1_Q,
        D1 => X_1,
        O  => X1_r
    );

    P_MUX2X1_2 : mux2x1
    port map (
        S  => S_i,
        D0 => R2_Q,
        D1 => X_2,
        O  => X2_r
    );

    P_MUX2X1_3 : mux2x1
    port map (
        S  => S_i,
        D0 => R3_Q,
        D1 => X_3,
        O  => X3_r
    );

    P_MUX2X1_4 : mux2x1
    port map (
        S  => S_i,
        D0 => R4_Q,
        D1 => X_4,
        O  => X4_r
    );

    reg_1 : register16
    port map (
        clock  => CLOCK,
        enable => RESULT,
        D      => Y1_r,
        Q      => R1_Q
    );

    reg_2 : register16
    port map (
        clock  => CLOCK,
        enable => RESULT,
        D      => Y2_r,
        Q      => R2_Q
    );

    reg_3 : register16
    port map (
        clock  => CLOCK,
        enable => RESULT,
        D      => Y3_r,
        Q      => R3_Q
    );

    reg_4 : register16
    port map (
        clock  => CLOCK,
        enable => RESULT,
        D      => Y4_r,
        Q      => R4_Q
    );

    keygenerator_1 : keygenerator
    port map (
        key           => KEY,
        round_counter => ROUND_CNT,
        key1          => Z1_r,
        key2          => Z2_r,
        key3          => Z3_r,
        key4          => Z4_r,
        key5          => Z5_r,
        key6          => Z6_r
    );
     
    roundcounter_1 : roundcounter
    port map (
        CLK    => CLOCK,
        START  => START,
        RESULT => RESULT,
        READY  => READY,
        S_i    => S_i,
        INIT   => INIT,
        TRAFO  => TRAFO,
        ROUND  => ROUND_CNT
    );

    extended_round : clockedround
    port map (
        CLK      => CLOCK,
        INIT     => INIT,
        TRAFO    => TRAFO,
        X1       => X1_r,
        X2       => X2_r,
        X3       => X3_r,
        X4       => X4_r,
        Z1       => Z1_r,
        Z2       => Z2_r,
        Z3       => Z3_r,
        Z4       => Z4_r,
        Z5       => Z5_r,
        Z6       => Z6_r,
        Y1       => Y1_r,
        Y2       => Y2_r,
        Y3       => Y3_r,
        Y4       => Y4_r,
        RESULT   => RESULT,
        Y1_TRAFO => Y_1,
        Y2_TRAFO => Y_2,
        Y3_TRAFO => Y_3,
        Y4_TRAFO => Y_4
    );

end architecture structural;