library ieee;
use ieee.std_logic_1164.all;

entity fourbitadder is
	port (A, B : in std_logic_vector(3 downto 0);
			cin : in std_logic;
			S : out std_logic_vector(3 downto 0);
			cout : out std_logic);
end entity;

architecture Behavior of fourbitadder is
	component fulladder is
		port (a, b, ci : in std_logic;
				s, co : out std_logic);
	end component;
	signal c1, c2, c3 : std_logic;
begin
	FA0 : fulladder port map (a => A(0), b => B(0), ci => cin, s => S(0), co => c1);
	FA1 : fulladder port map (a => A(1), b => B(1), ci => c1, s => S(1), co => c2);
	FA2 : fulladder port map (a => A(2), b => B(2), ci => c2, s => S(2), co => c3);
	FA3 : fulladder port map (a => A(3), b => B(3), ci => c3, s => S(3), co => cout);
end architecture;