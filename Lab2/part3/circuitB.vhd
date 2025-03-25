library ieee;
use ieee.std_logic_1164.all;

-- Controlla il 7-segment-display delle decine
-- c = '0' -> display indica 0
-- c = '1' -> display indica 1
entity circuitB is
	port (
		c		:	IN	std_logic;
		decout 	:	OUT	std_logic_vector(0 TO 6)
	);
end entity;

architecture Behavior of circuitB is
begin
	decout <= (1 to 2 => c, others => '0');
end architecture;