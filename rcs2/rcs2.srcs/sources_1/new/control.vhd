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
-- Description:    FSM control module for rcs2.
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
    
    type T_STATE is (S0, S1, S2, S3, S4, S5, S6, S7);
    signal current_state : T_STATE := S7;
    signal next_state    : T_STATE := S7;

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
            when S7 =>
                if (INIT = '1') then
                    next_state <= S0;
                else 
                    next_state <= S7;
                end if;
            when S0 =>
                next_state <= S1;
            when S1 =>
                next_state <= S2;
            when S2 =>
                next_state <= S3;
            when S3 =>
                if (TRAFO = '1') then
                    next_state <= S6;
                else
                    next_state <= S4;
                end if;
            when S4 =>
                next_state <= S5;
            when S5 =>
                next_state <= S6;
            when S6 =>
                next_state <= S7;
            when others =>
                next_state <= S7;
        end case;
    end process P_NEXT_STATE;

    -- Output logic (Combinational)
    P_OUT : process (current_state, TRAFO) is
    begin
        case current_state is
            when S0 =>
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
            when S1 =>
                EN125  <= '0'; 
                EN346  <= '0'; 
                EN78   <= '0';
                RESULT <= '0';  
                S      <= "00";
                if (TRAFO = '1') then
                    S_T <= "01";
                else
                    S_T <= "00";
                end if;
            when S2 =>
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
            when S3 =>
                EN125  <= '0'; 
                EN346  <= '0'; 
                EN78   <= '0';
                RESULT <= '0';  
                S      <= "01";
                if (TRAFO = '1') then
                    S_T <= "00";
                else
                    S_T <= "01";
                end if;
            when S4 =>
                EN125  <= '0'; 
                EN346  <= '0'; 
                EN78   <= '1';
                RESULT <= '0';  
                S      <= "10";
                S_T    <= "10";
            
            when S5 =>
                EN125  <= '0'; 
                EN346  <= '0'; 
                EN78   <= '0';
                RESULT <= '0';  
                S      <= "10";
                S_T    <= "10";
                
            when S6 =>
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
               
            when S7 =>
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