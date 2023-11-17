library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Including the constants and types package
use work.constants_and_types.all;

entity vending_machine is
    Port (
        clk             : in STD_LOGIC;  -- System clock
        reset           : in STD_LOGIC;  -- System reset
        switches        : in STD_LOGIC_VECTOR (7 downto 0); -- Snack selection switches and cash selection
        btn1            : in STD_LOGIC;  -- Button for cash payment
        btn2            : in STD_LOGIC;  -- Button for card payment
        btn_pay         : in STD_LOGIC;  -- Button to confirm payment
        -- amount_entered  : in T_Amount;   -- Amount entered for cash payment
        segments        : out T_Seven_Segment_Display -- 6x7-segment display outputs
    );
end vending_machine;

architecture Behavioral of vending_machine is

    -- Component Declarations
    component snack_selector
        Port (
            switches       : in STD_LOGIC_VECTOR (3 downto 0);
            snack_number   : out T_Snack_Number;
            valid_choice   : out STD_LOGIC
        );
    end component;

    component payment_processor
        Port (
            payment_mode   : in STD_LOGIC; 
            amount_entered : in T_Amount;
            price          : in T_Price;
            pay_signal     : in STD_LOGIC;
            change_given   : out STD_LOGIC;
            payment_valid  : out STD_LOGIC;
            change         : out T_Change
        );
    end component;

    component price_display
        Port (
            snack_choice   : in T_Snack_Number;
            price_output   : out T_Price
        );
    end component;

    component state_machine
        Port (
            clk            : in STD_LOGIC;
            reset          : in STD_LOGIC;
            snack_choice   : in T_Snack_Number;
            valid_choice   : in STD_LOGIC;
            payment_mode   : in STD_LOGIC;
            payment_done   : in STD_LOGIC;
            change_given   : in STD_LOGIC;
            current_state  : out T_State
        );
    end component;

    component display_controller
        Port (
            clk            : in STD_LOGIC;
            reset          : in STD_LOGIC;
            current_state  : in T_State;
            snack_choice   : in T_Snack_Number;
            snack_price    : in T_Price;
            cash_inserted  : in T_Amount;
            change_to_give : in T_Change;
            segments       : out T_Seven_Segment_Display
        );
    end component;

    -- Signals for inter-component communication
    signal snack_number      : T_Snack_Number;
    signal valid_choice      : STD_LOGIC;
    signal price             : T_Price;
    signal current_state     : T_State;
	 SIGNAL cash_entered      : T_Amount;
    signal payment_mode      : STD_LOGIC;
    signal pay_signal        : STD_LOGIC;
    signal payment_valid     : STD_LOGIC;
    signal change            : T_Change;
    signal change_given      : STD_LOGIC;

begin

    -- Component Instantiations
    snack_selector_inst : snack_selector
        port map (
            switches     => switches(3 downto 0),
            snack_number => snack_number,
            valid_choice => valid_choice
        );

    price_display_inst : price_display
        port map (
            snack_choice => snack_number,
            price_output => price
        );

        -- Logic for determining payment mode
    process(clk, reset, btn1, btn2)
    begin
        if reset = '1' then
            payment_mode <= '0'; -- Default to cash payment
        elsif rising_edge(clk) then
            if btn1 = '1' then
                payment_mode <= '0'; -- Cash payment
            elsif btn2 = '1' then
                payment_mode <= '1'; -- Card payment
            end if;
        end if;
    end process;
	 
	 -- Switches to actual number
	 process(clk)
    begin
        if rising_edge(clk) then
            -- Assign the value from switches 7-4 to cash_entered
            cash_entered <= T_Amount(to_integer(unsigned(switches(7 downto 4))));
        end if;
    end process;

    -- Logic to generate payment confirmation signal
    process(clk, reset, btn_pay)
    begin
        if reset = '1' then
            pay_signal <= '0';
        elsif rising_edge(clk) then
            pay_signal <= btn_pay;
        end if;
    end process;

    payment_processor_inst : payment_processor
        port map (
            payment_mode   => payment_mode,
            amount_entered => cash_entered,
            price          => price,
            pay_signal     => pay_signal,
            change_given   => change_given,
            payment_valid  => payment_valid,
            change         => change
        );

    state_machine_inst : state_machine
        port map (
            clk            => clk,
            reset          => reset,
            snack_choice   => snack_number,
            valid_choice   => valid_choice,
            payment_mode   => payment_mode,
            payment_done   => payment_valid,
            change_given   => change_given,
            current_state  => current_state
        );

    display_controller_inst : display_controller
        port map (
            clk            => clk,
            reset          => reset,
            current_state  => current_state,
            snack_choice   => snack_number,
            snack_price    => price,
            cash_inserted  => cash_entered,
            change_to_give => change,
            segments       => segments
        );

end Behavioral;


