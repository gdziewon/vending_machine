library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- For arithmetic operations

-- Including the constants and types package
use work.constants_and_types.all;

entity price_display is
    Port (
        snack_choice : in T_Snack_Number; -- Input snack number
        price_output : out T_Price -- Output price for the selected snack
    );
end price_display;

architecture Behavioral of price_display is
begin
    -- Process to determine the price based on the snack choice
    process(snack_choice)
    begin
				price_output <= SNACK_PRICES(snack_choice);
    end process;
end Behavioral;
