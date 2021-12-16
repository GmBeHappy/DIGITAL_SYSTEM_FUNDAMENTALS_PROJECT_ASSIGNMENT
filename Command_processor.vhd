---George Saman

library IEEE;
use IEEE.numeric_bit.all;
use IEEE.STD_LOGIC_1164.ALL;

entity command_processor is
	port(
		Rx_line : in std_logic;
		clk100mhz: in std_logic;
		Tx_line : out std_logic
		);
end entity;

architecture structure of command_processor is

component Rx_top
	port( baud : in std_logic;; 
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

--------------------------------Signals
signal reset,baud,baudx16,FifoValid,MemWrite,MemRead,TxSend,Tx_out : std_logic;
signal Data_from_Rx_to_Get_command, MemData, TxData : std_logic_vector (7 downto 0);	  
signal MemAddress : std_logic_vector ( 5 downto 0);
begin


	clock_gen : clkgen port map (
			clk100mhz => clk100mhz,
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
			Data_out => TxData,
			send => TxSend
			);
			
	Transmitter: Tx port map (
			clk => baud,
			send => TxSend,
			DATA_IN => TxData,
			DATA_OUT => Tx_line
			);
	  
end architecture;	