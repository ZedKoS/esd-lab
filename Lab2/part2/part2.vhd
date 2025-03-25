library ieee;
use ieee.std_logic_1164.all;

-- Connette gli switch SW e i display HEX0, HEX1, HEX2, HEX3 a dei decoder
-- in modo da mostrare 4 caratteri, inseriti tramite gli switch SW(7:0).
-- La sequenza di caratteri è ruotata a sinistra per un numero di volte pari
-- al numero indicato in SW(9:8).
entity part2 is
	port (
		SW		:	in	std_logic_vector(9 downto 0);
		HEX0	:	out	std_logic_vector(6 downto 0);
		HEX1	:	out	std_logic_vector(6 downto 0);
		HEX2	:	out	std_logic_vector(6 downto 0);
		HEX3	:	out	std_logic_vector(6 downto 0)
	);
end entity;

architecture Behavior of part2 is
	component mux4to1 is
		port (a, b, c, d, s : in std_logic_vector(1 downto 0);
			m : out std_logic_vector(1 downto 0)
		);
	end component;
	
	component decoder_ESD is
		PORT (c : in std_logic_vector(1 downto 0);
			decout : out std_logic_vector(0 to 6));
	end component;
	
	-- caratteri in input; impostati tramite switch
	signal char0, char1, char2, char3, sel : std_logic_vector(1 downto 0);
	
	-- caratteri in uscita dai MUX
	signal m0, m1, m2, m3 : std_logic_vector(1 downto 0);
begin
	char0 <= SW(7 downto 6);
	char1 <= SW(5 downto 4);
	char2 <= SW(3 downto 2);
	char3 <= SW(1 downto 0);
	sel <= SW(9 downto 8);
	
	-- i caratteri in ingresso vengono assegnati come input ai vari MUX,
	-- ma sono permutati in modo da avere una rotazione
	MUX0: mux4to1 port map(a => char0, b => char1, c => char2, d => char3, s => sel, m => m0);
	MUX1: mux4to1 port map(a => char1, b => char2, c => char3, d => char0, s => sel, m => m1);
	MUX2: mux4to1 port map(a => char2, b => char3, c => char0, d => char1, s => sel, m => m2);
	MUX3: mux4to1 port map(a => char3, b => char0, c => char1, d => char2, s => sel, m => m3);
	
	-- collegamento degli output dei MUX ai 7-segment display
	DEC0: decoder_ESD port map(c => m0, decout => HEX0);
	DEC1: decoder_ESD port map(c => m1, decout => HEX1);
	DEC2: decoder_ESD port map(c => m2, decout => HEX2);
	DEC3: decoder_ESD port map(c => m3, decout => HEX3);
end architecture;