library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity message_rom is
port (clk : in std_logic;
      A : in integer range 0 to 31;
      newAscii : in std_logic;
      DataIn : in std_logic_vector (7 downto 0);
      D : out std_logic_vector (7 downto 0));
end message_rom;
architecture rom32x8_beh of message_rom is

type rom_array is array(0 to 31) of std_logic_vector (7 downto 0);

shared variable pointer: integer:= 0;
shared variable rom : rom_array:= ("00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000",
"00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000");
begin
  process (clk, newAscii)
  begin
	  if clk = '1' and clk'event then 
		  D <= rom(A);
	  end if;
    if newAscii = '1' and newAscii'event then 
      if DataIn="00001000" then
        rom(pointer) := "00100000";
        pointer := pointer-1;
      else
        rom(pointer) := "0"&DataIn(6)&DataIn(5)&DataIn(4)&DataIn(3)&DataIn(2)&DataIn(1)&DataIn(0);
        pointer := pointer+1;
      end if;
    end if;
  end process;
end rom32x8_beh;




