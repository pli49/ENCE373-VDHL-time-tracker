----------------------------------------------------------------------------------
-- Company:  University of Canterbury
-- Authors: Pengcheng Liu (49791816)
--          Nate Brown (72825915)
--          Thomas Wang (65193909)
-- 
-- Create Date: 06.03.2020 12:17:23
-- Module Name: FSM - Behavioral
-- Description:  A finite state machine to control the system when button is pushed
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY FSM IS												-- A Finite State Machine is used to cycle between the states of the program, Start sequence (A), counting (B), displaying (C) and back to Start Sequence
	PORT ( 
		Push : IN STD_LOGIC;								-- Push recieves the value of the debounced button push
        start_sequence_finished : IN std_logic;				-- Start_sequence_finished is a Flag that the Start Seqence circuit sets when the start sequence has concluded
        Start_sequence_start : OUT std_logic;				-- Start_sequence_start is a flag that resets the Start Sequence curcuit
        output : OUT STD_LOGIC_VECTOR (1 downto 0);			-- Output is a two bit vector that tells the rest of the TOP_LEVEL how to behave
        reset : IN STD_LOGIC;		-- probably get rid of this					
        clock : IN STD_LOGIC;								-- 100MHz clock input is used
        Clk_2 : IN STD_LOGIC
	);
	
END FSM;

ARCHITECTURE RTL OF FSM IS		-- ARCHITECTURE of the finite state machine cylces through three states to run the program in the desired manner. 

TYPE State_type IS (A, B, C);  	-- three states are determined, A, B, and C

SIGNAL State : State_Type;    
SIGNAL butPop : Std_logic := '0';						-- butPop is used to register when theres been a button push, it is set to 0 when the button is pushed, and set back to 1 when the button has been 'popped'
SIGNAL Start_start : std_logic := '0';					-- Start_start is used to reset the start sequence 
							
BEGIN 
    
    Start_sequence_start <= Start_start;				-- set Start_sequence_start to the value of Start_start
    
    PROCESS (clock, reset) 
    BEGIN 
        IF butPop = '0' THEN			-- if butPop is equal to zero
            IF Push = '0' THEN			-- then check if the debounced value of the button is set to zero (the button is released)
                butPop <= '1';			-- if so, then set the value of butPop to '1'
            END IF;
        END IF;
        
        IF (reset = '1') THEN          
	           State <= A;
 
        ELSIF rising_edge(clock) THEN   -- On the rising edge 
			CASE State IS				-- check State
				WHEN A => 										-- if the finite state machine is in state A
					output <= "00"; 							-- set the output value of the finites state machine to "00"
					Start_start <= '0';							-- set the start sequence reset flag to zero so that the process can begin
					IF start_sequence_finished = '1' THEN		-- if the start sequence finished flag is equal to '1' then
						output <= "01"; 						-- change the output value of the finite state machine to "01"
						butPop <= '0'; 							-- change the value of butPop to '0' 
						Start_start <= '0';						-- keep the Start sequence reset flag as zero
						State <= B; 							-- change the finite state machine to state B
					END IF; 
				WHEN B => 										-- if the finite state machine is in state B
					output <= "01";  							-- keep the output of the finite state machine as "01"
					IF push='1' and butPop = '1' THEN 			-- check if the button has been pressed and and that the butPop is equal to '1' then
						output <= "10"; 						-- set the finite state machine output to "10"
						butPop <= '0'; 							-- set butPop to '0'
						State <= C; 							-- change the finite state maching state to C
					END IF; 
				WHEN C => 										-- if the finite state machine is in state C
					output <= "10";  							-- set the output to "10"
					Start_start <= '1';							-- set the start sequence reset flag to '1' to reset the sequence ready for when we enter state A again
					IF push='1' and butPop = '1' THEN 			-- check if the button has been pressed and butPop = '1'
						output <= "00";  						-- if so, then change the output back to "00"
						butPop <= '0';							-- set butPop back to 0
						State <= A; 							-- Set the FSM state back to A
					END IF; 
				WHEN OTHERS =>									-- if an error happens then set back to state A
					output <= "00"; 
					State <= A;
			END CASE; 
		END IF; 
	END PROCESS;

END RTL;
