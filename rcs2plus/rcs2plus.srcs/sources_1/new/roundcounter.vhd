----------------------------------------------------------------------------------
-- Company:        TUM School of Computation, Information and Technology
-- Engineer:       MEHMET ARSLAN
-- Account:        go75noj
-- E-MAIL:         mehmet.arslan@tum.de
-- Create Date:     
-- Design Name:    IDEA Encryption Algorithm
-- Module Name:    roundcounter - Behavioral 
-- Project Name:   IDEA Encryption Algorithm
-- Target Devices: Xilinx Spartan-3E (XC3S500E-FG320)
-- Tool versions:  Xilinx ISE WebPack
-- Description:    Round counter module for rcs2plus.
--
-- Dependencies:   IEEE.STD_LOGIC_1164.ALL, IEEE.NUMERIC_STD.ALL
--
-- Revision: 
-- Revision 0.04 - Replaced round_reg with ROUND_INT (unsigned) for arithmetic incrementing.
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity roundcounter is
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
end entity roundcounter;

architecture behavioral of roundcounter is

    -- FSM state definitions
    type T_STATE is (SLEEP, SETUP, CALC);
    signal current_state : T_STATE := SLEEP;
    signal next_state    : T_STATE := SLEEP;

    -- Internal round counter register
    signal ROUND_INT : unsigned(3 downto 0) := "1000";

begin

    -- FSM state register process
    P_STATE_REG : process (CLK) is
    begin
        if rising_edge(CLK) then
            current_state <= next_state;
        end if;
    end process P_STATE_REG;

    -- FSM next-state combinational logic
    -- Note to self:
    -- A process sensitivity list must include
    -- every signal read inside the process.
    P_NEXT_STATE : process (current_state, START, RESULT, ROUND_INT) is
    begin
        case current_state is
            when SLEEP =>
                if (START = '1') then
                    next_state <= SETUP;
                else
                    next_state <= SLEEP;
                end if;
                
            when SETUP =>
                next_state <= CALC;
                
            when CALC =>
                if (RESULT = '1') then
                    if (ROUND_INT = "1000") then
                        next_state <= SLEEP;
                    else
                        next_state <= SETUP;
                    end if;
                else
                    next_state <= CALC;
                end if;
                
            when others =>
                next_state <= SLEEP;
        end case;
    end process P_NEXT_STATE;

    -- FSM output assignments
    P_OUT : process (current_state)
    begin 
        case current_state is
            when SLEEP => 
                INIT <= '0';
                READY <= '1';
            when SETUP => 
                INIT <= '1';
                READY <= '0';
            when CALC => 
                INIT <= '0';
                READY <= '0';
            when others =>
                INIT <= '0';
                READY <= '1';
        end case;
    end process P_OUT;

    -- Separate round counter register process
    P_COUNTER : process (CLK)
    begin
        if rising_edge(CLK) then
            if ROUND_INT = "1000" then
                if START = '1' then
                    ROUND_INT <= "0000";
                else
                    ROUND_INT <= "1000";      -- hold, regardless of whether RESULT is 0 or 1
                end if;
            else
                if RESULT = '1' then
                    -- Eight rounds plus one transformation.
                    -- ROUND_INT increments when a round
                    -- operation completes in the CALC state.
                    ROUND_INT <= ROUND_INT + 1; 
                else
                    ROUND_INT <= ROUND_INT;   -- hold
                end if;
            end if;
        end if;
    end process P_COUNTER;

    -- Output signal assignments
    ROUND <= std_logic_vector(ROUND_INT);
    -- TRAFO: active '1' during output transformation round 8 (MSB of ROUND_INT)
    TRAFO <= ROUND_INT(3);
    -- S_i: select the external input ('1') for ROUND_INT == "0000"
    S_i   <= '1' when (ROUND_INT = "0000") else '0';

end architecture behavioral;
