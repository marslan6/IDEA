----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN 
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    03.05.2026
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    idea - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    Top-level module for the IDEA Encryption Algorithm.
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

entity idea is
    port (
        KEY : in    std_logic_vector(127 downto 0);
        X_1 : in    std_logic_vector(15 downto 0);
        X_2 : in    std_logic_vector(15 downto 0);
        X_3 : in    std_logic_vector(15 downto 0);
        X_4 : in    std_logic_vector(15 downto 0);
        Y_1 : out   std_logic_vector(15 downto 0);
        Y_2 : out   std_logic_vector(15 downto 0);
        Y_3 : out   std_logic_vector(15 downto 0);
        Y_4 : out   std_logic_vector(15 downto 0)
    );
end entity idea;

architecture Structural of idea is

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

    signal y_round_1_1_o : std_logic_vector(15 downto 0);
    signal y_round_1_2_o : std_logic_vector(15 downto 0);
    signal y_round_1_3_o : std_logic_vector(15 downto 0);
    signal y_round_1_4_o : std_logic_vector(15 downto 0);

    signal y_round_2_1_o : std_logic_vector(15 downto 0);
    signal y_round_2_2_o : std_logic_vector(15 downto 0);
    signal y_round_2_3_o : std_logic_vector(15 downto 0);
    signal y_round_2_4_o : std_logic_vector(15 downto 0);

    signal y_round_3_1_o : std_logic_vector(15 downto 0);
    signal y_round_3_2_o : std_logic_vector(15 downto 0);
    signal y_round_3_3_o : std_logic_vector(15 downto 0);
    signal y_round_3_4_o : std_logic_vector(15 downto 0);

    signal y_round_4_1_o : std_logic_vector(15 downto 0);
    signal y_round_4_2_o : std_logic_vector(15 downto 0);
    signal y_round_4_3_o : std_logic_vector(15 downto 0);
    signal y_round_4_4_o : std_logic_vector(15 downto 0);

    signal y_round_5_1_o : std_logic_vector(15 downto 0);
    signal y_round_5_2_o : std_logic_vector(15 downto 0);
    signal y_round_5_3_o : std_logic_vector(15 downto 0);
    signal y_round_5_4_o : std_logic_vector(15 downto 0);

    signal y_round_6_1_o : std_logic_vector(15 downto 0);
    signal y_round_6_2_o : std_logic_vector(15 downto 0);
    signal y_round_6_3_o : std_logic_vector(15 downto 0);
    signal y_round_6_4_o : std_logic_vector(15 downto 0);

    signal y_round_7_1_o : std_logic_vector(15 downto 0);
    signal y_round_7_2_o : std_logic_vector(15 downto 0);
    signal y_round_7_3_o : std_logic_vector(15 downto 0);
    signal y_round_7_4_o : std_logic_vector(15 downto 0);

    signal y_round_8_1_o : std_logic_vector(15 downto 0);
    signal y_round_8_2_o : std_logic_vector(15 downto 0);
    signal y_round_8_3_o : std_logic_vector(15 downto 0);
    signal y_round_8_4_o : std_logic_vector(15 downto 0);

    type t_idea_keys is array (0 to 51) of std_logic_vector(15 downto 0);
    signal keys_array    : t_idea_keys;

