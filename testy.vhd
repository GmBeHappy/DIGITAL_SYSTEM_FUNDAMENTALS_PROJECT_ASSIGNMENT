library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testy is
    port (
        i1, i2: in std_logic;
        o: out std_logic
    );
end testy;

architecture Behavioral of testy is
    begin
        o <= i1 and i2;
end Behavioral;