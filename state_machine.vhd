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
		  no_choice       : in STD_LOGIC;
        payment_cash    : in STD_LOGIC; -- Signal for card(1) payment
		  payment_card    : in STD_LOGIC; -- Signal for cash(1) payment
		  
        payment_done    : in STD_LOGIC; -- Signal indicating payment is done
		  
        change_given    : in STD_LOGIC; -- Signal indicating change has been given
        current_state   : out T_State -- Output current state of the machine
    );
end state_machine;

architecture Behavioral of state_machine is
    signal internal_state : T_State := ST_WAITING; -- Internal state signal
	 signal counter : natural := 0;
begin
    -- Process to handle state transitions
    process(clk, reset)
    begin
        if reset = '0' then
            internal_state <= ST_WAITING;
        elsif rising_edge(clk) then
            case internal_state is
                when ST_WAITING =>
                    if no_choice = '0' then
                        internal_state <= ST_CHOOSING_SNACK;
                    end if;

                when ST_CHOOSING_SNACK =>
							counter <= 0;
                    if valid_choice = '0' then
                        internal_state <= ST_ERROR;
                    elsif no_choice = '1' then
                        internal_state <= ST_WAITING;
                    elsif payment_cash = '1' then
                        internal_state <= ST_PAYING_CASH;
                    elsif payment_card = '1' then
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
							if counter > PROCESSING_DELAY then
                        internal_state <= ST_GETTING_SNACK;
								counter <= 0;
							else
								counter <= counter + 1;
							end if;

                when ST_GETTING_SNACK =>
							if counter > SNACK_DISPENSE_DELAY then
							  if change_given = '1' then
									internal_state <= ST_GETTING_CHANGE;
							  else
									internal_state <= ST_WAITING;
							  end if;
							else
								counter <= counter + 1;
							end if;

                when ST_GETTING_CHANGE =>
                    internal_state <= ST_WAITING;
						  
					when ST_ERROR =>
							if valid_choice = '1' then
								internal_state <= ST_WAITING;
							end if;

                when others =>
                    internal_state <= ST_ERROR;
            end case;
        end if;
    end process;

    -- Output the current state
    current_state <= internal_state;
end Behavioral;