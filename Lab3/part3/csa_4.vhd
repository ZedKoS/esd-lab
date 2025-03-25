library ieee;
use ieee.std_logic_1164.all;

architecture BehaviorCSA of fourbitadder is
	component mux2to1 is 
	
		port( x, y: in std_logic;
			s: in std_logic;
			f: out std_logic);
			
	end component;
	
	signal cout1, cout2 : std_logic;
	signal sum1, sum2 : std_logic_vector(3 downto 0);
	
begin

	ADDER_1 : entity work.fourbitadder(Behavior) port map(A => A, B => B, cin => '0', cout => cout1, s => sum1);
	ADDER_2 : entity work.fourbitadder(Behavior) port map(A => A, B => B, cin => '1', cout => cout2, s => sum2);
	
	MUX_1 : mux2to1 port map(x => sum1(0), y => sum2(0), s => cin, f => S(0));
	MUX_2 : mux2to1 port map(x => sum1(1), y => sum2(1), s => cin, f => S(1));
	MUX_3 : mux2to1 port map(x => sum1(2), y => sum2(2), s => cin, f => S(2));
	MUX_4 : mux2to1 port map(x => sum1(3), y => sum2(3), s => cin, f => S(3));
	
	MUX_finale : mux2to1 port map(x => cout1, y => cout2, s => cin, f => cout);
end architecture;