library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.constants_and_types.all;

entity vending_machine_tb is
end vending_machine_tb;

architecture Behavioral of vending_machine_tb is
    -- Signal declarations
    signal tb_clk          : STD_LOGIC := '0';
    signal tb_reset        : STD_LOGIC := '1';
    signal tb_switches     : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal tb_btn1         : STD_LOGIC := '0';
    signal tb_btn2         : STD_LOGIC := '0';
    signal tb_btn_pay      : STD_LOGIC := '0';
    signal tb_segments     : T_Seven_Segment_Display;

    -- Component instantiation of vending_machine
    component vending_machine
        Port (
            clk             : in STD_LOGIC;
            reset           : in STD_LOGIC;
            switches        : in STD_LOGIC_VECTOR (7 downto 0);
            btn1            : in STD_LOGIC;
            btn2            : in STD_LOGIC;
            btn_pay         : in STD_LOGIC;
            segments        : out T_Seven_Segment_Display
        );
    end component;

    begin
    uut: vending_machine
        port map (
            clk             => tb_clk,
            reset           => tb_reset,
            switches        => tb_switches,
            btn1            => tb_btn1,
            btn2            => tb_btn2,
            btn_pay         => tb_btn_pay,
            segments        => tb_segments
        );

    -- Clock process (50 MHz clock)
    clk_process: process
    begin
        tb_clk <= '0';
        wait for 10 ns;  
        tb_clk <= '1';
        wait for 10 ns;  
    end process;

    -- Test process
    test_process: process
    begin
        -- Initialize
        tb_reset <= '0';
        wait for 100 ns; 
        tb_reset <= '1';

         -- Selecting a snack and paying with cash
    tb_switches <= "00000001"; 
    wait for 50 ns;
    tb_btn1 <= '1'; 
    wait for 50 ns;
    tb_btn_pay <= '1'; 
    wait for 50 ns;
    tb_btn_pay <= '0'; 
    wait for 50 ns;
	 

    -- Selecting a snack and paying with card
    tb_switches <= "00000010"; 
    wait for 50 ns;
    tb_btn2 <= '0'; 
    wait for 50 ns;
    tb_btn_pay <= '0'; 
    wait for 50 ns;
    tb_btn_pay <= '1'; 
    wait for 50 ns;
	 
	 tb_reset <= '0';
        wait for 100 ns;  -- Wait for reset
        tb_reset <= '1';


    -- Testing invalid snack selection
    tb_switches <= "00001101"; 
    wait for 50 ns;
    tb_switches <= (others => '0');
    wait for 50 ns;

    -- Test case for snack selection and then canceling the selection
    tb_switches <= "00000100"; 
    wait for 50 ns;
    tb_switches <= (others => '0');
    wait for 50 ns;

    -- Test case for attempting to pay without selection
    tb_btn_pay <= '0';
    wait for 50 ns;
    tb_btn_pay <= '1';
    wait for 50 ns;
	 
	 tb_reset <= '0';
    wait for 100 ns;
    tb_reset <= '1';
	 
	  -- Selecting a snack and cancelling before payment
    tb_switches <= "00000011";
    wait for 50 ns;
    tb_switches <= (others => '0');
    wait for 50 ns;
	 
	 tb_reset <= '0';
    wait for 100 ns;
    tb_reset <= '1';

    -- Attempting to pay with insufficient cash
    tb_switches <= "00000010";
    wait for 50 ns;
    tb_switches(7 downto 4) <= "0010";
    wait for 50 ns;
    tb_btn1 <= '1'; 
    wait for 50 ns;
    tb_btn_pay <= '0';
    wait for 50 ns;
    tb_btn_pay <= '1';
    wait for 50 ns;
	 
	 tb_reset <= '0';
    wait for 100 ns;
    tb_reset <= '1';

    -- Paying with cash and receiving change
    tb_switches <= "00000001";
    wait for 50 ns;
    tb_switches(7 downto 4) <= "1111";
    wait for 50 ns;
    tb_btn1 <= '0';
    wait for 50 ns;
    tb_btn_pay <= '0';
    wait for 50 ns;
    tb_btn_pay <= '1';
    wait for 50 ns;
	 
	 tb_reset <= '0';
    wait for 100 ns;
    tb_reset <= '1';

    -- Handling an error state and recovering
    tb_switches <= "00001101";
    wait for 50 ns;
    tb_switches <= "00000001";
    wait for 50 ns;
	 
	 tb_reset <= '0';
    wait for 100 ns;
    tb_reset <= '1';

    -- Rapid consecutive snack selections
    tb_switches <= "00000001";
    wait for 20 ns;
    tb_switches <= "00000010";
    wait for 20 ns;
    tb_switches <= "00000100";
    wait for 20 ns;
    tb_switches <= (others => '0');
    wait for 50 ns;
	 
	 tb_reset <= '0';
    wait for 100 ns;
    tb_reset <= '1';

        wait;
    end process;
end Behavioral;