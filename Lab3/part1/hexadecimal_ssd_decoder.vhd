library ieee;
use ieee.std_logic_1164.all;

entity hexadecimal_ssd_decoder is
	port (c : in std_logic_vector(3 downto 0);
		  dec : out std_logic_vector(0 to 6));
end entity;

architecture Behavior of hexadecimal_ssd_decoder is
begin
	with c select dec <=
		"0000001" when "0000", --0
		"1001111" when "0001", --1
		"0010010" when "0010", --2
		"0000110" when "0011", --3
		"1001100" when "0100", --4
		"0100100" when "0101", --5
		"0100000" when "0110", --6
		"0001111" when "0111", --7
		"0000000" when "1000", --8
		"0000100" when "1001", --9
		"0001000" when "1010", --A 10
		"1100000" when "1011", --b 11
		"0110001" when "1100", --C 12
		"1000010" when "1101", --d 13
		"0110000" when "1110", --E 14
		"0111000" when "1111", --F 15
		"1111110" when others; -- in caso di errore
end;