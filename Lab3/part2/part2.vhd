--Signed Adder a 4 bit
library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity part2 is
	port (SW : in std_logic_vector(9 downto 0); --sw9 for subtraction, sw7-4 for A, sw3-0 for B
			KEY : in std_logic_vector(0 to 1); --key0 for activelow async reset, key1 for manual clk
			LEDR : out std_logic_vector(9 downto 0); --ledr9 for overflow, ledr3-0 for sum
			HEX0, HEX1, HEX2 : out std_logic_vector(0 to 6)); --hex0 for B, hex1 for A, hex2 for S
end entity;

architecture Behavior of part2 is
	component flipflop is
		PORT (D, Clock, Resetn : IN STD_LOGIC;
			Q : OUT STD_LOGIC);
	end component;

	component regn IS
	GENERIC ( N : integer:=4);
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

	signal inputA, inputB, outputS : signed(3 downto 0);
	signal carryout, overflow, sub : std_logic;
	signal outSum : std_logic_vector(3 downto 0);
	
	signal addOrSubB : signed(3 downto 0);

begin
	REGA : regn port map (R => signed(SW(7 downto 4)), Clock => KEY(1), Resetn => KEY(0), Q => inputA);
	REGB : regn port map (R => signed(SW(3 downto 0)), Clock => KEY(1), Resetn => KEY(0), Q => inputB);
	
	sub <= SW(9);
	addOrSubB <= inputB xor (3 downto 0 => sub);
	
	ADDER : fourbitadder port map (A => std_logic_vector(inputA), B => std_logic_vector(addOrSubB), cin => sub,
		signed(S) => outputS, cout => carryout);
	
	REGS : regn port map (R => outputS, Clock => KEY(1), Resetn => KEY(0), std_logic_vector(Q) => outSum);
	overflow <= carryout xor outputS(3) xor inputA(3) xor addOrSub(3);
	DFF1 : flipflop port map (D => overflow, Clock => KEY(1), Resetn => KEY(0), Q => LEDR(9));
	
	DECODERA : hexadecimal_ssd_decoder port map (c => SW(3 downto 0), dec => HEX0);
	DECODERB : hexadecimal_ssd_decoder port map (c => SW(7 downto 4), dec => HEX1);
	DECODERS : hexadecimal_ssd_decoder port map (c => outSum, dec => HEX2);
	
	LEDR(3 downto 0) <= outSum;
	LEDR(8 downto 4) <= (others => '0');
end architecture;