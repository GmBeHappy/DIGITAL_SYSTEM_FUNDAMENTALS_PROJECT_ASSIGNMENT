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

entity main is --Declare port to use
    port (
        a, w: in std_logic; -- 2 input port
        b: out std_logic -- 1 output port
    );
end main;

architecture Behavioral of main is -- Declare what this sh*t do
    component testy -- import testy module
    port (
        i1, i2: in std_logic; -- this module has 2 input port
        o: out std_logic -- and 1 output port
    );
    end component;
    component inverse -- import inverse module
    port (
        i: in std_logic;
        o: out std_logic
    );
    end component;
    signal w1: std_logic; -- Create wire for connection
begin
    IC1: testy port map (i1 => a, i2 => w, o => w1); -- Connect i1 of testy to a of main, i2 of testy to b of main, o of testy to w1 wire
    IC2: inverse port map (i => w1, o => b); -- Connect i of inverse to w1 wire, o of inverse to b of main
end Behavioral;





