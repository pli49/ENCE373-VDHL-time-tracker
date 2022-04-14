----------------------------------------------------------------------------------
-- Company:  University of Canterbury
-- Authors: Pengcheng Liu (49791816)
--          Nate Brown (72825915)
--          Thomas Wang (65193909)
-- 
-- Create Date: 06.03.2020 12:17:23
-- Module Name: multiplexer - Behavioral
-- Description:  A multiplexer to control which sigment of the 8 sigments is displaying
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



ENTITY multiplexer IS
    PORT (
        mux_in : IN std_logic_vector(2 downto 0);			-- Multiplexer select input, tells us what anode is selected.
		start_in : IN std_logic_vector(2 downto 0);			-- Multiplexer select input from the start sequence. lets us know what anode we are writing the decimal points too
		State_fsm : IN std_logic_vector (1 downto 0);		-- Receives the current state from the Finite State Machine
        counter_1 : IN std_logic_vector(3 downto 0);		-- Input registers counters 1 to 8 store the 4 bit counter number for each 7 segment display
        counter_2 : IN std_logic_vector(3 downto 0);
        counter_3 : IN std_logic_vector(3 downto 0);
        counter_4 : IN std_logic_vector(3 downto 0);
        counter_5 : IN std_logic_vector(3 downto 0);
        counter_6 : IN std_logic_vector(3 downto 0);
        counter_7 : IN std_logic_vector(3 downto 0);
        counter_8 : IN std_logic_vector(3 downto 0);
        decimal_p_out : OUT std_logic;
        AN_out : OUT std_logic_vector(7 downto 0);			-- An_out selects the 7 segment anode we wish to write our character to.
        counter_out : OUT std_logic_vector(3 downto 0)		-- Counter_out carries our current character out to the 7 segment display to be displayed
    );
            
END multiplexer;

ARCHITECTURE Behavioral OF multiplexer IS		-- ARCHITECTURE of our multiplexer

SIGNAL Anode : std_logic_vector(7 downto 0);		-- signal Anode carries the value of AN_out

BEGIN

    AN_out <= Anode;		-- make AN_out equal to the value of Anode

    my_AN_mux: PROCESS(mux_in)		-- multiplexer process, uses mux_in in the sensitivity list.
        BEGIN
			CASE mux_in IS
				WHEN "000" =>  
				    IF start_in = "000" and State_fsm = "00" THEN		-- when start sequence is on its first state and the state of the final state machine
				        Anode <= "11111000";							-- is equal to the start sequence state then display a decimal point on the first three anodes
				        counter_out <= "1010";							-- the number "1010" causes the seven segment display to display only a decimal point
				    ELSE
				        Anode <= "11111110";							-- else only turn on the first anode
				        counter_out <= counter_1;						-- set counter out to the value of our first counter, on the first anode
				    END IF;
				    
				WHEN "001" => 
				    IF start_in = "001" and State_fsm = "00" THEN		-- when the start sequence is on its second state and the finite state machine is equal to the 
				        Anode <= "11111100";							-- start sequence state, then display only a decimal point on the first two anodes
				        counter_out <= "1010";
				    ELSE 
				        counter_out <= counter_2;						-- else set the value of the counter_out to the value of our the second counter and
				        Anode <= "11111101";							-- display this on the second anode
				    END IF;
				    
				WHEN "010" =>  
				    IF start_in = "010" and State_fsm = "00" THEN		-- when the start sequence is on its third state and the finite state machine is equal to the 
				        Anode <= "11111110";							-- start sequence state, then display only a decimal point on the first anode
				        counter_out <= "1010";
				    ELSE
				        counter_out <= counter_3;						-- else display the value of our third counter on the third anode
				        Anode <= "11111011";
				    END IF;
				    
				WHEN "011" => 
				    IF start_in = "00" and State_fsm = "00" THEN		-- during the start sequence state, display nothing on any anode during this cycle
				        Anode <= "11111111";		
				        counter_out <= "1011";							-- counter_out = "1011" sets the 7 segment display to off
				    ELSE 
				        Anode <= "11110111";
				        counter_out <= counter_4;						-- else display the value of our fourth counter on the forth anode
				    END IF;
				    
				WHEN "100" => 
				    IF start_in = "00" and State_fsm = "00" THEN		-- during the start sequence state, display nothing on any anode during this cycle
				        Anode <= "11111111";
				        counter_out <= "1011";							-- counter_out = "1011" sets the 7 segment display to off
				    ELSE 
				        Anode <= "11101111";
				        counter_out <= counter_5;						-- else display the value of our fith counter on the fith anode
				    END IF;
				    
				WHEN "101" =>  
				    IF start_in = "00" and State_fsm = "00" THEN		-- during the start sequence state, display nothing on any anode during this cycle
				        Anode <= "11111111";
				        counter_out <= "1011";							-- counter_out = "1011" sets the 7 segment display to off
				    ELSE
				        Anode <= "11011111";				        
				        counter_out <= counter_6;						-- else display the value of our sixth counter on the sixth anode
				    END IF;
				    
				WHEN "110" => 
				    IF start_in = "00" and State_fsm = "00" THEN		-- during the start sequence state, display nothing on any anode during this cycle
				        Anode <= "11111111";
				        counter_out <= "1011";							-- counter_out = "1011" sets the 7 segment display to off
				    ELSE 
				        Anode <= "10111111";				        
				        counter_out <= counter_7;						-- else display the value of our seventh counter on the seventh anode
				    END IF;
				    
				WHEN "111" => Anode <= "01111111"; 
				    IF start_in = "00" and State_fsm = "00" THEN		-- during the start sequence state, display nothing on any anode during this cycle
				        Anode <= "11111111";
				        counter_out <= "1011";							-- counter_out = "1011" sets the 7 segment display to off
				    ELSE
				        Anode <= "01111111";				        
				        counter_out <= counter_8;						-- else display the value of our eighth counter on the eighth anode
				    END IF;
			END CASE;
    END PROCESS my_AN_mux;		-- end the multiplexer process
				
END Behavioral;
