--Multiplexer a 4 ingressi a 2 bit con segnale di selezione a 2 bit
library ieee;
use ieee.std_logic_1164.all;

entity mux4to1 is
	port (SW: IN std_logic_vector(7 downto 0);
			LEDR: OUT std_logic_vector(9 downto 0));
end entity;

architecture Behavior of mux4to1 is
	signal x, u, v, w, s : std_logic_vector(1 downto 0);
	signal f1, f2, m : std_logic_vector(1 downto 0);
	
	component mux2to1 is
		port( x, y: in std_logic_vector(1 downto 0);
			s: in std_logic;
			f: out std_logic_vector(1 downto 0));
	end component;

begin
	s <= SW(1 downto 0);
	
	u <= SW(7 downto 6);
	v <= SW(5 downto 4);
	w <= SW(3 downto 2);
	x <= "11";
	
	LEDR(7 downto 0) <= SW;
	LEDR(9 downto 8) <= m;
	
	mux1: mux2to1 port map(u, v, s(0), f1);
	mux2: mux2to1 port map(w, x, s(0), f2);
	mux3: mux2to1 port map(f1, f2, s(1), m);
end architecture;