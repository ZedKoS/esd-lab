library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.adder64;

architecture BehaviorCSA of adder64 is
	signal carry_vet : std_logic_vector(16 downto 0);
	
	component fourbitadder is
		port (A, B : in std_logic_vector(3 downto 0);
			cin : in std_logic;
			S : out std_logic_vector(3 downto 0);
			cout : out std_logic);
	end component;
	
	component flipflop is
		PORT (D, Clock, Resetn : IN STD_LOGIC;
			Q : OUT STD_LOGIC);
	end component;
	
	component regn is
		GENERIC ( N : integer := 64);
		PORT (R : IN SIGNED(N-1 DOWNTO 0);
			Clock, Resetn : IN STD_LOGIC;
			Q : OUT SIGNED(N-1 DOWNTO 0));
	end component;
	
begin
	carry_vet(0) <= cin;
	cout <= carry_vet(16); 
	
	ADDER : for i in 0 to 15 generate
		ADD_1 : entity work.fourbitadder(BehaviorCSA) port map(
			A => std_logic_vector(A((4*i+3) downto 4*i)),
			B => std_logic_vector(B((4*i+3) downto 4*i)),
			s => S((4*i+3) downto 4*i),
			cin => carry_vet(i), cout => carry_vet(i+1));
	end generate;
	
end architecture;