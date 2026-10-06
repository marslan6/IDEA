----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:    03.05.2026
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    control - Behavioral
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    Control unit for the register-controlled structure of the
--                 IDEA processor (RCS1).
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

entity control is
    port (
        CLK   : in    std_logic;
        START : in    std_logic;
        ROUND : out   std_logic_vector(3 downto 0);
        READY : out   std_logic;
        EN    : out   std_logic;
        S     : out   std_logic
    );
end entity control;

architecture Behavioral of control is

    type T_STATE is (SIDLE, S0, S1, S2, S3, S4, S5, S6, S7, STRAFO);
    signal current_state : T_STATE := SIDLE;
    signal next_state    : T_STATE := SIDLE;

begin

    -- State memory (Sequential)
    P_CURRENT_STATE : process (CLK) is
    begin
        if rising_edge(CLK) then
            current_state <= next_state;
        end if;
    end process P_CURRENT_STATE;

    -- Next state logic (Combinational)
    P_NEXT_STATE : process (current_state, START) is
    begin
        case (current_state) is     
            when SIDLE =>
                if (START = '1') then
                    next_state <= S0;
                else 
                    next_state <= SIDLE;
                end if;
            when S0 =>
                next_state <= S1;
            when S1 =>
                next_state <= S2;
            when S2 =>
                next_state <= S3;
            when S3 =>
                next_state <= S4;
            when S4 =>
                next_state <= S5;
            when S5 =>
                next_state <= S6;
            when S6 =>
                next_state <= S7;
            when S7 =>
                next_state <= STRAFO;
            when STRAFO =>
                next_state <= SIDLE;
        end case;
    end process P_NEXT_STATE;

    -- Output logic (Combinational)
    P_OUT : process (current_state) is
    begin
        case (current_state) is
            when S0 =>
                READY <= '0';
                EN    <= '1';
                ROUND <= "0000";
                S     <= '0';
                
            when S1 =>
                READY <= '0';
                EN    <= '1';
                ROUND <= "0001";
                S     <= '1';
                
            when S2 =>
                READY <= '0';
                EN    <= '1';
                ROUND <= "0010";
                S     <= '1';
                
            when S3 =>
                READY <= '0';
                EN    <= '1';
                ROUND <= "0011";
                S     <= '1';
                
            when S4 =>
                READY <= '0';
                EN    <= '1';
                ROUND <= "0100";
                S     <= '1';
                
            when S5 =>
                READY <= '0';
                EN    <= '1';
                ROUND <= "0101";
                S     <= '1';
                
            when S6 =>
                READY <= '0';
                EN    <= '1';
                ROUND <= "0110";
                S     <= '1';
                
            when S7 =>
                READY <= '0';
                EN    <= '1';
                ROUND <= "0111";
                S     <= '1';
                
            when STRAFO =>
                READY <= '1';
                EN    <= '0';
                ROUND <= "1000";
                S     <= '1';

            when SIDLE =>
                READY <= '1';
                EN    <= '0';
                ROUND <= "1000";
                S     <= '1';

            when others =>
                READY <= '1';
                EN    <= '0';
                ROUND <= "1000";
                S     <= '1';
        end case;
    end process P_OUT;

end architecture Behavioral;
