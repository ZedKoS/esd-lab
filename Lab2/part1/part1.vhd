library ieee;
use ieee.std_logic_1164.all;

-- Connette gli SWITCH a un decoder il cui output è inviato al display HEX0
-- Mostra un carattere tra 'e', 'S', 'd' e BLANK
entity part1 is
	PORT (
		SW		:	in	std_logic_vector(1 downto 0);
		HEX0	:	out	std_logic_vector(0 to 6)
	);
end entity;

architecture Behavior of part1 is
	component decoder_ESD is
		PORT (
			c		:	in	std_logic_vector(1 downto 0);
			decout	:	out	std_logic_vector(0 to 6));
	end component;
begin
	DECODER: decoder_ESD port map (c => SW, decout => HEX0);
end architecture;