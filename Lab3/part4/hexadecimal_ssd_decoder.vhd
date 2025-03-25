library ieee;
use ieee.std_logic_1164.all;

entity hexadecimal_ssd_decoder is
	port (c : in std_logic_vector(3 downto 0);
		  dec : out std_logic_vector(0 to 6));
end entity;

architecture Behavior of hexadecimal_ssd_decoder is
begin
	with c select dec <=
		"0000001" when "1111", --0
		"1001111" when "1110", --1
		"0010010" when "1101", --2
		"0000110" when "1100", --3
		"1001100" when "1011", --4
		"0100100" when "1010", --5
		"0100000" when "1001", --6
		"0001111" when "1000", --7
		"0000000" when "0111", --8
		"0000100" when "0110", --9
		"0001000" when "0101", --A 10
		"1100000" when "0100", --b 11
		"0110001" when "0011", --C 12
		"1000010" when "0010", --d 13
		"0110000" when "0001", --E 14
		"0111000" when "0000", --F 15
		"1111110" when others; -- in caso di errore
end;