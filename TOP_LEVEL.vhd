----------------------------------------------------------------------------------
-- Company:  University of Canterbury
-- Authors: Pengcheng Liu (49791816)
--          Nate Brown (72825915)
--          Thomas Wang (65193909)
-- 
-- Create Date: 06.03.2020 12:17:23
-- Module Name: TOP_LEVEL - Behavioral
-- Description:  A top level file for the program
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY TOP_LEVEL IS
	PORT (
    	CA : OUT std_logic;			-- ports CA - DP are LEDs on the 7 segment display
    	CB : OUT std_logic;
    	CC : OUT std_logic;
    	CD : OUT std_logic;
    	CE : OUT std_logic;
    	CF : OUT std_logic;
    	CG : OUT std_logic;
    	DP : OUT std_logic;
    	AN: OUT std_logic_vector(7 downto 0);	-- AN is the anode port for selecting which 7 segment displays to write to 
        BTNC : IN std_logic;			-- BTNC is the button port for our central button
        CLK100MHZ : IN STD_LOGIC 		-- CLK100MHZ is the onboard clock
    );
	
END TOP_LEVEL;

ARCHITECTURE Behavioral of TOP_LEVEL IS

COMPONENT Start_Sequence IS
    PORT ( 
		Start_out : OUT std_logic_vector (2 downto 0);		-- Start_out of Start_output goes to the multiplexer to determine which decimal point(s) to display
		Start_Flag : INOUT std_logic_vector (1 downto 0);	-- Start_flag isn't really a flag, this takes in the output value of the finite state machine which the start sequence uses as a 'flag' to begin the sequence
		Start_seq_flag : IN std_logic;						-- Start_seq_flag is a flag that the finite state machine sets to reset the start sequence to restart
		Finished_Flag : INOUT std_logic;					-- Finished_Flag is a flag that lets the Finite state machine know when the countdown sequence is finished and proceed to the next state
		Clk_in_seq : IN std_logic							-- 1 Hz clock signal enters to set the timing of the countdown sequence
	);
	
END COMPONENT;

COMPONENT FSM IS
	PORT ( 
		Push : IN STD_LOGIC;								-- Push recieves the value of the debounced button push
        start_sequence_finished : IN std_logic;				-- Start_sequence_finished is a Flag that the Start Seqence circuit sets when the start sequence has concluded
        Start_sequence_start : OUT std_logic;				-- Start_sequence_start is a flag that resets the Start Sequence curcuit
        output : OUT STD_LOGIC_VECTOR (1 downto 0);			-- Output is a two bit vector that tells the rest of the TOP_LEVEL how to behave
        reset : IN STD_LOGIC;		-- probably get rid of this					
        clock : IN STD_LOGIC;								-- 100MHz clock input is used
        Clk_2 : IN STD_LOGIC
	);
	
END COMPONENT;

COMPONENT DeBounce IS
    PORT ( 
		Clock : IN STD_LOGIC;		-- Clock signal used is running at 50Hz with a period of 20ms
        but_in : IN STD_LOGIC;		-- input directly from BTNC
        pulse_out : OUT STD_LOGIC	-- pulse_out is the debounced state of the button BTNC
	);
	
END COMPONENT;

COMPONENT four_bit_counter IS
    PORT ( 
		Clk_input : IN STD_LOGIC;						-- Clk_input is value of the the 1 kHz clock signal, but on subsuquent iterations of this component becomes the carry out of the previous adder
		state : IN std_logic_vector(1 downto 0);		-- State is connected to the output of the central Finite state machine
		adder_out : OUT STD_LOGIC_VECTOR(3 downto 0);	-- Adder_out is current value of the 4 bit adder, in subsuquent iterations of this component this represents value of its "decade" 
		Clk_out: OUT std_logic							-- clk_out is the carry out of the adder, this will pass through to the next adder, this works as a type of 1:10 clock devider
    );
END COMPONENT;

COMPONENT my_divider IS
    PORT ( 
		Clk_in : IN  STD_LOGIC;			-- Clk_in takes in the 100MHz clock signal from the hardware
        Clk_out : OUT  STD_LOGIC;		-- outputs 1 Khz
        CLK_OUT_1 : OUT std_logic;		-- outputs 2 Hz
        CLK_OUT_2 : OUT std_logic		-- outputs 50 Hz
	);
-- attributes - these are not needed, as they are provided in the constraints file	
END COMPONENT;

COMPONENT BCD_to_7SEG IS
	PORT ( 
		bcd_in: IN std_logic_vector (3 downto 0);	-- Input vector brings in the value of counter_out from the multiplexer
    	leds_out: OUT	std_logic_vector (1 to 8);	-- output vector turns on correct leds on the 7 segment display to light up our desired characters
    	decimal_p : IN std_logic					-- 
	);
    						
END COMPONENT;

COMPONENT multiplexer IS
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
            
END COMPONENT;

COMPONENT mux_counter IS
    PORT (
		CLK_in : IN std_logic;										-- Clock input taken in from blairs clock divider, at 1kHz
        adder_out : OUT STD_LOGIC_VECTOR(2 downto 0)				-- adder_out carries a three bit signal out that increments continuously counting through states "000" to "111" every 8 clock cycles
	);
	
