library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity message_rom is
port (clk : in std_logic;
      A : in integer range 0 to 15;
      newAscii : in std_logic;
      DataIn : in std_logic_vector (7 downto 0);
      requestToload : in std_logic;
      debug_add: in std_logic_vector (3 downto 0);
      D : out std_logic_vector (7 downto 0);
      debug_data : out std_logic_vector (7 downto 0) := "00000000";
      debug: out std_logic;
      Reading: out std_logic;
      Writing: out std_logic);

end message_rom;
architecture rom32x8_beh of message_rom is

type rom_array is array(0 to 15) of std_logic_vector (7 downto 0);
-- signal rom_block : rom_array;
-- signal rom_block : rom_array := ("00100000","00000000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000");
-- shared variable rom : rom_array:= ("00100000","00000000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000");
shared variable rom : rom_array:= ("00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000","00100000");
-- shared variable romBuffer : std_logic_vector(7 downto 0);
shared variable romBuffer : std_logic_vector(7 downto 0);
-- shared variable debug_Buffer : std_logic_vector(7 downto 0);
begin
  -- process (requestToload)
  -- begin
	--   if requestToload'event and requestToload = '1' then 
  --   romBuffer := rom_block(A);
	--   end if;
  -- end process;
  process (newAscii, requestToload)
  variable pointer: integer := 0;
  begin
    -- if newAscii'event and newAscii = '1' then 
    --   if pointer < 0 then
    --     pointer := 0;
    --   end if;

    --   if DataIn = "00001000" and pointer > 0 then
    --     rom(pointer-1) := "00100000";
    --     pointer := pointer-1;
    --   elsif DataIn /= "00000000" and DataIn /= "00001000" and pointer < 16 then
    --     rom(pointer) := '0'&DataIn(6)&DataIn(5)&DataIn(4)&DataIn(3)&DataIn(2)&DataIn(1)&DataIn(0);
    --     pointer := pointer+1;
    --   else
    --     rom(pointer) := "00100000";
    --   end if;

    -- end if;
    if newAscii'event and newAscii = '1' then
      Writing <= '1';
      if DataIn = "00001000" then
        if pointer /= 0 then
          pointer := pointer-1;
          -- rom_block(pointer) <= "00100000";
          rom(pointer) := "00100000";
          -- debug_data <= std_logic_vector( to_unsigned( pointer, debug_data'length));
          -- debug_data <= DataIn
        else
          rom(0) := "00100000";
        end if;
      elsif DataIn > x"19" and DataIn < x"7E" and pointer < 16 then
          -- if DataIn /= "00001000" then
          -- rom_block(pointer) <= DataIn;
          rom(pointer) := DataIn(7 downto 0);
          -- debug_buffer := rom_block(pointer);
          pointer := pointer+1;
          -- debug_data <= std_logic_vector( to_unsigned( pointer, debug_data'length));
          -- end if;
      end if;
    end if;
    Writing <= '0';

	  if requestToload'event and requestToload = '1' then 
      Reading <= '1';
      romBuffer := rom(A);
      Reading <= '0';
	  end if;
  end process;
  -- process(clk)
  -- begin
  --   if clk'event and clk='1' then
  --     debug_buffer := rom(to_integer(signed(debug_add)));
  --   end if;
  -- end process;
  D <= romBuffer;
  -- debug_data <= debug_buffer;
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




