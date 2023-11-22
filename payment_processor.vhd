library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Import the package with constants and types
use work.constants_and_types.ALL;

-- Payment Processor Module
entity payment_processor is
    Port (
        payment_cash   : in STD_LOGIC; -- '1' for cash
		  payment_card   : in STD_LOGIC; -- '1' for card
        amount_entered : in T_Amount; -- Amount entered for cash payment
        price          : in T_Price; -- Price of the selected snack
		  
		  pay_signal     : in STD_LOGIC; -- If button to pay is pressed
		  
		  change_given   : out STD_LOGIC; -- Indicates if change is more then 0
        payment_valid  : out STD_LOGIC; -- '1' if payment is valid, '0' otherwise
        change         : out T_Change -- Change to be given for cash payments
    );
end payment_processor;

architecture Behavioral of payment_processor is
begin
    -- Process to determine if payment is valid and to calculate change
    process(payment_cash, payment_card, amount_entered, price)
		variable int_change : integer;
    begin
        -- Reset output signals
        payment_valid <= '0';
        change <= 0;
		  change_given <= '0';

        if payment_cash = '1' then -- Cash payment
            if integer(amount_entered) >= integer(price) then
					 if pay_signal = '1' then
						payment_valid <= '1';
						int_change := integer(amount_entered) - integer(price);
						if int_change = 0 then
							change_given <= '0';
						else
							change_given <= '1';
						end if;
						
						change <= T_Change(int_change);
					end if;
            end if;
        elsif payment_card = '1' then -- Card payment
				if pay_signal = '1' then
					payment_valid <= '1'; -- Assume card payment is always valid
					change <= 0;
					change_given <= '0';
				end if;
        end if;
    end process;
end Behavioral;
