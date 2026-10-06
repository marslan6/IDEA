library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_keygenerator is
end tb_keygenerator;

architecture Behavioral of tb_keygenerator is

    component keygenerator is
        port (
            key           : in  std_logic_vector(127 downto 0);
            round_counter : in  std_logic_vector(3 downto 0);
            key1          : out std_logic_vector(15 downto 0);
            key2          : out std_logic_vector(15 downto 0);
            key3          : out std_logic_vector(15 downto 0);
            key4          : out std_logic_vector(15 downto 0);
            key5          : out std_logic_vector(15 downto 0);
            key6          : out std_logic_vector(15 downto 0)
        );
    end component;

    signal tb_key : std_logic_vector(127 downto 0);
    signal tb_round_counter : std_logic_vector(3 downto 0) := "0000";
    signal tb_key1, tb_key2, tb_key3, tb_key4, tb_key5, tb_key6 : std_logic_vector(15 downto 0);

begin

    DUT_KEYGEN : keygenerator
        port map (
            key           => tb_key,
            round_counter => tb_round_counter,
            key1          => tb_key1,
            key2          => tb_key2,
            key3          => tb_key3,
            key4          => tb_key4,
            key5          => tb_key5,
            key6          => tb_key6
        );

    P_STIMULUS : process
    begin
    
        tb_key <= x"00010002000300040005000600070008";
        for i in 0 to 8 loop
            tb_round_counter <= std_logic_vector(to_unsigned(i, 4));
            wait for 20 ns;
        end loop;
        
        assert (false) report "KEY GENERATOR TEST COMPLETE. Inspect waveform for partial keys." severity note;
        wait;
    end process P_STIMULUS;

end Behavioral;
