--Signed Adder a 4 bit
library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity part3 is
	port (
		A, B : in signed(63 downto 0);
		clock, resetn : in std_logic;
		S : out signed(63 downto 0);
		overflow : out std_logic
	);
end entity;

--

architecture Behavior of part3 is
	component flipflop is
		PORT (D, Clock, Resetn : IN STD_LOGIC;
			Q : OUT STD_LOGIC);
	end component;

	component regn IS
	GENERIC ( N : integer := 64);
		PORT (R : IN SIGNED(N-1 DOWNTO 0);
			Clock, Resetn : IN STD_LOGIC;
			Q : OUT SIGNED(N-1 DOWNTO 0));
	END component;

	component fourbitadder is
		port (A, B : in std_logic_vector(3 downto 0);
				cin : in std_logic;
				S : out std_logic_vector(3 downto 0);
				cout : out std_logic);
	end component;

	component hexadecimal_ssd_decoder is
		port (c : in std_logic_vector(3 downto 0);
			  dec : out std_logic_vector(0 to 6));
	end component;
	
	component adder64 is
		port(
			A, B : in std_logic_vector(63 downto 0);
			S : out std_logic_vector(63 downto 0);
			cin : in std_logic;
			cout : out std_logic
		);
	end component;

	signal inputA, inputB, outputS : signed(63 downto 0);
	signal async_overflow : std_logic;
	signal cout : std_logic;

begin
	REGA : regn port map (R => A, Clock => clock, Resetn => resetn, Q => inputA);
	REGB : regn port map (R => B, Clock => clock, Resetn => resetn, Q => inputB);
	
	ADDER: adder64 port map (
		A => std_logic_vector(inputA), B => std_logic_vector(inputB), signed(S) => outputS,
		cin => '0', cout => cout
		);

	REGS : regn port map (R => outputS, Clock => clock, Resetn => resetn, Q => S);
		
	async_overflow <= cout xor outputS(63) xor inputA(63) xor inputB(63);
	DFF1 : flipflop port map (D => async_overflow, Clock => clock, Resetn => resetn, Q => overflow);
end architecture;

--

configuration Use_RCA of part3 is
	for Behavior
		for ADDER:
			adder64 use entity work.adder64(BehaviorRCA);
		end for;
	end for;
end configuration Use_RCA;

configuration Use_CSA of part3 is
	for Behavior
		for ADDER:
			adder64 use entity work.adder64(BehaviorCSA);
		end for;
	end for;
end configuration Use_CSA;