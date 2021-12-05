library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity inverse is
    port (
        i: in std_logic;
        o: out std_logic
    );
end inverse;

architecture Behavioral of inverse is
begin
    o <= not i;
end Behavioral;