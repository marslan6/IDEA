----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    03.05.2026
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    idea_single - Structural
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    Single-cycle structural VHDL implementation of the IDEA cipher.
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

entity idea_single is
    port (
        CLOCK : in    std_logic;
        START : in    std_logic;
        READY : out   std_logic;
        KEY   : in    std_logic_vector(127 downto 0);
        X_1   : in    std_logic_vector(15 downto 0);
        X_2   : in    std_logic_vector(15 downto 0);
        X_3   : in    std_logic_vector(15 downto 0);
        X_4   : in    std_logic_vector(15 downto 0);
        Y_1   : out   std_logic_vector(15 downto 0);
        Y_2   : out   std_logic_vector(15 downto 0);
        Y_3   : out   std_logic_vector(15 downto 0);
        Y_4   : out   std_logic_vector(15 downto 0)
    );
end entity idea_single;

architecture Structural of idea_single is

    component control is
        port (
            CLK   : in    std_logic;
            START : in    std_logic;
            ROUND : out   std_logic_vector(3 downto 0);
            READY : out   std_logic;
            EN    : out   std_logic;
            S     : out   std_logic
        );
    end component control;

    component round is
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
    end component round;

    component trafo is
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
    end component trafo;

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

    component keygenerator is
        port (
            key           : in    std_logic_vector(127 downto 0);
            round_counter : in    std_logic_vector(3 downto 0);
            key1          : out   std_logic_vector(15 downto 0);
            key2          : out   std_logic_vector(15 downto 0);
            key3          : out   std_logic_vector(15 downto 0);
            key4          : out   std_logic_vector(15 downto 0);
            key5          : out   std_logic_vector(15 downto 0);
            key6          : out   std_logic_vector(15 downto 0)
        );
    end component keygenerator;

    signal round_counter : std_logic_vector(3 downto 0) := (others => '0');
    signal en            : std_logic                    := '0';
    signal sel           : std_logic                    := '0';

    -- INPUTS for ROUND module & OUTPUTS of MUXES
    signal round1_sigin  : std_logic_vector(15 downto 0);
    signal round2_sigin  : std_logic_vector(15 downto 0);
    signal round3_sigin  : std_logic_vector(15 downto 0);
    signal round4_sigin  : std_logic_vector(15 downto 0);

    -- INPUTS for REGISTERS & OUTPUTS of ROUND module
    signal round1_sigout : std_logic_vector(15 downto 0);
    signal round2_sigout : std_logic_vector(15 downto 0);
    signal round3_sigout : std_logic_vector(15 downto 0);
    signal round4_sigout : std_logic_vector(15 downto 0);

    -- INPUTS for TRAFO module & OUTPUTS of REGISTERS
    signal trafo1_sigin  : std_logic_vector(15 downto 0);
    signal trafo2_sigin  : std_logic_vector(15 downto 0);
    signal trafo3_sigin  : std_logic_vector(15 downto 0);
    signal trafo4_sigin  : std_logic_vector(15 downto 0);

    signal key1_sigin    : std_logic_vector(15 downto 0);
    signal key2_sigin    : std_logic_vector(15 downto 0);
    signal key3_sigin    : std_logic_vector(15 downto 0);
    signal key4_sigin    : std_logic_vector(15 downto 0);
    signal key5_sigin    : std_logic_vector(15 downto 0);
    signal key6_sigin    : std_logic_vector(15 downto 0);

begin

    MUX1 : mux2x1
        port map (
            S  => sel,
            D0 => X_1,
            D1 => trafo1_sigin,
            O  => round1_sigin
        );

    MUX2 : mux2x1
        port map (
            S  => sel,
            D0 => X_2,
            D1 => trafo2_sigin,
            O  => round2_sigin
        );

    MUX3 : mux2x1
        port map (
            S  => sel,
            D0 => X_3,
            D1 => trafo3_sigin,
            O  => round3_sigin
        );

    MUX4 : mux2x1
        port map (
            S  => sel,
            D0 => X_4,
            D1 => trafo4_sigin,
            O  => round4_sigin
        );

    REG1 : register16
        port map (
            clock  => CLOCK,
            enable => en,
            D      => round1_sigout,
            Q      => trafo1_sigin
        );

    REG2 : register16
        port map (
            clock  => CLOCK,
            enable => en,
            D      => round2_sigout,
            Q      => trafo2_sigin
        );

    REG3 : register16
        port map (
            clock  => CLOCK,
            enable => en,
            D      => round3_sigout,
            Q      => trafo3_sigin
        );

    REG4 : register16
        port map (
            clock  => CLOCK,
            enable => en,
            D      => round4_sigout,
            Q      => trafo4_sigin
        );

    U_CTRL : control
        port map (
            CLK   => CLOCK,
            START => START,
            ROUND => round_counter,
            READY => READY,
            EN    => en,
            S     => sel
        );

    U_ROUND : round
        port map (
            X1 => round1_sigin,
            X2 => round2_sigin,
            X3 => round3_sigin,
            X4 => round4_sigin,
            Z1 => key1_sigin,
            Z2 => key2_sigin,
            Z3 => key3_sigin,
            Z4 => key4_sigin,
            Z5 => key5_sigin,
            Z6 => key6_sigin,
            Y1 => round1_sigout,
            Y2 => round2_sigout,
            Y3 => round3_sigout,
            Y4 => round4_sigout
        );

    U_TRAFO : trafo
        port map (
            X1 => trafo1_sigin,
            X2 => trafo2_sigin,
            X3 => trafo3_sigin,
            X4 => trafo4_sigin,
            Z1 => key1_sigin,
            Z2 => key2_sigin,
            Z3 => key3_sigin,
            Z4 => key4_sigin,
            Y1 => Y_1,
            Y2 => Y_2,
            Y3 => Y_3,
            Y4 => Y_4
        );

    U_KEYGEN : keygenerator
        port map (
            key           => KEY,
            round_counter => round_counter,
            key1          => key1_sigin,
            key2          => key2_sigin,
            key3          => key3_sigin,
            key4          => key4_sigin,
            key5          => key5_sigin,
            key6          => key6_sigin
        );

end architecture Structural;

