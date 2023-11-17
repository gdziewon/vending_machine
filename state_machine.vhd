library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Including the constants and types package
use work.constants_and_types.all;

entity state_machine is
    Port (
        clk             : in STD_LOGIC; -- System clock
        reset           : in STD_LOGIC; -- System reset
        snack_choice    : in T_Snack_Number; -- Input from snack selector
		  valid_choice    : in STD_LOGIC; -- Indicates if choice is valid from payment_processor
        payment_mode    : in STD_LOGIC; -- Signal for card(1) or cash(0) payment
		  
        payment_done    : in STD_LOGIC; -- Signal indicating payment is done
		  
        change_given    : in STD_LOGIC; -- Signal indicating change has been given
        current_state   : out T_State -- Output current state of the machine
    );
end state_machine;

architecture Behavioral of state_machine is
    signal internal_state : T_State := ST_WAITING; -- Internal state signal
begin
    -- Process to handle state transitions
    process(clk, reset)
    begin
        if reset = '1' then
            internal_state <= ST_WAITING;
        elsif rising_edge(clk) then
            case internal_state is
                when ST_WAITING =>
                    if snack_choice /= 0 then
                        internal_state <= ST_CHOOSING_SNACK;
                    end if;

                when ST_CHOOSING_SNACK =>
                    if valid_choice = '0' then
                        internal_state <= ST_ERROR;
                    elsif snack_choice = 0 then
                        internal_state <= ST_WAITING;
                    elsif payment_mode = '0' then
                        internal_state <= ST_PAYING_CASH;
                    elsif payment_mode = '1' then
                        internal_state <= ST_PAYING_CARD;
                    end if;

                when ST_PAYING_CASH =>
                    if payment_done = '1' then
                        internal_state <= ST_GETTING_SNACK;
                    end if;

                when ST_PAYING_CARD =>
							if payment_done = '1' then
                    internal_state <= ST_PROCESSING;
						  end if;

                when ST_PROCESSING =>
                        internal_state <= ST_GETTING_SNACK;

                when ST_GETTING_SNACK =>
                    if change_given = '1' then
                        internal_state <= ST_GETTING_CHANGE;
                    else
                        internal_state <= ST_WAITING;
                    end if;

                when ST_GETTING_CHANGE =>
                    internal_state <= ST_WAITING;
						  
					when ST_ERROR =>
							if valid_choice = '1' then
								internal_state <= ST_CHOOSING_SNACK;
							end if;

                when others =>
                    internal_state <= ST_ERROR;
            end case;
        end if;
    end process;

    -- Output the current state
    current_state <= internal_state;
end Behavioral;
