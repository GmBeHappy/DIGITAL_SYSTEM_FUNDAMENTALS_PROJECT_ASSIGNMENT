----------------------------------------------------------------------------------
-- Company: 
-- Engineer: A lot of people
-- 
-- Create Date:    23:58:1234 15/12/2021
-- Design Name: 
-- Module Name:    ControllerTest_TOP - Behavioral 
-- Project Name: 	 LCD Controller Test
-- Target Devices: 	
-- Tool versions: 	ISE 14.7
-- Description: 	Handles controlling the 16x2 Character LCD screen and PS2 Keyboard
--
-- Dependencies: 
--
-- Revision: 1
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use     ieee.math_real.all;


entity ControllerTest_TOP is
	port (
		ps2_clk		 : in  std_logic;
    	ps2_data     : in  std_logic;
		clk          : in  std_logic;
		rst          : in  std_logic;
		lcd_e        : out std_logic;
		lcd_rs       : out std_logic;
		lcd_rw       : out std_logic;
		lcd_db       : out std_logic_vector(7 downto 0);
		comm_tx           : out std_logic := '0';
		comm_rx           : in std_logic;
		comm_tc       : out std_logic := '0';
		comm_rc       : in std_logic;
		comm_tm       : out std_logic := '0';
		comm_rm       : in std_logic;
		debugrx        : out std_logic := '0';
		debugtx        : out std_logic);
		
end ControllerTest_TOP;

architecture Behavioral of ControllerTest_TOP is

	COMPONENT lcd_controller IS
	  PORT(
		 clk        : IN    STD_LOGIC;  --system clock
		 reset_n    : IN    STD_LOGIC;  --active low reinitializes lcd
		 rw, rs, e  : OUT   STD_LOGIC;  --read/write, setup/data, and enable for lcd
		 lcd_data   : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0); --data signals for lcd
		 line1_buffer : IN STD_LOGIC_VECTOR(127 downto 0); -- Data for the top line of the LCD
		 line2_buffer : IN STD_LOGIC_VECTOR(127 downto 0)); -- Data for the bottom line of the LCD
	END COMPONENT;
	
	-- These lines can be configured to be input from anything. 
	-- 8 bits per character
	signal top_line : std_logic_vector(127 downto 0) := x"20202020202020202020202020202020"; -- Translates to Mayur's FPGA
	signal bottom_line : std_logic_vector(127 downto 0) := x"20202020202020202020202020202020";

	signal newChar: std_logic;
	signal charCode: std_logic_vector (7 downto 0);

	subtype char_type is std_logic_vector(7 downto 0);
	type ram_array is array(0 to 31) of char_type;
	signal ram: ram_array := (x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20");
	signal pointer: integer := 0;

	shared variable uartSendBuffer: std_logic_vector (7 downto 0);
	shared variable uartRecieveBuffer: std_logic_vector(7 downto 0);
	signal uartSendPackageConfirrm: std_logic := '0';
	signal uartIncomingData: std_logic := '0';
	signal uartRecievePackageConfirrm: std_logic := '0';
	signal txSignal: std_logic;

	shared variable pt: integer:= 0;
	shared variable txBuffer: std_logic:= '0';
	shared variable tcBuffer: std_logic:= '0';
	signal comm_rxBuffer: std_logic_vector(255 downto 0);
	signal comm_txBuffer: std_logic_vector(255 downto 0);


begin

	LCD: lcd_controller port map(
		clk => clk,
		reset_n => not rst,
		e => lcd_e,
		rs => lcd_rs,
		rw => lcd_rw,
		lcd_data => lcd_db,
		line1_buffer => top_line,
		line2_buffer => bottom_line 
	);
	
	ps2_keyboard_to_ascii:entity work.ps2_keyboard_to_ascii
		port map(
		clk => clk,
		ps2_clk => ps2_clk,
		ps2_data => ps2_data,
		ascii_new => newChar,
		ascii_code => charCode
	);

	uartController: entity work.uart
	 	generic map(baud => 4800,clock_frequency => 20000000)
		port map(
		clock => clk,
		reset => '1',
		data_stream_in => uartRecieveBuffer,
		data_stream_in_stb => uartSendPackageConfirrm,
		data_stream_in_ack => uartIncomingData,
		data_stream_out => uartSendBuffer,
		data_stream_out_stb => uartRecievePackageConfirrm,
		rx => '0'
	);

process (newChar, comm_rc)
begin
	if newChar'event and newChar = '0' then
		if charCode = x"08" then
			if pointer > 0 then
				pointer <= pointer-1;
				ram(pointer-1) <= x"20";
			else
				pointer <= pointer;
				ram(0) <= x"20";
			end if;
		elsif charCode = x"0D" then
			comm_tm <= '1';
			tcBuffer := not tcBuffer;
		elsif charcode > x"19" and charCode < x"7F" and pointer < 32 then
			ram(pointer) <= charCode;
			pointer <= pointer+1;
		end if;
		end if;
	if comm_rc'event and comm_rc='1' then
		if pointer < 32 then
			if comm_rm = '1' then
				ram(integer(pt/8))(pt mod 8) <= comm_rx;
			else
				comm_tx <= comm_txBuffer(pt);
			end if;
			pt := pt+1;
			tcBuffer := not tcBuffer;
		else
			pt := 0;
			comm_tm <= '0';
		end if;
	end if;
	if comm_rc'event and comm_rc='0' then
		if pointer < 32 then
			if comm_rm = '1' then
				ram(integer(pt/8))(pt mod 8) <= comm_rx;
			else
				comm_tx <= comm_txBuffer(pt);
			end if;
			pt := pt+1;
			tcBuffer := not tcBuffer;
		else
			pt := 0;
			comm_tm <= '0';
		end if;
	end if;
end process;

top_line <= ram(0)&ram(1)&ram(2)&ram(3)&ram(4)&ram(5)&ram(6)&ram(7)&ram(8)&ram(9)&ram(10)&ram(11)&ram(12)&ram(13)&ram(14)&ram(15);
bottom_line <= ram(16)&ram(17)&ram(18)&ram(19)&ram(20)&ram(21)&ram(22)&ram(23)&ram(24)&ram(25)&ram(26)&ram(27)&ram(28)&ram(29)&ram(30)&ram(31);

comm_txBuffer <= top_line&bottom_line;

debugtx <= tcBuffer and not comm_rc;
debugrx <= comm_rx;
comm_tc <= tcBuffer and not comm_rc;

end Behavioral;

