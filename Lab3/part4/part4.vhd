library ieee;
use ieee.std_logic_1164.all;

entity part4 is
	port
	(
		SW : in	std_logic_vector(9 downto 0);
		HEX5 : out std_logic_vector(0 to 6); -- A
		HEX3 : out std_logic_vector(0 to 6); -- B
		HEX0 : out std_logic_vector(0 to 6); -- Prodotto (LO 4)
		HEX1 : out std_logic_vector(0 to 6)  -- Prodotto (HI 4)
	);
end entity;

architecture Behavior of part4 is
	component multiplier is
		port
		(
			x, y : in	std_logic_vector(3 downto 0);
			z : out	std_logic_vector(7 downto 0)
		);
	end component;
	
	component hexadecimal_ssd_decoder is
		port (c : in std_logic_vector(3 downto 0);
			  dec : out std_logic_vector(0 to 6));
	end component;
	
	-- numeri in ingresso
	signal A, B : std_logic_vector(3 downto 0);
	-- prodotto di A e B
	signal P : std_logic_vector(7 downto 0);
	
begin
	A <= SW(9 downto 6);
	B <= SW(3 downto 0);
	
	MULT: multiplier port map (x => A, y => B, z => P);
	DEC_P0: hexadecimal_ssd_decoder port map (c => P(3 downto 0), dec => HEX0);
	DEC_P1: hexadecimal_ssd_decoder port map (c => P(7 downto 4), dec => HEX1);
	
	DEC_A: hexadecimal_ssd_decoder port map (c => A, dec => HEX5);
	DEC_B: hexadecimal_ssd_decoder port map (c => B, dec => HEX3);
end architecture;