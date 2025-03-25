--Multiplexer a 2 ingressi a 2 bit con segnale di selezione a 1 bit
library ieee;
use ieee.std_logic_1164.all;

entity mux2to1 is
	port( x, y: in std_logic_vector(1 downto 0);
		s: in std_logic;
		f: out std_logic_vector(1 downto 0));
end entity;

architecture Behavior of mux2to1 is
begin
	f(0) <= (x(0) and not(s)) or (y(0) and s);
	f(1) <= (x(1) and not(s)) or (y(1) and s);
end architecture;