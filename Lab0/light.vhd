library ieee;
use ieee.std_logic_1164.all;

entity light is
	port (x1, x2: in std_logic; f: out std_logic);
end;

architecture behaviour of light is
begin
	f <= (x1 and not x2) or (x2 and not x1);
end;