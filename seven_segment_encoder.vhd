library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Importing the package with constants and types
use work.constants_and_types.ALL;

-- Seven Segment Encoder Module
entity seven_segment_encoder is
    Port (
        bin_input : in STD_LOGIC_VECTOR (3 downto 0);
        segments : out T_Seven_Segment -- Output to a single seven-segment display
    );
end seven_segment_encoder;

architecture Behavioral of seven_segment_encoder is
begin
    -- Process to convert binary input to seven-segment display output
    process(bin_input)
    begin
        case bin_input is
            when "0000" => segments <= "0000001"; -- 0
            when "0001" => segments <= "1001111"; -- 1
            when "0010" => segments <= "0010010"; -- 2
            when "0011" => segments <= "0000110"; -- 3
            when "0100" => segments <= "1001100"; -- 4
            when "0101" => segments <= "0100100"; -- 5
            when "0110" => segments <= "0100000"; -- 6
            when "0111" => segments <= "0001111"; -- 7
            when "1000" => segments <= "0000000"; -- 8
            when "1001" => segments <= "0000100"; -- 9
            when "1010" => segments <= "0001000"; -- A
            when "1011" => segments <= "1100000"; -- C
            when "1100" => segments <= "0110001"; -- E
            when "1101" => segments <= "1111111"; -- Turn Off
            when "1110" => segments <= "0111000"; -- P
            when "1111" => segments <= "0111010"; -- U
            when others => segments <= "1111111"; -- Off or invalid input
        end case;
    end process;
end Behavioral;
