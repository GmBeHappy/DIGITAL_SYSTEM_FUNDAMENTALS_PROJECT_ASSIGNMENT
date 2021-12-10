--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:53:44 12/06/2021
-- Design Name:   
-- Module Name:   C:/Users/gm/OneDrive - KMITL/1_2564/digital/project_assignment/testps2.vhd
-- Project Name:  project_assignment
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ps2_keyboard
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY testps2 IS
END testps2;
 
ARCHITECTURE behavior OF testps2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ps2_keyboard
    PORT(
         clk : IN  std_logic;
         ps2_clk : IN  std_logic;
         ps2_data : IN  std_logic;
         ps2_code_new : OUT  std_logic;
         ps2_code : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal ps2_clk : std_logic := '1';
   signal ps2_data : std_logic := '1';

 	--Outputs
   signal ps2_code_new : std_logic;
   signal ps2_code : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 1 ns;
   constant ps2_clk_period : time := 10 ns;

   signal enable : std_logic := '1';
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ps2_keyboard PORT MAP (
          clk => clk,
          ps2_clk => ps2_clk,
          ps2_data => ps2_data,
          ps2_code_new => ps2_code_new,
          ps2_code => ps2_code
        );
   Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   -- ps2_clk_process :process
   -- begin
   --    ps2_clk <= '0';
   --    wait for ps2_clk_period/2;
   --    ps2_clk <= '1';
   --    wait for ps2_clk_period/2;
   -- end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      enable <= '1';
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
      
      -- enable <= '0';
      -- wait for 100 ns;
      -- --ps2_clk <= '0';
      -- ps2_data <= '0';
      -- wait for 100 ns;
      -- ps2_data <= '0';
      -- --ps2_clk <= '1';		
      -- wait for 100 ns;  
      -- ps2_data <= '0';
      -- --ps2_clk <= '0';		
      -- wait for 100 ns;
      -- ps2_data <= '0';
      -- --ps2_clk <= '1';	
      -- wait for 100 ns;
      -- ps2_data <= '1';
      -- --ps2_clk <= '0';	
      -- wait for 100 ns;
      -- ps2_data <= '1';
      -- --ps2_clk <= '1';	
      -- wait for 100 ns;
      -- ps2_data <= '0';
      -- --ps2_clk <= '0';	
      -- wait for 100 ns;
      -- ps2_data <= '1';
      -- --ps2_clk <= '1';	
      -- wait for 100 ns;
      -- ps2_data <= '0';
      -- --ps2_clk <= '0';	
      -- wait for 100 ns;
      -- ps2_data <= '0';
      -- --ps2_clk <= '1';	
      -- wait for 100 ns;
      -- ps2_data <= '1';
      -- enable <= '1';
      wait;
   end process;
   ps2_clk <= '1', '0' after 19 ns, '1' after 29 ns, '0' after 39 ns, '1' after 49 ns, '0' after 59 ns, '1' after 69 ns, '0' after 79 ns, '1' after 89 ns, '0' after 99 ns, '1' after 109 ns, '0' after 119 ns, '1' after 129 ns, '0' after 139 ns, '1' after 149 ns, '0' after 159 ns, '1' after 169 ns, '0' after 179 ns, '1' after 189 ns, '0' after 199 ns, '1' after 209 ns, '0' after 219 ns, '1' after 229 ns;
   ps2_data <= '1', '0' after 15 ns, '1' after 69 ns, '0' after  129 ns, '1' after 209 ns;
END;