begin

    KEY_GENERATOR : process (KEY) is

        variable key_copy : std_logic_vector(127 downto 0);
        variable pos      : integer range 0 to 52;

    begin

        key_copy := KEY;
        pos      := 0;

        for round_num in 0 to 5 loop -- 6 round in total with full cycle rotation
            keys_array(pos + 0) <= key_copy(127 downto 112);
            keys_array(pos + 1) <= key_copy(111 downto 96);
            keys_array(pos + 2) <= key_copy(95 downto 80);
            keys_array(pos + 3) <= key_copy(79 downto 64);
            keys_array(pos + 4) <= key_copy(63 downto 48);
            keys_array(pos + 5) <= key_copy(47 downto 32);
            keys_array(pos + 6) <= key_copy(31 downto 16);
            keys_array(pos + 7) <= key_copy(15 downto 0);

            pos      := pos + 8;
            key_copy := key_copy(102 downto 0) & key_copy(127 downto 103);
        end loop;

        -- Last 4 of 16(bits) keys for output transformation.
        keys_array(pos + 0) <= key_copy(127 downto 112);
        keys_array(pos + 1) <= key_copy(111 downto 96);
        keys_array(pos + 2) <= key_copy(95 downto 80);
        keys_array(pos + 3) <= key_copy(79 downto 64);

    end process KEY_GENERATOR;

    ROUND_1 : round
        port map (
            X1 => X_1,
            X2 => X_2,
            X3 => X_3,
            X4 => X_4,
            Z1 => keys_array(0),
            Z2 => keys_array(1),
            Z3 => keys_array(2),
            Z4 => keys_array(3),
            Z5 => keys_array(4),
            Z6 => keys_array(5),
            Y1 => y_round_1_1_o,
            Y2 => y_round_1_2_o,
            Y3 => y_round_1_3_o,
            Y4 => y_round_1_4_o
        );

    ROUND_2 : round
        port map (
            X1 => y_round_1_1_o,
            X2 => y_round_1_2_o,
            X3 => y_round_1_3_o,
            X4 => y_round_1_4_o,
            Z1 => keys_array(6),
            Z2 => keys_array(7),
            Z3 => keys_array(8),
            Z4 => keys_array(9),
            Z5 => keys_array(10),
            Z6 => keys_array(11),
            Y1 => y_round_2_1_o,
            Y2 => y_round_2_2_o,
            Y3 => y_round_2_3_o,
            Y4 => y_round_2_4_o
        );

    ROUND_3 : round
        port map (
            X1 => y_round_2_1_o,
            X2 => y_round_2_2_o,
            X3 => y_round_2_3_o,
            X4 => y_round_2_4_o,
            Z1 => keys_array(12),
            Z2 => keys_array(13),
            Z3 => keys_array(14),
            Z4 => keys_array(15),
            Z5 => keys_array(16),
            Z6 => keys_array(17),
            Y1 => y_round_3_1_o,
            Y2 => y_round_3_2_o,
            Y3 => y_round_3_3_o,
            Y4 => y_round_3_4_o
        );

    ROUND_4 : round
        port map (
            X1 => y_round_3_1_o,
            X2 => y_round_3_2_o,
            X3 => y_round_3_3_o,
            X4 => y_round_3_4_o,
            Z1 => keys_array(18),
            Z2 => keys_array(19),
            Z3 => keys_array(20),
            Z4 => keys_array(21),
            Z5 => keys_array(22),
            Z6 => keys_array(23),
            Y1 => y_round_4_1_o,
            Y2 => y_round_4_2_o,
            Y3 => y_round_4_3_o,
            Y4 => y_round_4_4_o
        );

    ROUND_5 : round
        port map (
            X1 => y_round_4_1_o,
            X2 => y_round_4_2_o,
            X3 => y_round_4_3_o,
            X4 => y_round_4_4_o,
            Z1 => keys_array(24),
            Z2 => keys_array(25),
            Z3 => keys_array(26),
            Z4 => keys_array(27),
            Z5 => keys_array(28),
            Z6 => keys_array(29),
            Y1 => y_round_5_1_o,
            Y2 => y_round_5_2_o,
            Y3 => y_round_5_3_o,
            Y4 => y_round_5_4_o
        );

    ROUND_6 : round
        port map (
            X1 => y_round_5_1_o,
            X2 => y_round_5_2_o,
            X3 => y_round_5_3_o,
            X4 => y_round_5_4_o,
            Z1 => keys_array(30),
            Z2 => keys_array(31),
            Z3 => keys_array(32),
            Z4 => keys_array(33),
            Z5 => keys_array(34),
            Z6 => keys_array(35),
            Y1 => y_round_6_1_o,
            Y2 => y_round_6_2_o,
            Y3 => y_round_6_3_o,
            Y4 => y_round_6_4_o
        );

    ROUND_7 : round
        port map (
            X1 => y_round_6_1_o,
            X2 => y_round_6_2_o,
            X3 => y_round_6_3_o,
            X4 => y_round_6_4_o,
            Z1 => keys_array(36),
            Z2 => keys_array(37),
            Z3 => keys_array(38),
            Z4 => keys_array(39),
            Z5 => keys_array(40),
            Z6 => keys_array(41),
            Y1 => y_round_7_1_o,
            Y2 => y_round_7_2_o,
            Y3 => y_round_7_3_o,
            Y4 => y_round_7_4_o
        );

    ROUND_8 : round
        port map (
            X1 => y_round_7_1_o,
            X2 => y_round_7_2_o,
            X3 => y_round_7_3_o,
            X4 => y_round_7_4_o,
            Z1 => keys_array(42),
            Z2 => keys_array(43),
            Z3 => keys_array(44),
            Z4 => keys_array(45),
            Z5 => keys_array(46),
            Z6 => keys_array(47),
            Y1 => y_round_8_1_o,
            Y2 => y_round_8_2_o,
            Y3 => y_round_8_3_o,
            Y4 => y_round_8_4_o
        );

    TRAFO_0 : trafo
        port map (
            X1 => y_round_8_1_o,
            X2 => y_round_8_2_o,
            X3 => y_round_8_3_o,
            X4 => y_round_8_4_o,
            Z1 => keys_array(48),
            Z2 => keys_array(49),
            Z3 => keys_array(50),
            Z4 => keys_array(51),
            Y1 => Y_1,
            Y2 => Y_2,
            Y3 => Y_3,
            Y4 => Y_4
        );

end architecture Structural;

