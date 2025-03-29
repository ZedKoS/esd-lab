library ieee;
use ieee.std_logic_1164.all;
use work.common_p.logic_matrix_t;

-- Converte un numero tra 0 e 9 (3 bit unsigned) nel formato del 7-segment-display.
entity decimal_ssd_decoder is
	port (
		c	:	in	std_logic_vector(3 downto 0);
		dec	:	out	std_logic_vector(0 to 6)
	);
end entity;

architecture Behavior of decimal_ssd_decoder is
	signal x, y, z, w : std_logic;
begin
	x <= c(0) or c(1) or not c(2);
	y <= not c(0) or c(1) or c(2) or c(3);
	z <= not c(0) or not c(1) or not c(2);
	w <= c(0) or not c(1) or c(2);
	
	dec(0) <= x;
	dec(1) <= (c(0) or not c(1) or not c(2)) and (not c(0) or c(1) or not c(2));
	dec(2) <= w and y;
	dec(3) <= x and y and z;
	dec(4) <= not c(0) and x;
	dec(5) <= (not c(0) or not c(1)) and w and (not c(0) or c(2) or c(3));
	dec(6) <= (c(1) or c(2) or c(3)) and z;
end;