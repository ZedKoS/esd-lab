library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mux1 is
	generic
	(
		order	:	Natural  :=	1
	);
	
	port
	(
		x	: 	in	std_logic_vector(2**order - 1 downto 0);
		s	: 	in	std_logic_vector(order - 1 downto 0);
		f	: 	out std_logic
	);
end Mux1;

architecture Behavior of Mux1 is
begin
	f <= x(to_integer(Unsigned(s)));
end Functional;

--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_p.logic_matrix_t;

entity MuxN is
	generic
	(
		bits	:	Natural;
		order	:	Natural	:=	1
	);

	port
	(
		x	:	in 	logic_matrix_t(2**order - 1 downto 0, bits - 1 downto 0);
		s	:	in 	std_logic_vector(order - 1 downto 0);
		f	:	out std_logic_vector(bits - 1 downto 0)
	);
end MuxN;

architecture Behavior of MuxN is
begin
	MuxLoop: for i in bits - 1 downto 0 generate
		f(i) <= x(to_integer(Unsigned(s)), i);
	end generate;
end Functional;

