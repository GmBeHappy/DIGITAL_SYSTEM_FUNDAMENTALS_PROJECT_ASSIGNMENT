----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:04:11 11/29/2015 
-- Design Name: 	Narong Buabthong
-- Module Name:    lcd_ex1 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:  lcd interface experiment 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity lcd_ex1 is
port ( clk : in std_logic;   	-- clock i/p
    ps2_clk: in std_logic;
    ps2_data: in  std_logic;
	  lcd_rst: in std_logic; 	-- Reset i/p
    debug_add: in std_logic_vector (3 downto 0);
    lcd_rw : out std_logic;   -- read&write control
    lcd_e  : out std_logic;   -- enable control
    lcd_rs : out std_logic;   -- data or command control
    lcd_data   : out std_logic_vector(7 downto 0);  ---data line
    debug : out std_logic;
    debug_data : out std_logic_vector (7 downto 0);
    r: out std_logic;
    w: out std_logic);
end lcd_ex1;

architecture Behavioral of lcd_ex1 is

  signal addr_d :integer range 0 to 31;
  signal addr_q :integer range 0 to 31;
  signal data : std_logic_vector (7 downto 0);
  signal newChar : std_logic := '0';
  signal charCode : std_logic_vector (7 downto 0);
  signal Load: std_logic;
  begin
  
  message_rom :  entity work.message_rom
	 port map (
		clk =>clk,
      A  => addr_q,
      D  => data,
      newAscii => newChar,
      DataIn => charCode,
      requestToload => Load,
      debug => debug,
      debug_data => debug_data,
      debug_add => debug_add,
      Reading => r,
      Writing => w
	 );

  lcd_control:entity work.lcd_control
    port map (clk  => clk,  
	  lcd_rst => lcd_rst,
		data_in => charCode,
		address => addr_d,
    refresh => newChar,
		lcd_rw  => lcd_rw,
		lcd_e   => lcd_e,
		lcd_rs  => lcd_rs,
		lcd_data => lcd_data,
    loadRequest => Load
	);
  ps2_keyboard_to_ascii:entity work.ps2_keyboard_to_ascii
    port map(
      clk => clk,
      ps2_clk => ps2_clk,
      ps2_data => ps2_data,
      ascii_new => newChar,
      ascii_code => charCode
    );


process (clk)
  begin
    if clk = '1' and clk'event then 
		addr_q <= addr_d;
    end if;
end process;
-- process (newChar)
-- begin
--   if newChar'event and newChar='1' then
--     lcd_e <= '1';
--     lcd_rs <= '1';
--     lcd_data <= charCode;
--   end if;
--   lcd_e <= '0';
--   end process;
end Behavioral; 

