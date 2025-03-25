--Multiplexer a 2 ingressi a 2 bit con segnale di selezione a 1 bit
library ieee;
use ieee.std_logic_1164.all;

entity mux2to1 is
	port( x, y: in std_logic;
		s: in std_logic;
		f: out std_logic);
end entity;

architecture Behavior of mux2to1 is
begin
	f <= (x and not s) or (y and s);
end architecture;
