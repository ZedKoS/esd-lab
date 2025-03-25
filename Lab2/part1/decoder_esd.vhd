library ieee;
use ieee.std_logic_1164.all;

-- Converte un codice a 2 bit in un carattere da mostrare sul display a 7 segmenti
-- 00 => e, 01 => S, 10 => d, 11 => BLANK
entity decoder_ESD is
	port (
		c		:	in	std_logic_vector(1 downto 0);
		decout	:	out	std_logic_vector(0 to 6)
	);
end entity;

architecture Behavior of decoder_ESD is
begin
	decout(0) <= NOT c(0);
	decout(1) <= NOT c(1);
	decout(2) <= c(0) XOR c(1);
	decout(3) <= c(0) NAND c(1);
	decout(4) <= NOT c(1);
	decout(5) <= NOT c(0);
	decout(6) <= c(0) NAND c(1);
end architecture;