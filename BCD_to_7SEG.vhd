library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY BCD_to_7SEG IS
	PORT ( 
		bcd_in: IN std_logic_vector (3 downto 0);	-- Input vector brings in the value of counter_out from the multiplexer
    	leds_out: OUT	std_logic_vector (1 to 8);	-- output vector turns on correct leds on the 7 segment display to light up our desired characters
    	decimal_p : IN std_logic					-- 
	);
	-- Output 7-Seg vector 
END BCD_to_7SEG;

ARCHITECTURE Behavioral of BCD_to_7SEG IS		-- Decoder for our 7 segment display

BEGIN
	my_seg_proc: PROCESS (bcd_in)		-- Enter this process whenever BCD input changes state
	BEGIN
		CASE bcd_in IS					 -- abcdefg segments
			WHEN "0000"	=> leds_out <= "00000011";	  	-- if BCD is "0000" write a zero to display
			WHEN "0001"	=> leds_out <= "10011111";	  	-- display '1'
			WHEN "0010"	=> leds_out <= "00100101";		-- display '2'
			WHEN "0011"	=> leds_out <= "00001101";		-- display '3'
			WHEN "0100"	=> leds_out <= "10011001";		-- display '4'
			WHEN "0101"	=> leds_out <= "01001001";		-- display '5'
			WHEN "0110"	=> leds_out <= "11000001";		-- display '6'
			WHEN "0111"	=> leds_out <= "00011111";		-- display '7'
			WHEN "1000"	=> leds_out <= "00000001";		-- display '8'
			WHEN "1001"	=> leds_out <= "00011001";		-- display '9'
			WHEN "1010" => leds_out <= "11111110";		-- display '.'
			WHEN "1011" => leds_out <= "11111111";		-- display OFF
			WHEN OTHERS => leds_out <= "--------";
		END CASE;
	END PROCESS my_seg_proc;

END Behavioral;