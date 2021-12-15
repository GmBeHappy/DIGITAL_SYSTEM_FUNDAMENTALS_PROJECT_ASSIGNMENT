
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lcd_control is
port ( clk : in std_logic;   ----clock i/p
	 lcd_rst: in std_logic; 	  ---- Reset i/p
	 data_in : in std_logic_vector(7 downto 0);  ---data input 
	 refresh : in std_logic;
	 address : out integer range 0 to 31; -- address 
    lcd_rw : out std_logic;   ---read&write control
    lcd_e  : out std_logic;   ----enable control
    lcd_rs : out std_logic;   ----data or command control
    lcd_data   : out std_logic_vector(7 downto 0);  ---data line
	debug : out std_logic;
	loadRequest : out std_logic
	 );
end lcd_control;

architecture Behavioral of lcd_control is
	constant N: integer := 4; --:=22;
   type arr is array (1 to N) of std_logic_vector(7 downto 0);
	constant datas : arr := (X"38",  --2 Line, 5x8 and 8 bit interface
									 X"0c",  --Display On, cursor off
									 X"06",	--shift display right
									 X"01"	--Clear display screen
									 ); --command and data to display    
 	signal clk5k : std_logic := '0';
	type state_type is(initial_lcd,set_cursor,lcd_print);
	signal state : state_type := initial_lcd ;
	signal e : std_logic := '0';
	signal re : std_logic := '0';
begin

DIVIDER1 : entity work.DIVIDER
   generic map(fin => 20000000,
            fout => 5000
				)  
   port map  (CLK=>clk,
         Q => clk5k 
			);

	lcd_rw <= '0'; ----lcd write
	process(clk5k)
		variable j : integer := 1;
 
	begin
		if clk5k'event and clk5k = '1' and refresh = '1' then
			if lcd_rst='1' then
				state <= initial_lcd;
				e <= '0';
			else	
				case state is
					when initial_lcd =>
						lcd_rs <= '0';   ---command signal
						if e <= '0' then
							lcd_data <= datas(j)(7 downto 0);
							e <= '1';
						else
							e <= '0';
							j := j+1;
						end if;
						if j > 4 then
							state <= set_cursor;
						end if;
					when set_cursor =>
					   lcd_rs <= '0';
						if e = '0' then
							lcd_data <= "10000000";		--set cursor to beginning of the 1st line 
							e <= '1';
						else
							e <= '0';
							j := 0;
							state <= lcd_print;
						end if;						
					when lcd_print =>
						lcd_rs <= '1';
						if e = '0' then
							address <= j;
							loadRequest <= '1';
							lcd_data <= data_in;
							e <= '1';
						else
							loadRequest <= '0';
							e <= '0';	
							j := j+1;
						end if;

						if j > 15 then
							state <= set_cursor;
						end if;								
				end case;				
				--if (refresh'event and refresh ='1' ) THEN		
				--	state <= initial_lcd;
				--end if;
			end if;			
		end if;

	end process;
	lcd_e <= e;
end Behavioral; 



