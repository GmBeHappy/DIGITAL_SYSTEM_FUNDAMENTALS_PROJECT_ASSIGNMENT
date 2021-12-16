---George Saman

library IEEE;
use IEEE.numeric_bit.all;
use IEEE.STD_LOGIC_1164.ALL;

entity get_command is 
	port(
		baud	   : in std_logic;
		Fifo_valid : in std_logic;
		data_from_fifo : in std_logic_vector (7 downto 0);
		mem_write  : out std_logic;
		mem_read   : out std_logic;
		mem_data_to_write : out std_logic_vector (7 downto 0);
		mem_address: out std_logic_vector (5 downto 0)			--- memory got 16 entries each 8 bits wide
		);
end entity;

architecture behave of get_command is

--------------------------------Declaring States
type states is (Szero,SDatatoWrite,SMemRead,SMemWrite);
signal pstate, nstate : states;

-------------------------------Internal Signals
signal Read_detected, Write_detected : std_logic;

-------------------------------Store Regsiters
signal address_register, data_register : std_logic_vector ( 7 downto 0);

begin


----------------------------------State_transition

	State_transition : process(baud)
					begin
						if baud'event and baud = '1' then
							Pstate <= Nstate;
						end if;
					end process;
					
----------------------------------State_Machine

	State_Machine : process(pstate,Fifo_valid,data_from_fifo,Read_detected,write_detected)
					begin
						mem_write <= '0'; mem_read <= '0';
						case pstate is
										
							when Szero =>
										if data_from_fifo = "00000000" then
											nstate <= SMemRead;
										else
											nstate <= SDatatoWrite;
										end if;
							
							when SDatatoWrite =>
										data_register <= data_from_fifo;											-- Store Data
										nstate <= SMemWrite;
							
							when SMemRead => 
										mem_read <= '1';
										mem_address <= address_register(5 downto 0);
										nstate <= Szero;
										
							when SMemWrite => 
										mem_write <= '1';
										mem_address <= address_register (5 downto 0);
										mem_data_to_write <= data_register;
										nstate <= Szero;
										
										
											
						
						end case;
						
					
					end process;
	

end architecture;
