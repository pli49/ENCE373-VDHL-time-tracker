----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.05.2020 12:34:53
-- Design Name: 
-- Module Name: Start_Sequence - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
-- Company:  University of Canterbury
-- Authors: Pengcheng Liu (49791816)
--          Nate Brown (72825915)
--          Thomas Wang (65193909)
-- 
-- Create Date: 06.03.2020 12:17:23
-- Module Name: Start_Sequence - Behavioral
-- Description:  A top level file for the program
----------------------------------------------------------------------------------


entity Start_Sequence is
    Port ( 
			Start_out : out std_logic_vector (2 downto 0);		-- Output port that sends the signal to COUNT_MS to begin counting miliseconds
			Start_Flag : in std_logic_vector (1 downto 0);		-- Start_flag isn't really a flag, this takes in the output value of the finite state machine which the start sequence uses as a 'flag' to begin the sequence
			Start_seq_flag : in std_logic;				-- Start_seq_flag is a flag that the finite state machine sets to reset the start sequence to restart
			Finished_Flag : out std_logic;				-- Finished_Flag is a flag that lets the Finite state machine know when the countdown sequence is finished and proceed to the next state
			Clk_in_seq : in std_logic				-- 1 Hz clock signal enters to set the timing of the countdown sequence 
);

end START_SEQUENCE;

architecture RTL of START_SEQUENCE is

    	TYPE State_type IS (A, B, C, D);					-- define the state types
    	signal State : State_Type;    						-- Create a signal that uses 
	signal Finished_seq : std_logic;					-- Finished_seq holds the value of the Finished_Flag. this is set to 0 when sequence is runing, and to 1 when the sequence has concluded
	signal Start_seq : std_logic_vector (1 downto 0);			-- Start_seq is equal to tthe Start_Flag

begin

	Start_seq <= Start_Flag;										-- set Start_seq to the value of Start_Flag
	
	Begin_Sequence : PROCESS (Clk_in_seq, Start_Flag) is							-- this is the start sequence process, this takes in the 1 Hz clock and value of the finite state machine
		begin 
		    if Start_seq_flag = '1' then								-- if the finite state machine sets the value of Start_seq_flag to '1' then
		              Finished_seq <= '0';								-- set the state of Finished_seq back to zero ready to begin again
		              State <= A;									-- Set the State of the Start Sequence back to the begining
	        end if;
		    if Clk_in_seq = '1' and Clk_in_seq'Event then						-- on the rising edge of the 1Hz clock edge
				  if Start_seq = "00"  and Finished_seq = '0' then				-- then check that output from the FSM and the finished flag are both equal to zero
					   case State is
						  when A => Start_out <= "000"; State <= B;			-- set Start_out to the first three decimal points, and set the start sequence state to the next state
						  when B => Start_out <= "001"; State <= C;			-- set Start_out to the first two decimal points, and set the start sequence state to the next state
						  when C => Start_out <= "010"; State <= D;			-- set Start_out to the first decimal point, and set the start sequence state to the next state
						  when D => Finished_seq <= '1'; 				-- set the Finished_Flag to '1' ending the start sequence and telling the FSM to go to the next state
						  when others => Start_out <= "000";                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
					   end case;
				    end if;
		    end if;
			
	end Process Begin_Sequence;
			
	Finished_Flag <= Finished_seq;         -- set the Finished_Flag to the signal Finished_seq
	
end RTL;

