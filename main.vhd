----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:46:42 12/05/2021 
-- Design Name: 
-- Module Name:    main - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    port (
        a, w: in std_logic;
        b: out std_logic 
    );
end main;

architecture Behavioral of main is
    component testy
    port (
        i1, i2: in std_logic;
        o: out std_logic
    );
    end component;
    component inverse
    port (
        i: in std_logic;
        o: out std_logic
    );
    end component;
    signal w1: std_logic;
begin
    IC1: testy port map (i1 => a, i2 => w, o => w1);
    IC2: inverse port map (i => w1, o => b);
end Behavioral;





