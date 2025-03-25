library ieee;
use ieee.std_logic_1164.all;

-- Implementa la funzione a >= 10 (base 10), e porta '1' in uscita in tal caso
entity comparator is
	port (
		a	:	in	std_logic_vector(3 downto 0); -- numero unsigned
		z	:	out	std_logic
	);
end entity;

architecture Behavior of comparator is
begin
	z <= a(3) and (a(2) or a(1));
end architecture;