END COMPONENT;

COMPONENT clock_divider IS

	GENERIC(
		INPUT_FREQUENCY  : integer := 50000000;
		OUTPUT_FREQUENCY : integer :=     1000
	);

	PORT(
		in_clock  : IN std_logic;
		enable    : IN std_logic;
		out_clock : OUT std_logic := '0'
	);
	
END COMPONENT;


SIGNAL adder_1, adder_2, adder_3, adder_4, adder_5, adder_6, adder_7, adder_8, adder_in : STD_LOGIC_VECTOR(3 downto 0);
SIGNAL Start_Select, counter_3_bit : std_logic_vector(2 downto 0);
SIGNAL output_FSM : std_logic_vector(1 downto 0);
SIGNAL clk_in_de, clk_in_db, clk_in_1, clk_in_2, clk_in_3, clk_in_4, clk_in_5, clk_in_6, clk_in_7, clk_in_8 : std_logic;
SIGNAL clk_in_three_bit, debounce_out, start_seq, bounce_clr, Start_seqence_flag, decimal_point  : std_logic;
SIGNAL reset_fsm : std_logic := '0'; 


BEGIN

-- Connecting all the components using portmap for structural modelling.

Start : Start_Sequence
    PORT MAP (
        Start_out => Start_Select,	
		Start_Flag => output_FSM,
		Start_seq_flag => Start_seqence_flag,
		Finished_Flag => start_seq,
		Clk_in_seq => Clk_in_de
    );

clock_devider : my_divider 
    PORT MAP (
        Clk_in=>CLK100MHZ, 
        clk_out => clk_in_1, 
        clk_out_1 => clk_in_de,
        clk_out_2 => clk_in_db
    );

blairs : clock_divider GENERIC MAP(OUTPUT_FREQUENCY => 1000) 
    PORT MAP (
        in_clock => CLK100MHZ, 
        enable => '1', 
        out_clock => clk_in_three_bit
    );

debouncer: DeBounce 
    PORT MAP (
        Clock => clk_in_db, 
        but_in => BTNC, 
        pulse_out => debounce_out
    );

FSM1 : FSM 
    PORT MAP (
        Push => debounce_out, 
        start_sequence_finished=> start_seq,
        Start_sequence_start => Start_seqence_flag, 
        reset => reset_fsm, 
        clock => CLK100MHZ, 
        output => output_FSM,
        Clk_2 => clk_in_de
    );

counter_1 : four_bit_counter 
    PORT MAP (
        Clk_input => clk_in_1, 
        state => output_FSM, 
        adder_out => adder_1, 
        Clk_out => clk_in_2
	);
        
counter_2 : four_bit_counter 
    PORT MAP (
        Clk_input => clk_in_2, 
        state => output_FSM, 
        adder_out => adder_2, 
        Clk_out => clk_in_3
    );
        
counter_3 : four_bit_counter 
    PORT MAP (
        Clk_input => clk_in_3, 
        state => output_FSM, 
        adder_out => adder_3, 
        Clk_out => clk_in_4
    );
        
counter_4 : four_bit_counter 
    PORT MAP (
        Clk_input => clk_in_4, 
        state => output_FSM, 
        adder_out => adder_4, 
        Clk_out => clk_in_5
    );
        
counter_5 : four_bit_counter 
    PORT MAP (
        Clk_input => clk_in_5, 
        state => output_FSM, 
        adder_out => adder_5, 
        Clk_out => clk_in_6
        );
        
counter_6 : four_bit_counter 
    PORT MAP (
        Clk_input => clk_in_6, 
        state => output_FSM, 
        adder_out => adder_6, 
        Clk_out => clk_in_7
    );
        
counter_7 : four_bit_counter 
    PORT MAP (
        Clk_input => clk_in_7, 
        state => output_FSM, 
        adder_out => adder_7, 
        Clk_out => clk_in_8
    );

counter_8 : four_bit_counter 
    PORT MAP (
        Clk_input => clk_in_8, 
        state => output_FSM, 
        adder_out => adder_8
    );

three_bit_counter : mux_counter 
    PORT MAP(
        CLK_in => clk_in_three_bit, 
        adder_out => counter_3_bit
    );

counter_mux : multiplexer 
    PORT MAP (
        mux_in => counter_3_bit, 
        start_in => Start_select,
		State_fsm => output_FSM,
        counter_1 => adder_1, 
        counter_2 => adder_2, 
        counter_3 => adder_3, 
        counter_4 => adder_4,
        counter_5 => adder_5, 
        counter_6 => adder_6, 
        counter_7 => adder_7, 
        counter_8 => adder_8, 
        counter_out=> adder_in, 
        decimal_p_out => decimal_point,
        AN_out => AN
    );


BCD_to_7SEG_desplay : BCD_to_7SEG 
    PORT MAP (
        bcd_in => adder_in, 
        decimal_p => decimal_point,
        leds_out(1) =>CA,
        leds_out(2) =>CB,
        leds_out(3) =>CC,
        leds_out(4) =>CD,
        leds_out(5) =>CE,
        leds_out(6) =>CF,
        leds_out(7) =>CG,
        leds_out(8) =>DP
    );

END Behavioral;
