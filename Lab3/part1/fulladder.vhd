library ieee;
use ieee.std_logic_1164.all;

entity fulladder is
	port (a, b, ci : in std_logic;
			s, co: out std_logic);
end entity;

architecture Behavior of fulladder is
begin
	s <= ci xor (a xor b);
	co <= (ci and (a xor b)) or (b and not (a xor b));
end architecture;