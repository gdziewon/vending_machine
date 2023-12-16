library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Importing the package with constants and types
use work.constants_and_types.ALL;

-- Seven Segment Encoder Module
entity seven_segment_encoder is
    Port (
        bin_input : in STD_LOGIC_VECTOR (4 downto 0);
        segments : out T_Seven_Segment -- Output to a single seven-segment display
    );
end seven_segment_encoder;

architecture Behavioral of seven_segment_encoder is
begin
    -- Process to convert binary input to seven-segment display output
    process(bin_input)
    begin
        case bin_input is
            when "00000" => segments <= "0000001"; -- 0
            when "00001" => segments <= "1001111"; -- 1
            when "00010" => segments <= "0010010"; -- 2
            when "00011" => segments <= "0000110"; -- 3
            when "00100" => segments <= "1001100"; -- 4
            when "00101" => segments <= "0100100"; -- 5
            when "00110" => segments <= "0100000"; -- 6
            when "00111" => segments <= "0001111"; -- 7
            when "01000" => segments <= "0000000"; -- 8
            when "01001" => segments <= "0000100"; -- 9
            when "01010" => segments <= "0001000"; -- A
            when "01011" => segments <= "0110001"; -- C
            when "01100" => segments <= "0110000"; -- E
            when "01101" => segments <= "1111111"; -- Turn Off
            when "01110" => segments <= "0011000"; -- P
            when "01111" => segments <= "1000001"; -- U
				when "10000" => segments <= "1001000"; -- H
				when "10001" => segments <= "1111010"; -- r
				when "10010" => segments <= "1100010"; -- o
            when others => segments <= "1111111"; -- Off or invalid input
        end case;
    end process;
end Behavioral;