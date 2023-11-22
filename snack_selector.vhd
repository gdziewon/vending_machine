library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Import the package with constants and types
use work.constants_and_types.ALL;

-- Snack Selector Module
entity snack_selector is
    Port (
        switches : in STD_LOGIC_VECTOR (3 downto 0); -- 4 switches for snack selection
        snack_number : out T_Snack_Number;           -- Output snack number
        valid_choice : out STD_LOGIC                 -- Indicates if choice is valid
    );
end snack_selector;

architecture Behavioral of snack_selector is
    
begin
    -- Process to translate switch positions into a snack number and validate the choice
    process(switches)
		variable v_snack_number : T_Snack_Number; -- Intermediate variable to hold the snack number
    begin
        -- Convert binary switches input to an integer for snack number
        v_snack_number := T_Snack_Number(to_integer(unsigned(switches)));
		  -- Check if the snack number is within the valid range
        if integer(v_snack_number) <= MAX_SNACK_NUMBER - 1 then
            valid_choice <= '1'; -- Valid snack number
        else
            valid_choice <= '0'; -- Invalid snack number
        end if;
		  
        snack_number <= v_snack_number;
    end process;
end Behavioral;
