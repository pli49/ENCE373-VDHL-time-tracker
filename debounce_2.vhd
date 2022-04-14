-- Company:  University of Canterbury
-- Authors: Pengcheng Liu (49791816)
--          Nate Brown (72825915)
--          Thomas Wang (65193909)
-- Module Name: DEBOUNCE - Behavioural 
--
-- Project Name: ENEL373 ALU PROJECT
-- Target Devices: NEXUS4DDR FPGA BOARD
--
-- Description: THIS CODE DEBOUNCES THE BUTTONS ON THE NEXUSDDR4. THERE IS NO HARDWARE
-- DEBOUNCING ON THE BUTTONS AND THEREFORE THIS CODE IS VITAL TO BE ABLE TO USE THE BUTTONS
-- FOR OPERATIONS FLAWLESSLY.
--
-- Revision: FINAL

-- Reference: https://github.com/lilindian16/ENEL373/blob/master/DeBounce.vhd
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

ENTITY DeBounce IS
    PORT ( Clock : IN STD_LOGIC;
           but_in : IN STD_LOGIC;
           pulse_out : OUT STD_LOGIC);
END DeBounce;

ARCHITECTURE Behavioral OF DeBounce IS
signal a, b, c ,d, e, f, g, h, i, j: std_logic;


BEGIN
PROCESS (Clock)
BEGIN
    IF ((but_in = '1') AND (Clock'Event) and Clock = '1') THEN					-- To achieve debouncing, multiple flipflops are used. 
    a <= but_in;																
    b <= a;																		
    c <= b;
    d <= c;
    e <= d;
    f <= e;
    g <= f;
    h <= g;
    i <= h;
    j <= i;
    END IF;
     
END PROCESS;
    pulse_out <= a and b and c and d and e and f and g and h and i and j and but_in;                                                   
END ARCHITECTURE Behavioral;