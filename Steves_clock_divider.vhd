----------------------------------------------------------------------------------

--
--Reference: Steves_clock_divider from week two labs
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY my_divider IS 					-- my_divider is based off the clock devider given to us in the labs, however has been modified to have 3 clock outputs
    PORT ( 	
		Clk_in : IN  STD_LOGIC;			-- Clk_in takes in the 100MHz clock signal from the hardware
        Clk_out : OUT  STD_LOGIC;		-- outputs 1 Khz
        CLK_OUT_1 : OUT std_logic;		-- outputs 2 Hz
        CLK_OUT_2 : OUT std_logic		-- outputs 50 Hz
	);
			  
END my_divider;

ARCHITECTURE Behavioral OF my_divider IS
--
CONSTANT clk_limit_1 : std_logic_vector(27 downto 0) := X"17D783F"; -- 2 Hz output | these constants are used to compare our counter value to in order to select an apropriate output frequency
CONSTANT clk_limit : std_logic_vector(27 downto 0) := X"000C350"; -- 1 kHz   "
CONSTANT clk_limit_2 : std_logic_vector(27 downto 0) := X"01E8480"; -- 50 Hz   "

SIGNAL clk_ctr : std_logic_vector(27 downto 0);			-- these three vector signals are used in a counter to devide the clock signal by the pre-defined value of our constants
SIGNAL clk_ctr_1 : std_logic_vector(27 downto 0);
SIGNAL clk_ctr_2 : std_logic_vector(27 downto 0);
SIGNAL temp_clk : std_logic;							-- these three signals are used for the states of our output clock signals
SIGNAL temp_clk_1 : std_logic;
SIGNAL temp_clk_2 : std_logic;

BEGIN

 	clock: PROCESS (Clk_in)			-- This process devides the clock into a 1 kHz signal by way of a counter

	BEGIN
		IF Clk_in = '1' and Clk_in'Event THEN 		-- if the 100MHz clock in has a rising edge then
			IF clk_ctr = clk_limit THEN				-- check if we have counted up to the limit of our pre-defined constant yet,
				temp_clk <= not temp_clk;			-- if so, then toggle the output state
				clk_ctr <= X"0000000";				-- and reset the counter
			ELSE											
				clk_ctr <= clk_ctr + X"0000001";	-- otherwise increment the value of clk_ctr
			END IF;
		END IF;
	END PROCESS clock;

	Clk_out <= temp_clk;		-- set the output signal to the value of temp_clk;
	
    clock_2: PROCESS (Clk_in)		-- this process devides the clock into a 2 Hz signal by way of a counter

    BEGIN
        IF Clk_in = '1' and Clk_in'Event THEN
			IF clk_ctr_1 = clk_limit_1 THEN				
				temp_clk_1 <= not temp_clk_1;				
				clk_ctr_1 <= X"0000000";					
			ELSE											
				clk_ctr_1 <= clk_ctr_1 + X"0000001";	
			END IF;
        END IF;
	END PROCESS clock_2;
	
	Clk_out_1 <= temp_clk_1;
		
    clock_3: PROCESS (Clk_in)		-- this process devides the clock into a 50 Hz signal by way of a counter

    BEGIN
        IF Clk_in = '1' and Clk_in'Event THEN
			IF clk_ctr_2 = clk_limit_2 THEN				-- if counter == (1Hz count)/2
				temp_clk_2 <= not temp_clk_2;				--  toggle clock
				clk_ctr_2 <= X"0000000";					--  reset counter
			ELSE											-- else
				clk_ctr_2 <= clk_ctr_2 + X"0000001";	--  counter = counter + 1
			END IF;
        END IF;
	END PROCESS clock_3;
	
	Clk_out_2 <= temp_clk_2;

END Behavioral;

