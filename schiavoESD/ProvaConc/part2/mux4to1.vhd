library ieee;
use ieee.std_logic_1164.all;

--Multiplexer a 4 ingressi a 2 bit con segnale di selezione a 1 bit
entity mux4to1 is
	port (a, b, c, d, s : in std_logic_vector(1 downto 0);
			m : out std_logic_vector(1 downto 0)
	);
end entity;

architecture Behavior of mux4to1 is
	signal f1, f2 : std_logic_vector(1 downto 0);
	component mux2to1 is
		port( x, y: in std_logic_vector(1 downto 0);
		s: in std_logic;
		f: out std_logic_vector(1 downto 0));
	end component;
begin
	mux1: mux2to1 port map(a, b, s(0), f1);
	mux2: mux2to1 port map(c, d, s(0), f2);
	mux3: mux2to1 port map(f1, f2, s(1), m);
end architecture;