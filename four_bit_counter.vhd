----------------------------------------------------------------------------------
-- Company:  University of Canterbury
-- Authors: Pengcheng Liu (49791816)
--          Nate Brown (72825915)
--          Thomas Wang (65193909)
-- 
-- Create Date: 06.03.2020 12:17:23
-- Module Name: four_bit_counter - Behavioral
-- Description:  A four bit counter to control the number goes to one of the 8 displays
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



ENTITY four_bit_counter IS		-- four bit counter is one of a series of 8 iterations of the same component which are all used to count the time that passes for the reaction time, and act as a decade counter
    PORT ( 
		Clk_input : IN STD_LOGIC;						-- Clk_input is value of the the 1 kHz clock signal, but on subsuquent iterations of this component becomes the carry out of the previous adder
		state : IN std_logic_vector(1 downto 0);		-- State is connected to the output of the central Finite state machine
		adder_out : OUT STD_LOGIC_VECTOR(3 downto 0);	-- Adder_out is current value of the 4 bit adder, in subsuquent iterations of this component this represents value of its "decade" 
		Clk_out: OUT std_logic							-- clk_out is the carry out of the adder, this will pass through to the next adder, this works as a type of 1:10 clock devider
    );
	
END four_bit_counter;

ARCHITECTURE Behavioral OF four_bit_counter IS		

SIGNAL adder_count : std_logic_vector(3 downto 0) := "0000";		-- adder_count is used to increment the counter over time

    
BEGIN
    ADDER: PROCESS (Clk_input, state)
	
	BEGIN
	IF state = "00" THEN     -- if the state of the central FSM is equal to "00" then
	       adder_count <= "1011";	-- adder_count becomes "1011" this will set the display to turn off
	       clk_out <= '0';		-- don't carry this out
	       
	ELSE 
	    IF state = "10" THEN   -- it the state of the central FSM is equal to "10" then
	       adder_count <= adder_count;		-- adder_count becomes equal to adder_count
	       clk_out <= '0'; 					-- don't carry out, this pauses the counting sequence
        ELSIF state = "01" and rising_edge(Clk_input) THEN     	-- else, on the rising edge of the clock
			IF adder_count = "1011" THEN						-- if the adder was equal to "1011" in other words, the start sequence had been running...
                adder_count <= "0001";							-- then set adder_count equal to 1
                clk_out <= '0';									-- don't carry this out
			ELSIF adder_count = "1001" THEN						-- else if adder out is equal to "1001" or '9', then 
	           adder_count <= "0000";							-- set it back to zero, and carry out '1'
	           Clk_out <= '1';
			ELSE 
	           adder_count <= adder_count + "0001";				-- else increment value of the adder
	           Clk_out <= '0';									-- and don't carry out
	       END IF;
	    END IF;
	END IF;
	
	END PROCESS ADDER;
	
	adder_out <= adder_count;					-- ser adder_out to adder_count

END Behavioral;
