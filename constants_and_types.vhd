library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Package declaration containing constants, types, and states used by the vending machine
package constants_and_types is

    -- Define the states of the FSM
    type T_State is (
        ST_WAITING,
        ST_CHOOSING_SNACK,
        ST_PAYING_CASH,
        ST_PAYING_CARD,
        ST_PROCESSING,
        ST_GETTING_SNACK,
        ST_GETTING_CHANGE,
        ST_ERROR
    );

    -- Signals for the output of the snack selector and the payment processor
    type T_Snack_Number is range 0 to 15; -- 4-bit range for snack number
    type T_Price is range 0 to 15; -- 8-bit range for price
    type T_Amount is range 0 to 15; -- 8-bit range for amount entered
    type T_Change is range 0 to 15; -- 8-bit range for change to be given

    -- Custom type for the seven-segment display
    type T_Seven_Segment is array(0 to 6) of STD_LOGIC; -- For a seven-segment display
    type T_Seven_Segment_Display is array(0 to 5) of T_Seven_Segment; -- For six 7-segment displays

    -- Define a specific type for the array of snack prices
    type T_Snack_Prices_Array is array(T_Snack_Number) of T_Price;

    -- Constants for the snack prices (adjust as needed)
    constant SNACK_PRICES : T_Snack_Prices_Array := (
		 0 => 10,   -- Snack 0 costs 50 units
		 1 => 12,  
		 2 => 5,  
		 3 => 3,  
		 4 => 8,  
		 5 => 10,  
		 6 => 12,  
		 7 => 6,  
		 8 => 7,   
		 9 => 4,   
		 10 => 8, 
		 11 => 9,
		 others => 0
	);
	 
	 constant MAX_SNACK_NUMBER : integer := 12;

    -- Delay constants for processing and dispensing
	 constant CHANGE_DISPLAY_DELAY : natural := 100000000; -- 2-second delay for displaying change
    constant PROCESSING_DELAY : natural := 150000000; -- 3-second processing delay
    constant SNACK_DISPENSE_DELAY : natural := 200000000; -- 4-second snack dispensing delay

end package constants_and_types;