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
		Rx_line 		 : in  std_logic;
		Tx_line      : out std_logic
		);
		
end ControllerTest_TOP;

architecture Behavioral of ControllerTest_TOP is

	component Rx_top
	port( baud : in std_logic; 
		  baudx16: in std_logic;
		  Rx_line: in std_logic;
		  Data_out_of_Rx_top: out std_logic_vector ( 7 downto 0);
		  Fifo_valid : out std_logic
	);
		 
	end component;

	component get_command
		port(
			baud	   : in std_logic;
			Fifo_valid : in std_logic;
			data_from_fifo : in std_logic_vector(7 downto 0);
			mem_write  : out std_logic;
			mem_read   : out std_logic;
			mem_data_to_write : out std_logic_vector (7 downto 0);
			mem_address: out std_logic_vector (5 downto 0)		
			);
	end component;


	component memory
		port(
			baud	: in std_logic;
			read	: in std_logic;
			write	: in std_logic;
			Data_in	: in std_logic_vector (7 downto 0);
			Address : in std_logic_vector (5 downto 0);
			Data_out: out std_logic_vector(7 downto 0);
			send	: out std_logic	
			);
	end component;


	component Tx
	port (
			clk		: in std_logic;				    -- frequency of baudrate
			send	: in std_logic;  					-- a flag to start sending
			DATA_IN : in std_logic_vector(7 downto 0);-- loaded from fifo
			DATA_OUT: out std_logic					-- to the outside world
			);
	end component;

	component clkgen is
	port (clk100mhz : in std_logic;
			reset : in std_logic;
			baudclk_16x : out std_logic;
			baudclk : out std_logic);
	end component;

	COMPONENT lcd_controller IS
	  PORT(
		 clk        : IN    STD_LOGIC;  --system clock
		 reset_n    : IN    STD_LOGIC;  --active low reinitializes lcd
		 rw, rs, e  : OUT   STD_LOGIC;  --read/write, setup/data, and enable for lcd
		 lcd_data   : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0); --data signals for lcd
		 line1_buffer : IN STD_LOGIC_VECTOR(127 downto 0); -- Data for the top line of the LCD
		 line2_buffer : IN STD_LOGIC_VECTOR(127 downto 0)); -- Data for the bottom line of the LCD
	END COMPONENT;
	
	signal reset,baud,baudx16,FifoValid,MemWrite,MemRead,TxSend,Tx_out : std_logic;
	signal Data_from_Rx_to_Get_command, MemData, TxData : std_logic_vector (7 downto 0);	  
	signal MemAddress : std_logic_vector ( 5 downto 0);

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

	shared variable isSend: std_logic :='0';

	type dataState is (load, send, rreset, done);
	signal state : dataState:= load;

	shared variable txSendBuffer: std_logic;
	shared variable txDataBuffer: std_logic_vector (7 downto 0);


begin

	clock_gen : clkgen port map (
			clk100mhz => clk,
			reset => reset,
			baudclk_16x => baudx16,
			baudclk => baud
			);

	RxTOP : Rx_top port map (
			Rx_line => Rx_line,
			baud => baud,
			baudx16 => baudx16,
			Data_out_of_Rx_top => Data_from_Rx_to_Get_command,
			Fifo_valid => FifoValid	
			);


	getCommand : get_command port map ( 
			baud => baud,
			Fifo_valid => FifoValid,
			Data_from_fifo => Data_from_Rx_to_Get_command,
			mem_write => MemWrite,
			mem_read => MemRead,
			mem_data_to_write => MemData,
			mem_address => MemAddress
			);

	Memory16X8 : memory port map (
			baud => baud,
			read => MemRead,
			write => MemWrite,
			Data_in => MemData,
			Address => MemAddress,
			Data_out => txDataBuffer,
			send => txSendBuffer
			);
			
	Transmitter: Tx port map (
			clk => baud,
			send => txSendBuffer,
			DATA_IN => txDataBuffer,
			DATA_OUT => Tx_line
		);

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

process (newChar, MemWrite)
begin
	if newChar'event and newChar = '0' then
		if charCode = x"08" then
			if pointer > 0 then
				pointer <= pointer-1;
				ram(pointer) <= x"20";
			else
				pointer <= pointer;
				ram(0) <= x"20";
			end if;
		elsif charCode = x"0D" then
			isSend := '1';

		elsif charcode > x"19" and charCode < x"7F" and pointer < 32 then
			ram(pointer) <= charCode;
			pointer <= pointer+1;
		end if;
	end if;
	if MemWrite'event and MemWrite = '1' then
		ram(pointer) <= MemData;
		pointer <= pointer+1;
	end if;
end process;

process (baud)
variable count: integer:= 0;
begin
	if baud'event and baud='1' and isSend='1' then
		case state is
			when load =>
				txDataBuffer := ram(count);
				state <= send;
			when send =>
				txSendBuffer := '1';
				state <= rreset;
				count := count+1;
			when rreset =>
				txSendBuffer := '0';
				txDataBuffer := "00000000";
				if count > 31 then
					state <= done;
				else
					state <= load;
				end if;
			when others =>
				if count < 32 then
					state <= load;
				else
					state <= done;
				end if;
		end case;
		isSend := '0';
	end if;
end process;

		

top_line <= ram(0)&ram(1)&ram(2)&ram(3)&ram(4)&ram(5)&ram(6)&ram(7)&ram(8)&ram(9)&ram(10)&ram(11)&ram(12)&ram(13)&ram(14)&ram(15);
bottom_line <= ram(16)&ram(17)&ram(18)&ram(19)&ram(20)&ram(21)&ram(22)&ram(23)&ram(24)&ram(25)&ram(26)&ram(27)&ram(28)&ram(29)&ram(30)&ram(31);

txSend <= txSendBuffer;
txData <= txDataBuffer;
end Behavioral;

