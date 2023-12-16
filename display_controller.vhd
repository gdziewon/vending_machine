library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Including the constants and types package
use work.constants_and_types.all;

entity display_controller is
    Port (
        clk             : in STD_LOGIC;  -- System clock
        reset           : in STD_LOGIC;  -- System reset
        current_state   : in T_State;  -- Current state from state machine
        snack_choice    : in T_Snack_Number;  -- Snack choice from snack selector
        snack_price     : in T_Price;  -- Price of the selected snack
        cash_inserted   : in T_Amount;  -- Amount of cash inserted
        change_to_give  : in T_Change;  -- Change to be given
        segments        : out T_Seven_Segment_Display -- Seven segment display output
    );
end display_controller;

architecture Behavioral of display_controller is
    -- Signal for each digit to be displayed
	 type display_data_type is array(0 to 5) of STD_LOGIC_VECTOR(4 downto 0);
    signal display_data : display_data_type;
	 signal prev_state : T_State := ST_WAITING;
	 
	 function numberToVector(number : integer) return STD_LOGIC_VECTOR is
	 begin 
		case number is
			when 1 => return "00001";
			when 2 => return "00010";
			when 3 => return "00011";
			when 4 => return "00100";
			when 5 => return "00101";
			when 6 => return "00110";
			when 7 => return "00111";
			when 8 => return "01000";
			when 9 => return "01001";
			when 0 => return "00000";
			when others => return "00000";
		end case;
		return "0000";
		end function;
			
	function resetAll(state : T_State) return T_State is
  begin
			display_data(0) <= "01101";  -- Turn off all;
         display_data(1) <= "01101";  
         display_data(2) <= "01101";  
         display_data(3) <= "01101";  
         display_data(4) <= "01101";  
         display_data(5) <= "01101";
			return state;
  end function;
begin

    -- Process to control display data based on the current state
    process(clk, reset)
    begin
        if reset = '0' then
            display_data <= (others => (others => '0'));
        elsif rising_edge(clk) then
            case current_state is
                when ST_WAITING =>
							if prev_state /= ST_WAITING then
								prev_state <= resetAll(ST_WAITING);
							end if;
                    display_data(0) <= "01011";  -- 'C'
                    display_data(1) <= "10000";  -- 'H'
                    display_data(2) <= "00000";  -- 'O'
                    display_data(3) <= "00000";  -- 'O'
                    display_data(4) <= "00101";  -- 'S'
                    display_data(5) <= "01100";  -- 'E'

                when ST_CHOOSING_SNACK =>
							if prev_state /= ST_CHOOSING_SNACK then
								prev_state <= resetAll(ST_CHOOSING_SNACK);
							end if;
                    -- Check if snack_choice is less than 10 (single digit)
							if integer(snack_choice) < 10 then
							  -- Display snack number on a single hex display (e.g., display_data(0))
							  display_data(0) <= numberToVector(integer(snack_choice));
							  display_data(1) <=  "01101";  -- Turn off the other display or display zero
							else
							  -- Display snack number on both hex displays (two digits)
							  display_data(0) <= "00001"; -- First digitinteger
							  display_data(1) <= numberToVector(integer(snack_choice) - 10); -- Second digit
							end if;
							
							display_data(2) <= "01101";-- Turn off
							display_data(3) <= "01110";-- P

							-- Display price
							if integer(snack_price) < 10 then
								display_data(4) <= numberToVector(integer(snack_price));
								display_data(5) <=  "01101";
							else
								display_data(4) <= "00001";
								display_data(5) <= numberToVector(integer(snack_price) - 10);
							end if;

                when ST_ERROR =>
							if prev_state /= ST_ERROR then
								prev_state <= resetAll(ST_ERROR);
							end if;
                    display_data(0) <= "01100";  -- 'E'
                    display_data(1) <= "10001";  -- 'r'
                    display_data(2) <= "10001";  -- 'r'
                    display_data(3) <= "10010";  -- 'o'
                    display_data(4) <= "10001";  -- 'r'
                    display_data(5) <= "01101"; -- turn off

                when ST_PAYING_CASH =>
							if prev_state /= ST_PAYING_CASH then
								prev_state <= resetAll(ST_PAYING_CASH);
							end if;
							 -- Display the amount of cash inserted
						 if integer(cash_inserted) < 10 then
							  display_data(0) <= numberToVector(integer(cash_inserted));
							  display_data(1) <= "01101";
						 else
							  display_data(0) <= "00001";
							  display_data(1) <= numberToVector(integer(cash_inserted) - 10);
						 end if;

						 display_data(2) <= "01101";  -- Turn off
						 display_data(3) <= "01110";  -- 'P'

						 -- Display snack price
						 if snack_price < 10 then
								display_data(4) <= numberToVector(integer(snack_price));
							  display_data(5) <=  "01101";  -- Turn off
							  
						 else
							  display_data(4) <= "00001"; -- First digit
							  display_data(5) <= numberToVector(integer(snack_price) - 10); -- Second digit
						 end if;

                when ST_PAYING_CARD =>
							if prev_state /= ST_PAYING_CARD then
								prev_state <= resetAll(ST_PAYING_CARD);
							end if;
						 display_data(0) <= "01101";  -- Turn off
					    display_data(1) <= "01101";  -- Turn off
					    display_data(2) <= "01101";  -- Turn off
						 display_data(3) <= "01110";  -- Display 'P'
						 display_data(4) <= "01110";  -- Display 'P'
						 display_data(5) <= "01110";  -- Display 'P'

					 when ST_PROCESSING =>
							if prev_state /= ST_PROCESSING then
								prev_state <= resetAll(ST_PROCESSING);
							end if;
						 display_data(0) <= "01101";  -- Turn off
						 display_data(1) <= "01101";  -- Turn off
						 display_data(2) <= "01010";  -- Display 'A'
						 display_data(3) <= "01011";  -- Display 'C'
						 display_data(4) <= "01110";  -- Display 'P'
						 display_data(5) <= "01101";  -- Turn off

					 when ST_GETTING_SNACK =>
							if prev_state /= ST_GETTING_SNACK then
								prev_state <= resetAll(ST_GETTING_SNACK);
							end if;
						 display_data(0) <= "01010";  -- Turn off
						 display_data(1) <= "01010";  -- Turn off
						 display_data(2) <= "01010";  -- Display 'A'
						 display_data(3) <= "01010";  -- Display 'C'
						 display_data(4) <= "01010";  -- Display 'P'
						 display_data(5) <= "01010";  -- Turn off

					 when ST_GETTING_CHANGE =>
							if prev_state /= ST_GETTING_CHANGE then
								prev_state <= resetAll(ST_GETTING_CHANGE);
							end if;
						 display_data(0) <= "01100";  -- 'C'
						 display_data(1) <= "01101";  -- Turn off
							-- Check if change_to_give is less than 10 (single digit)
						if integer(change_to_give) < 10 then
							display_data(4) <= (others => '0'); -- Turn off the other display or display zero
							display_data(5) <= numberToVector(integer(change_to_give));
						else
							display_data(4) <= "00001"; -- First digit
							display_data(5) <= numberToVector(integer(change_to_give) - 10); -- Second digit
						end if;

                when others =>
                    prev_state <= resetAll(ST_WAITING);
            end case;
        end if;
    end process;

    -- Instantiate seven segment encoders for each display
    gen_led_encoders: for i in 0 to 5 generate
        led_encoder : entity work.seven_segment_encoder
            port map (
                bin_input => display_data(i),
                segments => segments(i)
            );
    end generate gen_led_encoders;

end Behavioral;