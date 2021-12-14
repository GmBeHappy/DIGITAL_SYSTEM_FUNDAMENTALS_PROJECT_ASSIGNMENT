library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity message_rom is
port (clk : in std_logic;
      A : in integer range 0 to 31;
      newAscii : in std_logic;
      DataIn : in std_logic_vector (7 downto 0);
      D : out std_logic_vector (7 downto 0);
      debug_data : out std_logic_vector (7 downto 0) := "00000000";
      debug: out std_logic);
end message_rom;
architecture rom32x8_beh of message_rom is

type rom_array is array(0 to 31) of std_logic_vector (7 downto 0);

shared variable rom : rom_array:= ("00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000",
"00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000");
begin
  process (clk)
  begin
	  if clk'event and clk = '1' then 
		  D <= rom(A);
	  end if;
  end process;
  process (newAscii)
  variable pointer: integer:= 0;
  begin
    if newAscii'event and newAscii = '1' then 
      if DataIn = "00001000" and pointer > 0 then
        pointer := pointer-1;
        rom(pointer) := "00100000"; 
        -- debug_data <= rom(pointer);
      elsif DataIn /= "00000000" and DataIn /= "00001000" and pointer < 15 then
        rom(pointer) := '0'&DataIn(6)&DataIn(5)&DataIn(4)&DataIn(3)&DataIn(2)&DataIn(1)&DataIn(0);
        -- rom(pointer) := "00100001";
        -- debug_data <= rom(pointer);
        pointer := pointer+1;
      end if;
    end if;
  end process;
end rom32x8_beh;

-- architecture rom32x8_beh of message_rom is
--   signal Q:character; 

-- type rom_array is array(0 to 31) of character;
-- constant rom : rom_array :=('H','e','l','l','o',' ','e','P','l','e','a','r','n',' ',' ',' ',
-- 									 ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '); -- data to display 
-- begin
--   process (clk)
--   begin
-- 	if clk = '1' and clk'event then 
-- 		D <= STD_LOGIC_VECTOR(TO_UNSIGNED(CHARACTER'POS(rom(A)), 8));
-- 	end if;
--   end process;
-- end rom32x8_beh;




