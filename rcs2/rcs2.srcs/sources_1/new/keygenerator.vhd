----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/13/2026 01:02:27 AM
-- Design Name: 
-- Module Name: keygenerator - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity keygenerator is
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
end keygenerator;

architecture Behavioral of keygenerator is
begin

    KEY_GENERATOR : process (key, round_counter) is
        variable r0, r1, r2, r3, r4, r5, r6 : std_logic_vector(127 downto 0);
    begin
        -- Create each round's buffer
        r0 := key;
        r1 := r0(102 downto 0) & r0(127 downto 103);
        r2 := r1(102 downto 0) & r1(127 downto 103);
        r3 := r2(102 downto 0) & r2(127 downto 103);
        r4 := r3(102 downto 0) & r3(127 downto 103);
        r5 := r4(102 downto 0) & r4(127 downto 103);
        r6 := r5(102 downto 0) & r5(127 downto 103);

        case (round_counter) is
            when "0000" => -- Round 1
                key1 <= r0(127 downto 112);
                key2 <= r0(111 downto  96);
                key3 <= r0( 95 downto  80);
                key4 <= r0( 79 downto  64);
                key5 <= r0( 63 downto  48);
                key6 <= r0( 47 downto  32);

            when "0001" => -- Round 2
                key1 <= r0( 31 downto  16);
                key2 <= r0( 15 downto   0);
                key3 <= r1(127 downto 112);
                key4 <= r1(111 downto  96);
                key5 <= r1( 95 downto  80);
                key6 <= r1( 79 downto  64);

            when "0010" => -- Round 3
                key1 <= r1( 63 downto  48);
                key2 <= r1( 47 downto  32);
                key3 <= r1( 31 downto  16);
                key4 <= r1( 15 downto   0);
                key5 <= r2(127 downto 112);
                key6 <= r2(111 downto  96);

            when "0011" => -- Round 4
                key1 <= r2( 95 downto  80);
                key2 <= r2( 79 downto  64);
                key3 <= r2( 63 downto  48);
                key4 <= r2( 47 downto  32);
                key5 <= r2( 31 downto  16);
                key6 <= r2( 15 downto   0);

            when "0100" => -- Round 5
                key1 <= r3(127 downto 112);
                key2 <= r3(111 downto  96);
                key3 <= r3( 95 downto  80);
                key4 <= r3( 79 downto  64);
                key5 <= r3( 63 downto  48);
                key6 <= r3( 47 downto  32);

            when "0101" => -- Round 6
                key1 <= r3( 31 downto  16);
                key2 <= r3( 15 downto   0);
                key3 <= r4(127 downto 112);
                key4 <= r4(111 downto  96);
                key5 <= r4( 95 downto  80);
                key6 <= r4( 79 downto  64);

            when "0110" => -- Round 7
                key1 <= r4( 63 downto  48);
                key2 <= r4( 47 downto  32);
                key3 <= r4( 31 downto  16);
                key4 <= r4( 15 downto   0);
                key5 <= r5(127 downto 112);
                key6 <= r5(111 downto  96);

            when "0111" => -- Round 8
                key1 <= r5( 95 downto  80);
                key2 <= r5( 79 downto  64);
                key3 <= r5( 63 downto  48);
                key4 <= r5( 47 downto  32);
                key5 <= r5( 31 downto  16);
                key6 <= r5( 15 downto   0);

            when "1000" => -- Output Transformation
                key1 <= r6(127 downto 112);
                key2 <= r6(111 downto  96);
                key3 <= r6( 95 downto  80);
                key4 <= r6( 79 downto  64);
                key5 <= (others => '0');
                key6 <= (others => '0');

            when others =>
                key1 <= (others => '0');
                key2 <= (others => '0');
                key3 <= (others => '0');
                key4 <= (others => '0');
                key5 <= (others => '0');
                key6 <= (others => '0');

        end case;
    end process KEY_GENERATOR;

end Behavioral;
