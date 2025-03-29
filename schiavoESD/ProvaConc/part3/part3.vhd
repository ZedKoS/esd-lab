library ieee;
use ieee.std_logic_1164.all;

entity part3 is
	port (
		SW			:	in std_logic_vector(3 downto 0);
		HEX0, HEX1	:	out std_logic_vector(0 to 6)
	);
end entity;

architecture Behavior of part3 is
	component Mux1 is
		generic (
			order	:	Natural := 1
		);
		port (
			x	: 	in	std_logic_vector(2**order - 1 downto 0);
			s	: 	in	std_logic_vector(order - 1 downto 0);
			f	: 	out std_logic
		);
	end component;
	
	component comparator is
		port (
			a	:	in	std_logic_vector(3 downto 0); -- numero unsigned
			z	:	out	std_logic
		);
	end component;
	
	-- Sottrae 2 al numero in ingresso (unsigned)
	-- Ignora i casi a = "000", a = "001"
	component circuitA is
		port (
			a	:	in	std_logic_vector(2 downto 0);
			b	:	out	std_logic_vector(2 downto 0)
		);
	end component;
	
	-- Controlla il 7-segment-display delle decine
	-- c = '0' -> display indica 0
	-- c = '1' -> display indica 1
	component circuitB is
		port (
			c		:	IN	std_logic;
			decout 	:	OUT	std_logic_vector(0 TO 6)
		);
	end component;
	
	component decimal_ssd_decoder is
		port (
			c	:	in	std_logic_vector(3 downto 0);
			dec	:	out	std_logic_vector(0 to 6)
		);
	end component;
	
	signal tens_digit	:	std_logic;
	signal units_digit	:	std_logic_vector(3 downto 0);
	signal sub2		:	std_logic_vector(3 downto 0);
begin
	CMP	: comparator
		port map (a => SW, z => tens_digit);
	
	sub2(3) <= '0'; -- necessario per MUX_loop
	circA : circuitA
		port map (a => SW(2 downto 0), b => sub2(2 downto 0));
	
	MUX_loop : for i in 0 to 3 generate
		MUX: Mux1
			port map (x => sub2(i) & SW(i), s => (0 => tens_digit), f => units_digit(i));
	end generate;
	
	-- connessioni ai 7-segment-display
	
	circB : circuitB
		port map (c => tens_digit, decout => HEX1);
		
	DSD : decimal_ssd_decoder
		port map (c => units_digit, dec => HEX0);
end architecture;
		