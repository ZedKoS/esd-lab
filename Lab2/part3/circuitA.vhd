library ieee;
use ieee.std_logic_1164.all;

-- Sottrae 2 al numero in ingresso (unsigned)
-- Ignora i casi a = "000", a = "001"
entity circuitA is 
	port (
		a	:	in	std_logic_vector(2 downto 0);
		b	:	out	std_logic_vector(2 downto 0)
	);
end entity;

architecture Behavior of circuitA is
begin
	b(0) <= a(0);
	b(1) <= not a(1);
	b(2) <= a(1) and a(2);
end architecture;