---George Saman

library IEEE;
use IEEE.numeric_bit.all;
use IEEE.STD_LOGIC_1164.ALL;

entity Rx_top is 
	port( baud : in std_logic; 
		  baudx16: in std_logic;
		  Rx_line: in std_logic;
		  Data_out_of_Rx_top: out std_logic_vector ( 7 downto 0);
		  Fifo_valid : out std_logic
	);
		 
end entity;

architecture structure of Rx_top is 

component Rx 
	port(baudx16 :in std_logic;
		 Rx_line : in std_logic;
		 Data_recieved : out std_logic_vector(7 downto 0);
		 D_valid	   : out std_logic
	);
	
end component;


component Rx_controller
	port(
		baud	: in std_logic;
		D_valid	: in std_logic;
		Fifo_full: in std_logic;
		Fifo_empty : in  std_logic;
		Fifo_write: out std_logic;
		Fifo_read : out std_logic;
		memory_write: out std_logic
			);
end component;

component fifo is
	port(
	write,read : in std_logic;
	clk		   : in std_logic;
	data_in	   : in std_logic_vector (7 downto 0);
	full,empty : buffer std_logic;
	data_out   : out std_logic_vector ( 7 downto 0)	);
end component;

--------------------------unused signals
signal reset : bit;

--------------------------Data lines
signal Data_into_fifo, Data_out_fifo : std_logic_vector(7 downto 0);

-------------------------internal signals
signal Dta_valid, write, Read, empty, full : std_logic;


begin  
	Data_out_of_Rx_top <= Data_out_fifo;
	
	Reciever : Rx port map (
			baudx16 => baudx16,
			Rx_line => Rx_line,
			Data_recieved => Data_into_fifo,
			D_valid => Dta_valid	
				);
				
	Fifo_unit: fifo port map (
			write => write,
			read  => read,
			clk	  => baud,
			data_in => Data_into_fifo,
			full	=> full,
			empty	=> empty,
			data_out=> Data_out_fifo
				);
	
	RxController: Rx_controller port map (
			baud => baud,
			D_valid => Dta_valid,
			Fifo_full => full,
			Fifo_empty => empty,
			Fifo_write => write,
			Fifo_read => read,
			memory_write => Fifo_valid
			);					  



end structure;
