----------------------------------------------------------------------------------
-- Company:  University of Canterbury
-- Authors: Pengcheng Liu (49791816)
--          Nate Brown (72825915)
--          Thomas Wang (65193909)
-- 
-- Create Date: 06.03.2020 12:17:23
-- Module Name: mux_counter - Behavioral
-- Description:  A multiplexer counter to control the speed of the 8 sigments that is displaying
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY mux_counter IS												-- Mux counter uses the clock edge to cause the multiplexer to cycle through its eight states
    Port ( 
		CLK_in : IN std_logic;										-- Clock input taken in from blairs clock divider, at 1kHz
        adder_out : OUT STD_LOGIC_VECTOR(2 downto 0)				-- adder_out carries a three bit signal out that increments continuously counting through states "000" to "111" every 8 clock cycles 
	);
	
END mux_counter;

ARCHITECTURE Behavioral OF mux_counter IS

    SIGNAL adder_count : std_logic_vector(2 downto 0) := "000";		-- signal adder_count is set to "000" initially 
	
BEGIN
    ADDER: PROCESS(CLK_in)							-- Process ADDER increments the value of adder_count with respect to the clock
    BEGIN
        IF rising_edge(Clk_in) THEN
			adder_count <= adder_count + "001";		-- increment the value of adder_count on every rising edge of the clock
        END IF;
    END PROCESS ADDER;
	
    adder_out <= adder_count;						-- set the value of adder_out to the current value of adder_count
	
END Behavioral;
