library ieee;
use ieee.std_logic_1164.all;

-- Moltiplicatore a 4 bit
entity multiplier is
	port
	(
		x, y	: in	std_logic_vector(3 downto 0);
		z		: out	std_logic_vector(7 downto 0)
	);
end entity;

architecture Behavior of multiplier is
	component fulladder is
		port
		(
			a, b, ci	: in	std_logic;
			s, co		: out	std_logic
		);
	end component;

	type logic_matrix is array(natural range <>) of std_logic_vector;
	signal partial	: logic_matrix(0 to 3)(3 downto 0);
	signal carry	: logic_matrix(1 to 3)(4 downto 0);
	signal sums		: logic_matrix(0 to 3)(4 downto 0);
	
begin
	sums(0) <= '0' & partial(0);
	
	SIGNALS_ROWS:
	for i in 0 to 3 generate
		SIGNALS_COLS:
		for j in 3 downto 0 generate
			partial(i)(j) <= x(j) and y(i);
		end generate;
		
		SIGNALS_NONZERO_ROWS:
		if i /= 0 generate
			carry(i)(0) <= '0';
			sums(i)(4) <= carry(i)(4);
		end generate;
	end generate;
	
	z(0) <= partial(0)(0);
	
	SUMS_ROWS:
	for i in 1 to 3 generate
		SUMS_COLS:
		for j in 0 to 3 generate
			ADDER: fulladder
				port map (a => sums(i-1)(j+1), b => partial(i)(j), ci => carry(i)(j),
					s => sums(i)(j), co => carry(i)(j+1));
		end generate;
		
		z(i) <= sums(i)(0);
	end generate;
	
	z(7 downto 4) <= sums(3)(4 downto 1);
end architecture;