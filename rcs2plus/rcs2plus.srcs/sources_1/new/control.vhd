----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:     
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    control - Behavioral 
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    FSM control module for rcs2plus.
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

entity control is
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
end entity control;

architecture behavioral of control is
    
    type T_STATE_UPDATED is (S0_RCS2, S2_RCS2, S4_RCS2, S6_RCS2, S7_RCS2);
    signal current_state : T_STATE_UPDATED := S7_RCS2;
    signal next_state    : T_STATE_UPDATED := S7_RCS2;

begin

    -- State memory (Sequential)
    P_CURRENT_STATE : process (CLK) is
    begin 
        if rising_edge(CLK) then
            current_state <= next_state;
        end if;
    end process P_CURRENT_STATE;

    -- Next state logic (Combinational)
    P_NEXT_STATE : process (current_state, INIT, TRAFO) is
    begin 
        case current_state is
            when S7_RCS2 =>
                if (INIT = '1') then
                    next_state <= S0_RCS2;
                else 
                    next_state <= S7_RCS2;
                end if;
            when S0_RCS2 =>
                next_state <= S2_RCS2;
            when S2_RCS2 =>
                if (TRAFO = '1') then
                    next_state <= S6_RCS2;
                else
                    next_state <= S4_RCS2;
                end if;
            when S4_RCS2 =>
                next_state <= S6_RCS2;
            when S6_RCS2 =>
                next_state <= S7_RCS2;
            when others =>
                next_state <= S7_RCS2;
        end case;
    end process P_NEXT_STATE;

    -- Output logic (Combinational)
    P_OUT : process (current_state, TRAFO) is
    begin
        case current_state is
            when S0_RCS2 =>
                EN125  <= '1'; 
                EN346  <= '0'; 
                EN78   <= '0';
                RESULT <= '0';  
                S      <= "00";
                if (TRAFO = '1') then
                    S_T <= "01";
                else
                    S_T <= "00";
                end if;
            when S2_RCS2 =>
                EN125  <= '0'; 
                EN346  <= '1'; 
                EN78   <= '0';
                RESULT <= '0';  
                S      <= "01";
                if (TRAFO = '1') then
                    S_T <= "00";
                else
                    S_T <= "01";
                end if;
            when S4_RCS2 =>
                EN125  <= '0'; 
                EN346  <= '0'; 
                EN78   <= '1';
                RESULT <= '0';  
                S      <= "10";
                S_T    <= "10";
            when S6_RCS2 =>
                EN125  <= '0'; 
                EN346  <= '0'; 
                EN78   <= '0';
                RESULT <= '1';  
                S      <= "11";
                if (TRAFO = '1') then
                    S_T <= "10";
                else
                    S_T <= "11";
                end if;
            when S7_RCS2 =>
                EN125  <= '0'; 
                EN346  <= '0'; 
                EN78   <= '0';
                RESULT <= '0';  
                S      <= "11";
                if (TRAFO = '1') then
                    S_T <= "10";
                else
                    S_T <= "11";
                end if;
            when others =>
                EN125  <= '0'; 
                EN346  <= '0'; 
                EN78   <= '0';
                RESULT <= '0';  
                S      <= "00";
                S_T    <= "00";

        end case;
    end process P_OUT;

end architecture behavioral;