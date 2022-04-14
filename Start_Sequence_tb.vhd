----------------------------------------------------------------------------------
-- Company:  University of Canterbury
-- Authors: Pengcheng Liu (49791816)
--          Nate Brown (72825915)
--          Thomas Wang (65193909)
-- 
-- Create Date: 06.03.2020 12:17:23
-- Module Name: TOP_LEVEL - Behavioral
-- Description:  A test bench for the start sequence FSM
----------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Start_Sequence_tb is
--  Port ( );
end Start_Sequence_tb;

architecture Behavioral of Start_Sequence_tb is

component Start_Sequence is
    Port ( 
			Start_out : out std_logic_vector (2 downto 0);		-- Output port that sends the signal to COUNT_MS to begin counting miliseconds
			Start_Flag : in std_logic_vector (1 downto 0);
			Start_seq_flag : in std_logic;
			Finished_Flag : inout std_logic;
			Clk_in_seq : in std_logic
);

end component;

signal Start_out :  std_logic_vector (2 downto 0);
signal Start_Flag :  std_logic_vector (1 downto 0);
signal Start_seq_flag :  std_logic;
signal Finished_Flag :  std_logic;
signal Clk_in_seq :  std_logic;
TYPE State_type IS (A, B, C, D);
SIGNAL State : State_Type;
SIGNAL Finished_seq : STD_LOGIC;
constant CLK_period : time := 2 ps;

begin
    uut: Start_Sequence port map(Start_out => Start_out, Start_Flag => Start_Flag, Start_seq_flag => Start_seq_flag, Clk_in_seq => Clk_in_seq);
    
   CLK_process :process
   begin
		Clk_in_seq <= '0';
		Finished_seq <= '0';
		wait for CLK_period/2;
		Clk_in_seq <= '1';
		wait for CLK_period/2;
   end process;
    
   stim_proc:process
   begin
   
       --TEST THEN STATE DONT CHANGE
       wait for 100 ns;
       Finished_seq <= '0';
       State <= A;
       START_FLAG <= "01";
       Start_seq_flag <= '0';
       
       --TEST STATE A TO B
       wait for 100 ns;
       Finished_seq <= '0';
       State <= A;
       START_FLAG <= "00";
       Start_seq_flag <= '1';
       
       -- TEST STATE B TO C
       wait for 100 ns;
       Finished_seq <= '0';
       START_FLAG <= "00";
       State <= B;
       Start_seq_flag <= '1';
       
       --TEST STATE C TO D
       wait for 100 ns;
       Finished_seq <= '0';
       START_FLAG <= "00";
       State <= C;
       Start_seq_flag <= '1';
       
       --TEST STATE D TO FINISH START SEQUENC       
       wait for 100 ns;
       Finished_seq <= '0';       
       START_FLAG <= "00";
       State <= C;
       Start_seq_flag <= '1';
      
       --
       wait for 100 ns;
       Finished_seq <= '0';
       START_FLAG <= "00";
       State <= D;
       Start_seq_flag <= '1';
       
       end process;
        
        
        

end Behavioral;
