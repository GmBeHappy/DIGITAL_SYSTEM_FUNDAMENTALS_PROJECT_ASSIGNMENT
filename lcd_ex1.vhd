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
    debug_data : out std_logic_vector (7 downto 0) := "00000000";
    r: out std_logic := '0';
    w: out std_logic := '0');
end lcd_ex1;

architecture Behavioral of lcd_ex1 is

  signal addr_d :integer range 0 to 31;
  signal addr_q :integer range 0 to 31;
  signal data : std_logic_vector (7 downto 0);
  signal newChar : std_logic := '0';
  signal charCode : std_logic_vector (7 downto 0);
  signal Load: std_logic;

  COMPONENT lcd_controller IS
	  PORT(
		 clk        : IN    STD_LOGIC;  --system clock
		 reset_n    : IN    STD_LOGIC;  --active low reinitializes lcd
		 rw, rs, e  : OUT   STD_LOGIC;  --read/write, setup/data, and enable for lcd
		 lcd_data   : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0); --data signals for lcd
		 line1_buffer : IN STD_LOGIC_VECTOR(127 downto 0); -- Data for the top line of the LCD
		 line2_buffer : IN STD_LOGIC_VECTOR(127 downto 0)); -- Data for the bottom line of the LCD
	END COMPONENT;

  signal top_line : std_logic_vector(127 downto 0) := x"4d617975722773204650474120202020"; -- Translates to Mayur's FPGA
	signal bottom_line : std_logic_vector(127 downto 0) := x"5445535420666f72204c434420202020";

  begin

    LCD: lcd_controller port map(
      clk => clk,
      reset_n => lcd_rst,
      e => lcd_e,
      rs => lcd_rs,
      rw => lcd_rw,
      lcd_data => lcd_data,
      line1_buffer => top_line,
      line2_buffer => bottom_line 
    );

  -- message_rom :  entity work.message_rom
	--  port map (
	-- 	clk =>clk,
  --     A  => addr_q,
  --     D  => data,
  --     newAscii => newChar,
  --     DataIn => charCode,
  --     requestToload => Load,
  --     debug => debug,
  --     debug_data => debug_data,
  --     debug_add => debug_add,
  --     Reading => r,
  --     Writing => w
	--  );

  -- lcd_control:entity work.lcd_control
  --   port map (clk  => clk,  
	--   lcd_rst => lcd_rst,
	-- 	data_in => charCode,
	-- 	address => addr_d,
  --   refresh => newChar,
	-- 	lcd_rw  => lcd_rw,
	-- 	lcd_e   => lcd_e,
	-- 	lcd_rs  => lcd_rs,
	-- 	lcd_data => lcd_data,
  --   loadRequest => Load
	-- );
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

